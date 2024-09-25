create or replace package test_005_engine_misc as
/* 
-- Flows for APEX - test_005_engine_misc.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 31-Mar-2023   Richard Allen - Oracle
--
*/

  -- uses models 5a-

  --%suite(05 Engine Misc)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - Model driven terminations - final status completed)
  procedure model_terminate_completed;

  --%test(A2 - Model driven terminations - final status terminated)
  procedure model_terminate_terminated;

  --%test(B1 - Link Events - Good Link)
  procedure model_link_good;

  --%test(B1 - Link Events - Duplicate Link)
  procedure model_link_Duplicate;

  --%test(B1 - Link Events - Incorrect Link)
  procedure model_link_Incorrect;

  --%test(C - ICE Types)
  procedure ICE_types;

  --%test(D - Repeating Timer BE)
  --%tags(timer)
  procedure repeating_TimerBE;


  --%afterall
  procedure tear_down_tests;

end test_005_engine_misc;
/
