create or replace package body flow_gateways
as 

  type t_new_sbfl_rec is record
  ( sbfl_id   flow_subflows.sbfl_id%type
  , route     flow_subflows.sbfl_route%type
  );

  type t_new_sbfls is table of t_new_sbfl_rec;

  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

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
      if flow_engine_util.lock_subflow(p_sbfl_info.sbfl_sbfl_id) then
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
      else 
        -- unable to lock parent 'split' subflow.
        apex_error.add_error
        ( p_message => 'Unable to lock split parent subflow '||p_subflow_id||' before merge.  Select for update timed out'
        , p_display_location => apex_error.c_on_error_page
        );
      end if;
      -- start new tx by locking parent subflow
      if not flow_engine_util.lock_subflow(p_sbfl_info.sbfl_sbfl_id) then
        -- unable to lock parent 'split' subflow.
        apex_error.add_error
        ( p_message => 'Unable to lock split parent subflow '||p_subflow_id||' after merge.  Select for update timed out'
        , p_display_location => apex_error.c_on_error_page
        );
      end if;
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

    -- commit the transaction
    commit;
    
    for new_subflow in 1.. l_new_subflows.count
    loop
      -- check subflow still exists and lock it(in case earlier loop terminated everything in level)
      if flow_engine_util.lock_subflow
        ( p_subflow_id => l_new_subflows(new_subflow).sbfl_id
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

  procedure process_para_incl_Gateway
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
    l_forward_routes            varchar2(2000);
    l_new_subflows              t_new_sbfls := t_new_sbfls();
    l_new_subflow               t_new_sbfl_rec;
  begin
    apex_debug.message(p_message => 'Next Step is '||p_step_info.target_objt_tag||' '||p_step_info.target_objt_ref, p_level => 4) ;
    -- get numbrer of forward and backward connections
    flow_engine_util.get_number_of_connections
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_target_objt_id => p_step_info.target_objt_id
    , pi_conn_type => flow_constants_pkg.gc_bpmn_sequence_flow
    , po_num_back_connections => l_num_back_connections
    , po_num_forward_connections => l_num_forward_connections
    );

    l_gateway_forward_status := 'proceed';
    l_sbfl_id  := p_subflow_id;

    if l_num_back_connections > 1  then
      apex_debug.message(p_message => 'Merging '||p_step_info.target_objt_tag||' '||p_step_info.target_objt_ref, p_level => 4) ;       
      -- we have merging gateway.  do the merge. returns 'wait' if flow is waiting at gateway, 'proceed' if merged
      l_gateway_forward_status := gateway_merge (p_process_id, p_subflow_id, p_sbfl_info, p_step_info);

      -- switch to parent subflow 
      l_sbfl_id := p_sbfl_info.sbfl_sbfl_id;
    end if;
    
    -- now do forward path, if you have token to 'proceed'
    if l_gateway_forward_status = 'proceed' then 
      if l_num_forward_connections > 1 then
        -- we have splitting gateway going forward
        apex_debug.message(p_message => 'Splitting '||p_step_info.target_objt_tag||' '||p_step_info.target_objt_ref, p_level => 4) ;       
        case p_step_info.target_objt_tag
        when flow_constants_pkg.gc_bpmn_gateway_inclusive then 
          l_forward_routes := get_gateway_route(p_process_id, p_step_info.target_objt_ref);
          apex_debug.message(p_message => 'Forward routes for inclusiveGateway '||p_step_info.target_objt_ref ||' :'||l_forward_routes, p_level => 4) ;
        when flow_constants_pkg.gc_bpmn_gateway_parallel then 
          l_forward_routes := 'parallel';  -- just needs to be some not null string
        end case;

        gateway_split
        ( p_process_id => p_process_id
        , p_subflow_id => l_sbfl_id
        , p_sbfl_info  => p_sbfl_info
        , p_step_info  => p_step_info
        , p_gateway_routes => l_forward_routes
        );

      elsif l_num_forward_connections = 1 then
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
  end process_para_incl_Gateway;

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
    -- l_gateway_op_type           varchar2(10);
  begin
    -- handles opening and closing and closing and reopening
    apex_debug.message(p_message => 'Begin process_exclusiveGateway for object: '||p_step_info.target_objt_tag, p_level => 3) ;
    flow_engine_util.get_number_of_connections
    ( pi_dgrm_id => p_step_info.dgrm_id
    , pi_target_objt_id => p_step_info.target_objt_id
    , pi_conn_type => flow_constants_pkg.gc_bpmn_sequence_flow
    , po_num_back_connections => l_num_back_connections
    , po_num_forward_connections => l_num_forward_connections
    );

    if l_num_forward_connections > 1 then
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
    ( p_process_id in flow_processes.prcs_id%type
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