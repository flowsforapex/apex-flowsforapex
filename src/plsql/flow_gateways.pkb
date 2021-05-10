create or replace package body flow_gateways
as 

  type t_new_sbfl_rec is record
  ( sbfl_id   flow_subflows.sbfl_id%type
  , route     flow_subflows.sbfl_route%type
  );

  type t_new_sbfls is table of t_new_sbfl_rec;

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  function gateway_op_type
    ( pi_dgrm_id          in flow_diagrams.dgrm_id%type
    , pi_gateway_objt_id  in flow_objects.objt_id%type
    ) return varchar2 
  is 
    l_num_forward_connections number;
    l_num_back_connections    number;
    l_gateway_op_type         varchar2(10);
    e_gateway_no_forward_path exception;
  begin   
    select count(*)
      into l_num_back_connections
      from flow_connections conn 
     where conn.conn_tgt_objt_id = pi_gateway_objt_id
       and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
    select count(*)
      into l_num_forward_connections
      from flow_connections conn 
     where conn.conn_src_objt_id = pi_gateway_objt_id
       and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
       and conn.conn_dgrm_id = pi_dgrm_id
    ;
    case 
    when (l_num_back_connections > 1 AND l_num_forward_connections > 1) then
      l_gateway_op_type := flow_constants_pkg.gc_gateway_both;
    when l_num_forward_connections = 1 then
      l_gateway_op_type := flow_constants_pkg.gc_gateway_merging;
    when l_num_forward_connections > 1 then
      l_gateway_op_type := flow_constants_pkg.gc_gateway_splitting;
    else
      raise e_gateway_no_forward_path;
    end case;
    return l_gateway_op_type;
  exception 
    when others then 
      apex_error.add_error
      ( p_message => 'Error getting Gateway role for object'||pi_gateway_objt_id||'. Check your Flow Diagram. '
      , p_display_location => apex_error.c_on_error_page
      );
  end gateway_op_type;

  function get_gateway_route
    ( pi_process_id     in flow_processes.prcs_id%type
    , pi_objt_bpmn_id   in flow_objects.objt_bpmn_id%type
    ) return varchar2
  is
    l_forward_route     varchar2(2000);  -- 1 route for exclusiveGateway, 1 or more for inclusive (:sep)
    l_bad_routes        apex_application_global.vc_arr2;
    l_bad_route_string  varchar2(2000) := '';
    l_num_bad_routes    number := 0;
  begin
    -- check if route is in process variable
    l_forward_route := flow_process_vars.get_var_vc2(pi_process_id, pi_objt_bpmn_id||':route');
    if l_forward_route is not null
    then
       begin
        -- test routes are all valid connections before returning
        l_num_bad_routes := 0;
        for bad_routes in (
            select column_value as bad_route 
              from table(apex_string.split(l_forward_route,':'))
            minus 
            select conn.conn_bpmn_id
              from flow_connections conn
              join flow_objects objt 
                on objt.objt_id = conn.conn_src_objt_id
              and conn.conn_dgrm_id = objt.objt_dgrm_id
              join flow_processes prcs
                on prcs.prcs_dgrm_id = conn.conn_dgrm_id
            where prcs.prcs_id = pi_process_id
              and objt.objt_bpmn_id = pi_objt_bpmn_id
            )
        loop
           l_num_bad_routes := l_num_bad_routes +1;
           l_bad_route_string := l_bad_route_string||bad_routes.bad_route||', ';
        end loop;
        if l_num_bad_routes > 0 then
            apex_error.add_error( p_message => 'Error routing process flow at '||pi_objt_bpmn_id||'. Supplied variable '||pi_objt_bpmn_id||':route contains invalid route: '||l_bad_route_string
                         , p_display_location => apex_error.c_on_error_page) ;
        end if;
      exception
        when no_data_found then -- all routes good
          return l_forward_route
          ;
      end;
    else -- forward route is null -- look for default routing
        begin
            -- check default route 
            select conn_bpmn_id
              into l_forward_route
              from flow_connections conn
              join flow_objects objt 
                on objt.objt_id = conn.conn_src_objt_id
               and conn.conn_dgrm_id = objt.objt_dgrm_id
              join flow_processes prcs 
                on prcs.prcs_dgrm_id = conn.conn_dgrm_id
             where conn.conn_is_default = 1
               and objt.objt_bpmn_id = pi_objt_bpmn_id
               and prcs.prcs_id = pi_process_id
                ;
        exception
            when no_data_found then
                apex_error.add_error
                ( p_message => 'Please specify the connection ID for process variable '||pi_objt_bpmn_id||':route or specify a default route for the gateway.'
                , p_display_location => apex_error.c_on_error_page
                );
            when too_many_rows then
                apex_error.add_error
                ( p_message => 'More than one default route specified on Gateway '||pi_objt_bpmn_id
                , p_display_location => apex_error.c_on_error_page
                );
        end;
    end if; 
    return l_forward_route;
  end get_gateway_route;

  function gateway_merge
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    ) return varchar2 -- returns forward status 'wait' or 'proceed'
  is 
    l_num_unfinished_subflows number;
    l_gateway_forward_status    varchar2(10)  := 'wait';
  begin  
    -- set current subflow to status waiting,       
    update flow_subflows sbfl
        set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
          , sbfl.sbfl_last_update = systimestamp 
          , sbfl.sbfl_current = p_step_info.target_objt_ref
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- check if we are waiting for other flows or can proceed
    select count(*)
      into l_num_unfinished_subflows
      from flow_subflows sbfl
      where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
        and (  sbfl.sbfl_current != p_step_info.target_objt_ref
            or sbfl.sbfl_status != flow_constants_pkg.gc_sbfl_status_waiting_gateway
            )
    ;
    if l_num_unfinished_subflows = 0 then
      -- all task to be merged have completed.  So we do the merge... 
      -- lock parent subflow first
      flow_engine_util.lock_subflow(p_sbfl_info.sbfl_sbfl_id);
      -- proceed from gateway, locking child subflows
      for completed_subflows in ( select sbfl.sbfl_id
                                    from flow_subflows sbfl 
                                    where sbfl.sbfl_prcs_id = p_process_id
                                      and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                                      and sbfl.sbfl_current = p_step_info.target_objt_ref 
                                      and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
                                      for update wait 2
                                )
      loop
        flow_engine_util.subflow_complete
        ( p_process_id => p_process_id
        , p_subflow_id => completed_subflows.sbfl_id
        );
      end loop;
      -- execute post-merge variable expressions here (note for next feature)
    
      --mark parent split subflow ready to restart
      update flow_subflows sbfl
          set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_proceed_gateway
            , sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_update = systimestamp
        where sbfl.sbfl_last_completed = p_sbfl_info.sbfl_starting_object
          and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
          and sbfl.sbfl_id = p_sbfl_info.sbfl_sbfl_id
      ;
      -- commit tx
      commit;
      l_gateway_forward_status := 'proceed';
    end if; 
    return l_gateway_forward_status;
  end gateway_merge;

  procedure gateway_split
    ( p_process_id     in flow_processes.prcs_id%type
    , p_subflow_id     in flow_subflows.sbfl_id%type
    , p_sbfl_info      in flow_subflows%rowtype
    , p_step_info      in flow_types_pkg.flow_step_info
    , p_gateway_routes in varchar2
    )
  is 
    l_new_subflows              t_new_sbfls := t_new_sbfls();
    l_new_subflow               t_new_sbfl_rec;
  begin 
    -- we have splitting gateway going forward
    -- Current Subflow into status split and no current object
    update flow_subflows sbfl
        set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
          , sbfl.sbfl_current = null
          , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
          , sbfl.sbfl_last_update = systimestamp 
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- get all forward parallel paths and create subflows for them
    -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
    -- create subflows in one loop then step through them again in second loop
    -- to prevent some subflows getting to following merge gateway before all subflows are created (causes race condition)

    for new_path in ( select conn.conn_bpmn_id route
                           , ultimate_tgt_objt.objt_bpmn_id target
                        from flow_connections conn
                        join flow_objects ultimate_tgt_objt -- first object in each child
                          on ultimate_tgt_objt.objt_id = conn.conn_tgt_objt_id
                         and conn.conn_dgrm_id = ultimate_tgt_objt.objt_dgrm_id
                        join flow_objects objt  -- gateway object
                          on objt.objt_id = conn.conn_src_objt_id
                         and conn.conn_dgrm_id = objt.objt_dgrm_id
                       where conn.conn_dgrm_id = p_step_info.dgrm_id
                         and conn.conn_src_objt_id = p_step_info.target_objt_id
                         and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
                         and ( objt.objt_tag_name = flow_constants_pkg.gc_bpmn_gateway_parallel
                             OR 
                             ( objt.objt_tag_name = flow_constants_pkg.gc_bpmn_gateway_inclusive
                             and 
                               conn.conn_bpmn_id member of apex_string.split( p_gateway_routes, ':' )
                             ))
                    )
    loop
      -- path is included in list of chosen forward paths.
      apex_debug.message(p_message => 'starting parallel flow for '||p_step_info.target_objt_tag, p_level => 3) ;

      l_new_subflow.sbfl_id :=
        flow_engine_util.subflow_start
        ( p_process_id             => p_process_id         
        , p_parent_subflow         => p_subflow_id       
        , p_starting_object        => p_step_info.target_objt_ref         
        , p_current_object         => p_step_info.target_objt_ref          
        , p_route                  => new_path.route         
        , p_last_completed         => p_step_info.target_objt_ref  
        , p_status                 => flow_constants_pkg.gc_sbfl_status_created
        , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
        , p_new_proc_level         => false
        )
      ;
      l_new_subflow.route   := new_path.route;
      l_new_subflows.extend;
      l_new_subflows (l_new_subflows.last) := l_new_subflow;
    end loop;
    
    for new_subflow in 1.. l_new_subflows.count
    loop
      -- check subflow still exists (in case earlier loop terminated everything in level)
      if flow_engine_util.check_subflow_exists
        ( p_process_id => p_process_id
        , p_subflow_id => l_new_subflows(new_subflow).sbfl_id
        )
      then
        -- step into first step on the new path
        flow_engine.flow_complete_step    
        ( p_process_id    => p_process_id
        , p_subflow_id    => l_new_subflows(new_subflow).sbfl_id
        , p_forward_route => l_new_subflows(new_subflow).route
        );
      end if;
    end loop;
  end gateway_split;

  procedure process_parallelGateway
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
    l_gateway_forward_status    varchar2(10);
    l_sbfl_id                   flow_subflows.sbfl_id%type;
    l_sbfl_id_sub               flow_subflows.sbfl_id%type;
    l_sbfl_id_par               flow_subflows.sbfl_id%type; 
    l_num_back_connections      number;   -- number of connections leading into object
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_unfinished_subflows   number;
    l_gateway_op_type           varchar2(10);
    l_new_subflows              t_new_sbfls := t_new_sbfls();
    l_new_subflow               t_new_sbfl_rec;
  begin
    apex_debug.message(p_message => 'Next Step is parallelGateway '||p_step_info.target_objt_ref, p_level => 4) ;
    -- test if this is splitting or merging (or both) gateway
    l_gateway_op_type := gateway_op_type
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_gateway_objt_id => p_step_info.target_objt_id
    );

    l_gateway_forward_status := 'proceed';
    l_sbfl_id  := p_subflow_id;

    if ( l_gateway_op_type = flow_constants_pkg.gc_gateway_merging 
      or l_gateway_op_type = flow_constants_pkg.gc_gateway_both )  then
      apex_debug.message(p_message => 'Merging Parallel Gateway'||p_step_info.target_objt_ref, p_level => 4) ;       
      -- we have merging gateway
      l_gateway_forward_status := gateway_merge (p_process_id, p_subflow_id, p_sbfl_info, p_step_info);
      /*
      -- set current subflow to status waiting,       
      update flow_subflows sbfl
         set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
           , sbfl.sbfl_last_update = systimestamp 
           , sbfl.sbfl_current = p_step_info.target_objt_ref
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- check if we are waiting for other flows or can proceed
      select count(*)
        into l_num_unfinished_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
         and (  sbfl.sbfl_current != p_step_info.target_objt_ref
             or sbfl.sbfl_status != flow_constants_pkg.gc_sbfl_status_waiting_gateway
             )
      ;
      if l_num_unfinished_subflows = 0 then
        -- all merging tasks completed.  lock parent subflow first
        flow_engine_util.lock_subflow(p_sbfl_info.sbfl_sbfl_id);
        -- proceed from gateway, locking child subflows
        for completed_subflows in ( select sbfl.sbfl_id
                                      from flow_subflows sbfl 
                                     where sbfl.sbfl_prcs_id = p_process_id
                                       and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                                       and sbfl.sbfl_current = p_step_info.target_objt_ref 
                                       and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
                                       for update wait 2
                                  )
        loop
          flow_engine_util.subflow_complete
          ( p_process_id => p_process_id
          , p_subflow_id => completed_subflows.sbfl_id
          );
        end loop;
        -- execute post-merge variable expressions here
        
        --restart parent split subflow
        update flow_subflows sbfl
           set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_proceed_gateway
             , sbfl.sbfl_current = p_step_info.target_objt_ref
             , sbfl.sbfl_last_update = systimestamp
         where sbfl.sbfl_last_completed = p_sbfl_info.sbfl_starting_object
           and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
           and sbfl.sbfl_id = p_sbfl_info.sbfl_sbfl_id
        ;
      end if; -- end of new gateway_merge */
      -- switch to parent subflow
      l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
    end if;
    
    -- now do forward path, if you have token to 'proceed'
    if l_gateway_forward_status = 'proceed' then 
      if ( l_gateway_op_type = flow_constants_pkg.gc_gateway_splitting 
        or l_gateway_op_type = flow_constants_pkg.gc_gateway_both ) then
        -- we have splitting gateway going forward
      apex_debug.message(p_message => 'Splitting Parallel Gateway'||p_step_info.target_objt_ref, p_level => 4) ;       

      gateway_split
      ( p_process_id => p_process_id
      , p_subflow_id => l_sbfl_id
      , p_sbfl_info  => p_sbfl_info
      , p_step_info  => p_step_info
      , p_gateway_routes => 'parallel'
      );
      /*
        -- Current Subflow into status split and no current object
        update flow_subflows sbfl
           set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
             , sbfl.sbfl_current = null
             , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
             , sbfl.sbfl_last_update = systimestamp 
         where sbfl.sbfl_id = l_sbfl_id
           and sbfl.sbfl_prcs_id = p_process_id
        ;
        -- get all forward parallel paths and create subflows for them
        -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
        -- create subflows in one loop then step through them again in second loop
        -- to prevent some subflows getting to following merge gateway before all subflows are created (causes race condition)

        for new_path in ( select conn.conn_bpmn_id route
                               , objt.objt_bpmn_id target
                            from flow_connections conn
                            join flow_objects objt
                              on objt.objt_id = conn.conn_tgt_objt_id
                             and conn.conn_dgrm_id = objt.objt_dgrm_id
                           where conn.conn_dgrm_id = p_step_info.dgrm_id
                             and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
                             and conn.conn_src_objt_id = p_step_info.target_objt_id
                        )
        loop
          l_new_subflow.sbfl_id :=
            flow_engine_util.subflow_start
            ( p_process_id             => p_process_id         
            , p_parent_subflow         => l_sbfl_id        
            , p_starting_object        => p_step_info.target_objt_ref         
            , p_current_object         => p_step_info.target_objt_ref          
            , p_route                  => new_path.route         
            , p_last_completed         => p_step_info.target_objt_ref  
            , p_status                 => flow_constants_pkg.gc_sbfl_status_created
            , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
            , p_new_proc_level         => false
            )
          ;
          l_new_subflow.route   := new_path.route;
          l_new_subflows.extend;
          l_new_subflows (l_new_subflows.last) := l_new_subflow;
        end loop;
       
        for new_subflow in 1.. l_new_subflows.count
        loop
          -- check subflow still exists (in case earlier loop terminated everything in level)
          if flow_engine_util.check_subflow_exists
            ( p_process_id => p_process_id
            , p_subflow_id => l_new_subflows(new_subflow).sbfl_id
            )
          then
            -- step into first step on the new path
            flow_engine.flow_complete_step    
            ( p_process_id    => p_process_id
            , p_subflow_id    => l_new_subflows(new_subflow).sbfl_id
            , p_forward_route => l_new_subflows(new_subflow).route
            );
          end if;
        end loop; */
      elsif l_gateway_op_type = flow_constants_pkg.gc_gateway_merging then
        -- only single path going forward
        update  flow_subflows sbfl
            set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
              , sbfl.sbfl_current = p_step_info.target_objt_ref
              , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
              , sbfl.sbfl_last_update = systimestamp 
          where sbfl.sbfl_id = l_sbfl_id
            and sbfl.sbfl_prcs_id = p_process_id
        ;
        -- step into first step on the new path
        flow_engine.flow_complete_step   
        ( p_process_id => p_process_id
        , p_subflow_id => l_sbfl_id
        , p_forward_route => null
        );
      end if;  -- single path
    end if;  -- forward token
  end process_parallelGateway;

  procedure process_inclusiveGateway
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
    l_sbfl_id                 flow_subflows.sbfl_id%type;
    l_sbfl_id_sub             flow_subflows.sbfl_id%type;
    l_sbfl_id_par             flow_subflows.sbfl_id%type; 
    l_num_back_connections    number;   -- number of connections leading into object
    l_num_forward_connections number;   -- number of connections forward from object
    l_num_unfinished_subflows number;
    l_gateway_op_type         varchar2(10);
    l_forward_routes          varchar2(2000);
    l_new_subflows            t_new_sbfls := t_new_sbfls();
    l_new_subflow             t_new_sbfl_rec;
    l_gateway_forward_status    varchar2(10);
  begin
    -- handles opening and closing but not closing and reopening  --FFA41
    apex_debug.message(p_message => 'Next Step is inclusiveGateway '||p_step_info.target_objt_ref, p_level => 4) ;
    -- test if this is splitting or merging (or both) gateway
    l_gateway_op_type := gateway_op_type 
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_gateway_objt_id => p_step_info.target_objt_id
    );


    if l_gateway_op_type = flow_constants_pkg.gc_gateway_splitting  then
      -- this is opening inclusiveGateway.  Step into it.  Forward paths will get opened by flow_complete_step
      -- after user decision.
      l_forward_routes := get_gateway_route(p_process_id, p_step_info.target_objt_ref);
      apex_debug.message(p_message => 'Forward routes for inclusiveGateway '||p_step_info.target_objt_ref ||' :'||l_forward_routes, p_level => 4) ;
      -- we have splitting gateway going forward
      gateway_split
      ( p_process_id => p_process_id
      , p_subflow_id => p_subflow_id
      , p_sbfl_info  => p_sbfl_info
      , p_step_info  => p_step_info
      , p_gateway_routes => l_forward_routes
      );


