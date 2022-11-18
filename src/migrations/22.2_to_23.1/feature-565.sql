PROMPT >> Add Timestamp with Time Zone Process Variable type

PROMPT >> Add new timestamp column to flow_process_variables and logging table
alter table flow_process_variables add  ( prov_var_ts      timestamp with time zone );
alter table flow_variable_event_log add ( lgvr_var_ts      timestamp with time zone );

