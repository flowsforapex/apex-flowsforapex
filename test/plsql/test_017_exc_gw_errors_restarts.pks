create or replace package test_017_exc_gw_errors_restarts as
/* 
-- Flows for APEX - test_017_exc_gw_errors_restarts.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 30-Jun-2022   Richard Allen - Oracle
--
*/

  -- uses models 17a

  --%suite(Exclusive Gateway Errors and Restarts)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - Default Routing)
  procedure default_routing;

  --%test(A2 - Good Routing Variable)
  procedure good_routing_variable;

  --%test(A3 - Routing Variable - Too Many routes)
  procedure too_many_routing_variable_routes;

  --%test(A4 - No Routing Supplied)
  procedure no_routing;

  --%test(A5 - Bad Routing Variable)
  procedure bad_routing;

  --%test(B1 - Good Pre-split Routing Variable)
  procedure good_pre_split_var_exp;

  --%test(B2 - only 1 forward path)
  procedure single_path;

  --%test(B3 - single path, autorun)
  procedure single_path_autorun;

  --%test(C1 - error in following pre-task)
  procedure following_pre_task_error;

  --%test(C2 - error in pre-task variable expression)
  procedure pre_task_var_exp_error;

  --%test(C3 - error in post-merge variable expression)
  procedure post_merge_var_exp_error;

  --%test(Suite - Process completed successfully)
  procedure check_process_completed;

  --%afterall
  procedure tear_down_tests;

end test_017_exc_gw_errors_restarts;