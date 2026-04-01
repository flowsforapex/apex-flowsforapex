# Flows for APEX Feature Spec - Task Subjects

## Version Info

| Version | Date | Author | Comments |
| -- | -- | -- | -- |
| 0.1 | 22-Mar-2026 | GitHub Copilot | Initial draft based on design discussion |

## Background

Task names shown in Flows for APEX task lists are currently generated from technical runtime metadata, typically using a fallback pattern such as process name, business reference, and current BPMN object name. This is useful for developers and administrators, but it is not sufficiently business-friendly for end users.

APEX Human Tasks already support a subject concept. In Flows for APEX, APEX Human Task user tasks can already define an XML element that becomes `objt_attributes."apex"."subject"` at runtime and is passed into `APEX_HUMAN_TASK.CREATE_TASK`.

The aim of this feature is to introduce an equivalent business subject concept for Flows for APEX task-list presentation, without forcing unnecessary BPMN migration and without breaking existing APEX Human Task behavior.

## Goals

- Provide a business-friendly task subject for Flows for APEX task lists.
- Support subject evaluation at runtime using existing Flows substitutions.
- Preserve existing APEX Human Task behavior and compatibility.
- Avoid BPMN migration unless absolutely necessary.
- Store the evaluated subject on the runtime subflow so all task-list surfaces can use the same value.
- Clear the runtime subject when a step completes so stale values are not shown on subsequent steps.

## Non-Goals

- No support is required for direct substitution from arbitrary JSON keys inside task input JSON.
- No BPMN migration of existing APEX Approval or APEX user task XML should be required.
- No redesign of APEX Human Task subject handling in APEX itself.
- No attempt to make AHSP use the exact same XML subtype structure as APEX Human Tasks.

## Summary of Design

### Core Rule

For BPMN user tasks, the subject value used by Flows for APEX should come from the existing parsed `apex.subject` runtime attribute.

If a subject is defined, Flows for APEX evaluates its own substitutions and stores the evaluated result on the runtime subflow as `sbfl_subject`.

For APEX Human Task backed user tasks, that same evaluated value is also passed into `APEX_HUMAN_TASK.CREATE_TASK(... p_subject => ...)`.

If no explicit subject is defined, then:

- APEX Human Tasks continue to use the subject defined in the APEX Task Definition.
- Flows for APEX task lists continue to use the existing fallback technical subject string.

### Why Use Existing `apex.subject`

The existing BPMN XML for APEX Approval user tasks commonly stores subject inside:

```xml
<bpmn:userTask id="Activity_1ozp31e" name="B" apex:type="apexApproval" apex:manualInput="false">
  <bpmn:extensionElements>
    <apex:apexApproval>
      <apex:subject>fred</apex:subject>
    </apex:apexApproval>
  </bpmn:extensionElements>
</bpmn:userTask>
```

Even though `apex:subject` appears nested under `apex:apexApproval` in XML, the BPMN parser already flattens task subtype properties into the top-level `apex` JSON object in `flow_objects.objt_attributes`.

Therefore existing BPMN can already be read at runtime as:

```json
{
  "apex": {
    "subject": "fred",
    "applicationId": "...",
    "taskStaticId": "..."
  },
  "taskType": "apexApproval"
}
```

This means no BPMN migration is required for the user-task side of this feature.

## Functional Requirements

### 1. Runtime Storage

Add a new column to `flow_subflows`:

- `sbfl_subject varchar2(...)`

Purpose:

- store the evaluated runtime subject for the current step
- expose it consistently through views and APIs
- prevent repeated recalculation in every task-list query

### 2. Subject Evaluation Timing

The subject should be evaluated:

- after `beforeTask` variable expressions have been processed
- after any input parameters needed for the step have been set or stored
- before the task becomes visible in any Flows task list

This matches the desired behavior because:

- `beforeTask` expressions already run before task dispatch
- AHSP activity input parameters are already processed before child subflow startup
- APEX Human Task creation already evaluates Flows substitutions before calling APEX

### 3. Supported Substitutions

Subject evaluation uses normal Flows for APEX substitution behavior.

Supported:

- scalar process variables
- built-in Flows substitutions such as process id, subflow id, scope, step key where applicable
- mixed-substitution strings where Flows substitutions are resolved first and APEX may resolve additional APEX-side substitutions later for AHT

Not required:

- direct substitution from arbitrary JSON keys in task input JSON

If a scalar must be extracted from JSON for use in a subject, that should be done earlier using a variable expression.

