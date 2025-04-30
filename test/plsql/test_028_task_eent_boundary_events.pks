create or replace package test_028_task_error_boundary_events as
/* 
-- Flows for APEX - test_028_task_error_boundary_events.pks
-- 
-- (c) Copyright Flowquest Ltd and / or its affiliates, 2025.
--
-- Created 03-Apr-2025   Richard Allen - Flowquest
--
*/

  -- uses models 28a-b

  --%suite(28 Task Error Boundary Events)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A - Parse and Access all objects - No Lanes)
  procedure custom_exts_no_lanes;

  --%test(B - Parse and Access all objects - In Collaboration)
  procedure custom_ext_lanes;

  --%afterall
  procedure tear_down_tests;

end test_028_task_error_boundary_events;
/