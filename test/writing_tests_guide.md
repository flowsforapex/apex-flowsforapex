# Writing Tests for Flows for APEX - AI Learning Guide

This guide documents lessons learned from AI-generated test creation for the Flows for APEX engine, capturing best practices, common pitfalls, and proven patterns.

## Table of Contents
- [Test Suite Structure](#test-suite-structure)
- [BPMN Model Creation Guidelines](#bpmn-model-creation-guidelines)
- [Test Implementation Best Practices](#test-implementation-best-practices)
- [Common Mistakes to Avoid](#common-mistakes-to-avoid)
- [Test Helper Usage](#test-helper-usage)
- [Process Variable Testing](#process-variable-testing)
- [Validation Patterns](#validation-patterns)
- [Test Harness and Execution](#test-harness-and-execution)

---

## Test Suite Structure

### Naming Convention
- **Test Models**: `A[NN][x] - Description` (e.g., `A90a - Basic AI Model`)
- **Test Package**: `test_[NNN]_description` (e.g., `test_090_ai_basic_model`)
- **Test Procedures**: `test_[descriptive_name]` (e.g., `test_complete_task_a`)

### Package Template
```sql
create or replace package test_[NNN]_description is
   --%suite([NN] Descriptive Suite Name)
   --%rollback(manual)
   --%tags(short,ce,ee,ai-generated)

   --%beforeall
   procedure set_up_tests;

   --%test(descriptive test name)
   procedure test_[specific_functionality];

   --%afterall
   procedure tear_down_tests;
end test_[NNN]_description;
```

### utPLSQL Annotations Required
- `%suite`: Test suite description
- `%rollback(manual)`: Use manual rollback for process cleanup
- `%tags`: Include appropriate tags (short, ce, ee, ai-generated)
- `%beforeall`: Setup (parse diagrams)
- `%test`: Individual test case descriptions
- `%afterall`: Cleanup (delete test processes)

---

## BPMN Model Creation Guidelines

### Basic Model Structure
```xml
<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:bpmn="..." xmlns:apex="http://flowsforapex.com/bpmn" ...>
  <bpmn:process id="Process_unique_id" isExecutable="true">
    <bpmn:startEvent id="Start" name="Start">
      <bpmn:outgoing>Flow_start_to_first</bpmn:outgoing>
    </bpmn:startEvent>
    
    <bpmn:task id="TaskA" name="Task A">
      <bpmn:incoming>Flow_start_to_first</bpmn:incoming>
      <bpmn:outgoing>Flow_first_to_second</bpmn:outgoing>
    </bpmn:task>
    
    <!-- Include sequence flows for all connections -->
    <bpmn:sequenceFlow id="Flow_start_to_first" sourceRef="Start" targetRef="TaskA" />
    
    <!-- Include visual diagram information -->
  </bpmn:process>
  
  <bpmndi:BPMNDiagram>
    <!-- Visual layout coordinates -->
  </bpmndi:BPMNDiagram>
</bpmn:definitions>
```

### Key Requirements
- **Unique IDs**: All BPMN elements must have unique IDs
- **Complete Flows**: Every task needs incoming/outgoing sequence flows
- **Visual Layout**: Include BPMN diagram info for proper rendering
- **Executable**: Set `isExecutable="true"` on process
- **Namespaces**: Include Flows for APEX namespace when using extensions

### Model Installation Pattern
```sql
declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]',
      q'[<bpmn:definitions ...>]',
      -- BPMN content here
      q'[]'
  ));
  
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Model Name',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Testing',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
  );
end;
```

---

## Test Implementation Best Practices

### Process Creation Pattern
```sql
l_prcs_id := flow_api_pkg.flow_create(
  pi_dgrm_name => model_constant
, pi_prcs_name => 'test - descriptive name'
);
g_prcs_id_[n] := l_prcs_id;  -- Store for cleanup

flow_api_pkg.flow_start( p_process_id => l_prcs_id );
```

### Validation Pattern Using Cursors
```sql
-- Expected results
open l_expected for
  select 
    expected_value as column_name,
    another_expected as another_column
  from dual;

-- Actual results  
open l_actual for
  select actual_value as column_name, actual_another as another_column
  from some_table 
  where condition = l_prcs_id;

ut.expect( l_actual ).to_equal( l_expected );
```

### Process State Validation
```sql
-- Check process status
open l_expected for
  select 
    l_prcs_id as prcs_id,
    flow_constants_pkg.gc_prcs_status_running as prcs_status
  from dual;

open l_actual for
  select prcs_id, prcs_status 
  from flow_processes 
  where prcs_id = l_prcs_id;

ut.expect( l_actual ).to_equal( l_expected );
```

### Subflow Position Validation
```sql
-- Check current task position
open l_expected for
  select 
    l_prcs_id as sbfl_prcs_id,
    'TaskB' as sbfl_current,
    flow_constants_pkg.gc_sbfl_status_running as sbfl_status
  from dual;

open l_actual for
  select sbfl_prcs_id, sbfl_current, sbfl_status 
  from flow_subflows 
  where sbfl_prcs_id = l_prcs_id 
    and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;

ut.expect( l_actual ).to_equal( l_expected );
```

---

## Common Mistakes to Avoid

### ❌ Missing Step Key
**WRONG:**
```sql
-- This fails - missing step key parameter
flow_api_pkg.flow_complete_step( 
  p_process_id => l_prcs_id, 
  p_subflow_id => l_sbfl_id 
);
```

**CORRECT:**
```sql
-- Use test helper instead
test_helper.step_forward(
  pi_prcs_id => l_prcs_id,
  pi_current => 'TaskA'
);
```

### ❌ Invalid FOR Loop Syntax
**WRONG:**
```sql
-- Cannot iterate over literal values in PL/SQL
for task_name in ('TaskA', 'TaskB', 'TaskC') loop
  -- processes task_name.column_value
end loop;
```

**CORRECT:**
```sql
-- Use individual calls or arrays
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskB');
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskC');
```

### ❌ Wrong Package for Process Variables
**WRONG:**
```sql
-- Process variables are NOT in flow_api_pkg
flow_api_pkg.set_var(p_var_name => 'test', p_var_value => 'value');
flow_api_pkg.get_var_vc2(p_var_name => 'test');
```

**CORRECT:**
```sql
-- Use flow_process_vars package
flow_process_vars.set_var(
  pi_prcs_id => l_prcs_id,
  pi_var_name => 'test_var', 
  pi_vc2_value => 'value'
);

flow_process_vars.get_var_vc2(
  pi_prcs_id => l_prcs_id,
  pi_var_name => 'test_var'
);
```

### ❌ Non-existent Status Constants
**WRONG:**
```sql
-- This constant doesn't exist
flow_constants_pkg.gc_dgrm_status_parsed
```

**CORRECT:**
```sql
-- Check if diagram parsed by looking for objects
case when not exists(
  select null from flow_objects objt 
  where objt.objt_dgrm_id = d.dgrm_id
) then 'No' else 'Yes' end as diagram_parsed
```

---

## Test Helper Usage

### Basic Step Forward
```sql
-- Step forward from current task using BPMN ID
test_helper.step_forward(
  pi_prcs_id => l_prcs_id,
  pi_current => 'TaskA'
);

-- Step forward using subflow ID  
test_helper.step_forward(
  pi_prcs_id => l_prcs_id,
  pi_sbfl_id => l_sbfl_id
);
```

### Restart and Step Forward
```sql
-- Restart process and step forward
test_helper.restart_forward(
  pi_prcs_id => l_prcs_id,
  pi_current => 'TaskA'
);
```

### When NOT to Use Test Helpers
- When specifically testing step completion API functionality
- When testing error conditions in step processing
- When testing step key generation itself

---

## Process Variable Testing

### Setting Variables
```sql
-- Set different data types
flow_process_vars.set_var(
  pi_prcs_id => l_prcs_id,
  pi_var_name => 'string_var',
  pi_vc2_value => 'test value'
);

flow_process_vars.set_var(
  pi_prcs_id => l_prcs_id, 
  pi_var_name => 'number_var',
  pi_num_value => 42
);

flow_process_vars.set_var(
  pi_prcs_id => l_prcs_id,
  pi_var_name => 'clob_var', 
  pi_clob_value => large_text_value
);
```

### Testing Variable Persistence
```sql
-- Set variable before task completion
flow_process_vars.set_var(pi_prcs_id => l_prcs_id, pi_var_name => 'test', pi_vc2_value => 'value');

-- Complete task
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');

-- Verify variable survived
open l_expected for
  select 'value' as var_value from dual;

open l_actual for
  select flow_process_vars.get_var_vc2(
    pi_prcs_id => l_prcs_id,
    pi_var_name => 'test'
  ) as var_value from dual;

ut.expect( l_actual ).to_equal( l_expected );
```

---

## Validation Patterns

### Process Completion Validation
```sql
-- Verify process completed successfully
open l_expected for
  select 
    l_prcs_id as prcs_id,
    flow_constants_pkg.gc_prcs_status_completed as prcs_status
  from dual;

open l_actual for
  select prcs_id, prcs_status 
  from flow_processes 
  where prcs_id = l_prcs_id;

ut.expect( l_actual ).to_equal( l_expected );
```

### Task Execution History Validation
```sql
-- Count completed tasks in history
select count(*) into l_task_count
from flow_subflow_log
where sflg_prcs_id = l_prcs_id 
  and sflg_objt_id in ('TaskA', 'TaskB', 'TaskC', 'TaskD');

ut.expect( l_task_count ).to_equal( 4 );
```

### Diagram Parsing Validation
```sql
-- Check if BPMN model parsed correctly
open l_expected for
  select 
    'Model Name' as dgrm_name,
    '0' as dgrm_version,
    'Testing' as dgrm_category,
    'Yes' as diagram_parsed
  from dual;

open l_actual for
  select 
    d.dgrm_name,
    d.dgrm_version, 
    d.dgrm_category,
    case when not exists(
      select null from flow_objects objt 
      where objt.objt_dgrm_id = d.dgrm_id
    ) then 'No' else 'Yes' end as diagram_parsed
  from flow_diagrams d
  where d.dgrm_id = l_dgrm_id;

ut.expect( l_actual ).to_equal( l_expected );
```

---

## Test Harness and Execution

### Test Harness Structure
- Create `/test/harness/` directory for executable test scripts
- Separate AI tests from regression tests
- Include proper cleanup and environment setup
- Provide clear output formatting and timing

### Sample Test Harness Script
```sql
-- Set up environment
set serveroutput on size unlimited
set pagesize 0
set linesize 200
set timing on

-- Run specific test suite
exec ut.run('test_090_ai_basic_model');

-- Reset environment
set timing off
```

### Cleanup Patterns
```sql
procedure tear_down_tests is
begin
  -- Clean up all test processes
  for i in 1..8 loop
    case i
      when 1 then if g_prcs_id_1 is not null then flow_api_pkg.flow_delete(g_prcs_id_1); end if;
      when 2 then if g_prcs_id_2 is not null then flow_api_pkg.flow_delete(g_prcs_id_2); end if;
      -- ... continue for all process IDs
    end case;
  end loop;
end tear_down_tests;
```

---

## Lessons Learned

### From Test Suite 90 (Basic AI Model):
1. **Always use test helpers** for step completion unless testing the step API itself
2. **Step keys are mandatory** - never call flow_complete_step without them
3. **Process variables require specific package** - use flow_process_vars, not flow_api_pkg
4. **Diagram parsing validation** requires checking for parsed objects, not status constants
5. **PL/SQL FOR loops** cannot iterate over literal value lists
6. **Test cleanup is critical** - always implement proper tear_down_tests procedures
7. **Individual test isolation** - each test should create its own process instance

### AI Test Generation Insights:
- AI can successfully generate working BPMN models and test suites
- AI can implement BPMN variable expressions (beforeTask, afterTask)
- Domain-specific knowledge (step keys, package usage) requires learning
- Test patterns are highly reusable once established
- Framework abstractions (test helpers) prevent many common errors
- Proper documentation enables better AI-generated tests
- Variable expression testing requires validation at multiple workflow stages

## Variable Expression Testing Patterns

### Adding Variable Expressions to BPMN Tasks
```xml
<bpmn:task id="TaskB" name="Task B">
  <bpmn:extensionElements>
    <apex:beforeTask>
      <apex:processVariable>
        <apex:varSequence>0</apex:varSequence>
        <apex:varName>static_var</apex:varName>
        <apex:varDataType>VARCHAR2</apex:varDataType>
        <apex:varExpressionType>static</apex:varExpressionType>
        <apex:varExpression>Static Value</apex:varExpression>
      </apex:processVariable>
      <apex:processVariable>
        <apex:varSequence>1</apex:varSequence>
        <apex:varName>dynamic_var</apex:varName>
        <apex:varDataType>VARCHAR2</apex:varDataType>
        <apex:varExpressionType>plsqlExpression</apex:varExpressionType>
        <apex:varExpression>to_char(systimestamp, 'YYYY-MM-DD HH24:MI:SS.FF3')</apex:varExpression>
      </apex:processVariable>
    </apex:beforeTask>
  </bpmn:extensionElements>
</bpmn:task>
```

### Testing Variable Expression Execution
```sql
-- Step forward to task that has beforeTask variable expressions
test_helper.step_forward(
  pi_prcs_id => l_prcs_id,
  pi_current => 'TaskA'  -- This moves to TaskB and executes beforeTask
);

-- Test static variable was set
open l_expected for
  select 'Static Value' as var_value from dual;

open l_actual for
  select flow_process_vars.get_var_vc2(
    pi_prcs_id => l_prcs_id,
    pi_var_name => 'static_var'
  ) as var_value from dual;

ut.expect( l_actual ).to_equal( l_expected );

-- Test dynamic/expression variable exists and is reasonable
select count(*) into l_var_exists
from flow_process_variables  
where prov_prcs_id = l_prcs_id
  and prov_var_name = 'dynamic_var'
  and prov_var_vc2 is not null
  and length(prov_var_vc2) >= expected_min_length;

ut.expect( l_var_exists ).to_equal( 1 );
```

### Testing Variable Persistence Across Tasks
```sql
-- Step through multiple tasks
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');  -- Sets vars
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskB');  -- Move on

-- Verify variables persist
ut.expect( flow_process_vars.get_var_vc2(
  pi_prcs_id => l_prcs_id,
  pi_var_name => 'static_var'
) ).to_equal( 'Static Value' );

-- Test dynamic variable accessibility  
l_dynamic_value := flow_process_vars.get_var_vc2(
  pi_prcs_id => l_prcs_id,
  pi_var_name => 'dynamic_var'
);

ut.expect( l_dynamic_value ).to_be_not_null();
ut.expect( length(l_dynamic_value) ).to_be_greater_than( min_expected );
```

### Variable Count Validation
```sql
-- Count variables created by expressions
select count(*) into l_var_count
from flow_process_variables
where prov_prcs_id = l_prcs_id
  and prov_var_name in ('static_var', 'dynamic_var')
  and prov_var_vc2 is not null;

ut.expect( l_var_count ).to_equal( 2 );
```

---

## Test Suites Created

### Suite 90A: Basic Sequential Model
- **Purpose**: Validate AI BPMN generation and basic workflow execution
- **Pattern**: Start > TaskA > TaskB > TaskC > TaskD > End
- **Tests**: Model creation, step progression, process completion, variable persistence

### Suite 90B: Model with Variable Expressions  
- **Purpose**: Validate BPMN variable expressions and beforeTask functionality
- **Pattern**: TaskA > TaskB (beforeTask sets variables) > TaskC (test variables) > TaskD
- **Variables**: `task_b_started` (static), `task_b_timestamp` (plsqlExpression)
- **Tests**: Expression execution, variable persistence, full workflow with expressions

---

---

*This guide will be updated as AI test generation capabilities evolve and new patterns emerge.*

---

## Gateway Testing Patterns

### BPMN Gateway Structure
```xml
<!-- Inclusive Gateway (multiple paths possible) -->
<bpmn:inclusiveGateway id="InclusiveGateway" name="Inclusive Gateway">
  <bpmn:incoming>Flow_to_gateway</bpmn:incoming>
  <bpmn:outgoing>Flow_to_admin</bpmn:outgoing>
  <bpmn:outgoing>Flow_to_priority</bpmn:outgoing>
  <bpmn:outgoing>Flow_to_north</bpmn:outgoing>
</bpmn:inclusiveGateway>

<!-- Exclusive Gateway (single path only) -->
<bpmn:exclusiveGateway id="ExclusiveGateway" name="Exclusive Gateway" default="Flow_default">
  <bpmn:incoming>Flow_to_exclusive</bpmn:incoming>
  <bpmn:outgoing>Flow_approve</bpmn:outgoing>
  <bpmn:outgoing>Flow_reject</bpmn:outgoing>
  <bpmn:outgoing>Flow_default</bpmn:outgoing>
</bpmn:exclusiveGateway>

<!-- Gateway routing with process variable conditions -->
<bpmn:sequenceFlow id="Flow_to_admin" sourceRef="InclusiveGateway" targetRef="AdminTask" apex:sequence="10">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$user_type = 'ADMIN'</bpmn:conditionExpression>
</bpmn:sequenceFlow>

<bpmn:sequenceFlow id="Flow_approve" sourceRef="ExclusiveGateway" targetRef="ApproveTask" apex:sequence="10">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">:F4A$routing_decision = 'APPROVE'</bpmn:conditionExpression>
</bpmn:sequenceFlow>
```

### Setting Process Variables Before Gateways
```xml
<bpmn:task id="SetVariables" name="Set Process Variables">
  <bpmn:extensionElements>
    <apex:beforeTask>
      <apex:processVariable>
        <apex:varSequence>0</apex:varSequence>
        <apex:varName>user_type</apex:varName>
        <apex:varDataType>VARCHAR2</apex:varDataType>
        <apex:varExpressionType>static</apex:varExpressionType>
        <apex:varExpression>ADMIN</apex:varExpression>
      </apex:processVariable>
      <apex:processVariable>
        <apex:varSequence>1</apex:varSequence>
        <apex:varName>priority_level</apex:varName>
        <apex:varDataType>NUMBER</apex:varDataType>
        <apex:varExpressionType>static</apex:varExpressionType>
        <apex:varExpression>5</apex:varExpression>
      </apex:processVariable>
    </apex:beforeTask>
  </bpmn:extensionElements>
</bpmn:task>
```

### Testing Inclusive Gateway Multiple Paths
```sql
-- Test that inclusive gateway allows multiple concurrent paths
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'SetVariables');
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'InclusiveGateway');

-- Verify multiple tasks are running simultaneously
open l_actual for
  select sbfl_objt_id
  from flow_subflows
  where sbfl_prcs_id = l_prcs_id
    and sbfl_objt_id in ('AdminTask', 'PriorityTask', 'NorthTask')
    and sbfl_status = 'running'
  order by sbfl_objt_id;

-- All qualifying conditions should execute  
open l_expected for
  select 'AdminTask' as sbfl_objt_id from dual
  union all select 'NorthTask' from dual  
  union all select 'PriorityTask' from dual
  order by sbfl_objt_id;

ut.expect( l_actual ).to_equal( l_expected );
```

### Testing Exclusive Gateway Single Path
```sql
-- Test that exclusive gateway allows only one path
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'SetRouting');
test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'ExclusiveGateway');

-- Verify only ApproveTask is running
open l_actual for
  select sbfl_objt_id, sbfl_status
  from flow_subflows
  where sbfl_prcs_id = l_prcs_id
    and sbfl_objt_id = 'ApproveTask'
    and sbfl_status = 'running';

ut.expect( l_actual ).to_have_count( 1 );

-- Verify other tasks are NOT running
open l_actual for
  select count(*) as inactive_count
  from flow_subflows
  where sbfl_prcs_id = l_prcs_id
    and sbfl_objt_id in ('RejectTask', 'DefaultTask')
    and sbfl_status = 'running';

open l_expected for
  select 0 as inactive_count from dual;

ut.expect( l_actual ).to_equal( l_expected );
```

### Testing Gateway Default Flow
```sql
-- Test exclusive gateway default flow when no conditions match
flow_process_vars.set_var(
  pi_prcs_id => l_prcs_id,
  pi_var_name => 'routing_decision', 
  pi_vc2_value => 'UNKNOWN'  -- Value that matches no conditions
);

test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'ExclusiveGateway');

-- Verify default task is running
open l_actual for
  select sbfl_objt_id
  from flow_subflows
  where sbfl_prcs_id = l_prcs_id
    and sbfl_objt_id = 'DefaultTask'
    and sbfl_status = 'running';

ut.expect( l_actual ).to_have_count( 1 );
```

### Variable-Based Gateway Routing Testing
```sql
-- Test different routing scenarios by modifying variables
procedure test_routing_scenarios(
  p_user_type in varchar2,
  p_priority in number,
  p_expected_tasks in varchar2  -- Comma-separated list
) is
begin
  -- Set up new process
  l_prcs_id := flow_api_pkg.flow_create(pi_dgrm_id => g_dgrm_id);
  
  -- Override variables before gateway
  flow_process_vars.set_var(pi_prcs_id => l_prcs_id, pi_var_name => 'user_type', pi_vc2_value => p_user_type);
  flow_process_vars.set_var(pi_prcs_id => l_prcs_id, pi_var_name => 'priority_level', pi_num_value => p_priority);
  
  -- Execute through gateway
  test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'InclusiveGateway');
  
  -- Validate expected tasks are running
end test_routing_scenarios;

-- Test multiple scenarios
test_routing_scenarios('USER', 2, 'NorthTask');          -- Only region matches
test_routing_scenarios('ADMIN', 5, 'AdminTask,PriorityTask,NorthTask');  -- All match
```

### Gateway Testing Best Practices

1. **Separate Process Instances**: Create new process for each gateway test scenario
2. **Variable Setup**: Set routing variables before reaching gateway
3. **Multiple Path Validation**: For inclusive gateways, verify all expected paths execute
4. **Single Path Validation**: For exclusive gateways, verify only one path executes
5. **Default Flow Testing**: Test fallback routing when no conditions match
6. **Variable Persistence**: Ensure variables survive gateway transitions
7. **Condition Validation**: Test both true and false conditions thoroughly

---

## AI Test Generation Insights from Gateway Testing

### Successful AI Patterns:
- AI can generate complex gateway routing logic with proper examples
- AI understands inclusive vs exclusive gateway behavior differences  
- AI can create comprehensive test coverage for different routing scenarios
- AI properly implements variable-based conditional expressions

### Critical Requirements for AI Success:
1. **Process Variable References**: Use `:F4A$variable_name` syntax in conditions
2. **Gateway Types**: Understand difference between inclusive/exclusive behavior
3. **Default Flows**: Proper use of `default="flow_id"` attribute for fallback
4. **Condition Languages**: Use `language="plsqlExpression"` for simple expressions
5. **Sequence Ordering**: Use `apex:sequence` for evaluation order control

### Test Suite Evolution:
- **90A**: Basic sequential model → Foundation workflow execution
- **90B**: Variable expressions → Dynamic data handling  
- **90C**: Gateway routing → Complex flow control with decision logic

### Future Gateway Enhancement Ideas:
- **90D**: Complex conditional expressions with multiple variables
- **90E**: Event-based gateway routing with message/timer events
- **90F**: Nested gateway structures (gateways within gateways)
- **90G**: Dynamic gateway routing based on runtime calculations

*This guide continues to evolve as AI test generation capabilities advance and new BPMN patterns are explored.*