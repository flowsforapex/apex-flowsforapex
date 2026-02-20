Here's a condensed version optimized for VSCode:

# BPMN Task Input/Output Parameters - Design Specification

## Overview
Adding structured input/output parameters to BPMN tasks in Flows for APEX. Parameters define task contracts, enable validation, support AHSP interactive execution, and facilitate service task templating.

## Key Design Decisions

### Input Parameters
- **Combined Definition**: Parameter schema and source binding in one structure 
- **Source Types**: 
  - `processVariable` - Get value from process variable
  - `userInput` - Collect from user in AHSP UI
  - `static` - Use a fixed/hardcoded value
  - Future: `expression`, `sqlQuery`, `functionBody`, etc (possible for 26.1)
- **Top-level scalars auto-unpacked** in PL/SQL scripts (objects/arrays stay as JSON) using `l_var := flow_globals.input_parameter(var_name);`
- **Backward compatible**: Existing tasks without parameters work unchanged

### Output Parameters
- Must include `result` and optionally `keyValues` field for AHSP display
- **Output assignments use variable expressions** for flexibility (e.g., incrementing counters)
- Assignments set process variables after task completion

### Storage
- Stored in JSON in `flow_objects.objt_attributes`
- Runtime input values in `flow_adhoc_subflows` table
- Generate JSON Schema for APEX UI (using Ewe Simon's APEX JSON Region plugin)

## XML Structure 

```xml
<bpmn:scriptTask id="checkAirports" name="Check Other Airports">
  <bpmn:extensionElements>
    <apex:displayOrder>nn</apex:displayOrder>
    <apex:grouping>locate bag</apex:grouping>
    <apex:isRepeatable>true|false</apex:isRepeatable> (default to false)
    <apex:description>text to describe the step/task</apex:description>
    <apex:inputParameters>
      <apex:parameter>
        <apex:name>case_id</apex:name>
        <apex:type>string</apex:type>
        <apex:required>true</apex:required>
        <apex:description>the case id</apex:description>
        <apex:source>
          <apex:expressionType>processVariable</apex:expressionType>
          <apex:expression>P_CASE_ID</apex:expression>
        </apex:source>
        <apex:displayInstructions>json object listing plugin properties (model on custom extensions region inc json syntax check)
        </apex:displayInstructions>
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
    
  </bpmn:extensionElements>
  
</bpmn:scriptTask>
```

## Example JSON Storage Format (flow_objects.objt_attributes)

```json
{
  "apex" :
  {
    "customExtension" :
    {
      "isRepeatable" : true,  (for AHSPs)
      "description" : "Checks the airport luggage system for a lost bag.  Search can be 'quick or detailed.",
      "displayOrder" : 20,  (for AHSPs)
      "grouping" : "Locate Bag",  (for AHSPs)
      "inputParameters" :
      [
        {
          "name" : "airport_code",
          "type" : "string",
          "required" : true,
          "description" : "Three-letter IATA airport code (e.g., JFK, LAX, LHR)",
          "source" :
          {
            "expressionType" : "userInput"
          },
          "apexRendering" :
          {
            "itemtype" : "text",
            "maxLength" : 3,
            "placeholder" : "Enter airport code"
          }
        },
        {
          "name" : "search_depth",
          "type" : "string",
          "description" : "Search level required - determines how thoroughly the baggage system will be searched",
          "required" : false,
          "default" : "standard",
          "source" :
          {
            "expressionType" : "userInput"
          },
          "apexRendering" :
          {
            "enum" :
            {
              "quick" : "Quick Search (5 minutes)",
              "standard" : "Standard Search (15 minutes)",
              "deep" : "Deep Search (45 minutes)"
            }
          }
        },
        {
          "name" : "bag_tag",
          "type" : "string",
          "required" : true,
          "description" : "Bag tracking number from process variables",
          "source" :
          {
            "expressionType" : "processVariable",
            "expression" : "BAG_TAG"
          }
        }
      ],
      "outputParameters" :
      [
        {
          "name" : "result",
          "type" : "string",
          "required" : true,
          "description" : "Activity Result Text"
        },
        {
          "name" : "keyOutputs",
          "type" : "string",
          "required" : false
        }
      ]
    },
    "plsqlCode" :
    [
      "airp_demo_api.check_airport_luggage_store;"
    ]
  },
  "taskType" : "executePlsql"
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
1. Get output JSON from Output Parameters and use Variable Expressions to set proc vars
2. Store output JSON in flow_adhoc_subflows for AHSP display

## Use Cases

1. **AHSP Interactive**: User starts task, fills in `userInput` parameters, process vars auto-populated
2. **Start Events**: Collect process launch parameters without initial UserTask
3. **UserTasks** - add new AutoForm type (similar to Simple forma but auto create json schema dynamically...)
4. **Service Templates**: Reusable REST integrations (AI, Docusign, Salesforce, etc.) with parameter mapping

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
- ... see APEX JSON region doc...

## Future Extensions

- Additional sourceTypes: `expression`, `sqlQuery`, `systemValue`, `taskOutput`
- More complex validations (min/max, custom patterns)
- Conditional parameters (only show if other param has certain value)
- Parameter groups/sections for complex UIs

## JSONPath Variable Expressions 

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
  - Expression Type - 'JSON Path Expression' - creates expressionType 'jsonPath'
  - Source Type 
    - Select List - 'Process Variable (JSON)'|Task Input Parameters|Task Output Parameters
    -  Process Variable is always valid.  
    -  Input and Output Parameters are only displayed on After-Task, On Event variable expressions (subject to change - maybe add everywhere for now!)
    -  in XML - use tag `apex:varSourceType`
    -  BPMN values: `processVariable`, `taskOutput`, `taskInput`
  - Source.  
    -  in XML - use tag `apex:varSource`
    - For `processVariable`: source variable name
    - For `taskOutput`/`taskInput`: don't use tag
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

