# Flows for APEX BPMN Extensions Guide

Version: 26.1  
Namespace: `http://flowsforapex.org`  
Prefix: `apex`

## Table of Contents

1. [Introduction](#introduction)
2. [Process-Level Extensions](#process-level-extensions)
3. [Variable Expressions](#variable-expressions)
4. [Task Extensions](#task-extensions)
5. [Event Extensions](#event-extensions)
6. [Gateway Extensions](#gateway-extensions)
7. [Lane Extensions](#lane-extensions)
8. [Loop and Iterator Extensions](#loop-and-iterator-extensions)
9. [Expression Types Reference](#expression-types-reference)
10. [Process Variable Substitution](#process-variable-substitution)

---

## Introduction

Flows for APEX extends standard BPMN 2.0 with Oracle APEX-specific capabilities using the `apex:` namespace. This guide documents all available extensions with practical examples.

### Namespace Declaration

Always declare the apex namespace in your BPMN definitions:

```xml
<bpmn:definitions 
    xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"
    xmlns:apex="https://flowsforapex.org"
    ...>
```

---

## Process-Level Extensions

### Process Attributes

Configure process-wide settings using apex attributes on the `bpmn:process` element.

```xml
<bpmn:process 
    id="Process_OrderFulfillment" 
    name="Order Fulfillment Process"
    apex:isCallable="true"
    apex:isStartable="true"
    apex:minLoggingLevel="info"
    apex:instanceName="Order &F4A$ORDER_NUMBER."
    apex:applicationId="100"
    apex:businessAdmin="ADMIN_ROLE">
```

**Attributes:**
- `apex:isCallable` - Can be called via Call Activity (true/false)
- `apex:isStartable` - Can be started directly (true/false)
- `apex:minLoggingLevel` - Minimum logging level (off/error/warn/info/debug)
- `apex:instanceName` - Instance name template (supports variable substitution)
- `apex:applicationId` - Default APEX app ID for tasks
- `apex:pageId` - Default APEX page ID for tasks
- `apex:username` - Process username
- `apex:businessAdmin` - Business administrator

### Process-Level Priority and Due Dates

```xml
<bpmn:process id="Process_Main" name="Main Process">
    <bpmn:extensionElements>
        <apex:priority>
            <apex:expressionType>static</apex:expressionType>
            <apex:expression>5</apex:expression>
        </apex:priority>
        <apex:dueOn>
            <apex:expressionType>interval</apex:expressionType>
            <apex:expression>P7D</apex:expression>
        </apex:dueOn>
    </bpmn:extensionElements>
</bpmn:process>
```

### Input/Output Variables for Callable Processes

```xml
<bpmn:process id="Process_Callable" apex:isCallable="true">
    <bpmn:extensionElements>
        <apex:inVariables>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>CustomerID</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>static</apex:varExpressionType>
                <apex:varExpression></apex:varExpression>
                <apex:varDescription>Customer identifier</apex:varDescription>
            </apex:processVariable>
        </apex:inVariables>
        <apex:outVariables>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>OrderStatus</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>static</apex:varExpressionType>
                <apex:varExpression></apex:varExpression>
                <apex:varDescription>Final order status</apex:varDescription>
            </apex:processVariable>
        </apex:outVariables>
    </bpmn:extensionElements>
</bpmn:process>
```

---

## Variable Expressions

### Expression Sets

Variable expressions can be defined at different points in the process lifecycle:

- **beforeTask** - Before task execution
- **afterTask** - After task completion (can access task output)
- **onEvent** - When event is caught
- **beforeEvent** - Before event is thrown
- **beforeSplit** - Before gateway split
- **afterMerge** - After gateway merge

### Basic Variable Expression (Static)

```xml
<bpmn:task id="Activity_Setup" name="Setup">
    <bpmn:extensionElements>
        <apex:beforeTask>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>OrderStatus</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>static</apex:varExpressionType>
                <apex:varExpression>NEW</apex:varExpression>
            </apex:processVariable>
        </apex:beforeTask>
    </bpmn:extensionElements>
</bpmn:task>
```

### Process Variable Copy

```xml
<apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>TotalAmount</apex:varName>
    <apex:varDataType>NUMBER</apex:varDataType>
    <apex:varExpressionType>processVariable</apex:varExpressionType>
    <apex:varExpression>SubtotalAmount</apex:varExpression>
</apex:processVariable>
```

### SQL Query Expression

```xml
<apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>CustomerName</apex:varName>
    <apex:varDataType>VARCHAR2</apex:varDataType>
    <apex:varExpressionType>sqlQuerySingle</apex:varExpressionType>
    <apex:varExpression>
        select customer_name 
        from customers 
        where customer_id = :F4A$CUSTOMER_ID
    </apex:varExpression>
</apex:processVariable>
```

### PL/SQL Expression

```xml
<apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>DiscountRate</apex:varName>
    <apex:varDataType>NUMBER</apex:varDataType>
    <apex:varExpressionType>plsqlExpression</apex:varExpressionType>
    <apex:varExpression>
        calculate_discount(:F4A$CUSTOMER_ID, :F4A$ORDER_TOTAL)
    </apex:varExpression>
</apex:processVariable>
```

### JSONPath Expression (v26.1+)

Extract values from JSON sources (task output, task input, or JSON process variables).

**From Task Output Parameters:**

```xml
<bpmn:task id="Activity_ProcessResult" name="Process Result">
    <bpmn:extensionElements>
        <apex:afterTask>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>FoundLocation</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>jsonPath</apex:varExpressionType>
                <apex:varExpression>$.found_location</apex:varExpression>
                <apex:varSourceType>taskOutput</apex:varSourceType>
            </apex:processVariable>
            <apex:processVariable>
                <apex:varSequence>1</apex:varSequence>
                <apex:varName>CompleteOutput</apex:varName>
                <apex:varDataType>JSON</apex:varDataType>
                <apex:varExpressionType>jsonPath</apex:varExpressionType>
                <apex:varExpression>$</apex:varExpression>
                <apex:varSourceType>taskOutput</apex:varSourceType>
            </apex:processVariable>
        </apex:afterTask>
    </bpmn:extensionElements>
</bpmn:task>
```

**From JSON Process Variable:**

```xml
<apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>CustomerEmail</apex:varName>
    <apex:varDataType>VARCHAR2</apex:varDataType>
    <apex:varExpressionType>jsonPath</apex:varExpressionType>
    <apex:varExpression>$.customer.contact.email</apex:varExpression>
    <apex:varSourceType>processVariable</apex:varSourceType>
    <apex:varSource>CustomerData</apex:varSource>
</apex:processVariable>
```

### Date and Timestamp Variables

```xml
<!-- DATE variable -->
<apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>OrderDate</apex:varName>
    <apex:varDataType>DATE</apex:varDataType>
    <apex:varExpressionType>static</apex:varExpressionType>
    <apex:varExpression>2026-02-12 14:30:00</apex:varExpression>
</apex:processVariable>

<!-- TIMESTAMP WITH TIME ZONE variable -->
<apex:processVariable>
    <apex:varSequence>1</apex:varSequence>
    <apex:varName>DeliveryDeadline</apex:varName>
    <apex:varDataType>TIMESTAMP_WITH_TIME_ZONE</apex:varDataType>
    <apex:varExpressionType>static</apex:varExpressionType>
    <apex:varExpression>2026-02-15 17:00:00 PST</apex:varExpression>
</apex:processVariable>
```

---

## Task Extensions

### User Task with APEX Page

```xml
<bpmn:userTask id="Activity_Review" name="Review Order" apex:type="apexPage">
    <bpmn:extensionElements>
        <apex:apexPage>
            <apex:applicationId>&F4A$APP_ID.</apex:applicationId>
            <apex:pageId>10</apex:pageId>
        </apex:apexPage>
        <apex:priority>
            <apex:expressionType>processVariable</apex:expressionType>
            <apex:expression>OrderPriority</apex:expression>
        </apex:priority>
        <apex:dueOn>
            <apex:expressionType>interval</apex:expressionType>
            <apex:expression>PT2H</apex:expression>
        </apex:dueOn>
        <apex:beforeTask>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>TaskContext</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>static</apex:varExpressionType>
                <apex:varExpression>REVIEW_PENDING</apex:varExpression>
            </apex:processVariable>
        </apex:beforeTask>
    </bpmn:extensionElements>
</bpmn:userTask>
```

### User Task with APEX Approval Component

```xml
<bpmn:userTask id="Activity_Approve" name="Approve Purchase" 
               apex:type="apexApproval" apex:manualInput="true">
    <bpmn:extensionElements>
        <apex:apexApproval>
            <apex:applicationId>100</apex:applicationId>
            <apex:taskStaticId>PURCHASE_APPROVAL_TASK</apex:taskStaticId>
            <apex:businessRef>&F4A$ORDER_NUMBER.</apex:businessRef>
            <apex:parameters>
                <apex:parameter>
                    <apex:parStaticId>ORDER_ID</apex:parStaticId>
                    <apex:parDataType>String</apex:parDataType>
                    <apex:parValue>&F4A$ORDER_ID.</apex:parValue>
                </apex:parameter>
                <apex:parameter>
                    <apex:parStaticId>AMOUNT</apex:parStaticId>
                    <apex:parDataType>Number</apex:parDataType>
                    <apex:parValue>&F4A$ORDER_TOTAL.</apex:parValue>
                </apex:parameter>
            </apex:parameters>
            <apex:resultVariable>ApprovalResult</apex:resultVariable>
        </apex:apexApproval>
        <apex:priority>
            <apex:expressionType>static</apex:expressionType>
            <apex:expression>5</apex:expression>
        </apex:priority>
    </bpmn:extensionElements>
</bpmn:userTask>
```

### Script Task (PL/SQL)

```xml
<bpmn:scriptTask id="Activity_Calculate" name="Calculate Total">
    <bpmn:extensionElements>
        <apex:executePlsql>
            <apex:expressionType>plsqlFunctionBody</apex:expressionType>
            <apex:expression>
                declare
                    l_total number;
                begin
                    l_total := :F4A$SUBTOTAL + :F4A$TAX - :F4A$DISCOUNT;
                    flow_process_vars.set_var(
                        pi_prcs_id => :F4A$PROCESS_ID,
                        pi_var_name => 'TOTAL',
                        pi_vc2_value => to_char(l_total)
                    );
                end;
            </apex:expression>
        </apex:executePlsql>
    </bpmn:extensionElements>
</bpmn:scriptTask>
```

### Call Activity

```xml
<bpmn:callActivity id="Activity_CallShipping" name="Process Shipping"
                   apex:calledDiagram="ShippingProcess"
                   apex:calledDiagramVersionSelection="latestVersion">
    <bpmn:extensionElements>
        <apex:inVariables>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>ShipmentID</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>processVariable</apex:varExpressionType>
                <apex:varExpression>ORDER_ID</apex:varExpression>
            </apex:processVariable>
        </apex:inVariables>
        <apex:outVariables>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>TrackingNumber</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>processVariable</apex:varExpressionType>
                <apex:varExpression>TRACKING_NUM</apex:varExpression>
            </apex:processVariable>
        </apex:outVariables>
    </bpmn:extensionElements>
</bpmn:callActivity>
```

---

## Event Extensions

### Start Event with onEvent Variables

```xml
<bpmn:startEvent id="Event_Start" name="Start">
    <bpmn:extensionElements>
        <apex:onEvent>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>InitialStatus</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>static</apex:varExpressionType>
                <apex:varExpression>INITIATED</apex:varExpression>
            </apex:processVariable>
        </apex:onEvent>
    </bpmn:extensionElements>
</bpmn:startEvent>
```

### Timer Intermediate Event

```xml
<bpmn:intermediateCatchEvent id="Event_Wait" name="Wait 2 Hours">
    <bpmn:timerEventDefinition>
        <bpmn:extensionElements>
            <apex:dueOn>
                <apex:expressionType>interval</apex:expressionType>
                <apex:expression>PT2H</apex:expression>
            </apex:dueOn>
        </bpmn:extensionElements>
    </bpmn:timerEventDefinition>
</bpmn:intermediateCatchEvent>
```

### Message Throw Event

```xml
<bpmn:intermediateThrowEvent id="Event_SendMessage" name="Send Notification"
                             apex:type="simpleMessage">
    <bpmn:messageEventDefinition>
        <bpmn:extensionElements>
            <apex:endpoint>
                <apex:expressionType>static</apex:expressionType>
                <apex:expression>local</apex:expression>
            </apex:endpoint>
            <apex:messageName>
                <apex:expressionType>static</apex:expressionType>
                <apex:expression>OrderShipped</apex:expression>
            </apex:messageName>
            <apex:correlationKey>
                <apex:expressionType>static</apex:expressionType>
                <apex:expression>ORDER_ID</apex:expression>
            </apex:correlationKey>
            <apex:correlationValue>
                <apex:expressionType>processVariable</apex:expressionType>
                <apex:expression>OrderID</apex:expression>
            </apex:correlationValue>
            <apex:payload>
                <apex:expressionType>processVariable</apex:expressionType>
                <apex:expression>ShippingDetails</apex:expression>
            </apex:payload>
        </bpmn:extensionElements>
    </bpmn:messageEventDefinition>
</bpmn:intermediateThrowEvent>
```

### Message Catch Event

```xml
<bpmn:intermediateCatchEvent id="Event_ReceiveMessage" name="Wait for Confirmation">
    <bpmn:messageEventDefinition>
        <bpmn:extensionElements>
            <apex:messageName>
                <apex:expressionType>static</apex:expressionType>
                <apex:expression>OrderConfirmed</apex:expression>
            </apex:messageName>
            <apex:correlationKey>
                <apex:expressionType>static</apex:expressionType>
                <apex:expression>ORDER_ID</apex:expression>
            </apex:correlationKey>
            <apex:correlationValue>
                <apex:expressionType>processVariable</apex:expressionType>
                <apex:expression>OrderID</apex:expression>
            </apex:correlationValue>
            <apex:payloadVariable>ConfirmationData</apex:payloadVariable>
        </bpmn:extensionElements>
    </bpmn:messageEventDefinition>
</bpmn:intermediateCatchEvent>
```

### Terminate End Event with Status

```xml
<bpmn:endEvent id="Event_Cancel" name="Cancel Order">
    <bpmn:terminateEventDefinition>
        <bpmn:extensionElements>
            <apex:terminateStatus>
                <apex:expressionType>static</apex:expressionType>
                <apex:expression>CANCELLED</apex:expression>
            </apex:terminateStatus>
        </bpmn:extensionElements>
    </bpmn:terminateEventDefinition>
</bpmn:endEvent>
```

---

## Gateway Extensions

### Exclusive Gateway with beforeSplit

```xml
<bpmn:exclusiveGateway id="Gateway_Decision" name="Check Amount">
    <bpmn:extensionElements>
        <apex:beforeSplit>
            <apex:processVariable>
                <apex:varSequence>0</apex:varSequence>
                <apex:varName>ApprovalRequired</apex:varName>
                <apex:varDataType>VARCHAR2</apex:varDataType>
                <apex:varExpressionType>plsqlExpression</apex:varExpressionType>
                <apex:varExpression>
                    case when :F4A$ORDER_TOTAL > 10000 
                         then 'YES' 
                         else 'NO' 
                    end
                </apex:varExpression>
            </apex:processVariable>
        </apex:beforeSplit>
    </bpmn:extensionElements>
</bpmn:exclusiveGateway>
```

### Sequence Flow with apex:sequence

```xml
<bpmn:sequenceFlow id="Flow_HighPriority" name="High Priority"
                   sourceRef="Gateway_Split" targetRef="Activity_Fast"
                   apex:sequence="10">
    <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" 
                              language="plsqlExpression">
        :F4A$PRIORITY > 3
    </bpmn:conditionExpression>
</bpmn:sequenceFlow>

<bpmn:sequenceFlow id="Flow_NormalPriority" name="Normal Priority"
                   sourceRef="Gateway_Split" targetRef="Activity_Normal"
                   apex:sequence="20">
    <bpmn:conditionExpression xsi:type="bpmn:tFormalExpression"
                              language="plsqlExpression">
        :F4A$PRIORITY <= 3
    </bpmn:conditionExpression>
</bpmn:sequenceFlow>
```

---

## Lane Extensions

### Lanes with Role Assignment

```xml
<bpmn:laneSet>
    <bpmn:lane id="Lane_Sales" name="Sales Team" 
               apex:isRole="true" apex:role="SALES_ROLE">
        <bpmn:flowNodeRef>Activity_CreateOrder</bpmn:flowNodeRef>
        <bpmn:flowNodeRef>Activity_ReviewOrder</bpmn:flowNodeRef>
    </bpmn:lane>
    <bpmn:lane id="Lane_Manager" name="Manager" 
               apex:isRole="true" apex:role="MANAGER_ROLE">
        <bpmn:flowNodeRef>Activity_ApproveOrder</bpmn:flowNodeRef>
    </bpmn:lane>
    <bpmn:lane id="Lane_System" name="System" 
               apex:isRole="false">
        <bpmn:flowNodeRef>Activity_SendNotification</bpmn:flowNodeRef>
    </bpmn:lane>
</bpmn:laneSet>
```

---

## Loop and Iterator Extensions

### Multi-Instance Parallel Loop

```xml
<bpmn:userTask id="Activity_ReviewItems" name="Review Each Item">
    <bpmn:multiInstanceLoopCharacteristics isSequential="false">
        <bpmn:extensionElements>
            <apex:inputCollection>
                <apex:expressionType>processVariable</apex:expressionType>
                <apex:expression>OrderItems</apex:expression>
            </apex:inputCollection>
            <apex:outputCollection>
                <apex:expressionType>processVariable</apex:expressionType>
                <apex:expression>ReviewResults</apex:expression>
            </apex:outputCollection>
            <apex:completionCondition>
                <apex:expressionType>plsqlExpression</apex:expressionType>
                <apex:expression>
                    :F4A$COMPLETED_INSTANCES >= 3
                </apex:expression>
            </apex:completionCondition>
        </bpmn:extensionElements>
    </bpmn:multiInstanceLoopCharacteristics>
</bpmn:userTask>
```

### Standard Loop

```xml
<bpmn:task id="Activity_Retry" name="Retry Operation">
    <bpmn:standardLoopCharacteristics>
        <bpmn:extensionElements>
            <apex:loopCondition>
                <apex:expressionType>plsqlExpression</apex:expressionType>
                <apex:expression>
                    :F4A$STATUS != 'SUCCESS'
                </apex:expression>
            </apex:loopCondition>
            <apex:loopMaximum>
                <apex:expressionType>static</apex:expressionType>
                <apex:expression>5</apex:expression>
            </apex:loopMaximum>
        </bpmn:extensionElements>
    </bpmn:standardLoopCharacteristics>
</bpmn:task>
```

---

## Expression Types Reference

| Expression Type | Description | Example |
|----------------|-------------|---------|
| `static` | Literal value (supports variable substitution) | `NEW_ORDER` |
| `processVariable` | Reference to existing process variable | `CustomerID` |
| `sqlQuerySingle` | SQL query returning single value | `select name from customers where id = :F4A$ID` |
| `sqlQueryMulti` | SQL query returning collection | `select item_id from order_items` |
| `plsqlExpression` | PL/SQL expression with bind vars | `calculate_discount(:F4A$AMOUNT)` |
| `plsqlFunctionBody` | PL/SQL function body with bind vars | `begin return true; end;` |
| `plsqlRawExpression` | PL/SQL without F4A$ bind support | `my_pkg.get_value` |
| `plsqlRawFunctionBody` | PL/SQL function body without bind support | `begin return my_function(); end;` |
| `jsonPath` | JSONPath expression (v26.1+) | `$.customer.email` |
| `interval` | ISO 8601 duration | `PT2H` (2 hours), `P7D` (7 days) |

---

## Process Variable Substitution

Static expressions support process variable substitution using the `&F4A$VARIABLE_NAME.` syntax:

```xml
<apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>WelcomeMessage</apex:varName>
    <apex:varDataType>VARCHAR2</apex:varDataType>
    <apex:varExpressionType>static</apex:varExpressionType>
    <apex:varExpression>Welcome &F4A$CUSTOMER_NAME., your order &F4A$ORDER_NUMBER. is confirmed.</apex:varExpression>
</apex:processVariable>
```

### Special Substitution Variables

- `&F4A$PROCESS_ID.` - Current process instance ID
- `&F4A$PROCESS_NAME.` - Process diagram name
- `&F4A$STEP_KEY.` - Current step key
- `&F4A$SUBFLOW_ID.` - Current subflow ID
- `&F4A$USERNAME.` - Current user
- `&F4A$WORKSPACE.` - Current APEX workspace
- Custom variables: `&F4A$YOUR_VAR_NAME.`

---

## Best Practices

1. **Variable Naming**: Use descriptive, UPPER_CASE names for process variables
2. **Expression Order**: Use `varSequence` to control evaluation order when variables depend on each other
3. **Type Safety**: Always specify correct `varDataType` for proper type conversion
4. **Date Formats**: Use standard formats (DATE: `YYYY-MM-DD HH24:MI:SS`, TSTZ: `YYYY-MM-DD HH24:MI:SS TZR`)
5. **JSONPath Sources**: Specify `varSourceType` when using jsonPath expressions
6. **Error Handling**: Use try-catch in PL/SQL expressions for robust error handling
7. **Performance**: Prefer static expressions over SQL queries when possible
8. **Security**: Never expose sensitive data in process variable names or static values

---

## Additional Resources

- [flow_api_doc.md](../flow_api_doc.md) - Process API documentation
- [process_var_doc.md](../process_var_doc.md) - Process variables guide
- [flow-for-apex-extensions.xsd](./flow-for-apex-extensions.xsd) - XSD schema specification

---

*For questions or contributions, visit: https://github.com/flowsforapex/apex-flowsforapex*
