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

    select objt.objt_attributes."timerType"
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

  procedure process_apex_approval_task
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is 
    l_prcs_id          flow_processes.prcs_id%type      := p_sbfl_info.sbfl_prcs_id;
    l_sbfl_id          flow_subflows.sbfl_id%type       := p_sbfl_info.sbfl_id;
    l_scope            flow_subflows.sbfl_scope%type    := p_sbfl_info.sbfl_scope;
    l_step_key         flow_subflows.sbfl_step_key%type := p_sbfl_info.sbfl_step_key;
    l_app_id           flow_types_pkg.t_bpmn_attribute_vc2;
    l_static_id        flow_types_pkg.t_bpmn_attribute_vc2;
    l_subject          flow_types_pkg.t_bpmn_attribute_vc2;
    l_parameters       flow_types_pkg.t_bpmn_attribute_vc2;
    l_business_ref     flow_types_pkg.t_bpmn_attribute_vc2;
    l_task_comment     flow_types_pkg.t_bpmn_attribute_vc2;
    l_apex_task_id     number;
    $IF flow_apex_env.ver_le_21 $THEN
      -- only need this for testing as apex_approval should fail if attempt to run without apex 22.1+
      type t_task_parameter  is record
      ( static_id     varchar2(255)
      , string_value  varchar2(255)
      );
      type t_task_parameters is table of t_task_parameter;
      l_task_parameter    t_task_parameter;
      l_task_parameters   t_task_parameters := t_task_parameters();
    $else
      -- APEX 22.1 supports Approval Components and has apex_approval package
      l_task_parameters  apex_approval.t_task_parameters := apex_approval.t_task_parameters();
      l_task_parameter   apex_approval.t_task_parameter;
    $end
  begin
    apex_debug.enter 
    ( 'process_apex_approval_task'
    , 'step_bpmn_id: ', p_step_info.target_objt_ref
    );
    -- check that APEX is v22.1 which is required for APEX approval component
    if flow_apex_env.ver_le_21_2 then 
      flow_errors.handle_instance_error
      ( pi_prcs_id        => l_prcs_id
      , pi_sbfl_id        => l_sbfl_id
      , pi_message_key    => 'apex-task-not-supported'
      , p0 => '22.1'
      , p1 => p_step_info.target_objt_ref
      );  
      -- $F4AMESSAGE 'apex-task-not-supported' || 'APEX Workflow Feature use requires Oracle APEX v%0.'
    else
      -- get the parameters for the Approval Task creation
      select objt.objt_attributes."apex"."applicationId"
           , objt.objt_attributes."apex"."taskStaticId"
           , objt.objt_attributes."apex"."subject"
           , objt.objt_attributes."apex"."parameters"
           , objt.objt_attributes."apex"."businessRef"
           , objt.objt_attributes."apex"."taskComment"
        into l_app_id
           , l_static_id
           , l_subject
           , l_parameters
           , l_business_ref
           , l_task_comment
        from flow_objects objt
       where objt.objt_bpmn_id = p_step_info.target_objt_ref
         and objt.objt_dgrm_id = p_sbfl_info.sbfl_dgrm_id
         ;
      -- do substitutions
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_app_id);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_static_id);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_subject);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_parameters);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_business_ref);
      flow_proc_vars_int.do_substitution( pi_prcs_id => l_prcs_id, pi_sbfl_id => l_sbfl_id, pi_scope => l_scope, pio_string => l_task_comment);
      -- create parameters table
      for parameters in (
        select static_id
             , data_type
             , value
        from json_table (l_parameters, '$.parameters[*]'
                         columns(
                                  static_id path '$.static_id',
                                  data_type path '$.data_type',
                                  value path '$.value'
                                )
                        )
      )
      loop
        l_task_parameter.static_id    := parameters.static_id;
        l_task_parameter.string_value := parameters.value;
        l_task_parameters(l_task_parameters.count+1) := l_task_parameter;
      end loop;

      $IF flow_apex_env.ver_le_21_2 $THEN
        -- dummy for testing before APEX v22.1...
        l_apex_task_id := 99999999;
      $ELSE
        -- create the task in APEX Approvals if after APEX v22.1
        l_apex_task_id := apex_approval.create_task
                       ( p_application_id     => l_app_id
                       , p_task_def_static_id => l_static_id
                       , p_subject            => l_subject
                       , p_detail_pk          => coalesce(l_business_ref, flow_globals.business_ref, null) 
                       , p_parameters         => l_task_parameters
                       );
      $END

      flow_proc_vars_int.set_var 
      ( pi_prcs_id      => l_prcs_id
      , pi_scope        => l_scope
      , pi_var_name     => p_step_info.target_objt_ref||flow_constants_pkg.gc_prov_suffix_task_id
      , pi_num_value    => l_apex_task_id
      , pi_sbfl_id      => l_sbfl_id
      , pi_objt_bpmn_id => p_step_info.target_objt_ref
      );
      -- Add a comment to the task if included in the definition
     -- exceptions
      -- APEX workflow Task not supported on this APEX release
      -- APEX Task with Static ID %0 not found in Application %1 in this APEX Workspace
      -- APEX Task cannot be started with these parameters
    end if;
  end process_apex_approval_task;

  procedure cancel_apex_task
    ( p_process_id    in flow_processes.prcs_id%type
    , p_objt_bpmn_id  in flow_objects.objt_bpmn_id%type
    , p_apex_task_id  in number    
    )
  is
  begin
    apex_debug.enter 
    ( 'cancel_apex_task'
    , 'apex task_id: ', p_apex_task_id 
    );
    $IF flow_apex_env.ver_le_21_2 $THEN
      null;
    $ELSE
      -- cancel task
      apex_approval.cancel_task (p_task_id => p_apex_task_id);
    $END
     apex_debug.info 
    ( p_message => 'APEX Workflow Task : %0  cancelled on object : %1'
    , p0 => p_apex_task_id
    , p1 => p_objt_bpmn_id
    );
  exception
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id     => p_process_id
      , pi_message_key => 'apex-task-cancelation-error'
      , p0 => p_objt_bpmn_id
      , p1 => p_apex_task_id
      );
      -- $F4AMESSAGE 'apex-task-cancelation-error' || 'Error attempting to cancel APEX workflow task (task_id: %1 ) for process step : %0.)' 
  end cancel_apex_task;

  procedure process_userTask
    ( p_sbfl_info     in flow_subflows%rowtype
    , p_step_info     in flow_types_pkg.flow_step_info
    )
  is 
    l_usertask_type flow_types_pkg.t_bpmn_attribute_vc2;
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
    select objt.objt_attributes."apex"."taskType"
      into l_usertask_type
      from flow_objects objt
     where objt.objt_bpmn_id = p_step_info.target_objt_ref
       and objt.objt_dgrm_id = p_sbfl_info.sbfl_dgrm_id
       ;
       
    case l_usertask_type
    when flow_constants_pkg.gc_apex_usertask_apex_approval then
       process_apex_approval_task
       ( p_sbfl_info => p_sbfl_info
       , p_step_info => p_step_info
       );
    -- Note: no action required for apex_page type so no 'when...' required.
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