### 4. Runtime Fallback Behavior

If `sbfl_subject` is null, Flows task-list surfaces continue to use the current fallback subject logic, typically based on process name, business reference, and current object name.

This preserves backward compatibility for all existing diagrams that do not define a subject.

## BPMN and Parser Behavior

### User Tasks

For user tasks, the feature uses the existing subject attribute that the parser already exposes as `objt_attributes."apex"."subject"`.

This applies to:

- APEX Approval backed user tasks
- other Flows user task subtypes that may use a subject in future

### APEX Human Task Backed User Tasks

For APEX Human Task backed user tasks:

- if `apex.subject` is defined, Flows evaluates it and:
  - stores the evaluated result in `flow_subflows.sbfl_subject`
  - passes the same evaluated result to `APEX_HUMAN_TASK.CREATE_TASK(... p_subject => ...)`
- if `apex.subject` is not defined:
  - Flows does not override APEX task-definition subject
  - `sbfl_subject` remains null
  - Flows UI falls back to the existing technical subject string

This preserves legacy behavior and adds consistent runtime subject support for the Flows task list.

### AHSP

AHSP is EE-only, but the core runtime subject feature is CE.

AHSP itself is not an APEX Human Task subtype, so its subject should be implemented as its own AHSP property in EE when needed. That property should be evaluated and stored into `sbfl_subject` for the adhoc subprocess header subflow.

This allows the CE runtime column and task-list plumbing to be shared, while AHSP-specific subject authoring remains an EE extension.

## Precedence Rules

### User Task Backed by APEX Human Task

1. If `apex.subject` is present, it is the explicit subject override.
2. Flows substitutions are evaluated first.
3. The evaluated string is stored in `sbfl_subject`.
4. The evaluated string is passed to APEX Human Task as `p_subject`.
5. If APEX itself can perform further substitution on the resulting string, that remains APEX behavior.
6. If `apex.subject` is absent, APEX task definition subject remains in control.

### Flows Task List Display

1. Use `sbfl_subject` if present.
2. Otherwise use existing fallback technical subject text.

### AHSP Display

1. Use AHSP-specific subject setting if defined.
2. Store evaluated result into `sbfl_subject` on the AHSP header subflow.
3. Otherwise use existing fallback technical subject text.

## Database Changes

### Table: `flow_subflows`

Add:

- `sbfl_subject`

This must be included in:

- CE scratch install DDL
- CE migration script
- any read-only or admin views that expose runtime subflow state
- task-list supporting views and APIs

### Migration Requirement

The migration must check for `SBFL_SUBJECT` independently.

Do not bundle this into an older migration block that only checks for earlier adhoc-subprocess columns. Otherwise upgraded instances that already have those columns may fail to receive `SBFL_SUBJECT`.

## Runtime Package Changes

### `flow_usertask_pkg`

Enhance task-processing logic so that user-task subject handling does the following:

- read `objt_attributes."apex"."subject"`
- evaluate Flows substitutions
- persist the evaluated result to `flow_subflows.sbfl_subject`
- for APEX Human Tasks, pass the evaluated result to APEX `p_subject`

This should be centralized in a helper to avoid duplicating subject-resolution logic across:

- APEX page tasks
- APEX approval / human tasks
- future user-task variants

### `flow_engine`

When a step completes and the subflow is advanced to its next current object, clear task-specific runtime metadata including:

- `sbfl_subject`

This prevents stale business subject values from appearing on subsequent non-task steps or later tasks that reuse the same subflow row.

## View and API Changes

### Views

Update all relevant task/subflow views to expose and use `sbfl_subject`.

At minimum:

- `flow_subflows_vw`
- `flow_apex_task_inbox_vw`
- `flow_apex_task_inbox_my_tasks_vw` if required by its base query
- engine/admin subflow views that should expose the runtime subject

The display logic should generally be:

```sql
coalesce(sbfl.sbfl_subject, <existing fallback subject expression>)
```

### `flow_api_pkg`

Update the current-task API to:

- select `sbfl_subject`
- use it in `l_task.subject` with fallback to current technical subject generation

This is important because the modified combined task list unions:

- APEX managed tasks
- Flows managed tasks

Using a unified runtime subject model makes those two lists behave consistently.

## UX Behavior

### Before This Feature

End users see technical task labels such as:

- process name + business reference + BPMN object name

### After This Feature

If a subject is defined, end users should see business-friendly text such as:

