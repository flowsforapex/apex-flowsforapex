create or replace package test_028_task_parameters
/* 
-- Flows for APEX - test_028_task_parameters.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created 19-Jun-2026   GitHub Copilot
--
*/
is
  --%suite(28 Task Parameters)
  --%tags(ce,ee,short)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%test('1 - Script task input parameter definitions can be read')
  procedure get_script_task_input_parameter_defs;

  --%test('2 - Script task output parameter definitions can be read')
  procedure get_script_task_output_parameter_defs;

  --%test('3 - process_input_parameters merges user, static and process variable values')
  procedure process_script_task_input_parameters;

  --%test('4 - Input schema includes enum values for user input parameters')
  procedure input_schema_includes_enum_values;

  --%test('5 - Script task execution path remains valid with task parameters present')
  procedure script_task_executes_with_parameters;

  --%test('6 - validate_parameters returns true when required values are present')
  procedure validate_parameters_success;

  --%test('7 - validate_parameters returns false when required values are missing')
  procedure validate_parameters_missing_required;

  --%test('8 - process_input_parameters handles non-varchar2 process variable types')
  procedure process_input_parameters_all_proc_var_types;

  --%test('9 - flow_globals.input_parameter is callable from script context')
  procedure flow_globals_input_parameter_from_script;

  --%test('10 - flow_globals output parameter setters are callable from script context')
  procedure flow_globals_set_output_parameter_from_script;

  --%test('11 - flow_globals.business_ref supports lookup by subflow id')
  procedure flow_globals_business_ref_by_sbfl_id;

  --%afterall
  procedure tear_down_tests;

end test_028_task_parameters;
/
