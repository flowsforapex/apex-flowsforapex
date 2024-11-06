create or replace package test_027_var_exp_errors
/* 
-- Flows for APEX - test_027_var_exp_errors.pks
-- 
-- (c) Copyright Flowquest Consulting Limited and / or its affiliates, 2024.
--
-- Created 26-May-2024   Richard Allen - Flowquest Consulting Limited
--
*/
is 
  --%suite(27 Variable Expression Errors)
  --%tags(ce,ee,short)
  --%rollback(manual)
  
  --%beforeall
  procedure set_up_tests;

  --%test('1 - Bad Static Date Format')
  procedure bad_static_date;

  --%test('2 - Bad Static TSTZ Format')
  procedure bad_static_tstz;

  --%test('3 - Bad Static Num Format')
  procedure bad_static_num;

  --%test('4 - Bad Static JSON Format')
  procedure bad_static_json;

  --%test('5 - Bad Single SQL')
  procedure bad_single_sql;

  --%test('6 - Bad Multi SQL')
  procedure bad_multi_sql;

  --%test('7 - Bad PLSQL Expression')
  procedure bad_plsql_expression;

  --%test('8 - Bad PLSQL Function Body')
  procedure bad_plsql_func_body;

  --%afterall
  procedure tear_down_tests;

end test_027_var_exp_errors;
/
