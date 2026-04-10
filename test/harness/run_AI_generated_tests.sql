-- =====================================================================
-- Flows for APEX - AI Generated Test Suite Runner
-- =====================================================================
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates. 2026.
-- Created  13-Mar-2026   Claude Sonnet 4 AI (Generated)
--
-- Test Harness for running AI-generated test suites via SQLcl/SQL*Plus
-- Usage: Run from VSCode or command line with SQLcl
--
-- =====================================================================

-- Set up environment
set serveroutput on size unlimited
set pagesize 0
set linesize 200
set trimspool on
set timing on
set echo on

-- Display test run header
prompt =====================================================================
prompt FLOWS FOR APEX - AI GENERATED TEST SUITE RUNNER
prompt =====================================================================
prompt Run Date: 
select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') as run_date from dual;
prompt 
prompt Current Schema: 
select user as current_schema from dual;
prompt =====================================================================

-- Clear any previous test data
prompt Cleaning up any previous test run data...
begin
  -- Clean up any hanging test processes
  for rec in (
    select prcs_id 
    from flow_processes 
    where prcs_name like 'test - %AI%' 
       or prcs_name like '%AI Generated%'
       or prcs_name like '%AI basic model%'  
       or prcs_name like '%AI model B%'
       or prcs_name like '%TaskB variables%'
       or prcs_name like '%variables at TaskC%'
       or prcs_name like '%AI Gateway%'
       or prcs_name like '%gateway routing%'
       or prcs_name like '%inclusive gateway%'
       or prcs_name like '%exclusive gateway%'
  ) loop
    begin
      flow_api_pkg.flow_delete(rec.prcs_id);
      dbms_output.put_line('Cleaned up process: ' || rec.prcs_id);
    exception 
      when others then
        dbms_output.put_line('Warning: Could not clean up process ' || rec.prcs_id || ': ' || sqlerrm);
    end;
  end loop;
  
  commit;
  dbms_output.put_line('Cleanup completed.');
end;
/

prompt =====================================================================
prompt RUNNING AI GENERATED TEST SUITES
prompt =====================================================================

-- Run Test Suite 90: Basic AI Model Creation
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 90A: AI Generated Basic Sequential Model
prompt Testing: Start Event > Task A > Task B > Task C > Task D > End Event
prompt ---------------------------------------------------------------------

-- Execute the test suite
exec ut.run('test_090_ai_basic_model');

-- Run Test Suite 90B: AI Model with Variable Expressions
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 90B: AI Generated Model with Variable Expressions
prompt Testing: Sequential tasks with beforeTask variable expressions
prompt Variables: task_b_started (static) + task_b_timestamp (plsqlExpression)
prompt ---------------------------------------------------------------------

-- Execute the test suite
exec ut.run('test_090_ai_basic_model_b');

-- Run Test Suite 90C: AI Gateway Routing Model
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 90C: AI Generated Gateway Routing Model
prompt Testing: Complex workflow with inclusive/exclusive gateways
prompt Features: Process variables, gateway conditions, routing logic
prompt ---------------------------------------------------------------------

-- Execute the test suite
exec ut.run('test_090_ai_gateway_routing');

prompt 
prompt ---------------------------------------------------------------------
prompt AI GENERATED TEST EXECUTION COMPLETED
prompt ---------------------------------------------------------------------

-- Show timing summary
prompt 
prompt Test execution completed at:
select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') as completion_time from dual;

prompt 
prompt =====================================================================
prompt SUMMARY: Check results above for test outcomes
prompt - All tests should show as PASSED
prompt - Any FAILED tests indicate issues with AI model generation
prompt - Review error messages for debugging information
prompt =====================================================================

-- Reset environment
set echo off
set timing off

prompt Test run complete. Review results above.