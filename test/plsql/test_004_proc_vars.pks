create or replace package test_004_proc_vars is
/* 
-- Flows for APEX - test_004_proc_vars.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright Flowquest Consulting Limited and / or its affiliates, 2024.
--
-- Created 08-Aug-2022   Richard Allen - Oracle
-- Edited  24-May-2024   Richard Allen, Flowquest Consulting Limited
--
*/
   -- uses model A01

   -- tests  process variable functions

   --%suite(04 Process Variable operations)
   --%rollback(manual)
   --%tags(short,ce,ee)

   -- Need to add tests for by name, by name and version, by id
   -- Maybe need to test the versionning logic as well here?

  --%beforeall
  procedure set_up_tests;


  --%test(1a. Basic Process Variable Operations - set(insert) and get variables)
  procedure basic_flow_variables;

  --%test(1b. Basic Process Variable Operations - repeats SET operations to set(update) proc vars)
  procedure set_to_update_variables;

  --%test(2. Case sensitivity of Proc Vars - vc2)
  procedure var_case_sensitivity_vc2;

  --%test(2. Case sensitivity of Proc Vars - number)
  procedure var_case_sensitivity_num;

  --%test(2. Case sensitivity of Proc Vars - date)
  procedure var_case_sensitivity_date;

  --%test(3a. Bad Format data - number)
  --%throws(-06502,-06512)
  procedure bad_format_num;

  --%test(3b. Bad Format data - date)
  --%disabled
  procedure bad_format_date;

  --%test(3c. Bad Format data - tstz)
  --%disabled
  procedure bad_format_tstz;

  --%test(4a. Get non-existant Proc Vars - vc2)
  --%throws(no_data_found)
  procedure get_non_existant_vars_vc2;

  --%test(4b. Get non-existant Proc Vars - number)
  --%throws(no_data_found)
  procedure get_non_existant_vars_num;

  --%test(4c. Get non-existant Proc Vars - date)
  --%throws(no_data_found)
  procedure get_non_existant_vars_date;  


  --%test(4d. Get non-existant Proc Vars - tstz)
  --%throws(no_data_found)
  procedure get_non_existant_vars_tstz;

  --%test(4e. Get non-existant Proc Vars - clob)
  --%throws(no_data_found)
  procedure get_non_existant_vars_clob;


  --%test(4f. Get non-existant Proc Vars - json value)
  --%throws(no_data_found)
  procedure get_non_existant_vars_json_value;

  --%test(4g. Get non-existant Proc Vars - json element)
  --%throws(no_data_found)
  procedure get_non_existant_vars_json_element;

  --%afterall
  procedure tear_down_tests;

end test_004_proc_vars;
/

