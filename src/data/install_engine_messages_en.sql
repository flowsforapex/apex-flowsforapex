/* 
-- Flows for APEX - install_engine_messages_en.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2021,2022.
--
-- Created Sep-2021   Richard Allen - Flowquest 
--
*/PROMPT >> Resetting Engine Messages to initial state (English)
begin
  delete from flow_messages where fmsg_lang = 'en';

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'ITE-unsupported-type',
  'en',
  'Currently unsupported type of Intermediate Throw Event encountered at %0 .'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'boundary-event-child-lock-to',
  'en',
  'Child Boundary Subflows or Timers of %0 currently locked by another user.  Retry your transaction later.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'boundary-event-no-catch-found',
  'en',
  'No boundaryEvent of type %0 found to catch event.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'boundary-event-too-many',
  'en',
  'More than one %0 boundaryEvent found on sub process.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'eng_handle_event_int',
  'en',
  'Flow Engine Internal Error: Process %0 Subflow %1 Module %2 Current %4 Current Tag %3'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'engine-unsupported-object',
  'en',
  'Model Error: Process BPMN model next step uses unsupported object %0'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'engine-util-prcs-not-found',
  'en',
  'Application Error: Process ID %0 not found.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'engine-util-sbfl-not-in-prcs',
  'en',
  'Application Error: Subflow ID supplied ( %0 ) exists but is not child of Process ID Supplied ( %1 ).'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'engine-util-sbfl-not-found',
  'en',
  'Subflow ID supplied ( %0 ) not found. Check for process events that changed process flow (timeouts, errors, escalations).'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'gateway-invalid-route',
  'en',
  'Error at gateway %0. Supplied variable %1 contains invalid route: %2'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'gateway-merge-error',
  'en',
  'Internal error processing merging gateway on subflow %0'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'gateway-no-route',
  'en',
  'No gateway routing instruction provided in variable %0 and model contains no default route.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'gateway-too-many-defaults',
  'en',
  'More than one default route specified in model for Gateway %0.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'link-no-catch',
  'en',
  'Unable to find matching link catch event named %0.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'link-too-many-catches',
  'en',
  'More than one matching link catch event named %0.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'logging-instance-event',
  'en',
  'Flows - Internal error while logging an Instance Event'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'logging-step-event',
  'en',
  'Flows - Internal error while logging a Step Event'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'logging-variable-event',
  'en',
  'Flows - Internal error while logging a Variable Event'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'process-lock-timeout',
  'en',
  'Process objects for %0 currently locked by another user.  Try again later.'
  );
    
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'more_than_1_forward_path',
  'en',
  'More than 1 forward path found when only 1 allowed.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'no_next_step_found',
  'en',
  'No Next Step Found on subflow %0.  Check your process diagram.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plsql_script_failed',
  'en',
  'Process %0: Task %1 failed due to PL/SQL error - see event log.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plsql_script_requested_stop',
  'en',
  'Process %0: Task %1 requested processing stop - see event log.'										  
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'timeout_locking_subflow',
  'en',
  'Unable to lock subflow %0 as currently locked by another user.  Try again later.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'reservation-already-placed',
  'en',
  'Reservation already placed on next task for you.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'reservation-by-other_user',
  'en',
  'Reservation for %0 unsuccessful.  Step already reserved by another user (%1).'
  ); 
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'reservation-failed-not-found',
  'en',
  'Reservation for %2 unsuccessful.  Subflow %0 in Process %1 not found.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'reservation-incorrect-step-key',
  'en',
  'Task is no longer current, probably already completed.  Please refresh your Inbox.'
  ); 

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'reservation-lock-timeout',
  'en',
  'Subflow currently locked (not reserved) by another user.  Try your reservation again later.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'reservation-release-not-found',
  'en',
  'Reservation release unsuccessful.  Subflow %0 in Process %1 not found.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'restart-no-error',
  'en',
  'No Current Error Found.  Check your process diagram.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'start-already-running',
  'en',
  'You tried to start a process (id %0)that is already running.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'start-multiple-already-running',
  'en',
  'You tried to start a process (id %0) with multiple copies already running.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'start-multiple-start-events',
  'en',
  'You have multiple starting events defined. Make sure your diagram has only one start event.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'start-no-start-event',
  'en',
  'No starting event is defined in the Flow diagram.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'start-not-created',
  'en',
  'You tried to start a process (id %0) that does not exist.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'start-type-unsupported',
  'en',
  'Unsupported start event type (%0). Only None (standard) Start Event and Timer Start Event are currently supported.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'startwork-sbfl-not-found',
  'en',
  'Start Work time recording unsuccessful.  Subflow %0 in Process %1 not found.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'step-key-incorrect',
  'en',
  'This Process Step has already occurred.  (Incorrect step key %0 supplied while expecting step key %1).'
  ); 

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'subProcess-no-start',
  'en',
  'Unable to find Sub-Process Start Event.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'subProcess-too-many-starts',
  'en',
  'More than one Sub-Process Start found.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'timer-broken',
  'en',
  'Timer %0 Run %4 broken in process %1 , subflow : %2.  See error_info.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'timer-cycle-unsupported',
  'en',
  'Cycle Timer defined for object %0 not currently supported.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'timer-incomplete-definition',
  'en',
  'Incomplete timer definitions for object %0. Type: %1; Value1: %2 Value2: %3  Value3: %4'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'timer-lock-timeout',
  'en',
  'Timer for subflow %0 currently locked by another user.  Try again later.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'timer-object-not-found',
  'en',
  'Object with timer not found in get_timer_definition. Subflow %0.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'timers-lock-timeout',
  'en',
  'Timers for process %0 currently locked by another user.  Try again later.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var-set-error',
  'en',
  'Error creating process variable %0 for process id %1.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var-get-error',
  'en',
  'Error getting process variable %0 for process id %1.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var-update-error',
  'en',
  'Error updating process variable %0 for process id %1.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var-delete-error',
  'en',
  'Error deleting process variable %0 for process id %1.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var-lock-error',
  'en',
  'Error locking process variable %0 for process id %1.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_datatype',
  'en',
  'Error setting process variable.  Incorrect datatype for variable %0.  SQL error shown in debug output.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_date_format',
  'en',
  'Error setting Process Variable %1: Incorrect Date Format (Subflow: %0, Set: %3.)'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_object_not_found',
  'en',
  'Internal error looking up object %0 in process_expressions.  SQL error shown in debug output.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_plsql_error',
  'en',
  'Subflow : %0 Error in %2 expression for Variable : %1'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_sql_no_data',
  'en',
  'Error setting %2 process variable %1 in process id %0.  No data found in query.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_sql_other',
  'en',
  'Error setting %2 process variable %1 in process id %0.  SQL error shown in event log.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_sql_too_many_rows',
  'en',
  'Error setting %2 process variable %1 in process id %0.  Query returns multiple rows.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'var_exp_static_general',
  'en',
  'Error setting %2 process variable %1 in process id %0.  See error in event log.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'version-no-rel-or-draft-v0',
  'en',
  'Cannot find released diagram or draft version 0 of diagram - please specify a version or diagram_id'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'version-not-found',
  'en',
  'Cannot find specified diagram version.  Please check version specification.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
    values (
  'timer_definition_error',
  'en',
  'Error parsing timer definition in process %0, subflow %1. Timer Type: %2, Definition: %3'
  );
  
  /* Plug-ins */
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-model-no-version',
  'en',
  'Version not defined.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-parsing-json-variables',
  'en',
  'Error during parsing process variables.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-route-not-define',
  'en',
  'Gateway is not define for routing.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-gateway-not-exist',
  'en',
  'Gateway define does not exists for this flow.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-no-instance-subflow-id',
  'en',
  'Unable to get Flow Instance Id and or subflow Id to manage the step.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-wrong-variable-number',
  'en',
  'Wrong number of APEX item(s) or process variable(s).'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-wrong-variable-type',
  'en',
  'One or more process variable(s) are a different type than the one defined in the JSON.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-variable-not-a-number',
  'en',
  '%0 is not a valid number.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-variable-not-a-date',
  'en',
  '%0 is not a valid date.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-invalid-json',
  'en',
  'JSON provided is invalid.'
  );
  
  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-modeler-id-not-found',
  'en',
  'No data found. Check if Diagram with given ID exists.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-unexpected-error',
  'en',
  'Unexpected error, please contact your administrator.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-diagram-not-parsable',
  'en',
  'Diagram could not be parsed.<br />Please review your diagram to ensure that it is supported.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-diagram-saved',
  'en',
  'Changes saved!'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'plugin-diagram-has-changed',
  'en',
  'Model has changed. Discard changes?'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'wrong-default-workspace',
  'en',
  'Process %0: ServiceTask %1 failed: the default workspace defined in the configuration parameter is not valid.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'workspace-not-found',
  'en',
  'Process %0: ServiceTask %1 failed: unable to find the workspace associated with the application id defined in the diagram. Please check the model.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'email-no-from',
  'en',
  'Process %0: ServiceTask %1 failed: attribute "From" and default email sender are not defined. Please check the model and or the configuration parameter.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'email-no-to',
  'en',
  'Process %0: ServiceTask %1 failed: attribute "To" not defined. Please check the model.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'email-no-template',
  'en',
  'Process %0: ServiceTask %1 failed: attribute "Template" not defined. Please check the model.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'email-no-body',
  'en',
  'Process %0: ServiceTask %1 failed: attribute "Body" not defined. Please check the model.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'email-failed',
  'en',
  'Process %0: ServiceTask %1 failed see error log and check the model.'
  );

  insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
  values (
  'email-placeholder-json-invalid',
  'en',
  'Process %0: ServiceTask %1 placeholder JSON is invalid.Please check the model.'
  );
  commit;
end;
/
