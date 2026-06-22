-- =====================================================================
-- Flows for APEX - Full Regression Test Suite Runner
-- =====================================================================
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates. 2026.
-- Created  13-Mar-2026   Claude Sonnet 4 AI (Generated)
--
-- Test Harness for running the complete Flows for APEX regression suite
-- Excludes AI-generated tests (Suite 90+) - use run_AI_generated_tests.sql for those
--
-- Usage: Run from VSCode or command line with SQLcl
-- =====================================================================

-- Set up environment for comprehensive test run
set serveroutput on size unlimited
set pagesize 0
set linesize 200
set trimspool on
set timing on
set echo on

-- Display test run header
prompt =====================================================================
prompt FLOWS FOR APEX - FULL REGRESSION TEST SUITE
prompt =====================================================================
prompt Run Date: 
select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') as run_date from dual;
prompt 
prompt Current Schema: 
select user as current_schema from dual;
prompt 
prompt Test Scope: Core engine regression tests (Suites 001-089)
prompt Excluded: AI-generated test suites (090+)
prompt =====================================================================

-- Check utPLSQL availability
prompt Verifying utPLSQL framework...
declare
  l_version varchar2(100);
begin
  select ut.version() into l_version from dual;
  dbms_output.put_line('utPLSQL Version: ' || l_version);
exception
  when others then
    dbms_output.put_line('ERROR: utPLSQL not available - ' || sqlerrm);
    raise;
end;
/

-- Clean up any previous comprehensive test data
prompt 
prompt Cleaning up any previous test run data...
begin
  -- Clean up test processes (but preserve AI test processes)
  for rec in (
    select prcs_id, prcs_name
    from flow_processes 
    where prcs_name like 'test - %'
      and prcs_name not like '%AI%'
      and rownum <= 100  -- Safety limit
  ) loop
    begin
      flow_api_pkg.flow_delete(rec.prcs_id);
      dbms_output.put_line('Cleaned up process: ' || rec.prcs_id || ' - ' || rec.prcs_name);
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
prompt RUNNING FULL REGRESSION TEST SUITE
prompt =====================================================================

-- Run Core API Tests (Suite 001)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 001: Basic API Functionality
prompt Testing: Core flow operations (create, start, reset, terminate, etc.)
prompt ---------------------------------------------------------------------
exec ut.run('test_001_api');

-- Run Gateway Tests (Suite 002)  
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 002: Gateway Operations
prompt Testing: Exclusive, Inclusive, Parallel, and Event-based gateways
prompt ---------------------------------------------------------------------
exec ut.run('test_002_gateway');

-- Run Start Event Tests (Suite 003)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 003: Start Event Handling
prompt Testing: Start event validation and processing
prompt ---------------------------------------------------------------------
exec ut.run('test_003_startEvents');

-- Run Process Variables Core Tests (Suite 004)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 004: Process Variables Core
prompt Testing: Basic process variable operations
prompt ---------------------------------------------------------------------
exec ut.run('test_004_proc_vars');

-- Run Engine Miscellaneous Tests (Suite 005)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 005: Engine Miscellaneous
prompt Testing: Engine edge cases and error handling
prompt ---------------------------------------------------------------------
exec ut.run('test_005_engine_misc');

-- Run Lanes and Roles Tests (Suite 006)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 006: Lanes and Roles
prompt Testing: BPMN lanes and role assignment
prompt ---------------------------------------------------------------------
exec ut.run('test_006_lanes_roles');

-- Run Process Variables Extended Tests (Suite 007)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 007: Process Variables Extended
prompt Testing: Advanced process variable scenarios
prompt ---------------------------------------------------------------------
exec ut.run('test_007_procvars');

-- Run Subprocess Tests (Suite 008)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 008: Subprocess Handling
prompt Testing: Embedded subprocesses and events
prompt ---------------------------------------------------------------------
exec ut.run('test_008_subproc_misc');

-- Run Call Activity Tests (Suite 009)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 009: Call Activity Nesting
prompt Testing: Call activity nesting and recursion
prompt ---------------------------------------------------------------------
exec ut.run('test_009_call_activity_nesting');

-- Run Variable Expressions Tests (Suite 010)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 010: Variable Expressions
prompt Testing: Expression evaluation and variable manipulation
prompt ---------------------------------------------------------------------
exec ut.run('test_010_variable_expressions');

-- Run Call Activity Variable Expressions Tests (Suite 011)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 011: Variable Expressions in Call Activities
prompt Testing: Expression handling across call activity boundaries
prompt ---------------------------------------------------------------------
exec ut.run('test_011_var_exps_in_callActivities');