/*      -- set current subflow to status split, current = null       
      update flow_subflows sbfl
         set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
           , sbfl.sbfl_current = ''
           , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
           , sbfl.sbfl_last_update = systimestamp 
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      for new_path in ( select conn.conn_bpmn_id                route
                             , ultimate_tgt_objt.objt_bpmn_id   target
                          from flow_connections conn
                          join flow_objects ultimate_tgt_objt
                            on ultimate_tgt_objt.objt_id = conn.conn_tgt_objt_id
                           and conn.conn_dgrm_id = ultimate_tgt_objt.objt_dgrm_id
                         where conn.conn_dgrm_id = p_step_info.dgrm_id
                           and conn.conn_src_objt_id = p_step_info.target_objt_id
                           and conn.conn_bpmn_id member of apex_string.split( l_forward_routes, ':' ) -- verify if this works
                      )
      loop
        -- path is included in list of chosen forward paths.
        apex_debug.message(p_message => 'starting parallel flow for inclusiveGateway', p_level => 3) ;
        l_new_subflow.sbfl_id :=
          flow_engine_util.subflow_start
          ( 
            p_process_id             => p_process_id         
          , p_parent_subflow         => p_subflow_id        
          , p_starting_object        => p_step_info.target_objt_ref        
          , p_current_object         => p_step_info.target_objt_ref          
          , p_route                  => new_path.route         
          , p_last_completed         => p_step_info.target_objt_ref 
          , p_status                 => flow_constants_pkg.gc_sbfl_status_created 
          , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
          , p_new_proc_level         => false      
          );
        l_new_subflow.route   := new_path.route;
        l_new_subflows.extend;
        l_new_subflows (l_new_subflows.last) := l_new_subflow;
      end loop;
      -- now step the new sub flows forward into their first tasks
      for new_subflow in 1.. l_new_subflows.count
        loop
          -- check subflow still exists (in case earlier loop terminated everything in level)
          if flow_engine_util.check_subflow_exists
            ( p_process_id => p_process_id
            , p_subflow_id => l_new_subflows(new_subflow).sbfl_id
            )
          then
            -- step into first step on the new path
            flow_engine.flow_complete_step    
            ( p_process_id    => p_process_id
            , p_subflow_id    => l_new_subflows(new_subflow).sbfl_id
            , p_forward_route => l_new_subflows(new_subflow).route
            );
          end if;
        end loop;*/
    elsif l_gateway_op_type = flow_constants_pkg.gc_gateway_both then
      -- diagram has closing and re-opening inclusiveGateway which is not supported
      apex_error.add_error
      ( 
        p_message => 'Inclusive Gateway with multiple inputs and multiple outputs not supported.  Re-draw as two gateways.'
      , p_display_location => apex_error.c_on_error_page
      );
    elsif l_gateway_op_type = flow_constants_pkg.gc_gateway_merging then
      -- merging gateway.  
      -- note actual number of subflows chosen could be 1 or more and need not be all of defined routes 
      -- forward paths from the diagram may have been started.  So always work on running subflows
      -- not connections from the diagram.
      apex_debug.message(p_message => 'Merging Inclusive Gateway'||p_step_info.target_objt_ref, p_level => 4) ;       

      -- replace from here with call to gateway_merge
      l_gateway_forward_status := gateway_merge (p_process_id, p_subflow_id, p_sbfl_info, p_step_info);
