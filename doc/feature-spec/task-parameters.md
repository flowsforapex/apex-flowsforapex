Here's a condensed version optimized for VSCode:

# BPMN Task Input/Output Parameters - Design Specification

## Overview
Adding structured input/output parameters to BPMN tasks in Flows for APEX. Parameters define task contracts, enable validation, support AHSP interactive execution, and facilitate service task templating.

## Key Design Decisions

### Input Parameters
- **Combined Definition**: Parameter schema and source binding in one structure (not separate inputAssignments)
- **Source Types**: 
  - `processVariable` - Get value from process variable
  - `userInput` - Collect from user in AHSP UI
  - `static` - Use a fixed/hardcoded value
  - Future: `expression`, `sqlQuery`, `systemValue`, `taskOutput`
- **Top-level scalars auto-unpacked** in PL/SQL scripts (objects/arrays stay as JSON)
- **Backward compatible**: Existing tasks without parameters work unchanged

### Output Parameters
- Must include `result` field for AHSP display
- **Output assignments use expressions** for flexibility (e.g., incrementing counters)
- Assignments set process variables after task completion

### Storage
- Stored in JSON in `flow_objects.objt_attributes`
- Runtime input values in `flow_adhoc_subflows` table
- Generate JSON Schema for APEX UI (using Ewe Simon's APEX JSON Region plugin)

## XML Structure

```xml
<bpmn:scriptTask id="checkAirports" name="Check Other Airports">
  <bpmn:extensionElements>
    <apex:inputParameters>
      <apex:parameter>
        <apex:name>case_id</apex:name>
        <apex:type>string</apex:type>
        <apex:required>true</apex:required>
        <apex:source>
          <apex:expressionType>processVariable</apex:expressionType>
          <apex:expression>P_CASE_ID</apex:expression>
        </apex:source>
      </apex:parameter>
      
      <apex:parameter>
        <apex:name>airport_code</apex:name>
        <apex:type>string</apex:type>
        <apex:required>true</apex:required>
        <apex:description>Airport to check (3 letter code)</apex:description>
        <apex:source>
          <apex:expressionType>userInput</apex:expressionType>
        </apex:source>
      </apex:parameter>
      
      <apex:parameter>
        <apex:name>system_id</apex:name>
        <apex:type>string</apex:type>
        <apex:required>true</apex:required>
        <apex:source>
          <apex:expressionType>static</apex:expressionType>
          <apex:expression>BAGGAGE_SYSTEM_V2</apex:expression>
        </apex:source>
      </apex:parameter>
    </apex:inputParameters>
    
    <apex:outputParameters>
      <apex:parameter>
        <apex:name>result</apex:name>
        <apex:type>string</apex:type>
        <apex:required>true</apex:required>
        <apex:description>Summary of search results</apex:description>
      </apex:parameter>
      
      <apex:parameter>
        <apex:name>bag_found</apex:name>
        <apex:type>boolean</apex:type>
        <apex:required>true</apex:required>
      </apex:parameter>
      
      <apex:parameter>
        <apex:name>airports_checked</apex:name>
        <apex:type>array</apex:type>
        <apex:required>true</apex:required>
        <apex:items>
          <apex:type>string</apex:type>
        </apex:items>
      </apex:parameter>
    </apex:outputParameters>
    
    <apex:outputAssignments>
      <apex:assignment>
        <apex:sourceParameter>bag_found</apex:sourceParameter>
        <apex:targetVariable>P_BAG_LOCATED</apex:targetVariable>
        <apex:expression>bag_found</apex:expression>
      </apex:assignment>
      <apex:assignment>
        <apex:sourceParameter>airports_checked</apex:sourceParameter>
        <apex:targetVariable>P_SEARCH_COUNT</apex:targetVariable>
        <apex:expression>P_SEARCH_COUNT + json_array_length(airports_checked)</apex:expression>
      </apex:assignment>
    </apex:outputAssignments>
  </bpmn:extensionElements>
  
  <bpmn:script><![CDATA[
    declare
      l_output json_object_t := json_object_t();
      l_airports json_array_t := :airports;  -- Auto-unpacked
    begin
      -- :case_id also available as scalar
      
      l_output.put('result', 'Checked ' || l_airports.get_size || ' airports');
      l_output.put('bag_found', false);
      l_output.put('airports_checked', l_airports);
      
      :F4A$OUTPUT := l_output;
    end;
  ]]></bpmn:script>
</bpmn:scriptTask>
```

## JSON Storage Format (flow_objects.objt_attributes)

```json
{
  "inputParameters": [
    {
      "name": "case_id",
      "type": "string",
      "required": true,
      "source": {
        "expressionType": "processVariable",
        "expression": "P_CASE_ID"
      }
    },
    {
      "name": "airports",
      "type": "array",
      "required": true,
      "description": "Airport codes to check",
      "items": {
        "type": "string",
        "pattern": "^[A-Z]{3}$"
      },
      "rendering": {
        "control": "multiselect",
        "lov": "SELECT airport_code, airport_name FROM airports"
      },
      "source": {
        "expressionType": "userInput"
      }
    },
    {
      "name": "system_id",
      "type": "string",
      "required": true,
      "source": {
        "expressionType": "static",
        "expression": "BAGGAGE_SYSTEM_V2"
      }
    }
  ],
  "outputParameters": [
    {
      "name": "result",
      "type": "string",
      "required": true,
      "description": "Summary of search results"
    },
    {
      "name": "bag_found",
      "type": "boolean",
      "required": true
    },
    {
      "name": "airports_checked",
      "type": "array",
      "required": true,
      "items": {"type": "string"}
    }
  ],
  "outputAssignments": [
    {
      "sourceParameter": "bag_found",
      "targetVariable": "P_BAG_LOCATED",
      "expression": "bag_found"
    },
    {
      "sourceParameter": "airports_checked",
      "targetVariable": "P_SEARCH_COUNT",
      "expression": "P_SEARCH_COUNT + json_array_length(airports_checked)"
    }
  ]
}
```

## Runtime Input Values (flow_adhoc_subflows)

```json
{
  "case_id": "LC-2026-00234",
  "airports": ["SFO", "LAX", "JFK"],
  "system_id": "BAGGAGE_SYSTEM_V2",
  "priority": "urgent"
}
```

## Execution Flow

### Before Task Executes:
1. For each inputParameter:
   - If `expressionType = "processVariable"` → get from process var using expression
   - If `expressionType = "userInput"` → value already in input JSON from AHSP UI
   - If `expressionType = "static"` → use expression value directly
2. Validate complete input JSON against parameter schema
3. Unpack top-level scalars as bind variables (`:case_id`, `:airports`, etc.)

### After Task Executes:
1. Get output JSON from `:F4A$OUTPUT`
2. For each outputAssignment:
   - Evaluate expression (can reference output parameters and process variables)
   - Set targetVariable process variable
3. Store output JSON in flow_adhoc_subflows for AHSP display

## Use Cases

1. **AHSP Interactive**: User starts task, fills in `userInput` parameters, process vars auto-populated
2. **Start Events**: Collect process launch parameters without initial UserTask
3. **Service Templates**: Reusable REST integrations (Docusign, Salesforce, etc.) with parameter mapping

## Parameter Types Supported

- `string` - Text values
- `number` - Numeric values  
- `boolean` - True/false
- `array` - Collections (with `items` schema)
- `object` - Nested structures (with `properties` schema)

## Rendering Controls (APEX UI)

- `text` - Text input
- `select` - Dropdown (with LOV)
- `multiselect` - Multi-select list (with LOV)
- `radio` - Radio buttons (with enum)
- `checkbox` - Checkbox
- `datepicker` - Date picker
- `textarea` - Multi-line text

## Future Extensions

- Additional sourceTypes: `expression`, `sqlQuery`, `systemValue`, `taskOutput`
- More complex validations (min/max, custom patterns)
- Conditional parameters (only show if other param has certain value)
- Parameter groups/sections for complex UIs

## JSONPath Variable Expressions (Design - Next Release)

### Summary
Introduce a new variable expression type that can extract objects or scalars using JSONPath from:
- task output parameters
- task input parameters (after-task only)
- JSON-typed process variables

### New Expression Type
- `flow_constants_pkg.gc_expr_type_json_path` := 'jsonPath'

### New Expression Type
- jsonPath
  
### BPMN Modeler Properties Panel

- Add new Variable expression type
  - Sequence
  - Variable Name
  - variable Type (all types allowed)
  - Expression Type - 'JSON Path Expression' - creates exppressionType 'jsonPath'
  - Source Type 
    - Select List - 'Process Variable (JSON)'|Task Input Parameters|Task Output Parameters
    -  Process Variable is always valid.  
    -  Input and Output Parameters are only valid on After-Task, On Event variable expressions (subject to change - maybe add everywhere for now!)
    -  in XML - use tag `apex:varSourceType`
    -  BPMN values: `processVariable`, `taskOutput`, `taskInput`
  - Source.  
    -  in XML - use tag `apex:varSource`
    - For `processVariable`: source variable name
    - For `taskOutput`/`taskInput`: use `@`
  - Expression
    - - valid json path expression.
    - default start with $ ?

### Expression Storage (flow_object_expressions)
Add two nullable columns:
- `expr_source_type` (VARCHAR2)
  - in XML - use tag `apex:varSourceType`
  - Allowed: `processVariable`, `taskOutput`, `taskInput`
- `expr_source` (VARCHAR2)
  - in XML - use tag `apex:varSource`
  - For `processVariable`: source variable name
  - For `taskOutput`/`taskInput`: use `@`

`expr_expression` stores the JSONPath.

### Availability Rules
- `taskOutput`: only after task / after event expression sets
- `taskInput`: only after task expression sets
- `processVariable`: always available (source variable must be JSON-typed)

### Evaluation Flow (flow_expressions)
Add `set_json_path` parallel to `set_sql`/`set_plsql`:
1. Resolve source JSON
   - `taskOutput` → `flow_subflows.sbfl_task_output_parameters`
   - `taskInput` → task input JSON (available after task only)
   - `processVariable` → JSON-typed process var
2. Apply JSONPath to get value
3. Coerce to target variable type
4. Set process variable

### Type Coercion Rules (JSON → Process Variable)
- **VARCHAR2**: string/number/boolean to text; null → null
- **NUMBER**: JSON number; string parsed via `to_number`
- **DATE**: ISO-8601 date or datetime string using `gc_prov_default_date_format`
- **TIMESTAMP WITH TIME ZONE**: ISO-8601 with timezone using `gc_prov_default_tstz_format`
- **JSON/CLOB**: object/array/scalar serialized to JSON text

Missing path or JSON null → set target to null (log debug warning).
```

---

**To use in VSCode:**

1. Save this as `docs/design/task-parameters.md` in your project
2. In VSCode Chat, start with:

```
I'm implementing the task parameters feature described in @docs/design/task-parameters.md

First task: Build the PL/SQL XML parser that extracts apex:inputParameters from BPMN extensionElements and converts to the JSON format for storage in flow_objects.objt_attributes.

The parser should handle:
- Parameter name, type, required, description
- Source (sourceType and sourceExpression)
- Nested structures (items for arrays, properties for objects)
- Rendering hints
- Enum values and patterns

Can you help me build this parser function?
```

This gives Claude all the context it needs in a compact, searchable format!