-- Run Call Activity Timer Boundary Events Tests (Suite 012)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 012: Call Activity Timer Boundary Events
prompt Testing: Timer boundary events on call activities
prompt ---------------------------------------------------------------------
exec ut.run('test_012_call_Activity_timer_BEs');

-- Run Call Activity Escalation Boundary Events Tests (Suite 013)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 013: Call Activity Escalation Boundary Events
prompt Testing: Escalation boundary events on call activities
prompt ---------------------------------------------------------------------
exec ut.run('test_013_call_Activity_escalation_BEs');

-- Run Call Activity Error Boundary Events Tests (Suite 014)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 014: Call Activity Error Boundary Events
prompt Testing: Error boundary events on call activities
prompt ---------------------------------------------------------------------
exec ut.run('test_014_call_Activity_error_BEs');

-- Run Lanes Parse/Execute Tests (Suite 015)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 015: Lanes Parse and Execute
prompt Testing: Lane parsing and execution scenarios
prompt ---------------------------------------------------------------------
exec ut.run('test_015_lanes_parse_execute');

-- Run Gateway Errors Tests (Suite 016)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 016: Gateway Error Handling
prompt Testing: Gateway splitting errors and recovery
prompt ---------------------------------------------------------------------
exec ut.run('test_016_splitting_gw_errors');

-- Run Exclusive Gateway Restart Tests (Suite 017)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 017: Exclusive Gateway Errors and Restarts
prompt Testing: Error handling and restart scenarios
prompt ---------------------------------------------------------------------
exec ut.run('test_017_exc_gw_errors_restarts');

-- Run Gateway Routing Expression Tests (Suite 018)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 018: Gateway Routing Expressions
prompt Testing: Complex routing expressions and conditions
prompt ---------------------------------------------------------------------
exec ut.run('test_018_gw_routing_exps');

-- Run Priority and Due Dates Tests (Suite 019)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 019: Priority and Due Dates
prompt Testing: Task priority and due date calculations
prompt ---------------------------------------------------------------------
exec ut.run('test_019_priorityDueDates');

-- Run Message Flow Tests (Suite 021)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 021: Message Flow Basics
prompt Testing: Message flow and collaboration patterns
prompt ---------------------------------------------------------------------
exec ut.run('test_021_messageFlow_basics');

-- Run User Task Tests (Suite 022)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 022: User Task Handling
prompt Testing: User task scenarios and settings
prompt ---------------------------------------------------------------------
exec ut.run('test_022_usertask_misc');

-- Run Custom Extensions Tests (Suite 023)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 023: Custom Extensions
prompt Testing: Flows for APEX custom extension handling
prompt ---------------------------------------------------------------------
exec ut.run('test_023_custom_extensions');

-- Run User Task Approval Tests (Suite 024)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 024: User Task Approval Component
prompt Testing: APEX approval task integration
prompt ---------------------------------------------------------------------
exec ut.run('test_024_usertask_approval_task');

-- Run Script Task Tests (Suite 025)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 025: Script Tasks
prompt Testing: Script task execution and variable binding
prompt ---------------------------------------------------------------------
exec ut.run('test_025_script_tasks');


-- Run Parser Regression Tests (Suite 026)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 026: Parser Regressions
prompt Testing: Parser edge cases and bug regression coverage
prompt ---------------------------------------------------------------------
exec ut.run('test_026_parser_regressions');

-- Run Variable Expression Error Tests (Suite 027)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 027: Variable Expression Errors
prompt Testing: Error handling in variable expressions
prompt ---------------------------------------------------------------------
exec ut.run('test_027_var_exp_errors');

-- Run Task Parameters Tests (Suite 028)
prompt 
prompt ---------------------------------------------------------------------
prompt TEST SUITE 028: Task Parameters
prompt Testing: Script task input/output parameter definitions and processing
prompt ---------------------------------------------------------------------
exec ut.run('test_028_task_parameters');

prompt 
prompt =====================================================================
prompt FULL REGRESSION TEST EXECUTION COMPLETED
prompt =====================================================================

-- Show timing summary
prompt 
prompt Test execution completed at:
select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') as completion_time from dual;

-- Quick summary query
prompt 
prompt Test Suite Summary:
prompt (Run individual suites above to see detailed results)
select 
  'Core regression tests completed' as status,
  'Suites 001-027 executed (excluding AI-generated 090+)' as scope,
  'Check individual results above for pass/fail status' as instructions
from dual;

prompt 
prompt =====================================================================
prompt SUMMARY: Full Regression Test Execution Complete
prompt - Review results above for any FAILED tests
prompt - All core engine functionality has been tested
prompt - AI-generated tests (090+) run separately via run_AI_generated_tests.sql
prompt - Consider running specific test suites individually for debugging
prompt =====================================================================

-- Reset environment
set echo off
set timing off

prompt Full regression test run complete. Review results above.