/*      -- set current subflow to status waiting,       
      update flow_subflows sbfl
         set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
           , sbfl.sbfl_last_update = systimestamp 
           , sbfl.sbfl_current = p_step_info.target_objt_ref
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- check if we are waiting for other flows or can proceed
      select count(*)
        into l_num_unfinished_subflows
        from flow_subflows sbfl
       where sbfl.sbfl_prcs_id = p_process_id
         and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
         and (  sbfl.sbfl_current != p_step_info.target_objt_ref
             or sbfl.sbfl_status != flow_constants_pkg.gc_sbfl_status_waiting_gateway
             )
      ;
      if l_num_unfinished_subflows = 0 then
        -- all merging tasks completed.  proceed from gateway
        for completed_subflows in ( select sbfl.sbfl_id
                                      from flow_subflows sbfl 
                                     where sbfl.sbfl_prcs_id = p_process_id
                                       and sbfl.sbfl_starting_object = p_sbfl_info.sbfl_starting_object
                                       and sbfl.sbfl_current = p_step_info.target_objt_ref 
                                       and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_waiting_gateway
                                  )
        loop
          flow_engine_util.subflow_complete
          ( p_process_id        => p_process_id
          , p_subflow_id        => completed_subflows.sbfl_id
          );
        end loop;

        --restart parent split subflow
        update flow_subflows sbfl
          set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
            , sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
            , sbfl.sbfl_last_update = systimestamp
        where sbfl.sbfl_last_completed = p_sbfl_info.sbfl_starting_object
          and sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
          and sbfl.sbfl_id = p_sbfl_info.sbfl_sbfl_id
        ;
        -- end cut for replace with gateway_merge*/
      if l_gateway_forward_status = 'proceed' then
        -- switch to parent subflow
        l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
        -- step into first step on the new path
        flow_engine.flow_complete_step     
        ( 
          p_process_id    => p_process_id
        , p_subflow_id    => l_sbfl_id
        , p_forward_route => null
        );
      end if;    -- merging finished      
    end if;  -- operation type
