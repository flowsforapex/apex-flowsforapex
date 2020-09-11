create or replace package body flow_api_pkg
as

  function get_dgrm_name
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return varchar2
  is
    l_dgrm_name flow_diagrams.dgrm_name%type;
  begin

    select dgrm.dgrm_name
      into l_dgrm_name
      from flow_processes prcs
      join flow_diagrams dgrm
        on dgrm.dgrm_id = prcs.prcs_dgrm_id
     where prcs.prcs_id = p_prcs_id
    ;
         
    return l_dgrm_name;
  end get_dgrm_name;
  
  function get_dgrm_id    --- currently also exists in flow_engine - fix FFA41
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return flow_processes.prcs_dgrm_id%type
  as
    l_prcs_dgrm_id flow_processes.prcs_dgrm_id%type;
  begin
    
    select prcs.prcs_dgrm_id
      into l_prcs_dgrm_id
      from flow_processes prcs
     where prcs.prcs_id = p_prcs_id
    ;
    
    return l_prcs_dgrm_id;
    
  end get_dgrm_id;

  function flow_create
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_prcs_name in flow_processes.prcs_name%type default null
  ) return flow_processes.prcs_id%type
  as
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin
  
    select dgrm_id
      into l_dgrm_id
      from flow_diagrams
     where dgrm_name = pi_dgrm_name
    ;
  
    return
      flow_create
      (
        pi_dgrm_id   => l_dgrm_id
      , pi_prcs_name => pi_prcs_name
      )
    ;
  
  end flow_create;

  function flow_create
  (
    pi_dgrm_id   in flow_diagrams.dgrm_id%type
  , pi_prcs_name in flow_processes.prcs_name%type default null
  ) return flow_processes.prcs_id%type
  is
    l_ret flow_processes.prcs_id%type;
  begin
    apex_debug.message(p_message => 'Begin flow_create', p_level => 3) ;
    insert 
      into  flow_processes prcs
          ( prcs.prcs_name
          , prcs.prcs_dgrm_id
          , prcs.prcs_status
          , prcs.prcs_init_ts
          , prcs.prcs_last_update
          )
    values
          ( pi_prcs_name
          , pi_dgrm_id
          , 'created'
          , systimestamp
          , systimestamp
          )
      returning prcs.prcs_id into l_ret
    ;
    apex_debug.message(p_message => 'End flow_create', p_level => 3) ;

    return l_ret;
  end flow_create;

  procedure flow_create
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_prcs_name in flow_processes.prcs_name%type
  )
  as
    l_prcs_id flow_processes.prcs_id%type;
  begin
    l_prcs_id :=
      flow_create
      (
        pi_dgrm_name => pi_dgrm_name
      , pi_prcs_name => pi_prcs_name
      );
  end flow_create;

  procedure flow_create
  (
    pi_dgrm_id   in flow_diagrams.dgrm_id%type
  , pi_prcs_name in flow_processes.prcs_name%type
  )
  as
    l_prcs_id flow_processes.prcs_id%type;
  begin
    l_prcs_id :=
      flow_create
      (
        pi_dgrm_id   => pi_dgrm_id
      , pi_prcs_name => pi_prcs_name
      );
  end flow_create;

  function next_step_exists -- not using this now.  Needs checking. FFA41 remove PROCESS
  ( p_process_id in flow_processes.prcs_id%type
  ,  p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean
  is
    l_next_count number;
    l_dgrm_id    flow_diagrams.dgrm_id%type;
    l_return     boolean;
  begin
    apex_debug.message(p_message => 'Begin next_step_exists', p_level => 3) ;
    l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );

    if p_subflow_id is not null then
      select count(*)                        
        into l_next_count
        from flow_subflows sbfl
           , flow_objects   objt
      where sbfl.sbfl_prcs_id = p_process_id
        and sbfl.sbfl_id = p_subflow_id
        and  objt.objt_dgrm_id = l_dgrm_id
        and  objt.objt_bpmn_id = sbfl.sbfl_current
        and (  objt.objt_tag_name != 'bpmn:endEvent'
            or (    objt.objt_tag_name = 'bpmn:endEvent'
                and objt.objt_type != 'PROCESS'
               )
            or objt.objt_tag_name = 'bpmn:startEvent'
            )
      ;
      
      l_return := ( l_next_count > 0 );
    else 
      l_return := false;
    end if;
    
    return l_return;
  exception
    when others
    then
      raise;
  end next_step_exists;

  function next_step_exists_yn 
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return varchar2
  is
      l_ret boolean;
  begin
      l_ret := next_step_exists
              ( p_process_id => p_process_id
              , p_subflow_id => p_subflow_id
              );
      if l_ret = true
      then
          return 'y';
      else 
          return 'n';
      end if;
  end;

  function next_multistep_exists 
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean
  -- returns true if next step requires a choice of direction (i.e., has a tag of
  -- - an Opening Exclusive Gateway
  -- - an Opening Optional Gateway
  is
    l_next_count number;
    l_dgrm_id    flow_diagrams.dgrm_id%type;
    l_return     boolean;
  begin
    apex_debug.message(p_message => 'Begin next_multistep_exists', p_level => 3) ;
    
    if (p_subflow_id is not null and p_process_id is not null) then

      l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
      
      select count(*)                        
        into l_next_count
        from flow_connections conn
        join flow_objects objt
          on objt.objt_id = conn.conn_src_objt_id
         and conn.conn_tag_name = 'bpmn:sequenceFlow'
       where conn.conn_dgrm_id = l_dgrm_id
         and objt.objt_bpmn_id = ( select sbfl.sbfl_current
                                     from flow_subflows sbfl
                                    where sbfl.sbfl_prcs_id = p_process_id
                                      and sbfl.sbfl_id = p_subflow_id
                                 )
      ;
      
      l_return := ( l_next_count > 1 );
    else
      l_return := false;
    end if;
    
    return l_return;
  end next_multistep_exists;

  function next_multistep_exists_yn 
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return varchar2
  is
      l_ret boolean;
  begin
      l_ret := next_multistep_exists
              ( p_process_id => p_process_id
              , p_subflow_id => p_subflow_id
              );
      if l_ret = true
      then
          return 'y';
      else 
          return 'n';
      end if;
  end next_multistep_exists_yn;

  function next_step_type
  (
    p_sbfl_id in flow_subflows.sbfl_id%type
  ) return varchar2
  as
    l_objt_tag_name flow_objects.objt_tag_name%type;
    l_out_conns     number;

    l_return varchar2(50 char);
  begin
      select objt.objt_tag_name
           , count(*)
        into l_objt_tag_name
           , l_out_conns
        from flow_subflows sbfl
        join flow_processes prcs
          on prcs.prcs_id = sbfl.sbfl_prcs_id
        join flow_objects objt
          on objt.objt_dgrm_id = prcs.prcs_dgrm_id
         and objt.objt_bpmn_id = sbfl.sbfl_current
        join flow_connections conn
          on conn.conn_src_objt_id = objt.objt_id
         and conn.conn_tag_name = 'bpmn:sequenceFlow'
       where sbfl.sbfl_id = p_sbfl_id
    group by objt.objt_tag_name
    ;

    case 
      when l_out_conns > 1 then
        l_return :=
          case l_objt_tag_name
            when 'bpmn:exclusiveGateway' then gc_single_choice
            when 'bpmn:inclusiveGateway' then gc_multi_choice
            else 'unknown'
          end
        ;
      else
        l_return := gc_step;
    end case;

    return l_return;
  exception
    when no_data_found then
      return null;
  end next_step_type;

function get_current_progress -- creates the markings for the bpmn viewer to show current progress
( p_process_id in flow_processes.prcs_id%type
) return varchar2
is 
    l_marker_json varchar2(2000);
begin
    apex_debug.message(p_message => 'Begin get_current_progress', p_level => 3) ;
    WITH markings AS 
    (
    select 
          sflg.sflg_objt_id bpmnObject
         ,'completed-node-bpmn' marking
         ,'1' layer
      from flow_subflow_log sflg 
     where sflg.sflg_prcs_id = p_process_id
    UNION
    select distinct 
          sbfl.sbfl_last_completed bpmnObject 
        ,'last-completed-node-bpmn'  marking
        , '2' layer
     from flow_subflows sbfl
    where sbfl.sbfl_last_completed is not null
      and sbfl.sbfl_prcs_id = p_process_id
    UNION
    select distinct 
          sbfl.sbfl_current bpmnObject 
        ,'current-node-bpmn'  marking
        , '3' layer
     from flow_subflows sbfl
    where sbfl.sbfl_current is not null
      and sbfl.sbfl_prcs_id = p_process_id
    )
    select JSON_ARRAYAGG
            ( JSON_OBJECT
                ( KEY 'bpmnObject' VALUE m.bpmnObject
                , KEY 'marking' VALUE m.marking
                ) order by m.layer asc
            )
      into l_marker_json  
      from markings m
    ;
    return l_marker_json;
exception
  when others
  then
    raise;
end get_current_progress;

procedure flow_start
  ( p_process_id in flow_processes.prcs_id%type
  )
  is
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_process_status  flow_processes.prcs_status%type;
  begin
      l_dgrm_id := get_dgrm_id( p_prcs_id => p_process_id );
    
      apex_debug.message(p_message => 'Begin flow_start', p_level => 3) ;
      -- check the process isn't already running and return error if it is
      begin
        select prcs.prcs_status
          into l_process_status
          from flow_processes prcs 
        where prcs.prcs_id = p_process_id
        ;
        if l_process_status != 'created' then
          apex_error.add_error
          ( p_message => 'You tried to start a process that is already running'
          , p_display_location => apex_error.c_on_error_page
          );  
        end if;
      exception
        when no_data_found then
          apex_error.add_error
          ( p_message => 'You tried to start a non-existant process.'
          , p_display_location => apex_error.c_on_error_page
          );  
        when too_many_rows then
          apex_error.add_error
          ( p_message => 'Multiple copies of the process already running'
          , p_display_location => apex_error.c_on_error_page
          );  
      end;
      flow_engine.flow_start_process 
        ( p_process_id => p_process_id
        );
end flow_start;

procedure flow_next_step
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
, p_forward_route in flow_diagrams.dgrm_id%type default null
)
is 
begin
  flow_engine.flow_next_step
  ( p_process_id => p_process_id
  , p_subflow_id => p_subflow_id
  , p_forward_route => p_forward_route);   -- FFA 41 remove this & only pass null once next_branch removed
