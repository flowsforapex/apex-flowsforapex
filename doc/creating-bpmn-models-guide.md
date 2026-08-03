# Creating BPMN Models for Flows for APEX: Complete Developer Guide

*Last Updated: March 13, 2026*

## Overview

This guide demonstrates how to create sophisticated BPMN workflow models for Flows for APEX, covering process variables, gateway routing, and advanced modeling patterns. Learn to build enterprise-grade workflows with conditional logic and dynamic data processing.

## Table of Contents

1. [BPMN Model Structure](#bpmn-model-structure)
2. [Process Variables](#process-variables)
3. [Gateway Patterns](#gateway-patterns)
4. [Complete Model Examples](#complete-model-examples)
5. [Best Practices](#best-practices)
6. [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)

## BPMN Model Structure

### Basic Template

Every Flows for APEX BPMN model follows this structure:

```sql
declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ]'
      ,q'[  xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" ]'
      ,q'[  xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" ]'
      ,q'[  xmlns:di="http://www.omg.org/spec/DD/20100524/DI" ]'
      ,q'[  xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" ]'
      ,q'[  xmlns:apex="https://flowsforapex.org" ]'
      ,q'[  id="Definitions_xxx" targetNamespace="http://bpmn.io/schema/bpmn" ]'
      ,q'[  exporter="Flows for APEX" exporterVersion="26.1.0">]'
      -- Process definition here
      -- Diagram visualization here
      ,q'[</bpmn:definitions>]'
  ));
  
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Your Model Name',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Category',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
  );
end;
```

### Critical XML Namespace

The Flows for APEX namespace is **essential** for process variables and gateway conditions:
```xml
xmlns:apex="https://flowsforapex.org"
```

Without this namespace, you'll encounter parsing errors when using process variables or gateway conditions.

## Process Variables

Process variables enable dynamic data processing within your workflows. They can be defined in `<apex:beforeTask>` or equivalent sections and referenced throughout your process.

### Static Variables

Use static variables for fixed values that don't change during execution:

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
  <bpmn:incoming>Flow_start_to_variables</bpmn:incoming>
  <bpmn:outgoing>Flow_variables_to_gateway</bpmn:outgoing>
</bpmn:task>
```

### Dynamic PL/SQL Expression Variables

Use PL/SQL expressions for calculated or system-derived values:

```xml
<apex:processVariable>
  <apex:varSequence>2</apex:varSequence>
  <apex:varName>current_timestamp</apex:varName>
  <apex:varDataType>VARCHAR2</apex:varDataType>
  <apex:varExpressionType>plsqlExpression</apex:varExpressionType>
  <apex:varExpression>to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS')</apex:varExpression>
</apex:processVariable>
```

### Variable References

Reference process variables in gateway conditions using the `:F4A$` prefix:

```xml
<bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">
  :F4A$user_type = 'ADMIN'
</bpmn:conditionExpression>
```

## Gateway Patterns

Gateways control the flow of your process based on data and conditions, enabling sophisticated routing logic.

### Inclusive Gateways (OR-Split)

Inclusive gateways allow **multiple paths** to be taken simultaneously when their conditions are met. This is useful for parallel processing based on multiple criteria.

```xml
<bpmn:inclusiveGateway id="InclusiveGateway" name="Check Multiple Conditions">
  <bpmn:incoming>Flow_variables_to_gateway</bpmn:incoming>
  <bpmn:outgoing>Flow_to_admin_task</bpmn:outgoing>
  <bpmn:outgoing>Flow_to_priority_task</bpmn:outgoing>
  <bpmn:outgoing>Flow_to_region_task</bpmn:outgoing>
</bpmn:inclusiveGateway>

<!-- Admin user path -->
<bpmn:sequenceFlow id="Flow_to_admin_task" name="Admin User" 
                   sourceRef="InclusiveGateway" targetRef="AdminTask" apex:sequence="10">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">
    :F4A$user_type = 'ADMIN'
  </bpmn:conditionExpression>
</bpmn:sequenceFlow>

<!-- High priority path -->
<bpmn:sequenceFlow id="Flow_to_priority_task" name="High Priority" 
                   sourceRef="InclusiveGateway" targetRef="PriorityTask" apex:sequence="20">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">
    :F4A$priority_level >= 3
  </bpmn:conditionExpression>
</bpmn:sequenceFlow>

<!-- Regional path -->
<bpmn:sequenceFlow id="Flow_to_region_task" name="North Region" 
                   sourceRef="InclusiveGateway" targetRef="RegionTask" apex:sequence="30">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">
    :F4A$region like '%NORTH%'
  </bpmn:conditionExpression>
</bpmn:sequenceFlow>
```

#### Inclusive Gateway Key Points:
- Multiple conditions can be true simultaneously
- Each true condition creates a parallel execution path
- Use `apex:sequence` to control evaluation order (lower numbers evaluated first)
- Synchronize with another inclusive gateway to merge parallel flows

### Exclusive Gateways (XOR-Split)

Exclusive gateways allow **only one path** to be taken, choosing the first matching condition or a default path.

```xml
<bpmn:exclusiveGateway id="ExclusiveGateway" name="Routing Decision" 
                       default="Flow_to_default">
  <bpmn:incoming>Flow_routing_to_exclusive_gw</bpmn:incoming>
  <bpmn:outgoing>Flow_to_approve</bpmn:outgoing>
  <bpmn:outgoing>Flow_to_reject</bpmn:outgoing>
  <bpmn:outgoing>Flow_to_default</bpmn:outgoing>
</bpmn:exclusiveGateway>

<!-- Approval path -->
<bpmn:sequenceFlow id="Flow_to_approve" name="Approve" 
                   sourceRef="ExclusiveGateway" targetRef="ApproveTask" apex:sequence="10">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">
    :F4A$routing_decision = 'APPROVE'
  </bpmn:conditionExpression>
</bpmn:sequenceFlow>

<!-- Rejection path -->
<bpmn:sequenceFlow id="Flow_to_reject" name="Reject" 
                   sourceRef="ExclusiveGateway" targetRef="RejectTask" apex:sequence="20">
  <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">
    :F4A$routing_decision = 'REJECT'
  </bpmn:conditionExpression>
</bpmn:sequenceFlow>

<!-- Default path (no condition required) -->
<bpmn:sequenceFlow id="Flow_to_default" name="Default" 
                   sourceRef="ExclusiveGateway" targetRef="DefaultTask" apex:sequence="30" />
```

#### Exclusive Gateway Key Points:
- Only the first matching condition is taken
- Always include a `default` flow for unmatched conditions
- Evaluation follows `apex:sequence` order
- Use `isMarkerVisible="true"` in diagram section for visual X marker

### Gateway Joins

Use gateways to merge parallel flows back together:

```xml
<bpmn:inclusiveGateway id="JoinGateway" name="Join Parallel Flows">
  <bpmn:incoming>Flow_admin_to_join</bpmn:incoming>
  <bpmn:incoming>Flow_priority_to_join</bpmn:incoming>
  <bpmn:incoming>Flow_region_to_join</bpmn:incoming>
  <bpmn:outgoing>Flow_join_to_next</bpmn:outgoing>
</bpmn:inclusiveGateway>
```

## Complete Model Examples

### Example 1: Simple Sequential Workflow

```sql
declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:apex="https://flowsforapex.org" ]'
      ,q'[  xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" ]'
      ,q'[  id="Definitions_Simple" targetNamespace="http://bpmn.io/schema/bpmn">]'
      ,q'[  <bpmn:process id="Process_Simple" isExecutable="true">]'
      ,q'[    <bpmn:startEvent id="Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_to_taskA</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      ,q'[    <bpmn:task id="TaskA" name="Task A">]'
      ,q'[      <bpmn:incoming>Flow_to_taskA</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_to_taskB</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:task id="TaskB" name="Task B">]'
      ,q'[      <bpmn:incoming>Flow_to_taskB</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_to_end</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      ,q'[    <bpmn:endEvent id="End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_to_end</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      ,q'[    <bpmn:sequenceFlow id="Flow_to_taskA" sourceRef="Start" targetRef="TaskA" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_to_taskB" sourceRef="TaskA" targetRef="TaskB" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_to_end" sourceRef="TaskB" targetRef="End" />]'
      ,q'[  </bpmn:process>]'
      ,q'[</bpmn:definitions>]'
  ));
  
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Simple Sequential Model',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Examples',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
  );
end;
```

### Example 2: Approval Workflow with Routing

This example demonstrates a complete approval workflow with process variables and gateway routing:

```sql
declare
  l_dgrm_content clob;
begin
  l_dgrm_content := apex_string.join_clob(
    apex_t_varchar2(
      q'[<?xml version="1.0" encoding="UTF-8"?>]'
      ,q'[<bpmn:definitions xmlns:apex="https://flowsforapex.org" ]'
      ,q'[  xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" ]'
      ,q'[  id="Definitions_Approval" targetNamespace="http://bpmn.io/schema/bpmn">]'
      ,q'[  <bpmn:process id="Process_Approval" isExecutable="true">]'
      ,q'[    <bpmn:startEvent id="Start" name="Start">]'
      ,q'[      <bpmn:outgoing>Flow_start_to_setup</bpmn:outgoing>]'
      ,q'[    </bpmn:startEvent>]'
      
      -- Setup task with process variables
      ,q'[    <bpmn:task id="SetupRequest" name="Setup Request">]'
      ,q'[      <bpmn:extensionElements>]'
      ,q'[        <apex:beforeTask>]'
      ,q'[          <apex:processVariable>]'
      ,q'[            <apex:varSequence>0</apex:varSequence>]'
      ,q'[            <apex:varName>request_type</apex:varName>]'
      ,q'[            <apex:varDataType>VARCHAR2</apex:varDataType>]'
      ,q'[            <apex:varExpressionType>static</apex:varExpressionType>]'
      ,q'[            <apex:varExpression>PURCHASE</apex:varExpression>]'
      ,q'[          </apex:processVariable>]'
      ,q'[          <apex:processVariable>]'
      ,q'[            <apex:varSequence>1</apex:varSequence>]'
      ,q'[            <apex:varName>amount</apex:varName>]'
      ,q'[            <apex:varDataType>NUMBER</apex:varDataType>]'
      ,q'[            <apex:varExpressionType>static</apex:varExpressionType>]'
      ,q'[            <apex:varExpression>15000</apex:varExpression>]'
      ,q'[          </apex:processVariable>]'
      ,q'[        </apex:beforeTask>]'
      ,q'[      </bpmn:extensionElements>]'
      ,q'[      <bpmn:incoming>Flow_start_to_setup</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_setup_to_gateway</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      
      -- Exclusive gateway for routing
      ,q'[    <bpmn:exclusiveGateway id="ApprovalGateway" name="Approval Required?" default="Flow_to_auto_approve">]'
      ,q'[      <bpmn:incoming>Flow_setup_to_gateway</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_to_manual_approval</bpmn:outgoing>]'
      ,q'[      <bpmn:outgoing>Flow_to_auto_approve</bpmn:outgoing>]'
      ,q'[    </bpmn:exclusiveGateway>]'
      
      -- Manual approval path
      ,q'[    <bpmn:task id="ManualApproval" name="Manual Approval Required">]'
      ,q'[      <bpmn:incoming>Flow_to_manual_approval</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_manual_to_end</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      
      -- Auto approval path
      ,q'[    <bpmn:task id="AutoApprove" name="Auto Approved">]'
      ,q'[      <bpmn:incoming>Flow_to_auto_approve</bpmn:incoming>]'
      ,q'[      <bpmn:outgoing>Flow_auto_to_end</bpmn:outgoing>]'
      ,q'[    </bpmn:task>]'
      
      ,q'[    <bpmn:endEvent id="End" name="End">]'
      ,q'[      <bpmn:incoming>Flow_manual_to_end</bpmn:incoming>]'
      ,q'[      <bpmn:incoming>Flow_auto_to_end</bpmn:incoming>]'
      ,q'[    </bpmn:endEvent>]'
      
      -- Sequence flows
      ,q'[    <bpmn:sequenceFlow id="Flow_start_to_setup" sourceRef="Start" targetRef="SetupRequest" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_setup_to_gateway" sourceRef="SetupRequest" targetRef="ApprovalGateway" />]'
      
      ,q'[    <bpmn:sequenceFlow id="Flow_to_manual_approval" name="High Value" ]'
      ,q'[                       sourceRef="ApprovalGateway" targetRef="ManualApproval" apex:sequence="10">]'
      ,q'[      <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">]'
      ,q'[        :F4A$amount > 10000]'
      ,q'[      </bpmn:conditionExpression>]'
      ,q'[    </bpmn:sequenceFlow>]'
      
      ,q'[    <bpmn:sequenceFlow id="Flow_to_auto_approve" name="Low Value" ]'
      ,q'[                       sourceRef="ApprovalGateway" targetRef="AutoApprove" apex:sequence="20" />]'
      
      ,q'[    <bpmn:sequenceFlow id="Flow_manual_to_end" sourceRef="ManualApproval" targetRef="End" />]'
      ,q'[    <bpmn:sequenceFlow id="Flow_auto_to_end" sourceRef="AutoApprove" targetRef="End" />]'
      ,q'[  </bpmn:process>]'
      ,q'[</bpmn:definitions>]'
  ));
  
  flow_diagram.upload_and_parse(
    pi_dgrm_name => 'Approval Workflow with Routing',
    pi_dgrm_version => '0',
    pi_dgrm_category => 'Examples',
    pi_dgrm_content => l_dgrm_content,
    pi_force_overwrite => true
  );
end;
```

## Best Practices

### BPMN Design Guidelines

1. **Use Descriptive Naming**: 
   - Tasks: `SetRequestDetails`, `PerformApproval`, `SendNotification`
   - Gateways: `CheckApprovalRequired`, `RouteByPriority`
   - Flows: `Flow_high_priority`, `Flow_auto_approve`

2. **Consistent ID Patterns**:
   - Follow a naming convention: `TaskName`, `GatewayName`, `Flow_from_to`
   - Avoid special characters and spaces in IDs
   - Use descriptive but concise identifiers

3. **Sequence Numbering**:
   - Always include `apex:sequence` attributes for predictable evaluation
   - Use increments of 10: `10`, `20`, `30` for easy insertion
   - Lower numbers are evaluated first

4. **Gateway Design**:
   - Every exclusive gateway should have a default flow
   - Include descriptive names for conditional flows
   - Limit complexity - break complex routing into multiple gateways

### XML Structure Best Practices

1. **Namespace Management**:
   - Always declare `xmlns:apex="https://flowsforapex.org"`
   - Include all required BPMN namespaces
   - Declare namespaces only once at the definitions level

2. **Code Organization**:
   - Use `q'[]'` notation for clean string handling
   - Group related elements together (tasks, gateways, flows)
   - Add comments to mark major sections

3. **Variable Scope**:
   - Define variables in the earliest task where they're needed
   - Use meaningful variable names that describe their purpose
   - Choose appropriate data types (VARCHAR2, NUMBER, DATE)

### Performance Considerations

1. **Variable Management**:
   - Only create variables you actually need
   - Use static values when possible for better performance
   - Avoid complex PL/SQL expressions in high-volume processes

2. **Gateway Optimization**:
   - Limit the number of conditions per gateway
   - Order conditions by likelihood (most common first)
   - Consider breaking complex routing into multiple steps

3. **Model Complexity**:
   - Keep individual models focused on single business processes
   - Use sub-processes for complex workflows
   - Document complex business logic clearly

## Common Pitfalls and Solutions

### 1. Missing Flows for APEX Namespace
**Problem**: Variables and conditions don't work, causing parse errors
**Solution**: Always include `xmlns:apex="https://flowsforapex.org"` in your definitions

```xml
<!-- Correct -->
<bpmn:definitions xmlns:apex="https://flowsforapex.org" ...>
```

### 2. Incorrect Variable Reference Syntax
**Problem**: Gateway conditions fail to evaluate process variables
**Solution**: Use the correct `:F4A$variable_name` syntax

```xml
<!-- Correct -->
<bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" language="plsqlExpression">
  :F4A$user_type = 'ADMIN'
</bpmn:conditionExpression>
```

### 3. Missing Default Flow in Exclusive Gateway
**Problem**: Process gets stuck when no conditions match
**Solution**: Always specify a default flow

```xml
<!-- Correct -->
<bpmn:exclusiveGateway id="Gateway1" default="Flow_default">
  <bpmn:outgoing>Flow_condition1</bpmn:outgoing>
  <bpmn:outgoing>Flow_default</bpmn:outgoing>
</bpmn:exclusiveGateway>
```

### 4. Inconsistent Sequence Flow References
**Problem**: Diagram doesn't render correctly due to mismatched IDs
**Solution**: Ensure sourceRef and targetRef match actual element IDs

```xml
<!-- Correct -->
<bpmn:task id="TaskA" name="Task A">...</bpmn:task>
<bpmn:sequenceFlow id="Flow1" sourceRef="TaskA" targetRef="TaskB" />
```

### 5. Variable Data Type Mismatches
**Problem**: Runtime errors when using variables in conditions
**Solution**: Match data types between variable definitions and usage

```xml
<!-- For numeric comparisons -->
<apex:varDataType>NUMBER</apex:varDataType>
<apex:varExpression>5</apex:varExpression>
<!-- Condition: :F4A$priority_level >= 3 -->
```

## Running Your Models

Once created, you can run your BPMN models using the Flows for APEX API:

```sql
declare
  l_prcs_id flow_processes.prcs_id%type;
begin
  -- Create process instance
  l_prcs_id := flow_api_pkg.flow_create(
    pi_dgrm_name => 'Your Model Name',
    pi_prcs_name => 'Instance Name'
  );
  
  -- Start the process
  flow_api_pkg.flow_start( p_process_id => l_prcs_id );
  
  -- Complete tasks as needed
  flow_api_pkg.flow_complete_step(
    p_process_id => l_prcs_id,
    p_subflow_id => [subflow_id]
  );
end;
```

## Conclusion

This guide provides the foundation for creating sophisticated BPMN workflows in Flows for APEX. By following these patterns and best practices, you can build:

- ✅ Dynamic workflows with process variables
- ✅ Conditional routing with inclusive and exclusive gateways
- ✅ Complex business logic with PL/SQL expressions
- ✅ Maintainable and scalable process models

Start with simple sequential models and gradually add complexity as you become more comfortable with the patterns and syntax.

---

*For testing frameworks and validation approaches, see the companion testing guide in the test directory.*