end process_inclusiveGateway;

procedure process_exclusiveGateway
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
is 
    l_num_forward_connections   number;   -- number of connections forward from object
    l_num_back_connections      number;   -- number of connections back from object
    l_forward_route             varchar2(2000);
    l_gateway_op_type           varchar2(10);
begin
    -- handles opening and closing and closing and reopening
    apex_debug.message(p_message => 'Begin process_exclusiveGateway for object: '||p_step_info.target_objt_tag, p_level => 3) ;

    l_gateway_op_type := gateway_op_type 
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_gateway_objt_id => p_step_info.target_objt_id
    );
    if l_gateway_op_type = flow_constants_pkg.gc_gateway_splitting then
       -- opening gateway - get choice
      l_forward_route := get_gateway_route(p_process_id, p_step_info.target_objt_ref);
    else -- closing gateway - keep going
      l_forward_route := null;
    end if;  

    update flow_subflows sbfl
        set sbfl.sbfl_current = p_step_info.target_objt_ref
            , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
            , sbfl.sbfl_last_update = systimestamp
            , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
      where sbfl.sbfl_id = p_subflow_id
        and sbfl.sbfl_prcs_id = p_process_id
    ;  
    flow_engine.flow_complete_step   
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_forward_route => l_forward_route
    );

