create or replace package test_025_iterations_loops_tasks.pks
/* 
-- Flows for APEX - test_025_iterations_loops_tasks.pks
-- 
-- (c) Copyright Flowquest Consulting Limited and / or its affiliates, 2024.
--
-- Created 20-June-2024   Richard Allen - Flowquest Consulting Limited
--
*/
is 
  --%suite(25 Task Iterations and Loops)
  --%tags(ee,short)
  --%rollback(manual)
  
  --%beforeall
  procedure set_up_tests;

  --%test('1 - Sequential Task Iteration to Completion - List')
  procedure task_seq_iteration_list;

  --%test('2 - Sequential Task Iteration with Completion Condition - List')
  procedure task_seq_iteration_list_w_condition;

  --%test('3 - Parallel Task Iteration to Completion - Array')
  procedure task_par_iteration_array;

  --%test('4 - Parallel Task Iteration with Completion Condition - Array')
  procedure task_par_iteration_array_w_condition;

  --%test('5 - Parallel Task Iteration to Completion - Query')
  procedure task_par_iteration_query;

  --%test('6 - Parallel Task Iteration with Completion Condition - Query')
  procedure task_par_iteration_query_w_condition;

  --%test('7 - Sequential Task Loop with Completion Condition')
  procedure task_loop_w_condition;

  --%afterall
  procedure tear_down_tests;

end test_025_iterations_loops_tasks;
/
