PROMPT >> Loading Exported Messages
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'eng_handle_event_int',
'en',
'Flow Engine Internal Error: Process %0 Subflow %1 Module %2 Current %4 Current Tag %3'
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
'Process %0: ScriptTask %1 failed due to PL/SQL error - see event log.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plsql_script_requested_stop',
'en',
'Process %0: ScriptTask %1 requested processing stop - see event log.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timeout_locking_subflow',
'en',
'Unable to lock Subflow : %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer_broken',
'en',
'Timer %0 broken in process %1 , subflow : %2.  See error_info.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_date_format',
'en-us',
'Error setting Process Variable %1: Incorrect Date Format (Subflow: %0, Set: %3.)'
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
'timer_definition_error',
'en',
'Error parsing timer definition in process %0, subflow %1. Timer Type: %2, Definition: %3'
);


 /* Plug-ins */
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-model-no-version',
'en',
'Version not defined.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-parsing-json-variables',
'en',
'Error during parsing process variables.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-route-not-define',
'en',
'Gateway is not define for routing.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-gateway-not-exist',
'en',
'Gateway define does not exists for this flow.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-no-instance-subflow-id',
'en',
'Unable to get Flow Instance Id and or subflow Id to manage the step.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-wrong-variable-number',
'en',
'Wrong number of APEX item(s) or process variable(s).'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-wrong-variable-type',
'en',
'One or more process variable(s) are a different type than the one defined in the JSON.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-variable-not-a-number',
'en',
'%0 is not a valid number.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-variable-not-a-date',
'en',
'%0 is not a valid date.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-modeler-id-not-found',
'en',
'No data found. Check if Diagram with given ID exists.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-unexpected-error',
'en',
'Unexpected error, please contact your administrator.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-diagram-not-parsable',
'en',
'Diagram could not be parsed.<br />Please review your diagram to ensure that it is supported.'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-diagram-saved',
'en',
'Changes saved!'
);

insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plugin-diagram-has-changed',
'en',
'Model has changed. Discard changes?'
);