- `Return lost bag BA123456 (Emily Carter)`
- `Review customer request for order 84731`
- `Approve travel request for Alex Green`

If no subject is defined, existing behavior remains unchanged.

## Backward Compatibility

This feature must be backward compatible.

### Existing BPMN

- No BPMN migration required for existing APEX Approval user tasks that already use nested `<apex:apexApproval><apex:subject>...`
- Parser already normalizes this into `objt_attributes."apex"."subject"`
- Existing diagrams continue to work unchanged

### Existing Runtime

- If no subject is defined, existing task-list behavior remains unchanged
- Existing APEX Human Task definitions continue to use their own task-definition subject unless explicitly overridden via BPMN `apex.subject`

## Implementation Notes

### Recommended Runtime Helper

Create a helper in CE that:

- accepts process id, subflow id, object id, scope, and step key
- reads `apex.subject` from object attributes
- performs Flows substitution
- writes `sbfl_subject`
- returns the evaluated value for reuse by AHT creation where needed

That allows one resolution path to be used for both:

- Flows-native task-list rendering
- APEX Human Task subject override

### Mixed Flows and APEX Substitutions

A subject string may intentionally include both:

- Flows substitutions resolved by Flows for APEX
- APEX substitutions resolved later by APEX

Example:

```text
User &F4A$NAME. order number &ORDER_NUM.
```

Expected behavior:

- Flows resolves `&F4A$NAME.` first
- the resulting string is passed onward
- APEX may later resolve `&ORDER_NUM.` if applicable in that execution path

This behavior should be preserved.

## Implementation Checklist

### Suggested Build Order

1. Add runtime storage in CE DDL and migration.
2. Add subject resolution and persistence in CE runtime packages.
3. Clear runtime subject on step transition.
4. Push subject through CE views and CE task APIs.
5. Add regression coverage for user-task and fallback behavior.
6. Optionally add AHSP subject support in EE, reusing CE runtime plumbing.

### CE Database and Migration

- [ ] Update `src/ddl/install_scratch.sql`
   - add `sbfl_subject` to `flow_subflows`
   - place it near other task runtime metadata such as due date, priority, and assignment fields
- [ ] Update `src/migrations/25.1_to_26.1/feature-adhoc-subprocs.sql`
   - add an independent existence check for `SBFL_SUBJECT`
   - add `alter table flow_subflows add ( sbfl_subject ... )`
   - do not hide this under the older adhoc-column migration gate

### CE Runtime Subject Resolution

- [ ] Update `src/plsql/flow_usertask_pkg.pks`
   - add a helper signature for resolving and storing task subject
- [ ] Update `src/plsql/flow_usertask_pkg.pkb`
   - add helper to read `objt_attributes."apex"."subject"`
   - perform Flows substitution using process id, subflow id, step key, and scope
   - write the evaluated result to `flow_subflows.sbfl_subject`
   - return the evaluated result for reuse by APEX Human Task creation
- [ ] Update `process_apex_page_task` in `src/plsql/flow_usertask_pkg.pkb`
   - call the helper so F4A runtime tasks get `sbfl_subject`
- [ ] Update `process_apex_approval_task` in `src/plsql/flow_usertask_pkg.pkb`
   - continue using `apex.subject`
   - ensure the evaluated value is stored in `sbfl_subject`
   - pass the same evaluated value to `APEX_HUMAN_TASK.CREATE_TASK(... p_subject => ...)`
   - if `apex.subject` is null, leave APEX task-definition subject behavior unchanged

### CE Step Cleanup

- [ ] Update `src/plsql/flow_engine.pkb`
   - in the update that advances `flow_subflows` to the next current object
   - clear `sbfl_subject` together with other task-specific runtime values
   - verify that the field does not persist onto later steps on the same subflow row

### CE Views and Task APIs

- [ ] Update `src/views/flow_subflows_vw.sql`
   - expose `sbfl_subject`
- [ ] Update `src/views/flow_apex_task_inbox_vw.sql`
   - use `coalesce(sbfl.sbfl_subject, <existing fallback>) as subject`
- [ ] Review `src/views/flow_apex_task_inbox_my_tasks_vw.sql`
   - confirm no direct change is required beyond the base inbox view output
- [ ] Update `src/views/engine-app/flow_p0008_subflows_vw.sql`
   - expose `sbfl_subject` if useful for runtime/admin troubleshooting
- [ ] Update `src/plsql/flow_api_pkg.pkb`
   - include `sbfl_subject` in task query record types and cursors
   - use `sbfl_subject` in `l_task.subject` with fallback to existing technical text