end flow_next_step;


procedure flow_next_branch  -- to be removed for FFA50
  ( p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_branch_name in varchar2
  )
  is
    l_dgrm_id             flow_processes.prcs_dgrm_id%type;
    l_conn_target_ref     flow_objects.objt_bpmn_id%type;
    l_conn_tgt_objt_id    flow_connections.conn_tgt_objt_id%type;
    l_sbfl_current        flow_subflows.sbfl_current%type;
    l_sbfl_current_objt_id flow_objects.objt_id%type;
    l_current_tag_name    flow_objects.objt_tag_name%type;
    l_new_subflow         flow_subflows.sbfl_id%type;
  begin
    apex_debug.message(p_message => 'Begin flow_next_branch', p_level => 3) ;
    -- get diagram name and current state
    apex_debug.info('p_BRANCH_NAME passed in :',p_branch_name);
    if p_branch_name is null
    then 
          apex_error.add_error
          ( p_message => 'No forward path found for Gateway'
          , p_display_location => apex_error.c_on_error_page
          );
    end if;

    select prcs.prcs_dgrm_id
         , sbfl.sbfl_current
         , objt.objt_tag_name
         , objt.objt_id
      into l_dgrm_id
         , l_sbfl_current
         , l_current_tag_name
         , l_sbfl_current_objt_id
      from flow_processes prcs
      join flow_subflows sbfl
        on sbfl.sbfl_prcs_id = prcs.prcs_id
      join flow_objects objt
        on sbfl.sbfl_current = objt.objt_bpmn_id
       and prcs.prcs_dgrm_id = objt_dgrm_id
     where sbfl.sbfl_prcs_id = p_process_id
       and sbfl.sbfl_id = p_subflow_id
    ;
    case l_current_tag_name 
    when 'bpmn:exclusiveGateway' then
      -- only only path chosen.  Keep existing subflow but switch to chosen path
      -- step into first step on the chosen path
      flow_next_step 
        (p_process_id => p_process_id
        ,p_subflow_id => p_subflow_id
        ,p_forward_route => p_branch_name
        );
    when 'bpmn:inclusiveGateway' then
      apex_debug.message(p_message => 'Begin creating parallel flows for inclusiveGateway', p_level => 3) ;
      -- get all forward parallel paths and create subflows for them if they are in forward path(s) chosen
      -- these are paths forward of l_conn_target_ref as we are doing double step.
      begin
        for new_path in (
            select conn.conn_bpmn_id route
                  , objt.objt_bpmn_id target
              from flow_connections conn
              join flow_objects objt
                on objt.objt_id = conn.conn_tgt_objt_id
              where conn.conn_dgrm_id = l_dgrm_id
                and conn.conn_src_objt_id = l_sbfl_current_objt_id
                and conn.conn_bpmn_id in (select * from table(apex_string.split(':'||p_branch_name||':',':')))
        )
        loop
              -- path is included in list of chosen forward paths.
              apex_debug.message(p_message => 'starting parallel flow for inclusiveGateway', p_level => 3) ;
              l_new_subflow := flow_engine.subflow_start
                  ( p_process_id =>  p_process_id         
                  , p_parent_subflow =>  p_subflow_id        
                  , p_starting_object =>  l_sbfl_current        
                  , p_current_object => l_sbfl_current          
                  , p_route =>  new_path.route         
                  , p_last_completed =>  l_sbfl_current        
                  );
              -- step into first step on the new path
              flow_next_step 
                  (p_process_id => p_process_id
                  ,p_subflow_id => l_new_subflow
                  ,p_forward_route => new_path.route
                  );
        end loop;
        -- set current subflow to status split, current = null       
        update flow_subflows sbfl
          set sbfl.sbfl_last_completed = l_sbfl_current
            , sbfl.sbfl_current = ''
            , sbfl.sbfl_status = 'split'
            , sbfl.sbfl_last_update = sysdate 
        where sbfl.sbfl_id = p_subflow_id
          and sbfl.sbfl_prcs_id = p_process_id
            ;
      exception
        when no_data_found then
          apex_error.add_error
          ( p_message => 'No forward paths found for opening Inclusive Gateway'
          , p_display_location => apex_error.c_on_error_page
          );
      end;
    end case;  
  end flow_next_branch;

  procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  )
  is
        l_return_code   number;
  begin
    apex_debug.message(p_message => 'Begin flow_reset', p_level => 3) ;
  
    -- clear out run-time object_log
    -- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
    -- into log audit trail  (not yet planned feature!)

        
    -- kill any timers sill running in the process
    flow_timers_pkg.terminate_process_timers(
        p_process_id => p_process_id
      , p_return_code => l_return_code
    );  
    
    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    
    update flow_processes prcs
       set prcs.prcs_last_update = sysdate
         , prcs.prcs_status = 'created'
     where prcs.prcs_id = p_process_id
    ;
  end flow_reset;

  procedure flow_delete
  (
    p_process_id in flow_processes.prcs_id%type
  )
  is
    l_return_code   number;
  begin
    apex_debug.message(p_message => 'Begin flow_delete', p_level => 3) ;
    -- clear out run-time object_log
    -- if log retention enabled, maybe write existing logs out for the process with notes = 'RESET- '||notes
    -- into log audit trail  (not yet planned feature!)

    -- kill any timers sill running in the process
    flow_timers_pkg.delete_process_timers(
        p_process_id => p_process_id
      , p_return_code => l_return_code
    );  

    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;
  end flow_delete;

end flow_api_pkg;
