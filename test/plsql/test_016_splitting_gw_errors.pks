create or replace package test_016_splitting_gw_errors as
/* 
-- Flows for APEX - test_016_splitting_gw_errors.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 20-Jun-2022   Richard Allen - Oracle
--
*/

  -- uses models 16a

  --%suite(16 Splitting Gateway Errors and Restarts)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - No Routing - error and restart)
  procedure no_route_instruction;

  --%test(A2 - Bad Route Instruction)
  procedure bad_route_instruction;

  --%test(A3 - Bad pre-split expression)
  procedure bad_pre_split_expression;

  --%test(A4 - Bad pre-step expression in following step)
  procedure bad_following_pre_step_expression;

  --%test(B1a - bad post_phase expression - error)
  --%throws(-20987)
  procedure bad_post_phase_expression_A;

  --%test(B1b - bad post_phase expression - restart)
  procedure bad_post_phase_expression_B;

  --%test(B2 - bad post-merge expression)
  procedure bad_post_merge_expression;

  --%test(B3 - bad post-phase in scripttask pre-merge)
  procedure bad_post_phase_before_merge;

  --%test(B4 - bad pre-phase in task after merge gw)
  procedure bad_pre_phase_after_merge;

  --%afterall
  procedure tear_down_tests;

end test_016_splitting_gw_errors;
/
