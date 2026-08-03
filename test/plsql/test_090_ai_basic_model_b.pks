create or replace package test_090_ai_basic_model_b is
/* 
-- Flows for APEX - test_090_ai_basic_model_b.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created  13-Mar-2026   Claude Sonnet 4 AI (Generated)
--
-- Test Suite 90B: Test Basic AI Model with Variable Expressions
-- Tests sequential task execution with beforeTask variable expressions
-- TaskA > TaskB (with variable setting) > TaskC (variable testing) > TaskD
*/

   --%suite(90B AI Generated Model with Variable Expressions)
   --%rollback(manual)
   --%tags(short,ce,ee,ai-generated,variables)

   --%beforeall
   procedure set_up_tests;

   --%test(a. create and parse AI model with variable expressions) 
   procedure test_model_creation;

   --%test(b. start process and verify initial state)
   procedure test_process_start;

   --%test(c. complete TaskA and verify progression to TaskB)
   procedure test_complete_task_a;

   --%test(d. complete TaskB and verify variable expressions executed)
   procedure test_task_b_variable_expressions;

   --%test(e. verify variables persist when stepping to TaskC)
   procedure test_variables_at_task_c;

   --%test(f. complete TaskC and TaskD to finish process)
   procedure test_complete_remaining_tasks;

   --%test(g. full execution testing variable persistence throughout)
   procedure test_full_execution_with_variables;

   --%afterall
   procedure tear_down_tests;

end test_090_ai_basic_model_b;
/