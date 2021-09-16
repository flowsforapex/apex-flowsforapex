create or replace package body flow_tasks
as 


  procedure handle_script_error -- largely duplicates flow_errors.handle_instance_error
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_script_object in flow_objects.objt_bpmn_id%type 
  , p_error_type    in varchar2
  , p_error_stack   in varchar2 default null
  )
  is 
    l_prcs_id   flow_processes.prcs_id%type;
    l_sbfl_id   flow_subflows.sbfl_id%type;
  begin 
        apex_debug.enter 
      ( 'handle_script_error'
      , 'p_script_object: ', p_script_object
      , 'p_error_type ', p_error_type 
      );
       -- lock process and subflow
      select prcs.prcs_id, sbfl.sbfl_id
        into l_prcs_id, l_sbfl_id
        from flow_processes prcs
        join flow_subflows sbfl 
          on prcs.prcs_id = sbfl.sbfl_prcs_id
       where prcs.prcs_id = p_process_id
         and sbfl.sbfl_id = p_subflow_id
      for update wait 2;
      -- set subflow to error status
      update flow_subflows sbfl
         set sbfl.sbfl_current = p_script_object
           , sbfl.sbfl_last_update = systimestamp
           , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_error
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- set instance to error status
      update flow_processes prcs
         set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_error
           , prcs.prcs_last_update = systimestamp
       where prcs.prcs_id = p_process_id
      ;
      -- log error as instance event
      flow_logging.log_instance_event
      ( p_process_id  => p_process_id 
      , p_objt_bpmn_id => p_script_object
      , p_event       => flow_constants_pkg.gc_prcs_event_error
      , p_comment     => case p_error_type
                         when 'failed'      then 'ScriptTask failed on object '
                         when 'stop_engine' then 'User Script Requested ScriptTask Stop on object '
                         end 
                         || p_script_object|| ' error data....'||p_error_stack
      );

      apex_debug.message 
      ( p_message => 'Script failed in ScriptTask.  Object: %0.'
      , p0        => p_script_object
      , p_level   => 2
      );
  end handle_script_error;


  procedure process_task
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is
  begin
    apex_debug.enter 
    ( 'process_task'
    , 'object: ', p_step_info.target_objt_tag 
    );

    -- set boundaryEvent Timers, if any
    flow_boundary_events.set_boundary_timers
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
  end process_task;

  procedure process_userTask
    ( p_process_id    in flow_processes.prcs_id%type
    , p_subflow_id    in flow_subflows.sbfl_id%type
    , p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is 
  begin
    -- current implementation is limited to one userTask type, which is to run a user defined APEX page
    -- future userTask types could include parameterised, standarised template pages , e.g., for approvals??  template scripts ??
    -- current implementation is implemented via the process inbox view.  
    apex_debug.enter 
    ( 'process_userTask'
    , 'p_step_info.target_objt_tag', p_step_info.target_objt_tag 
    );


    -- set boundaryEvent Timers, if any
    flow_boundary_events.set_boundary_timers 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
  end process_userTask;

  procedure process_scriptTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.enter 
    ( 'process_scriptTask'
    , 'p_step_info.target_objt_tag', p_step_info.target_objt_tag 
    );
    -- current implementation is limited to one scriptTask type, which is to run a user defined PL/SQL script
    -- future scriptTask types could include standarised template scripts ??
    -- current implementation is limited to synchronous script execution (i.e., script is run as part of Flows for APEX process)
    -- future implementations could include async scriptTasks, where script execution is queued.
  
    -- set work started time
    flow_engine.start_step 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_called_internally => true
    );
    
    flow_plsql_runner_pkg.run_task_script(
      pi_prcs_id => p_process_id
    , pi_sbfl_id => p_subflow_id
    , pi_objt_id => p_step_info.target_objt_id
    );

    flow_engine.flow_complete_step 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id 
    );

  exception
    when flow_plsql_runner_pkg.e_plsql_script_failed then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script failed in plsql script runner'
      );
      /*handle_script_error
      ( p_process_id    => p_process_id
      , p_subflow_id    => p_subflow_id
      , p_script_object => p_step_info.target_objt_ref
      , p_error_type    => 'failed'
      , p_error_stack   => 'error stack to be added'
      );
      commit;*/
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_process_id
      , pi_sbfl_id        => p_subflow_id
      , pi_message_key    => 'plsql_script_failed'
      , p0 => p_process_id
      , p1 => p_step_info.target_objt_ref
      );
      -- $F4AMESSAGE 'plsql_script_failed' || 'Process %0: ScriptTask %1 failed due to PL/SQL error - see event log.'

    when flow_plsql_runner_pkg.e_plsql_script_requested_stop then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script requested stop_engine in plsql script runner'
      );
      /*handle_script_error
      ( p_process_id    => p_process_id
      , p_subflow_id    => p_subflow_id
      , p_script_object => p_step_info.target_objt_ref
      , p_error_type    => 'stop_engine'
      , p_error_stack   => 'error stack to be added'
      );
      commit;  */  
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_process_id
      , pi_sbfl_id        => p_subflow_id
      , pi_message_key    => 'plsql_script_requested_stop'
      , p0 => p_process_id
      , p1 => p_step_info.target_objt_ref
      );  
      -- $F4AMESSAGE 'plsql_script_requested_stop' || 'Process %0: ScriptTask %1 requested processing stop - see event log.'

  end process_scriptTask;

  procedure process_serviceTask --- note NOT CURRENTLY BEING USED FOR SERVICETASKS - USING process_scriptTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.enter 
    ( 'process_serviceTask'
    , 'p_step_info.target_objt_tag', p_step_info.target_objt_tag 
    );


    -- current implementation is limited to one serviceTask type, which is for apex message template sent from user defined PL/SQL script
    -- future serviceTask types could include text message, tweet, AOP document via email, etc.
    -- current implementation is limited to synchronous email send (i.e., email sent as part of Flows for APEX process).
    -- future implementations could include async serviceTask, where message generation is queued, or non-email services

    flow_engine.start_step 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    , p_called_internally => true
    );

    flow_plsql_runner_pkg.run_task_script
    ( pi_prcs_id => p_process_id
    , pi_sbfl_id => p_subflow_id
    , pi_objt_id => p_step_info.target_objt_id
    );

    flow_engine.flow_complete_step 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id 
    );

  exception
    when others then
      rollback;
      raise flow_plsql_runner_pkg.e_plsql_script_failed;
  end process_serviceTask;

  procedure process_manualTask
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.enter 
    ('process_manualTask'
    , 'p_step_info.target_objt_tag', p_step_info.target_objt_tag 
    );

    -- current implementation of manualTask performs exactly like a standard Task, without attached boundary timers
    -- future implementation could include auto-call of an APEX page telling you what the manual task is and providing information about it?

    -- set boundaryEvent Timers, if any
    flow_boundary_events.set_boundary_timers 
    ( p_process_id => p_process_id
    , p_subflow_id => p_subflow_id
    );  
  end process_manualTask;
  
end flow_tasks;
/
