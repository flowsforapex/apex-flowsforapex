create or replace package body flow_instances 
as


  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);


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
          )
    values
          ( p_prcs_name
          , p_dgrm_id
          , flow_constants_pkg.gc_prcs_status_created
          , systimestamp
          , systimestamp
          )
      returning prcs.prcs_id into l_ret
    ;
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
    l_main_subflow_id       flow_subflows.sbfl_id%type;
    l_new_subflow_status    flow_subflows.sbfl_status%type;
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
       set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_running
         , prcs.prcs_last_update = systimestamp
     where prcs.prcs_dgrm_id = l_dgrm_id
       and prcs.prcs_id = p_process_id
         ;    
    -- log the start
    flow_logging.log_instance_event
    ( p_process_id => p_process_id
    , p_event      => flow_constants_pkg.gc_prcs_event_started
    );
    -- create the status for new subflow based on start subtype 
    if l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then 
      l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_waiting_timer;
    else
      l_new_subflow_status := flow_constants_pkg.gc_sbfl_status_running;
    end if;

    l_main_subflow_id := flow_engine_util.subflow_start 
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
    ( p_message => 'Initial Subflow created %0'
    , p0 => l_main_subflow_id
    );
    if l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then 
      -- process any before-event variable expressions on the starting object
      flow_expressions.process_expressions
      ( pi_objt_id     => l_objt_id
      , pi_set         => flow_constants_pkg.gc_expr_set_before_event
      , pi_prcs_id     => p_process_id
      , pi_sbfl_id     => l_main_subflow_id
      );
      -- test for any step errors
      if not flow_globals.get_step_error then 
        flow_timers_pkg.start_timer
        (
          pi_prcs_id => p_process_id
        , pi_sbfl_id => l_main_subflow_id
        ); 
      end if;       

    elsif l_objt_sub_tag_name is null then
      -- plain (none) startEvent
      -- process any variable expressions on the starting object
      flow_expressions.process_expressions
      ( pi_objt_id     => l_objt_id
      , pi_set         => flow_constants_pkg.gc_expr_set_on_event
      , pi_prcs_id     => p_process_id
      , pi_sbfl_id     => l_main_subflow_id
      );

      if not flow_globals.get_step_error then 
        -- step into first step
        flow_engine.flow_complete_step  
        ( p_process_id => p_process_id
        , p_subflow_id => l_main_subflow_id
        , p_forward_route => null
        , p_recursive_call => false
        );
      end if;
    else 
      -- note that this path doesn't curretly get exercised (v21.1) because only the timer subType tag gets parsed...
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_process_id
      , pi_sbfl_id        => l_main_subflow_id
      , pi_message_key    => 'start-type-unsupported'
      , p0 => l_objt_sub_tag_name       
      );
      -- $F4AMESSAGE 'start-type-unsupported' || 'Unsupported start event type (%0). Only None (standard) Start Event and Timer Start Event are currently supported.'
    end if;

  end start_process;

  procedure reset_process
    ( p_process_id  in flow_processes.prcs_id%type
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
            for update of prcs.prcs_id, sbfl.sbfl_id, sflg.sflg_last_updated wait 2
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
        /*apex_error.add_error
        ( p_message => 'Process objects for '||p_process_id||' currently locked by another user.  Try to reset later.'
        , p_display_location => apex_error.c_on_error_page
        );*/
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
    flow_process_vars.delete_all_for_process 
    ( pi_prcs_id => p_process_id
    , pi_retain_builtins => true
    );

    update flow_processes prcs
       set prcs.prcs_last_update = systimestamp
         , prcs.prcs_status = flow_constants_pkg.gc_prcs_status_created
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
        /*apex_error.add_error
        ( p_message => 'Process objects for '||p_process_id||' currently locked by another user.  Try again later.'
        , p_display_location => apex_error.c_on_error_page
        );*/
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
    ( 'delete_process'
    , 'process_id', p_process_id
    );
    begin 
      -- lock all timers, logs, subflows and the process
      open c_lock_all;
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      ); 
      close c_lock_all; 

    exception 
      when lock_timeout then
        /*apex_error.add_error
        ( p_message => 'Process objects for '||p_process_id||' currently locked by another user.  Try again later.'
        , p_display_location => apex_error.c_on_error_page
        );*/
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

    flow_process_vars.delete_all_for_process 
    ( pi_prcs_id => p_process_id
    , pi_retain_builtins => false
    );
    
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;

    commit;
  end delete_process;

end flow_instances;
/