- [ ] Review `src/views/flow_apex_my_combined_task_list_vw.sql`
   - confirm union behavior remains correct once F4A side emits business subject text

### CE Parser and BPMN Compatibility Validation

- [ ] Validate that no parser code change is required for existing APEX Approval BPMN
   - existing nested `<apex:apexApproval><apex:subject>...` must continue to parse to `objt_attributes."apex"."subject"`
- [ ] Confirm user-task authoring guidance in docs
   - `apex.subject` remains the user-task subject source
   - no BPMN migration required for existing approval-task XML

### CE Regression Tests

- [ ] Add or update tests for user tasks with no explicit subject
   - Flows task list falls back to technical subject
   - AHT uses task-definition subject when BPMN subject is absent
- [ ] Add or update tests for user tasks with `apex.subject`
   - Flows substitution occurs
   - evaluated value lands in `sbfl_subject`
   - same value is passed to AHT when task type is APEX Human Task
- [ ] Add or update tests for mixed Flows and APEX substitutions
   - Flows substitutions resolve first
   - unresolved APEX substitutions are preserved for APEX-side processing
- [ ] Add or update tests for step cleanup
   - `sbfl_subject` is cleared when the step completes
- [ ] Add or update tests for task API/view fallback behavior
   - `coalesce(sbfl_subject, fallback)` works as expected

### EE Optional Follow-On for AHSP

- [ ] Define AHSP-specific BPMN subject property in EE modeler/parser design
   - do not treat AHSP as an APEX Human Task subtype
- [ ] Update `src/plsql/flow_adhoc_subprocesses.pkb` in EE
   - evaluate AHSP header subject when the adhoc subprocess becomes task-list visible
   - store evaluated value into `sbfl_subject` on the AHSP header subflow
- [ ] Add EE tests for AHSP header subject and fallback behavior

### Validation Before Merge

- [ ] Confirm CE installs cleanly from scratch
- [ ] Confirm CE migration applies on an upgraded schema that already has adhoc-subprocess columns
- [ ] Confirm task lists show subject consistently across:
   - F4A runtime task lists
   - combined APEX + F4A task list integration
- [ ] Confirm no regression to existing APEX Human Task subject behavior when BPMN subject is null

## Test Coverage

### Unit / Regression Areas

1. User task with no subject defined
   - Flows task list uses fallback technical subject
   - AHT uses APEX task-definition subject if applicable

2. APEX Human Task with `apex.subject`
   - Flows substitutions are applied
   - evaluated value stored in `sbfl_subject`
   - same value passed to APEX `p_subject`

3. Mixed Flows and APEX substitutions
   - Flows-side substitutions are resolved first
   - remaining APEX substitutions are preserved for APEX resolution

4. Subject cleared after step completion
   - `sbfl_subject` is null on the next current step unless explicitly set again

5. Task list API fallback
   - when `sbfl_subject` is null, fallback subject still appears

6. Existing BPMN approval task XML
   - nested `<apex:apexApproval><apex:subject>` continues to parse to runtime `apex.subject`

7. AHSP header subject in EE
   - if implemented, AHSP-specific subject is evaluated and stored in `sbfl_subject`
   - if not defined, fallback text remains

## Open Questions

1. What datatype/length should `sbfl_subject` use?
   Recommendation: large enough for realistic business subject text, aligned with existing subject/task display expectations.

2. Should admin/runtime views expose both fallback and evaluated subject for debugging?
   Recommendation: not initially required; `sbfl_subject` plus current object metadata should be sufficient.

3. Should subject be exposed in event logging?
   Recommendation: optional later enhancement, not required for first delivery.

## Proposed Delivery Split

### CE

- `flow_subflows.sbfl_subject`
- runtime subject evaluation for user tasks
- clear subject on step completion
- task-list and subflow view plumbing
- API updates
- tests for user-task behavior and fallback behavior

### EE

- AHSP-specific subject authoring and evaluation
- reuse CE runtime storage and display plumbing

## Summary

This feature introduces a runtime business subject for Flows for APEX task presentation using the existing parsed `apex.subject` for user tasks, stores the evaluated result on `flow_subflows.sbfl_subject`, clears it when the step completes, and exposes it consistently across Flows task lists.

The design preserves existing APEX Human Task behavior, does not require BPMN migration for current approval-task XML, and keeps the core capability in CE while allowing EE AHSP to reuse the same runtime model.
