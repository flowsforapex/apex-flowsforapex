create or replace package body flow_tasks
as 

  procedure set_task_status_running
  ( p_sbfl_info    in flow_subflows%rowtype
  , p_sbfl_current in flow_subflows.sbfl_current%type 
  )
  is 
  begin 
    update flow_subflows sbfl
     set   sbfl.sbfl_current = p_sbfl_current
         , sbfl.sbfl_last_completed = p_sbfl_info.sbfl_last_completed
         , sbfl.sbfl_last_update = systimestamp
         , sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_running
     where sbfl.sbfl_id = p_sbfl_info.sbfl_id
       and sbfl.sbfl_prcs_id = p_sbfl_info.sbfl_prcs_id
    ;
  end;

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
    set_task_status_running
    ( p_sbfl_info => p_sbfl_info
    , p_sbfl_current => p_step_info.target_objt_ref
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

    set_task_status_running
    ( p_sbfl_info => p_sbfl_info
    , p_sbfl_current => p_step_info.target_objt_ref
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
    set_task_status_running
    ( p_sbfl_info => p_sbfl_info
    , p_sbfl_current => p_step_info.target_objt_ref
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
    when flow_plsql_runner_pkg.e_plsql_call_failed then
      rollback;
      raise flow_plsql_runner_pkg.e_plsql_call_failed;
  end process_scriptTask;

  procedure process_serviceTask
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

    set_task_status_running
    ( p_sbfl_info => p_sbfl_info
    , p_sbfl_current => p_step_info.target_objt_ref
    );
    -- current implementation is limited to one serviceTask type, which is for apex message template sent from user defined PL/SQL script
    -- future serviceTask types could include text message, tweet, AOP document via email, etc.
    -- current implementation is limited to synchronous email send (i.e., email sent as part of Flows for APEX process).
    -- future implementations could include async serviceTask, where message generation is queued, or non-email services

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
      raise flow_plsql_runner_pkg.e_plsql_call_failed;
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
    set_task_status_running
    ( p_sbfl_info => p_sbfl_info
    , p_sbfl_current => p_step_info.target_objt_ref
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
