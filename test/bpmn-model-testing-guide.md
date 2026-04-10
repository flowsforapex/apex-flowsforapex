# Testing BPMN Models in Flows for APEX: Complete Testing Guide

*Last Updated: March 13, 2026*

## Overview

This guide covers comprehensive testing strategies for Flows for APEX BPMN models, including utPLSQL patterns, gateway testing, process lifecycle validation, and automated test harnesses. Based on successful Test Suites 90A, 90B, and 90C implementations.

## Table of Contents

1. [Test Framework Architecture](#test-framework-architecture)
2. [Process Lifecycle Testing](#process-lifecycle-testing)
3. [Gateway Testing Patterns](#gateway-testing-patterns)
4. [Variable Testing](#variable-testing)
5. [Test Harness Design](#test-harness-design)
6. [Common Testing Pitfalls](#common-testing-pitfalls)
7. [Test Suite Examples](#test-suite-examples)

## Test Framework Architecture

### Basic Test Structure

Every BPMN test suite follows this pattern:

```plsql
create or replace package test_xxx_model as
  -- utPLSQL annotations
  --%suite(Test Suite Name)
  --%suitepath(flows.models)

  --%beforeall(set_up_tests)
  --%test(Description of test)
  procedure test_specific_behavior;
  
  --%test(Description of another test)
  procedure test_another_behavior;
end test_xxx_model;
```

### Package Body Structure

```plsql
create or replace package body test_xxx_model as
  -- Model constants
  g_model_name constant varchar2(100) := 'Your Model Name';
  g_test_prcs_name constant varchar2(100) := 'test-model-prefix';
  
  -- Test framework variables
  g_dgrm_id flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is
  begin
    -- Setup diagram only once for all tests
    g_dgrm_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_name );
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_id );
  end set_up_tests;

  procedure test_specific_behavior
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Each test creates its own process instance
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-behavior'
    );
    
    -- Test implementation here
    
  end test_specific_behavior;
end test_xxx_model;
```

### Test Isolation Principles

1. **Separate Process Instances**: Each test creates its own process instance
2. **Descriptive Naming**: Use meaningful suffixes for process names
3. **No Shared State**: Tests should not depend on execution order
4. **Clean Setup**: Shared setup only for diagram parsing

## Process Lifecycle Testing

### Critical Process Lifecycle Pattern

**ALWAYS follow this sequence:**

```plsql
procedure test_process_lifecycle
is
  l_prcs_id flow_processes.prcs_id%type;
begin
  -- 1. CREATE process instance
  l_prcs_id := flow_api_pkg.flow_create(
    pi_dgrm_id   => g_dgrm_id,
    pi_prcs_name => 'test-instance-name'
  );
  
  -- 2. START process (executes Start Event, advances to first task)
  flow_api_pkg.flow_start( p_process_id => l_prcs_id );
  
  -- 3. STEP FORWARD through tasks only (NOT gateways!)
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'TaskName' );
  
  -- 4. VERIFY expected state
  -- Test assertions here
end test_process_lifecycle;
```

### Gateway Auto-Stepping Rules

**Critical:** Never call `step_forward` on gateways - they automatically advance!

```plsql
-- WRONG - Do NOT do this
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'InclusiveGateway' );

-- CORRECT - Step through tasks only
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
-- Gateway automatically evaluates and advances to next task(s)
-- Now test the resulting task states
```

### End Event Handling

**Never** try to step forward from an End event:

```plsql
-- WRONG - Process already completed
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'End' );

-- CORRECT - Step to final task, let it complete automatically
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'FinalTask' );
-- Process automatically reaches End event and completes
```

## Gateway Testing Patterns

### Inclusive Gateway Testing

Test that multiple paths can be active simultaneously:

```plsql
procedure test_inclusive_multiple_paths
is
  l_actual      sys_refcursor;
  l_expected    sys_refcursor;
  l_prcs_id     flow_processes.prcs_id%type;
begin
  l_prcs_id := flow_api_pkg.flow_create(
    pi_dgrm_id   => g_dgrm_id,
    pi_prcs_name => g_test_prcs_name||'-multiple'
  );
  
  flow_api_pkg.flow_start( p_process_id => l_prcs_id );
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
  
  -- Verify multiple tasks are running after inclusive gateway
  open l_actual for
    select sbfl_current
    from flow_subflows
    where sbfl_prcs_id = l_prcs_id
      and sbfl_current in ('AdminTask', 'PriorityTask', 'RegionTask')
      and sbfl_status = 'running'
    order by sbfl_current;
      
  open l_expected for
    select 'AdminTask' as sbfl_current from dual
    union all
    select 'PriorityTask' as sbfl_current from dual
    union all  
    select 'RegionTask' as sbfl_current from dual
    order by sbfl_current;
        
  ut.expect( l_actual ).to_equal( l_expected );
end test_inclusive_multiple_paths;
```

### Exclusive Gateway Testing

Test that only one path is taken:

```plsql
procedure test_exclusive_single_path
is
  l_actual      sys_refcursor;
  l_prcs_id     flow_processes.prcs_id%type;
begin
  l_prcs_id := flow_api_pkg.flow_create(
    pi_dgrm_id   => g_dgrm_id,
    pi_prcs_name => g_test_prcs_name||'-exclusive'
  );
  
  flow_api_pkg.flow_start( p_process_id => l_prcs_id );
  
  -- Navigate to exclusive gateway
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRoutingDecision' );
  
  -- Verify only one task is running after exclusive gateway
  open l_actual for
    select sbfl_current, sbfl_status
    from flow_subflows
    where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'ApproveTask'
      and sbfl_status = 'running';
        
  ut.expect( l_actual ).to_have_count( 1 );
  
  -- Verify other paths are NOT taken
  declare
    l_other_count number;
  begin
    select count(*)
    into l_other_count
    from flow_subflows
    where sbfl_prcs_id = l_prcs_id
      and sbfl_current in ('RejectTask', 'DefaultTask')
      and sbfl_status = 'running';
        
    ut.expect( l_other_count ).to_equal( 0 );
  end;
end test_exclusive_single_path;
```

### Testing Gateway Conditions

Test specific routing conditions by modifying process variables:

```plsql
procedure test_reject_path
is
  l_actual      sys_refcursor;
  l_prcs_id     flow_processes.prcs_id%type;
begin
  l_prcs_id := flow_api_pkg.flow_create(
    pi_dgrm_id   => g_dgrm_id,
    pi_prcs_name => g_test_prcs_name||'-reject'
  );
  
  flow_api_pkg.flow_start( p_process_id => l_prcs_id );
  
  -- Navigate to decision point
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
  
  -- MODIFY variable to test specific path
  flow_process_vars.set_var( 
    pi_prcs_id => l_prcs_id, 
    pi_var_name => 'routing_decision', 
    pi_vc2_value => 'REJECT' 
  );
  
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRoutingDecision' );
  
  -- Verify REJECT path was taken
  open l_actual for
    select sbfl_current, sbfl_status
    from flow_subflows
    where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'RejectTask'
      and sbfl_status = 'running';
        
  ut.expect( l_actual ).to_have_count( 1 );
end test_reject_path;
```

## Variable Testing

### Testing Variable Creation

Variables are created during `flow_start()` when the process reaches a task with `beforeTask` variables:

```plsql
procedure test_variables_created
is
  l_actual      sys_refcursor;
  l_expected    sys_refcursor;
  l_prcs_id     flow_processes.prcs_id%type;
begin
  l_prcs_id := flow_api_pkg.flow_create(
    pi_dgrm_id   => g_dgrm_id,
    pi_prcs_name => g_test_prcs_name||'-variables'
  );
  
  -- Variables are created when process reaches task with beforeTask
  flow_api_pkg.flow_start( p_process_id => l_prcs_id );
  
  -- DO NOT step forward - just test that variables exist
  open l_actual for
    select prov_var_name, prov_var_vc2, prov_var_num
    from flow_process_variables
    where prov_prcs_id = l_prcs_id
    order by prov_var_name;
      
  open l_expected for
    select 'priority_level' as prov_var_name, null as prov_var_vc2, 5 as prov_var_num from dual
    union all
    select 'user_type' as prov_var_name, 'ADMIN' as prov_var_vc2, null as prov_var_num from dual
    order by prov_var_name;
      
  ut.expect( l_actual ).to_equal( l_expected ).unordered();
end test_variables_created;
```

### Testing Variable Persistence

Verify variables survive gateway transitions:

```plsql
procedure test_variable_persistence
is
  l_actual      sys_refcursor;
  l_expected    sys_refcursor;
  l_prcs_id     flow_processes.prcs_id%type;
begin
  l_prcs_id := flow_api_pkg.flow_create(
    pi_dgrm_id   => g_dgrm_id,
    pi_prcs_name => g_test_prcs_name||'-persistence'
  );
  
  flow_api_pkg.flow_start( p_process_id => l_prcs_id );
  
  -- Step through multiple gateways and tasks
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'AdminTask' );
  test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRouting' );
  
  -- Verify original variables still exist plus new ones
  declare
    l_variable_count number;
  begin
    select count(*)
    into l_variable_count
    from flow_process_variables 
    where prov_prcs_id = l_prcs_id
      and prov_var_name in ('user_type', 'priority_level', 'routing_decision');
    
    ut.expect( l_variable_count ).to_equal( 3 );
  end;
end test_variable_persistence;
```

## Test Harness Design

### Complete Test Runner

Create a comprehensive test harness for multiple model suites:

```sql
-- test/harness/run_all_model_tests.sql
set serveroutput on size unlimited
set pagesize 0
set linesize 200
set timing on
set echo on

-- Display test run header
prompt =====================================================================
prompt FLOWS FOR APEX - BPMN MODEL TEST SUITE RUNNER
prompt =====================================================================

-- Clean up any previous test data
prompt Cleaning up previous test processes...
begin
  for rec in (
    select prcs_id 
    from flow_processes 
    where prcs_name like 'test-%'
       or prcs_name like '%test%'
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
end;
/

-- Run all test suites
prompt =====================================================================
prompt RUNNING MODEL TEST SUITES
prompt =====================================================================

exec ut.run('test_090_simple_model');
exec ut.run('test_090_variable_model'); 
exec ut.run('test_090_gateway_routing');

prompt =====================================================================
prompt TEST EXECUTION COMPLETED
prompt =====================================================================
```

### Test Suite Organization

Organize tests by complexity level:

```
test/
├── harness/
│   └── run_all_model_tests.sql
├── models/
│   ├── sql/
│   │   ├── A90a - Simple Model.sql
│   │   ├── A90b - Variable Model.sql
│   │   └── A90c - Gateway Model.sql
└── plsql/
    ├── test_090_simple_model.pks/.pkb
    ├── test_090_variable_model.pks/.pkb
    └── test_090_gateway_routing.pks/.pkb
```

## Common Testing Pitfalls

### 1. Stepping Through Gateways
**Problem**: Calling `step_forward` on gateway objects
**Error**: Gateway step operations fail
**Solution**: Only step through tasks - gateways auto-advance

```plsql
-- WRONG
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'InclusiveGateway' );

-- CORRECT  
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
-- Gateway automatically evaluates and proceeds
```

### 2. Cursor vs Number Comparisons
**Problem**: Comparing sys_refcursor directly to numbers
**Error**: "Actual (refcursor) cannot be compared to Expected (number)"
**Solution**: Use intermediate variables

```plsql
-- WRONG
open l_actual for select count(*) from table;
ut.expect( l_actual ).to_equal( 0 );

-- CORRECT
declare
  l_count number;
begin
  select count(*) into l_count from table;
  ut.expect( l_count ).to_equal( 0 );
end;
```

### 3. Incorrect Process Lifecycle
**Problem**: Not starting processes after creation
**Error**: Process never advances beyond created state
**Solution**: Always call `flow_start` after `flow_create`

```plsql
-- WRONG
l_prcs_id := flow_api_pkg.flow_create(...);
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'Task1' );

-- CORRECT
l_prcs_id := flow_api_pkg.flow_create(...);
flow_api_pkg.flow_start( p_process_id => l_prcs_id );
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'Task1' );
```

### 4. End Event Step Forward
**Problem**: Trying to step forward from End events
**Error**: Cannot advance from completed process
**Solution**: Let final task automatically complete

```plsql
-- WRONG
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'End' );

-- CORRECT
test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'FinalTask' );
-- Process automatically completes at End event
```

### 5. Shared Process State
**Problem**: Multiple tests using same process instance
**Error**: Tests interfere with each other
**Solution**: Each test creates its own process

```plsql
-- WRONG - Shared process in set_up_tests
procedure set_up_tests
is
begin
  g_prcs_id := flow_api_pkg.flow_create(...);
end;

-- CORRECT - Each test creates own process
procedure test_specific_behavior
is
  l_prcs_id flow_processes.prcs_id%type;
begin
  l_prcs_id := flow_api_pkg.flow_create(...);
  -- test using l_prcs_id
end;
```

### 6. Variable Testing Timing
**Problem**: Testing variables before they're created
**Error**: No variables found in assertions
**Solution**: Understand when variables are created

```plsql
-- Variables created during flow_start when reaching beforeTask
flow_api_pkg.flow_start( p_process_id => l_prcs_id );
-- Variables now exist - can test them

-- DON'T step forward if only testing variable creation
-- test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
```

## Test Suite Examples

### Example: Complete Gateway Test Suite

See `test/plsql/test_090_ai_gateway_routing.pkb` for a comprehensive example including:

- ✅ Variable creation testing
- ✅ Inclusive gateway multiple path testing  
- ✅ Exclusive gateway single path testing
- ✅ Gateway condition manipulation
- ✅ Variable persistence across gateways
- ✅ Complete workflow execution
- ✅ Process completion verification

### Example: Test Harness Usage

```sql
-- Run specific test suite
exec ut.run('test_090_ai_gateway_routing');

-- Run all gateway tests
exec ut.run('test_090_ai_gateway_routing.test_inclusive_multiple_paths');
```

## Performance Testing Considerations

### Large Volume Testing

For performance testing with many instances:

```plsql
procedure test_high_volume
is
begin
  for i in 1..1000 loop
    declare
      l_prcs_id flow_processes.prcs_id%type;
    begin
      l_prcs_id := flow_api_pkg.flow_create(
        pi_dgrm_id => g_dgrm_id,
        pi_prcs_name => 'perf-test-' || i
      );
      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      -- Complete process
      test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'Task1' );
      
      -- Clean up immediately
      flow_api_pkg.flow_delete( p_process_id => l_prcs_id );
    end;
  end loop;
end test_high_volume;
```

### Memory Management

For large test suites, manage memory usage:

```plsql
-- Commit periodically during cleanup
begin
  for rec in (select prcs_id from flow_processes where prcs_name like 'test-%') loop
    flow_api_pkg.flow_delete(rec.prcs_id);
    
    if mod(sql%rowcount, 100) = 0 then
      commit; -- Prevent excessive undo
    end if;
  end loop;
  commit;
end;
```

## Conclusion

This testing guide provides comprehensive patterns for validating BPMN models in Flows for APEX. Key principles:

- ✅ **Test Isolation**: Each test creates its own process instance
- ✅ **Proper Lifecycle**: Create → Start → Step through tasks only  
- ✅ **Gateway Understanding**: Never step through gateways - they auto-advance
- ✅ **Variable Timing**: Test variables after they're created during flow_start
- ✅ **Assertion Patterns**: Use proper cursor vs scalar comparisons
- ✅ **Comprehensive Coverage**: Test all paths, conditions, and edge cases

Follow these patterns to build robust, maintainable test suites that provide confidence in your BPMN model implementations.

---

*This guide is based on successfully implemented Test Suites 90A, 90B, and 90C demonstrating progressive complexity from basic sequential workflows to advanced gateway routing patterns.*