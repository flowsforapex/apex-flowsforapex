# Comprehensive Catalog of APEX Namespace Extensions in Flows for APEX

**Generated:** 12 February 2026  
**Purpose:** Complete XSD specification for apex: namespace extensions in BPMN

---

## 1. PROCESS-LEVEL EXTENSIONS

### 1.1 Process Attributes (on `bpmn:process`)

| Attribute | Type | Required | Purpose | Example |
|-----------|------|----------|---------|---------|
| `@apex:isCallable` | boolean | No | Whether process can be called from other processes | `true`/`false` |
| `@apex:isStartable` | boolean | No | Whether process can be started directly | `true`/`false` |
| `@apex:manualInput` | boolean | No | Whether process requires manual input to start | `true`/`false` |
| `@apex:minLoggingLevel` | xs:integer | No | Minimum logging level (0-6) | `0` |
| `@apex:instanceName` | xs:string | No | Template for instance name generation | `Order {order_id}` |
| `@apex:applicationId` | xs:string | No | Default APEX application ID | `100` |
| `@apex:pageId` | xs:string | No | Default APEX page ID | `1` |
| `@apex:username` | xs:string | No | Default username for process execution | `admin` |
| `@apex:businessAdmin` | xs:string | No | Business administrator role/user | `PROCESS_ADMIN` |

### 1.2 Process Extension Elements (in `bpmn:extensionElements`)

#### 1.2.1 Priority Expression
```xml
<apex:priority>
  <apex:expressionType>static|processVariable|sqlQuerySingle|plsqlExpression|plsqlFunctionBody</apex:expressionType>
  <apex:expression>5</apex:expression>
</apex:priority>
```

#### 1.2.2 Due Date Expression
```xml
<apex:dueOn>
  <apex:expressionType>static|interval|oracleScheduler|processVariable|sqlQuerySingle|plsqlExpression|plsqlFunctionBody</apex:expressionType>
  <apex:expression>2024-06-21 09:15:05 GMT</apex:expression>
  <apex:formatMask>YYYY-MM-DD HH24:MI:SS TZR</apex:formatMask>  <!-- Optional -->
</apex:dueOn>
```

#### 1.2.3 Process Variable Declarations (In/Out Variables)
```xml
<apex:inVariables>
  <apex:processVariable>
    <apex:varName>inputVarName</apex:varName>
    <apex:varDataType>VARCHAR2|NUMBER|DATE|TIMESTAMP_WITH_TIME_ZONE|CLOB|JSON</apex:varDataType>
    <apex:varDescription>Optional description</apex:varDescription>
  </apex:processVariable>
</apex:inVariables>

<apex:outVariables>
  <apex:processVariable>
    <apex:varName>outputVarName</apex:varName>
    <apex:varDataType>VARCHAR2|NUMBER|DATE|TIMESTAMP_WITH_TIME_ZONE|CLOB|JSON</apex:varDataType>
    <apex:varDescription>Optional description</apex:varDescription>
  </apex:processVariable>
</apex:outVariables>
```

#### 1.2.4 Custom Extension
```xml
<apex:customExtension>{"object": "Process A23a"}</apex:customExtension>
```

---

## 2. TASK/ACTIVITY EXTENSIONS

### 2.1 Task Type Attribute (on all task types)

| Attribute | Type | Required | Purpose |
|-----------|------|----------|---------|
| `@apex:type` | xs:string | Conditional | Specifies task subtype/handler |

**Valid values:**
- User Tasks: `apexPage`, `apexApproval`, `apexSimpleForm`, `externalUrl`
- Script/Service/BusinessRule Tasks: `executePlsql`
- Service Tasks: `sendMail`, `apexAIGeneration`
- Message Tasks: `simpleMessage`

### 2.2 UserTask Extensions

#### 2.2.1 APEX Page Task (`apex:type="apexPage"`)
```xml
<apex:apexPage>
  <apex:applicationId>100</apex:applicationId>
  <apex:pageId>3</apex:pageId>
  <apex:request>Optional request value</apex:request>
  <apex:cache>Optional cache value</apex:cache>
  <apex:pageItems>
    <apex:pageItem>
      <apex:itemName>PROCESS_ID</apex:itemName>
      <apex:itemValue>&F4A$PROCESS_ID.</apex:itemValue>
    </apex:pageItem>
    <apex:pageItem>
      <apex:itemName>MY_VAR</apex:itemName>
      <apex:itemValue>&F4A$MY_VAR.</apex:itemValue>
    </apex:pageItem>
  </apex:pageItems>
</apex:apexPage>
```

