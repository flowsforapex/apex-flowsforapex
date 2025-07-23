create or replace package test_025_script_tasks as
/* 
-- Flows for APEX - test_025_script_tasks.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
--
-- Created 23-May-2025   Richard Allen - Flowquest
--
*/

  -- uses models 25a-b

  --%suite(25 Script Tasks)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - Script Task context parameter substitutions)
  procedure script_task_substitutions_A1;

  --%test(A2 - Script Task context parameter binding)
  procedure script_task_substitutions_A2;

  --%test(A3 - Legacy depracated ScriptTask context binds)
  procedure script_task_substitutions_A3;

  --%test(A4 - ScriptTask process variable substitutions)
  procedure script_task_substitutions_A4;

  --%test(A5 - ScriptTask process variable binds)
  procedure script_task_substitutions_A5;

  --%test(B1 - Successful Script Task execution)
  procedure script_task_exceptions_B1;

  --%test(B2 - Script Task raises e_plsql_script_requested_stop exception)
  procedure script_task_exceptions_B2;

  --%test(B3 - Script Task raises flow_globals.request_stop_engine exception)
  procedure script_task_exceptions_B3;

  --%test(B4 - Script Task raises other exception)
  procedure script_task_exceptions_B4;  

  --%test(B5 - Script Task raises flow_globals.throw_bpmn_error_event exception)
  procedure script_task_exceptions_B5;

  --%afterall
  procedure tear_down_tests;

end test_025_script_tasks;
/
