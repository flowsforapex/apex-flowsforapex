create or replace package test_022_usertask_misc as
/* 
-- Flows for APEX - test_022_usertask_misc.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 09-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 22a-

  --%suite(22 Usertask Misc Features)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - Usertask Page Task parameter substitutions)
  procedure pagetask_substitutions_1;

  --%test(A2 - Usertask Page Task parameter substitutions)
  procedure pagetask_substitutions_2;

  --%test(B - Minor Tasks Smoke Test)
  procedure other_tasks_basic;

  --%afterall
  procedure tear_down_tests;

end test_022_usertask_misc;
/