#### 2.2.2 APEX Approval Task (`apex:type="apexApproval"`)
```xml
<apex:apexApproval>
  <apex:applicationId>100</apex:applicationId>
  <apex:taskStaticId>MY_TASK_STATIC_ID</apex:taskStaticId>
  <apex:businessRef>&F4A$BUSINESS_REF.</apex:businessRef>
  <apex:subject>Optional subject</apex:subject>
  <apex:taskComment>Optional comment</apex:taskComment>
  <apex:parameters>
    <apex:parameter>
      <apex:parStaticId>PARAM_NAME</apex:parStaticId>
      <apex:parDataType>String|Number|Date</apex:parDataType>
      <apex:parValue>value</apex:parValue>
    </apex:parameter>
  </apex:parameters>
  <apex:resultVariable>approvalResult</apex:resultVariable>
</apex:apexApproval>
```

#### 2.2.3 APEX Simple Form Task (`apex:type="apexSimpleForm"`)
```xml
<apex:apexSimpleForm>
  <!-- Similar structure to apexPage -->
</apex:apexSimpleForm>
```

#### 2.2.4 External URL Task (`apex:type="externalUrl"`)
```xml
<apex:externalUrl>
  <apex:url>https://example.com/page</apex:url>
</apex:externalUrl>
```

### 2.3 PL/SQL Execution Tasks (`apex:type="executePlsql"`)

Can be used on: `bpmn:scriptTask`, `bpmn:serviceTask`, `bpmn:businessRuleTask`

```xml
<apex:executePlsql>
  <apex:engine>true|false</apex:engine>  <!-- Optional: use engine binds -->
  <apex:autoBinds>true|false</apex:autoBinds>  <!-- Optional: auto-bind process vars -->
  <apex:plsqlCode>
begin
  -- Your PL/SQL code here
  flow_process_vars.set_var(
    pi_prcs_id => flow_globals.process_id,
    pi_var_name => 'RESULT',
    pi_vc2_value => 'OK'
  );
end;
  </apex:plsqlCode>
</apex:executePlsql>
```

### 2.4 Send Mail Service Task (`apex:type="sendMail"`)
```xml
<apex:sendMail>
  <apex:emailFrom>sender@example.com</apex:emailFrom>
  <apex:emailTo>recipient@example.com</apex:emailTo>
  <apex:emailCC>cc@example.com</apex:emailCC>
  <apex:emailBCC>bcc@example.com</apex:emailBCC>
  <apex:emailReplyTo>reply@example.com</apex:emailReplyTo>
  <apex:useTemplate>true|false</apex:useTemplate>
  <apex:applicationId>100</apex:applicationId>
  <apex:templateId>TEMPLATE_STATIC_ID</apex:templateId>
  <apex:placeholder>
    <apex:name>PLACEHOLDER_NAME</apex:name>
    <apex:value>placeholder value</apex:value>
  </apex:placeholder>
  <apex:subject>Email Subject</apex:subject>
  <apex:bodyText>Plain text body</apex:bodyText>
  <apex:bodyHTML><![CDATA[<html>HTML body</html>]]></apex:bodyHTML>
  <apex:attachment>
    <!-- Attachment specification -->
  </apex:attachment>
  <apex:immediately>true|false</apex:immediately>
</apex:sendMail>
```

### 2.5 AI Generation Service Task (`apex:type="apexAIGeneration"`)
```xml
<apex:apexAIGeneration>
  <apex:aiModel>model-name</apex:aiModel>
  <apex:aiPrompt>Your prompt here</apex:aiPrompt>
  <apex:aiTemperature>0.7</apex:aiTemperature>
  <apex:resultVariable>aiResult</apex:resultVariable>
</apex:apexAIGeneration>
```

### 2.6 Variable Expressions for Tasks

#### 2.6.1 beforeTask Variables
```xml
<apex:beforeTask>
  <apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>variableName</apex:varName>
    <apex:varDataType>VARCHAR2|NUMBER|DATE|TIMESTAMP_WITH_TIME_ZONE|CLOB|JSON</apex:varDataType>
    <apex:varExpressionType>static|processVariable|sqlQuerySingle|sqlQueryList|plsqlExpression|plsqlFunctionBody|plsqlRawExpression|plsqlRawFunctionBody</apex:varExpressionType>
    <apex:varExpression>expression value</apex:varExpression>
    <apex:varSourceType>Optional source type</apex:varSourceType>
    <apex:varSource>Optional source identifier</apex:varSource>
  </apex:processVariable>
</apex:beforeTask>
```

