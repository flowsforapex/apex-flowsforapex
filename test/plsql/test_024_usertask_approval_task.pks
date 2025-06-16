create or replace package test_024_usertask_approval_task as
/* 
-- Flows for APEX - test_024_usertask_approval_task.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
--
-- Created 16-May-2023   Richard Allen - Oracle
-- edited  10-Jun-2025   Richard Allen - Flowquest Limited (enhanced for 25.1 APEX Human Task enhs)
--
*/

  -- uses models 24a,b,c
  -- uses APEX App: FA Testing - Suite 024 - Approval Component Integration

  --%suite(24 usertask - approval task)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A - Basic Approval Task - Action Source Table)
  procedure basic_approval_action_source_table;

  --%test(B - Basic Approval Task - Action Source Query)
  procedure basic_approval_action_source_query;

  --%test(C - Basic Approval Task - No Action Source )
  procedure basic_approval_no_action_source;
 
  --%test(D - Basic Approval Task - Action Source Table - No PK Provided)
  procedure basic_approval_action_source_table_no_pk;
 
  --%test(E - Basic Approval Task - Action Source Query - No PK Provided)
  procedure basic_approval_action_source_query_no_pk;

  --%test(F - Basic Approval Task - Bad Priority Provided)
  procedure basic_approval_action_source_query_bad_priority;

  --%test(G - Approval Task cancelation when Subflow deleted)
  procedure approval_task_cleanup_sbfl_deletion;

  --%test(H - APEX Human Task - Setting Potential Owner and Business Admin)
  procedure AHT_set_pot_owner_and_business_admin;



  --%afterall
  procedure tear_down_tests;

end test_024_usertask_approval_task;
/
