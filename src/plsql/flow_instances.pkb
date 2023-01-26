/* 
-- Flows for APEX - flow_instances.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created  25-May-2021  Richard Allen (Flowquest) for  MT AG  - refactor from flow_engine
-- Modified 30-May-2022  Moritz Klein (MT AG)
--
*/
create or replace package body flow_instances 
as


  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

  e_unsupported_start_event exception;

  type t_call_def is record
    ( dgrm_name              flow_diagrams.dgrm_name%type
    , dgrm_version           flow_diagrams.dgrm_version%type
    , dgrm_id                flow_diagrams.dgrm_id%type
    , dgrm_version_selection flow_types_pkg.t_bpmn_attribute_vc2
    );

  function call_is_recursive
    ( p_prcs_id   flow_processes.prcs_id%type
    , p_prdg_id   flow_instance_diagrams.prdg_id%type
    , p_dgrm_id   flow_diagrams.dgrm_id%type  
    ) return boolean
  is
    l_num_recursive_nodes number;
  begin
    -- tests id p_dgrm_id exists in the instance diagram tree above p_prdg_id
    select  count(1)
    into    l_num_recursive_nodes
    from    flow_instance_diagrams
    where   prdg_prcs_id = p_prcs_id
    and     prdg_dgrm_id = p_dgrm_id
    and     level        > 1
    start with prdg_id   = p_prdg_id
    connect by prior prdg_prdg_id = prdg_id
    ;
    return l_num_recursive_nodes > 0;
  end call_is_recursive;

  function diagram_is_callable
    ( p_dgrm_id   flow_diagrams.dgrm_id%type
    ) return boolean
  is
    l_is_callable   flow_types_pkg.t_bpmn_attribute_vc2;
  begin
      select nvl( objt.objt_attributes."apex"."isCallable" ,'false')
        into l_is_callable
        from flow_objects objt
       where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process
         and objt.objt_dgrm_id = p_dgrm_id
      ;
      return l_is_callable = 'true';
  end diagram_is_callable;

  procedure find_nested_calls
    ( p_dgrm_id         flow_diagrams.dgrm_id%type
    , p_prcs_id         flow_processes.prcs_id%type
    , p_parent_prdg_id  flow_instance_diagrams.prdg_id%type
    )
  is 
    l_child_dgrm_id                         flow_diagrams.dgrm_id%type;
    l_call_def                              t_call_def;
    l_current_prdg_id                       flow_instance_diagrams.prdg_id%type;
  begin
    for call_activity in (
      select objt.objt_bpmn_id
           , objt.objt_id
           , objt.objt_attributes."apex"."calledDiagram" as dgrm_name
           , objt.objt_attributes."apex"."calledDiagramVersion" as dgrm_version
           , objt.objt_attributes."apex"."calledDiagramVersionSelection" as dgrm_version_selection
        from flow_objects objt
       where objt.objt_tag_name = flow_constants_pkg.gc_bpmn_call_activity
         and objt.objt_dgrm_id = p_dgrm_id
      )
    loop
      l_child_dgrm_id :=
        flow_diagram.get_current_diagram
        ( pi_dgrm_name            => call_activity.dgrm_name
        , pi_dgrm_calling_method  => call_activity.dgrm_version_selection
        , pi_dgrm_version         => call_activity.dgrm_version
        , pi_prcs_id              => p_prcs_id
        );
      -- check diagram is callable
      if  diagram_is_callable (p_dgrm_id => l_child_dgrm_id) then
        -- diagram is callable 
        -- Check for self-reference
        -- If Diagram is calling itself stop processing and error out.
        if l_child_dgrm_id = p_dgrm_id then
          flow_errors.handle_general_error
          ( pi_message_key => 'start-diagram-calls-itself'
          , p0 => p_dgrm_id
          );
          -- $F4AMESSAGE 'start-diagram-calls-itself' || 'You tried to start a diagram %0 that contains a callActivity calling itself.' 
        else
          -- insert an instance_diagram record
          insert into flow_instance_diagrams
          ( prdg_prcs_id
          , prdg_dgrm_id
          , prdg_calling_dgrm
          , prdg_calling_objt
          , prdg_prdg_id
          )
          values 
          ( p_prcs_id
          , l_child_dgrm_id
          , p_dgrm_id
          , call_activity.objt_bpmn_id
          , p_parent_prdg_id
          )
          returning prdg_id into l_current_prdg_id
          ;
          -- check for indirect recursion
          if call_is_recursive  ( p_prcs_id => p_prcs_id
                                , p_dgrm_id => l_child_dgrm_id
                                , p_prdg_id => l_current_prdg_id) 
          then
            flow_errors.handle_general_error
            ( pi_message_key => 'start-diagram-calls-itself'
            , p0 => p_dgrm_id
            );
            -- $F4AMESSAGE 'start-diagram-calls-itself' || 'You tried to start a diagram %0 that contains a callActivity calling itself.'           
          -- find any nested calls in child
          end if;
          find_nested_calls ( p_dgrm_id         => l_child_dgrm_id
                            , p_prcs_id         => p_prcs_id 
                            , p_parent_prdg_id  => l_current_prdg_id
                            );
        end if;
      else
        -- diagram is not callable - raise error
        apex_debug.info
        ( p_message  => 'Building Diagram Call Tree - Diagram %0 (called by diagram %1 is set as not-callable'
        , p0  => l_child_dgrm_id
        , p1  => p_dgrm_id
        );
        flow_errors.handle_general_error
        ( pi_message_key => 'call-diagram-not-callable'
        , p0 => l_child_dgrm_id
        );
        -- $F4AMESSAGE 'call-diagram-not-callable' || 'You tried to call a diagram %0 that is marked as being not callable.'        
      end if;
    end loop; 
  end find_nested_calls;

  procedure create_call_structure
    ( p_prcs_id  in flow_processes.prcs_id%type
    , p_dgrm_id  in flow_diagrams.dgrm_id%type
    )
  is 
    l_parent_prdg_id  flow_instance_diagrams.prdg_id%type;
  begin
    -- put top level diagram into the call structure
    insert into flow_instance_diagrams
      ( prdg_prcs_id
      , prdg_dgrm_id
      , prdg_diagram_level
      )
    values 
      ( p_prcs_id
      , p_dgrm_id
      , 0
      )
    returning prdg_id into l_parent_prdg_id;
    -- find any nested calls 
    find_nested_calls ( p_dgrm_id         => p_dgrm_id
                      , p_prcs_id         => p_prcs_id
                      , p_parent_prdg_id  => l_parent_prdg_id
                      );
  end create_call_structure;

  function create_process
    ( p_dgrm_id   in flow_diagrams.dgrm_id%type
    , p_prcs_name in flow_processes.prcs_name%type
    ) return flow_processes.prcs_id%type
  is
    l_ret flow_processes.prcs_id%type;
  begin
    apex_debug.enter
    ('create_process'
    , 'dgrm_id', p_dgrm_id
    , 'p_prcs_name', p_prcs_name 
    );
    insert into flow_processes prcs
          ( prcs.prcs_name
          , prcs.prcs_dgrm_id
          , prcs.prcs_status
          , prcs.prcs_init_ts
          , prcs.prcs_last_update
          , prcs.prcs_init_by
          )
    values
          ( p_prcs_name
          , p_dgrm_id
          , flow_constants_pkg.gc_prcs_status_created
          , systimestamp
          , systimestamp
          , coalesce  ( sys_context('apex$session','app_user') 
                      , sys_context('userenv','os_user')
                      , sys_context('userenv','session_user')
                      )  
          )
      returning prcs.prcs_id into l_ret
    ;
    -- build the call structure for the process instance and any diagram calls 
    create_call_structure ( p_prcs_id => l_ret, p_dgrm_id => p_dgrm_id);

    -- log the process creation
    flow_logging.log_instance_event
    ( p_process_id => l_ret
    , p_event      => flow_constants_pkg.gc_prcs_event_created
    );
    commit;

    apex_debug.info
    ( p_message => 'Flow Instance created.  DGRM_ID : %0, PRCS_ID : %1'
    , p0 => p_dgrm_id
    , p1 => l_ret 
    );
    return l_ret;
  end create_process;

  procedure start_process
  ( p_process_id    in flow_processes.prcs_id%type
  )
  is
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_process_status        flow_processes.prcs_status%type;
    l_objt_bpmn_id          flow_objects.objt_bpmn_id%type;
    l_objt_id               flow_objects.objt_id%type;
    l_objt_sub_tag_name     flow_objects.objt_sub_tag_name%type;
    l_main_subflow          flow_types_pkg.t_subflow_context;
    l_new_subflow_status    flow_subflows.sbfl_status%type;
    l_priority_json         flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority              flow_processes.prcs_priority%type;
    l_due_on_json           flow_types_pkg.t_bpmn_attribute_vc2;
    l_due_on                flow_processes.prcs_due_on%type;
  begin
    apex_debug.enter
    ('start_process'
    , 'Process_ID', p_process_id 
    );
    -- check process exists, is not running, and lock it
    begin

      flow_globals.set_is_recursive_step (p_is_recursive_step => false);
      -- initialise step_had_error flag
      flow_globals.set_step_error ( p_has_error => false);

      select prcs.prcs_status
           , prcs.prcs_dgrm_id
        into l_process_status
           , l_dgrm_id
        from flow_processes prcs 
       where prcs.prcs_id = p_process_id
      for update wait 2
      ;
      if l_process_status != 'created' then
        flow_errors.handle_general_error
        ( pi_message_key => 'start-already-running'
        , p0 => p_process_id
        );
        -- $F4AMESSAGE 'start-already-running' || 'You tried to start a process (id %0) that is already running.'
      end if;
    exception
      when no_data_found then
        flow_errors.handle_general_error
        ( pi_message_key => 'start-not-created'
        , p0 => p_process_id
        );
        -- $F4AMESSAGE 'start-not-created' || 'You tried to start a process (id %0) that does not exist.' 
      when too_many_rows then
        flow_errors.handle_general_error
        ( pi_message_key => 'start-multiple-already-running'
        , p0 => p_process_id
        );
        -- $F4AMESSAGE 'start-multiple-already-running' || 'You tried to start a process (id %0) with multiple copies already running.' 
    end;
    begin
      -- get instance scheduling information
      select objt.objt_attributes."apex"."priority"
           , objt.objt_attributes."apex"."dueOn"
        into l_priority_json
           , l_due_on_json
        from flow_objects objt
       where objt.objt_dgrm_id = l_dgrm_id
         and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process
      ;
      if l_priority_json is not null then
        l_priority := flow_settings.get_priority ( pi_prcs_id => p_process_id, pi_expr => l_priority_json);
      end if;
      if l_due_on_json is not null then 
        l_due_on   := flow_settings.get_due_on (pi_prcs_id => p_process_id, pi_expr => l_due_on_json);
      end if;
      apex_debug.info (p_message => 'Process Priority : %0  Due On : %1', p0 => l_priority, p1 => l_due_on );
    end;
    begin
      -- get the starting object 
      select objt.objt_bpmn_id
           , objt.objt_sub_tag_name
           , objt.objt_id
        into l_objt_bpmn_id
           , l_objt_sub_tag_name
           , l_objt_id
        from flow_objects objt
        join flow_objects parent
          on objt.objt_objt_id = parent.objt_id
       where objt.objt_dgrm_id = l_dgrm_id
         and parent.objt_dgrm_id = l_dgrm_id
         and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_start_event  
         and parent.objt_tag_name = flow_constants_pkg.gc_bpmn_process
      ;
    exception
      when too_many_rows then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'start-multiple-start-events'
        );
        -- $F4AMESSAGE 'start-multiple-start-events' || 'You have multiple starting events defined. Make sure your diagram has only one start event.'
      when no_data_found then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'start-no-start-event'
        );
        -- $F4AMESSAGE 'start-no-start-event' || 'No starting event is defined in the Flow diagram.'
    end;
    apex_debug.info
    ( p_message => 'Found starting object %0'
    , p0 =>l_objt_bpmn_id
    );
    -- mark process as running
    update flow_processes prcs
       set prcs.prcs_status         = flow_constants_pkg.gc_prcs_status_running
         , prcs.prcs_start_ts       = systimestamp
         , prcs.prcs_last_update    = systimestamp
         , prcs.prcs_last_update_by =  coalesce  ( sys_context('apex$session','app_user') 
                                                 , sys_context('userenv','os_user')
                                                 , sys_context('userenv','session_user')
                                                 )  
         , prcs.prcs_priority       = l_priority
         , prcs.prcs_due_on         = l_due_on
     where prcs.prcs_dgrm_id = l_dgrm_id
       and prcs.prcs_id = p_process_id
         ;    
    -- log the start
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_started
    );
    -- create the status for new subflow based on start subtype
    case
      when l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then
        l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_waiting_timer;
      when l_objt_sub_tag_name is null then
        l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_running;
      else
        raise e_unsupported_start_event;
    end case;

    l_main_subflow := flow_engine_util.subflow_start 
      ( p_process_id => p_process_id
      , p_parent_subflow => null
      , p_starting_object => l_objt_bpmn_id
      , p_current_object => l_objt_bpmn_id
      , p_route => 'main'
      , p_last_completed => null
      , p_status => l_new_subflow_status 
      , p_parent_sbfl_proc_level => 0 
      , p_new_proc_level => false
      , p_dgrm_id => l_dgrm_id
      );

    apex_debug.info
    ( p_message => 'Initial Subflow created %0 with Step Key %1'
    , p0 => l_main_subflow.sbfl_id
    , p1 => l_main_subflow.step_key
    );
    if l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then 
      -- process any before-event variable expressions on the starting object
      flow_expressions.process_expressions
      ( pi_objt_bpmn_id   => l_objt_bpmn_id
      , pi_set            => flow_constants_pkg.gc_expr_set_before_event
      , pi_prcs_id        => p_process_id
      , pi_sbfl_id        => l_main_subflow.sbfl_id
      , pi_var_scope      => l_main_subflow.scope
      , pi_expr_scope     => l_main_subflow.scope
      );
      -- test for any step errors
      if not flow_globals.get_step_error then 
        flow_timers_pkg.start_timer
        (
          pi_prcs_id    => p_process_id
        , pi_sbfl_id    => l_main_subflow.sbfl_id
        , pi_step_key   => l_main_subflow.step_key
        ); 
      end if;       

    elsif l_objt_sub_tag_name is null then
      -- plain (none) startEvent
      -- process any variable expressions on the starting object
      flow_expressions.process_expressions
      ( pi_objt_bpmn_id  => l_objt_bpmn_id
      , pi_set           => flow_constants_pkg.gc_expr_set_on_event
      , pi_prcs_id       => p_process_id
      , pi_sbfl_id       => l_main_subflow.sbfl_id
      , pi_var_scope     => l_main_subflow.scope
      , pi_expr_scope    => l_main_subflow.scope      
      );

      if not flow_globals.get_step_error then 
        -- step into first step
        flow_engine.flow_complete_step  
        ( p_process_id => p_process_id
        , p_subflow_id => l_main_subflow.sbfl_id
        , p_step_key   => l_main_subflow.step_key
        , p_forward_route => null
        , p_recursive_call => false
        );
      end if;
    else 
      raise e_unsupported_start_event;
    end if;

  exception
    when e_unsupported_start_event then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_process_id
      , pi_sbfl_id        => l_main_subflow.sbfl_id
      , pi_message_key    => 'start-type-unsupported'
      , p0                => l_objt_sub_tag_name       
      );
      -- $F4AMESSAGE 'start-type-unsupported' || 'Unsupported start event type (%0). Only None (standard) Start Event and Timer Start Event are currently supported.'
  end start_process;

  procedure reset_process
    ( p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    l_return_code   number;
    cursor c_lock_all is 
        select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg_id
          from flow_subflows sbfl
          join flow_processes prcs
            on prcs.prcs_id = sbfl.sbfl_prcs_id 
          join flow_subflow_log sflg 
            on prcs.prcs_id = sflg.sflg_prcs_id
          join flow_instance_diagrams prdg
            on prcs.prcs_id = prdg.prdg_prcs_id
          where prcs.prcs_id = p_process_id
          order by sbfl.sbfl_process_level, sbfl.sbfl_id
            for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg.prdg_id wait 2
    ;
  begin
    apex_debug.enter
    ( 'reset_process'
    , 'process_id', p_process_id
    );
    -- lock all objects
    begin
      open c_lock_all;
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      );  
      close c_lock_all;
    exception 
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'process-lock-timeout'
        , p0 => p_process_id          
        );
        -- $F4AMESSAGE 'process-lock-timeout' || 'Process objects for %0 currently locked by another user.  Try again later.'
    end;

    -- kill any timers still running in the process
    flow_timers_pkg.terminate_process_timers
    ( pi_prcs_id => p_process_id
    , po_return_code => l_return_code
    );  
    -- clear out run-time object_log
    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    -- delete the subflows
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    -- delete all process variables except the builtins (new behaviour in 21.1)
    flow_proc_vars_int.delete_all_for_process 
    ( pi_prcs_id => p_process_id
    , pi_retain_builtins => true
    );
    -- reset the instance diagrams / call structure
    update flow_instance_diagrams prdg
    set prdg.prdg_diagram_level = null
    where prdg.prdg_prcs_id = p_process_id
      and prdg.prdg_diagram_level != 0
    ;
    -- reset the process status to 'created'
    update flow_processes prcs
       set prcs.prcs_status         = flow_constants_pkg.gc_prcs_status_created
         , prcs_start_ts            = null
         , prcs_complete_ts         = null
         , prcs.prcs_last_update    = systimestamp
         , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
     where prcs.prcs_id = p_process_id
    ;
    -- log the reset
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_reset
    , p_comment    => p_comment
    );
    commit;
  end reset_process;

  procedure terminate_process
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    l_return_code   number;
    cursor c_lock_all is 
      select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated
        from flow_subflows sbfl
        join flow_processes prcs
          on prcs.prcs_id = sbfl.sbfl_prcs_id 
        join flow_subflow_log sflg 
          on prcs.prcs_id = sflg.sflg_prcs_id
       where prcs.prcs_id = p_process_id
       order by sbfl.sbfl_process_level, sbfl.sbfl_id
         for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated wait 2;
  begin
    apex_debug.enter
    ( 'terminate_process'
    , 'process_id', p_process_id
    );
    begin 
      -- lock all timers, logs, subflows and the process.  
      open c_lock_all;
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      ); 
      close c_lock_all; 

    exception 
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'process-lock-timeout'
        , p0 => p_process_id          
        );
        -- $F4AMESSAGE 'process-lock-timeout' || 'Process objects for %0 currently locked by another user.  Try again later.'
    end;

    -- kill any timers sill running in the process
    flow_timers_pkg.delete_process_timers
    (
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  
    -- stop processing 
    flow_engine_util.terminate_level
    ( p_process_id => p_process_id
    , p_process_level => 0
    );
    apex_debug.info
    ( p_message => 'Flow Instance %0 terminated'
    , p0        => p_process_id
    );
    -- mark process as terminated
    update flow_processes prcs
       set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_terminated
         , prcs.prcs_last_update = systimestamp
         , prcs.prcs_complete_ts = systimestamp
         , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                , sys_context('userenv','os_user')
                                                , sys_context('userenv','session_user')
                                                )  
     where prcs.prcs_id = p_process_id
    ; 
    -- log termination
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_terminated
    , p_comment    => p_comment
    );
    -- finalize
    commit;
  end terminate_process;

  procedure delete_process
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_comment     in flow_instance_event_log.lgpr_comment%type default null
    )
  is
    l_return_code   number;
    cursor c_lock_all is 
      select prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg.prdg_id
        from flow_subflows sbfl
        join flow_processes prcs
          on prcs.prcs_id = sbfl.sbfl_prcs_id 
        join flow_subflow_log sflg 
          on prcs.prcs_id = sflg.sflg_prcs_id
        join flow_instance_diagrams prdg
          on prcs.prcs_id = prdg.prdg_prcs_id
       where prcs.prcs_id = p_process_id
       order by sbfl.sbfl_process_level, sbfl.sbfl_id
         for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated, prdg.prdg_id wait 2;
  begin
    apex_debug.enter
    ( 'delete_process'
    , 'process_id', p_process_id
    );
    begin 
      -- lock all timers, logs, subflows, instance diagrams and the process
      open c_lock_all;
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      ); 
      close c_lock_all; 

    exception 
      when lock_timeout then
        flow_errors.handle_instance_error
        ( pi_prcs_id        => p_process_id
        , pi_message_key    => 'process-lock-timeout'
        , p0 => p_process_id          
        );
        -- $F4AMESSAGE 'process-lock-timeout' || 'Process objects for %0 currently locked by another user.  Try again later.'
    end;
    -- log the deletion before process data deleted
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_deleted
    , p_comment    => p_comment
    );
    -- kill any timers sill running in the process
    flow_timers_pkg.delete_process_timers(
        pi_prcs_id => p_process_id
      , po_return_code => l_return_code
    );  
    -- clear out run-time object_log

    delete
      from flow_subflow_log sflg 
     where sflg_prcs_id = p_process_id
    ;
    delete
      from flow_subflows sbfl
     where sbfl.sbfl_prcs_id = p_process_id
    ;
    flow_proc_vars_int.delete_all_for_process 
    ( pi_prcs_id => p_process_id
    , pi_retain_builtins => false
    );
    delete 
      from flow_instance_diagrams prdg
     where prdg_prcs_id = p_process_id
    ;
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;

    commit;
  end delete_process;

  procedure set_priority
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_priority    in flow_processes.prcs_priority%type
    )
    is
    begin
      update flow_processes prcs
      set prcs.prcs_priority = prcs_priority
        , prcs.prcs_last_update = systimestamp
        , prcs.prcs_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                              , sys_context('userenv','os_user')
                                              , sys_context('userenv','session_user')
                                              )  
      where prcs.prcs_id = p_process_id;
      -- log the priority change
      flow_logging.log_instance_event
      ( p_process_id => p_process_id
      , p_event      => flow_constants_pkg.gc_prcs_event_priority_set
      , p_comment    => 'Priority set to '||p_priority
      );      
    end set_priority;

  function priority
    ( p_process_id  in flow_processes.prcs_id%type
    ) return flow_processes.prcs_priority%type
    is
      l_priority    flow_processes.prcs_priority%type;
    begin
      select prcs_priority
        into l_priority
        from flow_processes
       where prcs_id = p_process_id;
      return l_priority;
    end priority;

  procedure set_due_on
    (
      p_process_id  in flow_processes.prcs_id%type
    , p_due_on      in flow_processes.prcs_due_on%type
    )
    is
    begin
      update flow_processes prcs
      set prcs.prcs_due_on = prcs_due_on
        , prcs.prcs_last_update = systimestamp
        , prcs.prcs_last_update_by = coalesce ( sys_context('apex$session','app_user') 
                                              , sys_context('userenv','os_user')
                                              , sys_context('userenv','session_user')
                                              )  
      where prcs.prcs_id = p_process_id;
      -- log the priority change
      flow_logging.log_instance_event
      ( p_process_id => p_process_id
      , p_event      => flow_constants_pkg.gc_prcs_event_due_on_set
      , p_comment    => 'Instance Due On set to '||to_char(p_due_on, flow_constants_pkg.gc_prov_default_tstz_format)
      );  
  end set_due_on;

  function due_on
    ( p_process_id  in flow_processes.prcs_id%type
    ) return flow_processes.prcs_due_on%type
    is
      l_due_on    flow_processes.prcs_due_on%type;
    begin
      select prcs_due_on
        into l_due_on
        from flow_processes
       where prcs_id = p_process_id;
      return l_due_on;
    end due_on;

end flow_instances;
/