#### 2.6.2 afterTask Variables
```xml
<apex:afterTask>
  <apex:processVariable>
    <!-- Same structure as beforeTask -->
  </apex:processVariable>
</apex:afterTask>
```

---

## 3. EVENT EXTENSIONS

### 3.1 Event Variable Expressions

#### 3.1.1 beforeEvent (Start Events, Boundary Events)
```xml
<apex:beforeEvent>
  <apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>variableName</apex:varName>
    <apex:varDataType>VARCHAR2</apex:varDataType>
    <apex:varExpressionType>static</apex:varExpressionType>
    <apex:varExpression>value</apex:varExpression>
  </apex:processVariable>
</apex:beforeEvent>
```

#### 3.1.2 onEvent (Start Events, Catch Events)
```xml
<apex:onEvent>
  <apex:processVariable>
    <!-- Same structure -->
  </apex:processVariable>
</apex:onEvent>
```

### 3.2 Timer Event Definitions

#### 3.2.1 Standard BPMN Timers (in `bpmn:timerEventDefinition`)
- `bpmn:timeDate` - ISO 8601 timestamp
- `bpmn:timeDuration` - ISO 8601 duration (PT2S)
- `bpmn:timeCycle` - ISO 8601 repeating interval

#### 3.2.2 Oracle Custom Timer Extensions
```xml
<apex:oracleDate>
  <apex:expressionType>static|processVariable|sqlQuerySingle|plsqlExpression|plsqlFunctionBody</apex:expressionType>
  <apex:expression>2024-06-21 09:15:05 GMT</apex:expression>
  <apex:formatMask>YYYY-MM-DD HH24:MI:SS TZR</apex:formatMask>
  <apex:date>timestamp expression</apex:date>
</apex:oracleDate>

<apex:oracleDuration>
  <apex:expressionType>static|processVariable|sqlQuerySingle|plsqlExpression|plsqlFunctionBody</apex:expressionType>
  <apex:expression>PT12H</apex:expression>
  <apex:intervalYM>Optional YEAR TO MONTH interval</apex:intervalYM>
  <apex:intervalDS>DAY TO SECOND interval</apex:intervalDS>
</apex:oracleDuration>

<apex:oracleCycle>
  <apex:expressionType>static|processVariable|sqlQuerySingle|plsqlExpression|plsqlFunctionBody</apex:expressionType>
  <apex:expression>FREQ=HOURLY;INTERVAL=1</apex:expression>
  <apex:startIntervalDS>Optional start interval</apex:startIntervalDS>
  <apex:repeatIntervalDS>Repeat interval</apex:repeatIntervalDS>
  <apex:maxRuns>Optional max runs</apex:maxRuns>
</apex:oracleCycle>
```

### 3.3 Message Event Definitions (`apex:type="simpleMessage"`)

#### 3.3.1 Throw/Send Message Events
```xml
<bpmn:messageEventDefinition>
  <bpmn:extensionElements>
    <apex:endpoint>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>local</apex:expression>
    </apex:endpoint>
    <apex:messageName>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>MyMessage</apex:expression>
    </apex:messageName>
    <apex:correlationKey>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>messageKey</apex:expression>
    </apex:correlationKey>
    <apex:correlationValue>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>messageValue</apex:expression>
    </apex:correlationValue>
    <apex:payload>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>messagePayload</apex:expression>
    </apex:payload>
  </bpmn:extensionElements>
</bpmn:messageEventDefinition>
```

#### 3.3.2 Catch/Receive Message Events
```xml
<bpmn:messageEventDefinition>
  <bpmn:extensionElements>
    <apex:messageName>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>MyMessage</apex:expression>
    </apex:messageName>
    <apex:correlationKey>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>messageKey</apex:expression>
    </apex:correlationKey>
    <apex:correlationValue>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>messageValue</apex:expression>
    </apex:correlationValue>
    <apex:payloadVariable>returnPayload</apex:payloadVariable>
  </bpmn:extensionElements>
</bpmn:messageEventDefinition>
```