end process_exclusiveGateway; 

procedure process_eventBasedGateway
  ( 
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_sbfl_info  in flow_subflows%rowtype
  , p_step_info  in flow_types_pkg.flow_step_info
  )
  is 
    l_sbfl_id_sub flow_subflows.sbfl_id%type;
  begin
    -- eventGateway can have multiple inputs and outputs, but there is no waiting, etc.
    -- incoming subflow continues on the first output path.
    -- additional output paths create new subflows
    apex_debug.message
    (
      p_message => 'Begin process_EventBasedGateway for object %s'
    , p0        => p_step_info.target_objt_ref
    , p_level => 4
    );
    -- mark parent flow as split
    update flow_subflows sbfl
       set sbfl.sbfl_last_completed = p_step_info.target_objt_ref
         , sbfl.sbfl_current = p_step_info.target_objt_ref
         , sbfl.sbfl_status =  flow_constants_pkg.gc_sbfl_status_split  
         , sbfl.sbfl_last_update = systimestamp 
     where sbfl.sbfl_id = p_subflow_id
       and sbfl.sbfl_prcs_id = p_process_id
    ;
    -- get all forward parallel paths and create subflows for them
    -- these are paths forward of p_step_info.target_objt_ref as we are doing double step
    for new_path in ( select conn.conn_bpmn_id route
                           , objt.objt_bpmn_id target
                        from flow_connections conn
                        join flow_objects objt
                          on objt.objt_id = conn.conn_tgt_objt_id
                         and conn.conn_dgrm_id = objt.objt_dgrm_id
                       where conn.conn_dgrm_id = p_step_info.dgrm_id
                         and conn.conn_tag_name = flow_constants_pkg.gc_bpmn_sequence_flow
                         and conn.conn_src_objt_id = p_step_info.target_objt_id
                    )
    loop
      -- create new subflows for forward event paths starting here
      l_sbfl_id_sub :=
        flow_engine_util.subflow_start
        ( 
          p_process_id             => p_process_id         
        , p_parent_subflow         => p_subflow_id       
        , p_starting_object        => p_step_info.target_objt_ref         
        , p_current_object         => p_step_info.target_objt_ref          
        , p_route                  => new_path.route         
        , p_last_completed         => p_step_info.target_objt_ref 
        , p_status                 => flow_constants_pkg.gc_sbfl_status_waiting_event   
        , p_parent_sbfl_proc_level => p_sbfl_info.sbfl_process_level
        , p_new_proc_level         => false    
        )
      ;
      -- step into first step on the new path
      flow_engine.flow_complete_step   
      (
        p_process_id    => p_process_id
      , p_subflow_id    => l_sbfl_id_sub
      , p_forward_route => new_path.route
      );
    end loop;
  end process_eventBasedGateway;



end flow_gateways;
/