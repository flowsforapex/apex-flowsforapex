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
    apex_debug.message(p_message => 'Begin flow_create', p_level => 3) ;
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
    commit;

    apex_debug.message(p_message => 'End flow_create', p_level => 3) ;

    return l_ret;
  end create_process;

  procedure start_process
  ( p_process_id    in flow_processes.prcs_id%type
  )
  is
    l_dgrm_id               flow_diagrams.dgrm_id%type;
    l_process_status        flow_processes.prcs_status%type;
    l_objt_bpmn_id          flow_objects.objt_bpmn_id%type;
    l_objt_sub_tag_name     flow_objects.objt_sub_tag_name%type;
    l_main_subflow_id       flow_subflows.sbfl_id%type;
    l_new_subflow_status    flow_subflows.sbfl_status%type;
  begin
      -- l_dgrm_id := flow_engine_util.get_dgrm_id( p_prcs_id => p_process_id );
    apex_debug.message(p_message => 'Starting Process '||p_process_id, p_level => 4) ;
    -- check process exists, is not running, and lock it
    begin
      select prcs.prcs_status
           , prcs.prcs_dgrm_id
        into l_process_status
           , l_dgrm_id
        from flow_processes prcs 
       where prcs.prcs_id = p_process_id
      for update wait 2
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
    begin
      -- get the starting object 
      select objt.objt_bpmn_id
           , objt.objt_sub_tag_name
        into l_objt_bpmn_id
           , l_objt_sub_tag_name
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
        apex_error.add_error
        ( p_message => 'You have multiple starting events defined. Make sure your diagram has only one starting event.'
        , p_display_location => apex_error.c_on_error_page
        );
      when no_data_found then
        apex_error.add_error
        ( p_message => 'No starting event was defined.'
        , p_display_location => apex_error.c_on_error_page
        );
    end;
    apex_debug.message(p_message => 'Found starting object '||l_objt_bpmn_id, p_level => 4) ;
    -- mark process as running
    update flow_processes prcs
       set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_running
         , prcs.prcs_last_update = systimestamp
     where prcs.prcs_dgrm_id = l_dgrm_id
       and prcs.prcs_id = p_process_id
         ;    
    -- check if start has a timer?  
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

    apex_debug.message(p_message => 'Initial Subflow created '||l_main_subflow_id, p_level => 4) ;

    -- commit the subflow creation
    commit;
    -- check startEvent sub type for timer or (later releases) other sub types
    if l_objt_sub_tag_name = flow_constants_pkg.gc_bpmn_timer_event_definition then 
      -- eventStart must be delayed with the timer 
      flow_timers_pkg.start_timer
      (
        pi_prcs_id => p_process_id
      , pi_sbfl_id => l_main_subflow_id
      );
    elsif l_objt_sub_tag_name is null then
      -- plain startEvent, step into first step
      flow_engine.flow_complete_step  
      ( p_process_id => p_process_id
      , p_subflow_id => l_main_subflow_id
      , p_forward_route => null
      );
    else 
      apex_error.add_error
      ( p_message => 'You have an unsupported starting event type. Only None (standard) Start Event and Timer Start Event are currently supported.'
      , p_display_location => apex_error.c_on_error_page
      );
    end if;
  end start_process;

  procedure reset_process
    ( p_process_id in flow_processes.prcs_id%type
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
    apex_debug.message(p_message => 'Begin flow_reset', p_level => 3) ;
  
    -- lock all objects
    begin
      open c_lock_all;
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      );  
      close c_lock_all;
    exception 
      when lock_timeout then
      apex_error.add_error
      ( p_message => 'Process objects for '||p_process_id||' currently locked by another user.  Try to reset later.'
      , p_display_location => apex_error.c_on_error_page
      );
    end;

    -- kill any timers sill running in the process
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
    
--    flow_process_vars.delete_all_for_process (pi_prcs_id => p_process_id);
--    commented out until variable expressions feature is released
--    process variables are NOT being cleared when the process is reset without this

    update flow_processes prcs
       set prcs.prcs_last_update = systimestamp
         , prcs.prcs_status = flow_constants_pkg.gc_prcs_status_created
     where prcs.prcs_id = p_process_id
    ;
    commit;
  end reset_process;

  procedure delete_process
    (
      p_process_id in flow_processes.prcs_id%type
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
    apex_debug.message(p_message => 'Begin flow_delete', p_level => 3) ;
    begin 
      -- lock all timers, logs, subflows and the process
      open c_lock_all;
      flow_timers_pkg.lock_process_timers
      ( pi_prcs_id => p_process_id
      ); 
      close c_lock_all; 

    exception 
      when lock_timeout then
        apex_error.add_error
        ( p_message => 'Process objects for '||p_process_id||' currently locked by another user.  Try again later.'
        , p_display_location => apex_error.c_on_error_page
        );
    end;

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

    flow_process_vars.delete_all_for_process (pi_prcs_id => p_process_id);
    
    delete
      from flow_processes prcs
     where prcs.prcs_id = p_process_id
    ;
    commit;
  end delete_process;

end flow_instances;