### 3.4 Terminate End Event
```xml
<bpmn:terminateEventDefinition>
  <apex:processStatus>completed|terminated</apex:processStatus>
</bpmn:terminateEventDefinition>
```

---

## 4. GATEWAY EXTENSIONS

### 4.1 Gateway Variable Expressions

#### 4.1.1 beforeSplit
```xml
<apex:beforeSplit>
  <apex:processVariable>
    <!-- Same structure as task variables -->
  </apex:processVariable>
</apex:beforeSplit>
```

#### 4.1.2 afterMerge
```xml
<apex:afterMerge>
  <apex:processVariable>
    <!-- Same structure -->
  </apex:processVariable>
</apex:afterMerge>
```

---

## 5. SEQUENCE FLOW EXTENSIONS

### 5.1 SequenceFlow Attributes

| Attribute | Type | Required | Purpose | Example |
|-----------|------|----------|---------|---------|
| `@apex:sequence` | xs:integer | No | Execution order/priority | `10` |

### 5.2 SequenceFlow Condition Expressions

Standard BPMN with language attribute:
```xml
<bpmn:conditionExpression xsi:type="bpmn:tFormalExpression" 
                          language="plsqlExpression|plsqlFunctionBody">
  :F4A$PATH = 'A'
</bpmn:conditionExpression>
```

### 5.3 Custom Extension on Flow
```xml
<bpmn:extensionElements>
  <apex:customExtension>{"object":"Flow_RouteD"}</apex:customExtension>
</bpmn:extensionElements>
```

---

## 6. CALL ACTIVITY EXTENSIONS

### 6.1 CallActivity Attributes

| Attribute | Type | Required | Purpose | Example |
|-----------|------|----------|---------|---------|
| `@apex:manualInput` | boolean | No | Whether requires manual input | `false` |
| `@apex:calledDiagram` | xs:string | Yes | Name of called diagram | `Called Diagram` |
| `@apex:calledDiagramVersionSelection` | enum | Yes | Version selection strategy | `latestVersion|namedVersion` |
| `@apex:calledDiagramVersion` | xs:string | Conditional | Specific version (if namedVersion) | `1.0` |

### 6.2 CallActivity Extension Elements

#### 6.2.1 Input Variables
```xml
<apex:inVariables>
  <apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>Called_Invar_Name</apex:varName>
    <apex:varDataType>VARCHAR2</apex:varDataType>
    <apex:varExpressionType>static|processVariable|sqlQuerySingle|sqlQueryList|plsqlExpression|plsqlFunctionBody|plsqlRawExpression|plsqlRawFunctionBody</apex:varExpressionType>
    <apex:varExpression>value</apex:varExpression>
  </apex:processVariable>
</apex:inVariables>
```

#### 6.2.2 Output Variables
```xml
<apex:outVariables>
  <apex:processVariable>
    <apex:varSequence>0</apex:varSequence>
    <apex:varName>Called_Outvar_Name</apex:varName>
    <apex:varDataType>VARCHAR2</apex:varDataType>
    <apex:varExpressionType>static|processVariable|sqlQuerySingle</apex:varExpressionType>
    <apex:varExpression>returnValue</apex:varExpression>
  </apex:processVariable>
</apex:outVariables>
```

---

## 7. SUBPROCESS EXTENSIONS

### 7.1 SubProcess Variable Expressions
- `<apex:beforeTask>` - Same structure as regular tasks
- `<apex:afterTask>` - Same structure as regular tasks

### 7.2 Ad Hoc SubProcess Extensions
```xml
<apex:completionCondition>
  <apex:expressionType>plsqlExpression|plsqlFunctionBody</apex:expressionType>
  <apex:expression>completion logic</apex:expression>
</apex:completionCondition>

<apex:adhocVisibility>none|subprocess|activities|all</apex:adhocVisibility>

<apex:startingActivities>
  <!-- List of activity IDs -->
</apex:startingActivities>
```

---

## 8. ITERATOR/LOOP EXTENSIONS

### 8.1 Multi-Instance Loop Characteristics

On `bpmn:multiInstanceLoopCharacteristics`:

```xml
<bpmn:multiInstanceLoopCharacteristics isSequential="true|false">
  <bpmn:extensionElements>
    <apex:inputCollection>
      <apex:expressionType>processVariable|sqlQueryList|plsqlFunctionBody</apex:expressionType>
      <apex:expression>collectionName</apex:expression>
      <apex:insideVariable>loopItem</apex:insideVariable>
    </apex:inputCollection>
    
    <apex:outputCollection>
      <apex:expressionType>static|processVariable</apex:expressionType>
      <apex:expression>outputCollectionName</apex:expression>
      <apex:insideVariable>outputItem</apex:insideVariable>
    </apex:outputCollection>
    
    <apex:completionCondition>
      <apex:expressionType>plsqlExpression|plsqlFunctionBody</apex:expressionType>
      <apex:expression>completion logic</apex:expression>
    </apex:completionCondition>
    
    <apex:description>Optional description</apex:description>
  </bpmn:extensionElements>
</bpmn:multiInstanceLoopCharacteristics>
```

### 8.2 Standard Loop Characteristics

On `bpmn:standardLoopCharacteristics`:

```xml
<bpmn:standardLoopCharacteristics>
  <bpmn:extensionElements>
    <apex:inputCollection>
      <!-- Same structure as multi-instance -->
    </apex:inputCollection>
    
    <apex:completionCondition>
      <!-- Same structure -->
    </apex:completionCondition>
    
    <apex:description>Optional description</apex:description>
  </bpmn:extensionElements>
</bpmn:standardLoopCharacteristics>
```

---

## 9. LANE/ROLE EXTENSIONS

### 9.1 Lane Attributes

| Attribute | Type | Required | Purpose | Example |
|-----------|------|----------|---------|---------|
| `@apex:isRole` | boolean | No | Whether lane represents a role | `true` |
| `@apex:role` | xs:string | Conditional | Role name (if isRole=true) | `ROLE_A2` |

### 9.2 Lane Extension Elements
```xml
<bpmn:extensionElements>
  <!-- Can contain variable expressions or custom extensions -->
  <apex:customExtension>{"lane":"data"}</apex:customExtension>
</bpmn:extensionElements>
```

---

## 10. COLLABORATION EXTENSIONS

### 10.1 Participant Extensions
Can contain custom extensions in `bpmn:extensionElements`

### 10.2 Message Flow Extensions
```xml
<bpmn:messageFlow>
  <bpmn:extensionElements>
    <apex:customExtension>{"flow":"metadata"}</apex:customExtension>
  </bpmn:extensionElements>
</bpmn:messageFlow>
```

---

## 11. EXPRESSION TYPES REFERENCE

All expression elements support these `<apex:expressionType>` values:

| Expression Type | Purpose | Example |
|----------------|---------|---------|
| `static` | Static/literal value | `StaticValue` |
| `processVariable` | Reference to process variable | `MY_VAR_NAME` |
| `sqlQuerySingle` | SQL query returning single value | `select 'value' from dual` |
| `sqlQueryList` | SQL query returning multiple values | `select col from table` |
| `plsqlExpression` | PL/SQL expression with substitutions | `'&F4A$VAR.' = 'A'` |
| `plsqlFunctionBody` | PL/SQL function body with substitutions | `return '&F4A$VAR.';` |
| `plsqlRawExpression` | PL/SQL expression with bind variables | `:F4A$VAR = 'A'` |
| `plsqlRawFunctionBody` | PL/SQL function body with bind variables | `return :F4A$VAR;` |
| `interval` | ISO 8601 duration | `PT12H`, `P1D` |
| `oracleScheduler` | Oracle DBMS_SCHEDULER syntax | `FREQ=HOURLY;INTERVAL=1` |

---

## 12. DATA TYPES REFERENCE

For `<apex:varDataType>`:

| Data Type | Purpose | Example Value |
|-----------|---------|---------------|
| `VARCHAR2` | Variable-length string | `Hello World` |
| `NUMBER` | Numeric value | `42`, `3.14` |
| `DATE` | Date/time (no timezone) | `2024-02-23 01:02:03` |
| `TIMESTAMP_WITH_TIME_ZONE` | Timestamp with timezone | `2032-06-21 23:59:59 GMT` |
| `CLOB` | Character large object | `<long text>` |
| `JSON` | JSON data | `{"key":"value"}` |

---

## 13. SUBSTITUTION STRINGS

Available in string values (with substitution):

