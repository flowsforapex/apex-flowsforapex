/* 
-- Flows for APEX - test_var_exps_in_callActivities.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 2022   Richard Allen, Oracle   
-- 
*/

create or replace package test_var_exps_in_callActivities is

   --%suite(test_variable_exps_in_callactivities)
   --%rollback(manual)

   --%test
   procedure var_exp_all_types;


end test_var_exps_in_callActivities;