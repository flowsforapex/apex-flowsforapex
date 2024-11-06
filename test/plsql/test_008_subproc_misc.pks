create or replace package test_008_subproc_misc as
/* 
-- Flows for APEX - test_008_subproc_misc.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 15-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 8a-g

  --%suite(08 SubProcesses Misc)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A - SubProcess with No Start Event)
  procedure subproc_no_start;

  --%test(B - SubProcess with 2 Start Event)
  procedure subproc_two_starts;

  --%test(C - Subprocess with 2 Int Timer Boundary Events)
  --%tags(timer)
  procedure subproc_two_int_timer_BEs;

  --%test(D - Subprocess with 2 Error Boundary Events)
  procedure subproc_two_error_BEs;

  --%test(E - Subprocess with 2 Int Esc Boundary Events)
  procedure subproc_two_int_esc_BEs;

  --%test(F - Subprocess with NonInt and Int Esc Boundary Events)
  procedure subproc_int_plus_non_int_esc_BEs;

  --%test(G - Subprocess with Int Timer and Nested SubProc )
  --%tags(timer)
  procedure subproc_int_timer_fires_nested_subproc;


  --%afterall
  procedure tear_down_tests;

end test_008_subproc_misc;
/