| Substitution | Purpose | Example |
|--------------|---------|---------|
| `&F4A$PROCESS_ID.` | Current process ID | `12345` |
| `&F4A$SUBFLOW_ID.` | Current subflow ID | `67890` |
| `&F4A$STEP_KEY.` | Current step key | `Activity_123` |
| `&F4A$SCOPE.` | Current scope | `0` |
| `&F4A$PROCESS_PRIORITY.` | Process priority | `3` |
| `&F4A${varName}.` | Process variable substitution | `&F4A$MY_VAR.` |
| `&F4A$LOOP_COUNTER.` | Iterator loop counter | `1`, `2`, `3` |
| `&F4A$TOTAL_INSTANCES.` | Total iterator instances | `10` |
| `&F4A$ACTIVE_INSTANCES.` | Active iterator instances | `5` |
| `&F4A$COMPLETED_INSTANCES.` | Completed instances | `3` |
| `&F4A$TERMINATED_INSTANCES.` | Terminated instances | `1` |

---

## 14. BIND VARIABLES

Available in PL/SQL code (with bind):

| Bind Variable | Purpose | Type |
|---------------|---------|------|
| `:F4A$PROCESS_ID` | Current process ID | NUMBER |
| `:F4A$SUBFLOW_ID` | Current subflow ID | NUMBER |
| `:F4A$STEP_KEY` | Current step key | VARCHAR2 |
| `:F4A$SCOPE` | Current scope | NUMBER |
| `:F4A${varName}` | Process variable bind | (type varies) |
| `:F4A$LOOP_COUNTER` | Iterator loop counter | NUMBER |

---

## 15. CUSTOM EXTENSION FORMAT

The `<apex:customExtension>` element can contain arbitrary JSON:

```xml
<apex:customExtension>
{
  "customProperty": "value",
  "nestedObject": {
    "key": "value"
  },
  "arrayProperty": ["item1", "item2"]
}
</apex:customExtension>
```

**Usage contexts:**
- Process level
- Any task/activity
- Events (start, end, intermediate, boundary)
- Gateways
- SubProcesses
- CallActivities
- Lanes
- SequenceFlows
- Collaboration elements

---

## 16. COMPLETE NAMESPACE DECLARATION

For BPMN files using Flows for APEX extensions:

```xml
<bpmn:definitions 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"
  xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI"
  xmlns:apex="https://flowsforapex.org"
  xmlns:dc="http://www.omg.org/spec/DD/20100524/DC"
  xmlns:di="http://www.omg.org/spec/DD/20100524/DI"
  id="Definitions_1"
  targetNamespace="http://bpmn.io/schema/b"
  exporter="Flows for APEX"
  exporterVersion="26.1">
```

---

## SUMMARY STATISTICS

- **Process-level attributes:** 9
- **Process extension elements:** 4 types
- **Task subtypes:** 10
- **Event extension types:** 8
- **Expression types:** 10
- **Data types:** 6
- **Iterator types:** 2
- **Substitution variables:** 11+
- **Total unique apex: elements:** 80+
- **Total unique apex: attributes:** 15+

---

## NOTES FOR XSD DEVELOPMENT

1. **Expression Pattern:** Most extension elements follow the pattern:
   ```xml
   <apex:elementName>
     <apex:expressionType>type</apex:expressionType>
     <apex:expression>value</apex:expression>
     <apex:formatMask>optional</apex:formatMask>
   </apex:elementName>
   ```

2. **Variable Pattern:** Process variables consistently use:
   - `varSequence` (integer, execution order)
   - `varName` (string, variable name)
   - `varDataType` (enum, data type)
   - `varExpressionType` (enum, expression type)
   - `varExpression` (string/clob, expression value)
   - `varSourceType` (optional string)
   - `varSource` (optional string)

3. **Conditional Requirements:**
   - `@apex:calledDiagramVersion` required when `@apex:calledDiagramVersionSelection="namedVersion"`
   - `@apex:role` required when `@apex:isRole="true"`
   - Task-specific extensions required when corresponding `@apex:type` is set

4. **Multi-line Content:** Many elements like `<apex:expression>` in plsql* types and `<apex:plsqlCode>` contain multi-line content that should be preserved with whitespace.

5. **Cardinality:**
   - Most extension elements are optional (0..1)
   - Process variables within expression sets are unbounded (0..unbounded)
   - Page items are unbounded (0..unbounded)
   - Parameters are unbounded (0..unbounded)

---

**Document Version:** 1.0  
**Complete:** This catalog represents ALL apex: namespace extensions found in the Flows for APEX codebase as of version 26.1.
