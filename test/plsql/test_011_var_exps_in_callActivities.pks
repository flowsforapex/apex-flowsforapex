create or replace package test_011_var_exps_in_callActivities is
/* 
-- Flows for APEX - test_011_var_exps_in_callActivities.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 2022   Richard Allen, Oracle   
-- 
*/

   --%suite(11 Variable Expressions in Call Activities)
   --%rollback(manual)

   --%test
   procedure var_exp_all_types;


   --%afterall
   procedure tear_down_tests;

end test_011_var_exps_in_callActivities;
/
