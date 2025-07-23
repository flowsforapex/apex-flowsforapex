set define '^'
set concat '.'
/*
  Contains all utPLSQl test scripts
*/

PROMPT >> Deleting Engine Test Scripts 
PROMPT >> =================
PROMPT >> Deleting Package Specifications

drop package test_helper;
drop package test_constants;
drop package test_001_api;
drop package test_002_gateway;
drop package test_003_startEvents;
drop package test_004_proc_vars;
drop package test_005_engine_misc;
drop package test_006_lanes_roles;
drop package test_007_procvars;
drop package test_008_subproc_misc;
drop package test_009_call_activity_nesting;
drop package test_010_variable_expression;
drop package test_011_var_exps_in_callActivities;
drop package test_012_call_activity_timer_BEs;
drop package test_013_call_Activity_escalation_BEs;
drop package test_014_call_Activity_error_BEs;
drop package test_015_lanes_parse_execute;
drop package test_016_splitting_gw_errors;
drop package test_017_exc_gw_errors_restarts;
drop package test_018_gw_routing_exps;
drop package test_019_priorityduedates;
drop package test_021_messageflow_basics;
drop package test_022_usertask_misc;
drop package test_023_custom_extensions;
drop package test_024_usertask_approval_task;
drop package test_025_script_tasks;

PROMPT >> Engine Test Packages deleted

