create or replace package test_090_ai_basic_model is
/* 
-- Flows for APEX - test_090_ai_basic_model.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created  13-Mar-2026   Claude Sonnet 4 AI (Generated)
--
-- Test Suite 90: Test Basic AI Model Creation
-- Tests basic sequential task execution through TaskA > TaskB > TaskC > TaskD
*/

   --%suite(90 AI Generated Basic Sequential Model)
   --%rollback(manual)
   --%tags(short,ce,ee,ai-generated)

   --%beforeall
   procedure set_up_tests;

   --%test(a. create and parse AI basic model)
   procedure test_model_creation;

   --%test(b. start process and verify initial state)
   procedure test_process_start;

   --%test(c. complete TaskA and verify progression to TaskB)
   procedure test_complete_task_a;

   --%test(d. complete TaskB and verify progression to TaskC)
   procedure test_complete_task_b;

   --%test(e. complete TaskC and verify progression to TaskD)
   procedure test_complete_task_c;

   --%test(f. complete TaskD and verify process completion)
   procedure test_complete_task_d;

   --%test(g. full sequential execution from start to end)
   procedure test_full_sequential_execution;

   --%test(h. verify process variable persistence across tasks)
   procedure test_process_variable_persistence;

   --%afterall
   procedure tear_down_tests;

end test_090_ai_basic_model;
/
