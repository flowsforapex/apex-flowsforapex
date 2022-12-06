create or replace package body flow_tasks as 
/* 
-- Flows for APEX - flow_tasks.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created 13-May-2021  Richard Allen (Flowquest Consuting, for MT AG) 
-- Edited  13-Apr-2022  Richard Allen (Oracle)
-- Edited  23-May-2022  Moritz Klein (MT AG)
--
*/
  function get_task_type
  (
    pi_objt_id in flow_objects.objt_id%type
  )
    return flow_types_pkg.t_bpmn_attribute_vc2
  as
    l_return flow_types_pkg.t_bpmn_attribute_vc2;
  begin

    select objt.objt_attributes."taskType"
      into l_return
      from flow_objects objt
     where objt_id = pi_objt_id
    ;
    if l_return is null then
      apex_debug.warn
      (
        p_message => 'No task type found for object %s'
      , p0        =>  pi_objt_id
      );
    end if;

    return l_return;
  end get_task_type;

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
         set sbfl.sbfl_current        = p_script_object
           , sbfl.sbfl_status         = flow_constants_pkg.gc_sbfl_status_error
           , sbfl.sbfl_last_update    = systimestamp 
           , sbfl.sbfl_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )         
       where sbfl.sbfl_id = p_subflow_id
         and sbfl.sbfl_prcs_id = p_process_id
      ;
      -- set instance to error status
      update flow_processes prcs
         set prcs.prcs_status         = flow_constants_pkg.gc_prcs_status_error
           , prcs.prcs_last_update    = systimestamp
           , prcs.prcs_last_update_by = coalesce  ( sys_context('apex$session','app_user') 
                                                  , sys_context('userenv','os_user')
                                                  , sys_context('userenv','session_user')
                                                  )  
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
    ( p_sbfl_info     in flow_subflows%rowtype
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
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    );  
  end process_task;

  procedure process_userTask
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is 
    l_usertask_type         flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority_json         flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority              flow_subflows.sbfl_priority%type;
    l_due_date_json         flow_types_pkg.t_bpmn_attribute_vc2;
    l_due_date              flow_subflows.sbfl_due_on%type;
  begin
  -- current implementation is limited to two userTask types, which are:
  --   - to run a user defined APEX page via the Task Inbox View
  --   - to call an APEX Approval Task (from APEX v22.1 onwards)
  -- future userTask types could include parameterised, standarised template pages , template scripts ??
    apex_debug.enter 
    ( 'process_userTask'
    , 'p_step_info.target_objt_tag'   , p_step_info.target_objt_tag 
    , 'p_step_info.target_objt_subtag', p_step_info.target_objt_subtag 
    );
    -- set boundaryEvent Timers, if any
    flow_boundary_events.set_boundary_timers 
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    );  
    -- get the userTask subtype  
    select objt.objt_attributes."taskType"
         , objt.objt_attributes."apex"."priority"
         , objt.objt_attributes."apex"."dueDate"
      into l_usertask_type
         , l_priority_json
         , l_due_date_json
      from flow_objects objt
     where objt.objt_bpmn_id = p_step_info.target_objt_ref
       and objt.objt_dgrm_id = p_sbfl_info.sbfl_dgrm_id
       ;
       
      if l_priority is not null then
        l_priority := flow_settings.get_priority 
                      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                      , pi_expr    => l_priority_json
                      , pi_scope   => p_sbfl_info.sbfl_scope
                      );
      end if;
      if l_due_date is not null then 
        l_due_date := flow_settings.get_due_date 
                      ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                      , pi_expr    => l_due_date_json
                      , pi_scope   => p_sbfl_info.sbfl_scope
                      );
      end if;

    case l_usertask_type
      when flow_constants_pkg.gc_apex_usertask_apex_approval then
       flow_usertask_pkg.process_apex_approval_task
       ( p_sbfl_info => p_sbfl_info
       , p_step_info => p_step_info
       );
      when flow_constants_pkg.gc_apex_usertask_apex_page then
       flow_usertask_pkg.process_apex_page_task
       ( p_sbfl_info => p_sbfl_info
       , p_step_info => p_step_info
       );
      else
        null;
    end case;

  end process_userTask;

  procedure process_scriptTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
    l_usertask_type    flow_types_pkg.t_bpmn_attribute_vc2;
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
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    , p_step_key   => p_sbfl_info.sbfl_step_key
    , p_called_internally => true
    );
    
    flow_plsql_runner_pkg.run_task_script(
      pi_prcs_id  => p_sbfl_info.sbfl_prcs_id
    , pi_sbfl_id  => p_sbfl_info.sbfl_id
    , pi_objt_id  => p_step_info.target_objt_id
    , pi_step_key => p_sbfl_info.sbfl_step_key
    );

    flow_engine.flow_complete_step 
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    , p_step_key   => p_sbfl_info.sbfl_step_key
    );

  exception
    when flow_plsql_runner_pkg.e_plsql_script_failed then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script failed in plsql script runner'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'plsql_script_failed'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
      -- $F4AMESSAGE 'plsql_script_failed' || 'Process %0: ScriptTask %1 failed due to PL/SQL error - see event log.'
    when flow_plsql_runner_pkg.e_plsql_script_requested_stop then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script requested stop_engine in plsql script runner'
      ); 
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'plsql_script_requested_stop'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );  
      -- $F4AMESSAGE 'plsql_script_requested_stop' || 'Process %0: ScriptTask %1 requested processing stop - see event log.'
  end process_scriptTask;

  procedure process_serviceTask 
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.enter 
    ( 'process_serviceTask'
    , 'p_step_info.target_objt_tag', p_step_info.target_objt_tag 
    );
  
    -- future serviceTask types could include text message, tweet, AOP document via email, etc.
    -- current implementation is limited to synchronous email send (i.e., email sent as part of Flows for APEX process).
    -- future implementations could include async serviceTask, where message generation is queued, or non-email services

    flow_engine.start_step 
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    , p_step_key   => p_sbfl_info.sbfl_step_key
    , p_called_internally => true
    );

    case get_task_type( p_step_info.target_objt_id )
      when flow_constants_pkg.gc_apex_task_execute_plsql then
        flow_plsql_runner_pkg.run_task_script
        ( pi_prcs_id  => p_sbfl_info.sbfl_prcs_id
        , pi_sbfl_id  => p_sbfl_info.sbfl_id
        , pi_objt_id  => p_step_info.target_objt_id
        , pi_step_key => p_sbfl_info.sbfl_step_key
        );
      when flow_constants_pkg.gc_apex_servicetask_send_mail then
        flow_services.send_email
        ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
        , pi_sbfl_id => p_sbfl_info.sbfl_id
        , pi_objt_id => p_step_info.target_objt_id
        );
      else
        null;
    end case;

    flow_engine.flow_complete_step 
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id 
    , p_step_key   => p_sbfl_info.sbfl_step_key
    );

  exception
    when flow_services.e_wrong_default_workspace then
      rollback;
      apex_debug.info( p_message => 'Rollback initiated after default workspace not valid'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'wrong-default-workspace'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
    when flow_services.e_workspace_not_found then
      rollback;
      apex_debug.info( p_message => 'Rollback initiated after workspace not found'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'workspace-not-found'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
    when flow_services.e_email_no_from then 
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after from attribute not found'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'email-no-from'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
    when flow_services.e_email_no_to then 
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after to attribute not found'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'email-no-to'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
    when flow_services.e_email_no_template then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after template or app_alias attributes not found'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'email-no-template'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      ); 
    when flow_services.e_email_no_body then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after body attribute not found'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'email-no-body'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
    when flow_services.e_json_not_valid then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after placeholder JSON object not valid'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'email-placeholder-json-invalid'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
    when flow_services.e_email_failed then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after send_email failed in service task'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'email-failed'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
    when flow_plsql_runner_pkg.e_plsql_script_failed then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script failed in plsql script runner'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'plsql_script_failed'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
      -- $F4AMESSAGE 'plsql_script_failed' || 'Process %0: PLSQL Script %1 failed due to PL/SQL error - see event log.'
    when flow_plsql_runner_pkg.e_plsql_script_requested_stop then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script requested stop_engine in plsql script runner'
      ); 
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'plsql_script_requested_stop'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );  
      -- $F4AMESSAGE 'plsql_script_requested_stop' || 'Process %0: PL/SQL Script %1 requested processing stop - see event log.'

  end process_serviceTask;

  procedure process_manualTask
  ( p_sbfl_info     in flow_subflows%rowtype
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
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    );  
  end process_manualTask;

    procedure process_businessRuleTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
  begin
    apex_debug.enter 
    ( 'process_businessRuleTask'
    , 'p_step_info.target_objt_tag', p_step_info.target_objt_tag 
    );
    -- current implementation is limited to one businessRuleTask type, 
    -- which is to run a user defined PL/SQL script
    -- future scriptTask types could include DMN or REST calls to other DecisionRule Engines
    -- current implementation is limited to synchronous script execution (i.e., script is run as part of Flows for APEX process)
    -- future implementations could include async scriptTasks, where script execution is queued.
  
    -- set work started time
    flow_engine.start_step 
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    , p_step_key   => p_sbfl_info.sbfl_step_key
    , p_called_internally => true
    );
    
    case get_task_type( p_step_info.target_objt_id )
      when flow_constants_pkg.gc_apex_task_execute_plsql then
        flow_plsql_runner_pkg.run_task_script
        ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
        , pi_sbfl_id => p_sbfl_info.sbfl_id
        , pi_objt_id => p_step_info.target_objt_id
        );
      else
        null;
    end case;
    
    flow_engine.flow_complete_step 
    ( p_process_id => p_sbfl_info.sbfl_prcs_id
    , p_subflow_id => p_sbfl_info.sbfl_id
    , p_step_key   => p_sbfl_info.sbfl_step_key
    );

  exception
    when flow_plsql_runner_pkg.e_plsql_script_failed then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script failed in plsql script runner'
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'plsql_script_failed'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );
      -- $F4AMESSAGE 'plsql_script_failed' || 'Process %0: PL/SQL Script %1 failed due to PL/SQL error - see event log.'
    when flow_plsql_runner_pkg.e_plsql_script_requested_stop then
      rollback;
      apex_debug.info 
      ( p_message => 'Rollback initiated after script requested stop_engine in plsql script runner'
      ); 
      flow_errors.handle_instance_error
      ( pi_prcs_id        => p_sbfl_info.sbfl_prcs_id
      , pi_sbfl_id        => p_sbfl_info.sbfl_id
      , pi_message_key    => 'plsql_script_requested_stop'
      , p0 => p_sbfl_info.sbfl_prcs_id
      , p1 => p_step_info.target_objt_ref
      );  
      -- $F4AMESSAGE 'plsql_script_requested_stop' || 'Process %0: PL/SQL Script %1 requested processing stop - see event log.'
  end process_businessRuleTask;

  
end flow_tasks;
/
