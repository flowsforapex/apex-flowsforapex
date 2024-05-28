create or replace package body test_027_var_exp_errors
/* 
-- Flows for APEX - test_027_var_exp_errors.pkb
-- 
-- (c) Copyright Flowquest Consulting Limited and / or its affiliates, 2024.
--
-- Created 26-May-2024   Richard Allen - Flowquest Consulting Limited
--
*/
is 
  -- suite(27 Variable Expression Errors)
  -- tag
  -- rollback(manual)

  -- uses models 19a-g
  g_model_a27a constant varchar2(100) := 'A27a - Variable Expression Errors';

  g_test_prcs_name_a constant varchar2(100) := 'test 027 - variable expression errors a';
  g_test_prcs_name_b constant varchar2(100) := 'test 027 - variable expression errors b';
  g_test_prcs_name_c constant varchar2(100) := 'test 027 - variable expression errors c';
  g_test_prcs_name_d constant varchar2(100) := 'test 027 - variable expression errors d';
  g_test_prcs_name_e constant varchar2(100) := 'test 027 - variable expression errors e';
  g_test_prcs_name_f constant varchar2(100) := 'test 027 - variable expression errors f';
  g_test_prcs_name_g constant varchar2(100) := 'test 027 - variable expression errors g';
  g_test_prcs_name_h constant varchar2(100) := 'test 027 - variable expression errors h';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;
  g_prcs_id_h       flow_processes.prcs_id%type;

  g_dgrm_a27a_id  flow_diagrams.dgrm_id%type;

  -- beforeall
  procedure set_up_tests
  is
  begin
    -- get dgrm_ids to use for comparison
    g_dgrm_a27a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a27a );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a27a_id);
  end set_up_tests;

  -- test('1 - Bad Static Date Format')
  procedure bad_static_date;

  -- test('1 - Bad Static TSTZ Format')
  procedure bad_static_tstz;

  -- test('1 - Bad Static Num Format')
  procedure bad_static_num;

  -- test('1 - Bad Static JSON Format')
  procedure bad_static_json;

  -- test('1 - Bad Single SQL')
  procedure bad_single_sql;

  -- test('1 - Bad Multi SQL')
  procedure bad_multi_sql;

  -- test('1 - Bad PLSQL Expression')
  procedure bad_plsql_expression;

  -- test('1 - Bad PLSQL Function Body')
  procedure bad_plsql_func_body;

  -- afterall
  procedure tear_down_tests;

end test_027_var_exp_errors;
/