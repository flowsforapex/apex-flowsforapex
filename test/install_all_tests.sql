set define '^'
set concat '.'
/*
  Contains all utPLSQl test scripts
*/

PROMPT >> Installing Engine Test Scripts 
PROMPT >> =================
PROMPT >> Installing Package Specifications

@plsql/test-helpers/test_helper.pks
@plsql/test_001_api.pks
@plsql/test_002_gateway.pks
@plsql/test_003_startEvents.pks
@plsql/test_004_proc_vars.pks
@plsql/test_005_engine_misc.pks
@plsql/test_006_lanes_roles.pks
@plsql/test_009_call_activity_nesting.pks
@plsql/test_010_variable_expression.pks
@plsql/test_011_var_exps_in_callActivities.pks
@plsql/test_012_call_activity_timer_BEs.pks
@plsql/test_013_call_Activity_escalation_BEs.pks
@plsql/test_014_call_Activity_error_BEs.pks
@plsql/test_015_lanes_parse_execute.pks
@plsql/test_016_splitting_gw_errors.pks
@plsql/test_017_exc_gw_errors_restarts.pks
@plsql/test_018_gw_routing_exps.pks
@plsql/test_019_priorityduedates.pks
@plsql/test_021_messageflow_basics.pks

PROMPT >> Installing Package Bodies

@plsql/test-helpers/test_helper.pkb
@plsql/test_001_api.pkb
@plsql/test_002_gateway.pkb
@plsql/test_003_startEvents.pkb
@plsql/test_004_proc_vars.pkb
@plsql/test_005_engine_misc.pkb
@plsql/test_006_lanes_roles.pkb
@plsql/test_009_call_activity_nesting.pkb
@plsql/test_010_variable_expression.pkb
@plsql/test_011_var_exps_in_callActivities.pkb
@plsql/test_012_call_activity_timer_BEs.pkb
@plsql/test_013_call_Activity_escalation_BEs.pkb
@plsql/test_014_call_Activity_error_BEs.pkb
@plsql/test_015_lanes_parse_execute.pkb
@plsql/test_016_splitting_gw_errors.pkb
@plsql/test_017_exc_gw_errors_restarts.pkb
@plsql/test_018_gw_routing_exps.pkb
@plsql/test_019_priorityduedates.pkb
@plsql/test_021_messageflow_basics.pkb

PROMPT >> Engine Test Scripts Installed

