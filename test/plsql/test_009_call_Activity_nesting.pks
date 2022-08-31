create or replace package test_009_call_Activity_nesting as
/* 
-- Flows for APEX - test_009_call_Activity_nesting.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 23-Aug-2022   Richard Allen - Oracle
--
*/

  -- uses models 09a-w (eventually)

  --%suite(09 Call Activity Nesting)
  --%rollback(manual)

  --%beforeall
  --%disabled
  procedure set_up_tests;

  --%test(1. deeply nested call ends)
  --%disabled
  procedure deep_standard_ends;

  --%test(2. deeply nested parallel gateway merges)
  --%disabled
  procedure deep_parallel_gw_merges;

  --%test(3. deeply nested subprocess ends)
  --%disabled
  procedure deep_subproc_ends;

  --%test(4. deeply nested callActivity ends)
  --%disabled
  procedure deep_callActivity_end;

  --%test(5. consequtive deep calls)
  --%disabled
  procedure conseq_deep_ends;

  --%test(6. direct recursive call)
  --%throws(-20987)
  procedure direct_recursion;

  --%test(7a. indirect recursion a)
  --%throws(-20987)
  procedure indirect_recursion_a;

  --%test(7b. indirect recursion b)
  --%throws(-20987)
  procedure indirect_recursion_b;

  --%test(8. call non-callable diagram)
  --%throws(-20987)
  procedure call_non_callable;

  -- should probably add tests on versions, non-existant diagrams, etc.

  --%afterall
  --%disabled
  procedure tear_down_tests;

end test_009_call_Activity_nesting;