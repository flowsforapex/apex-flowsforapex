-- delete from flow_messages;


insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'eng_handle_event_int',
'en-us',
'Flow Engine Internal Error: Process %0 Subflow %1 Module %2 Current %4 Current Tag %3'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'more_than_1_forward_path',
'en-us',
'More than 1 forward path found when only 1 allowed.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'no_next_step_found',
'en-us',
'No Next Step Found on subflow %0.  Check your process diagram.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plsql_script_failed',
'en-us',
'Process %0: ScriptTask %1 failed due to PL/SQL error - see event log.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'plsql_script_requested_stop',
'en-us',
'Process %0: ScriptTask %1 requested processing stop - see event log.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timeout_locking_subflow',
'en-us',
'Unable to lock Subflow : %0.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'timer_broken',
'en-us',
'Timer %0 broken in process %1 , subflow : %2.  See error_info.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_plsql_error',
'en-us',
'Subflow : %0 Error in %2 expression for Variable : %1'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_sql_no_data',
'en-us',
'Error setting %2 process variable %1 in process id %0.  No data found in query.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_sql_other',
'en-us',
'Error setting %2 process variable %1 in process id %0.  SQL error shown in event log.'
);
 
insert into flow_messages( fmsg_message_key, fmsg_lang, fmsg_message_content )
 values (
'var_exp_sql_too_many_rows',
'en-us',
'Error setting %2 process variable %1 in process id %0.  Query returns multiple rows.'
);
 
 