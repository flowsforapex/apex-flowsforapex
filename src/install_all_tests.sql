set define '^'
set concat '.'
/*
  Contains all utPLSQl test scripts
*/

PROMPT >> Installing Engine Test Scripts 
PROMPT >> =================
PROMPT >> Installing Package Specifications

@test/plsql/test-helpers/test_helper.pks
@test/plsql/test_001_api.pks
@test/plsql/test_002_gateway.pks
@test/plsql/test_003_startEvents.pks
@test/plsql/test_010_variable_expression.pks
@test/plsql/test_011_var_exps_in_callActivities.pks
@test/plsql/test_012_call_activity_timer_BEs.pks
@test/plsql/test_013_call_Activity_escalation_BEs.pks
@test/plsql/test_014_call_Activity_error_BEs.pks
@test/plsql/test_015_lanes_parse_execute.pks
@test/plsql/test_016_splitting_gw_errors.pks
@test/plsql/test_017_exc_gw_errors_restarts.pks

PROMPT >> Installing Package Bodies

@test/plsql/test-helpers/test_helper.pkb
@test/plsql/test_001_api.pkb
@test/plsql/test_002_gateway.pkb
@test/plsql/test_003_startEvents.pkb
@test/plsql/test_010_variable_expression.pkb
@test/plsql/test_011_var_exps_in_callActivities.pkb
@test/plsql/test_012_call_activity_timer_BEs.pkb
@test/plsql/test_013_call_Activity_escalation_BEs.pkb
@test/plsql/test_014_call_Activity_error_BEs.pkb
@test/plsql/test_015_lanes_parse_execute.pkb
@test/plsql/test_016_splitting_gw_errors.pkb
@test/plsql/test_017_exc_gw_errors_restarts.pkb
