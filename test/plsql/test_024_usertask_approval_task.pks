create or replace package test_024_usertask_approval_task as
/* 
-- Flows for APEX - test_024_usertask_approval_task.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 16-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 24a
  -- uses APEX App: FA Testing - Suite 024 - Apploval Component Integration

  --%suite(24 usertask - approval task)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%test(A - Basic Approval Task - Action Source Table)
  procedure basic_approval_action_source_table;

  --%test(B - Basic Approval Task - Action Source Query)
  procedure basic_approval_action_source_query;

  --%test(C - Basic Approval Task - No Action Source )
  procedure basic_approval_no_action_source;
 

  --%afterall
  procedure tear_down_tests;

end test_024_usertask_approval_task;
/
