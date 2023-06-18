create or replace package test_019_priorityDueDates as
/* 
-- Flows for APEX - test_019_priorityDueDates.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 28-Mar-2023   Richard Allen - Oracle
--
*/

  -- uses models 19a-g

  --%suite(19 Gateway Routing Expressions)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - Process Priority and Due On - Static)
  procedure proc_static;

  -- inserttest(A2 - Task Priority and Due On - All Setting Methods)
  procedure task_all;

  --%test(A3 - API get and set process priority and due on)
  procedure proc_api;

  --%test(B - Process Priority and Due On - Scheduler)
  procedure proc_scheduler;

  --%test(C - Process Priority and Due On - Interval)
  procedure proc_interval;

  --%test(D1 - Process Priority and Due On - Proc Var-num)
  procedure proc_procvar;

  --%test(D2 - Process Priority and Due On - Proc Var-vc2)
  procedure proc_procvar2;

  --%test(E - Process Priority and Due On - SQL)
  procedure proc_sql;

  --%test(F - Process Priority and Due On - Expression)
  procedure proc_expression;

  --%test(G - Process Priority and Due On - Func Body)
  procedure proc_funcbody;

  --%afterall
  procedure tear_down_tests;

end test_019_priorityDueDates;