---
name: edit-bpmn-diagram
description: 'Edit Flows for APEX BPMN diagrams in XML format with AI assistance. Use when: modifying existing process diagrams, adding/removing activities or flows, updating variable expressions, configuring APEX Page UserTasks or APEX Human Tasks, editing gateway expressions, updating AdHOC SubProcess definitions, preparing diagrams for API upload.'
argument-hint: 'Describe the diagram changes needed (e.g., "add a user task", "update gateway expression")'
---

# Edit Flows for APEX BPMN Diagram

Use this skill to modify BPMN diagram XML files with AI assistance, then upload them to Flows for APEX via API.

## When to Use

- Modify existing BPMN diagrams without the visual editor
- Add or remove activities, flows, events, or gateways
- Update Flows for APEX custom properties and extensions
- Batch-edit multiple diagrams programmatically
- Work with BPMN files outside the visual modeler interface

## Quick Workflow (5 Steps)

### 1. Understand the BPMN Structure
- BPMN files are XML documents with elements like `bpmn:process`, `bpmn:task`, `bpmn:sequenceFlow`
- Flows for APEX extensions appear in custom namespaces: `apex:`, typically as attributes or nested elements
- Each element has a unique `id` and optional `name`
- Connectors (flows) reference source and target elements via `sourceRef` and `targetRef`

### 2. Identify What to Modify
Locate elements in the XML using their:
- **Type**: `bpmn:task`, `bpmn:userTask`, `bpmn:serviceTask`, `bpmn:exclusiveGateway`, `bpmn:adHocSubProcess`, etc.
- **Name**: Human-readable label
- **ID**: Unique identifier (e.g., `Activity_abc123`)
- **Flows for APEX properties**: Common extensions include:
  - `apex:*` attributes on tasks and gateways
  - Variable expressions (e.g., `${variable}` references)
  - APEX Page UserTask configurations
  - APEX Human Task properties
  - Gateway Expressions for routing logic
  - AdHOC SubProcess definitions

### 3. Make the Changes
Common edits:
- **Update properties**: Modify `name`, attributes, or nested elements
- **Add elements**: Insert new tasks, gateways, or flows with unique IDs
- **Remove elements**: Delete elements and update any flows that reference them
- **Preserve structure**: Maintain proper XML nesting and valid element hierarchy

### 4. Validate the BPMN
- Check that `id` values are unique across the document
- Verify all `sourceRef` and `targetRef` values point to existing element IDs
- Ensure all elements have proper opening and closing tags
- Check Flows for APEX schema compliance using [flows4apex-bpmn-ext XSD](https://flowsforapex.org/xsd/flows4apex-bpmn-ext-v26.1.xsd)
- If the public URL is not yet available, use the repo copy at [flows4apex-bpmn-ext-v26.1.xsd](../../../doc/bpmn-extension-syntax/flows4apex-bpmn-ext-v26.1.xsd)

### 5. Upload to Flows for APEX
- Use the Flows for APEX Process API to upload the modified BPMN
- The modeler in Flows for APEX will validate and render the diagram
- If validation fails, review error messages and return to step 3

## Tips

- **Keep a backup** of the original BPMN file before major edits
- **Test incrementally**: Make one logical change, validate, then test in Flows for APEX before adding more
- **Reference the schema**: Review the BPMN extension syntax documentation for valid Flows for APEX properties
- **Use consistent formatting**: Maintain indentation and spacing for readability during reviews
- **Coordinate IDs**: If adding elements, ensure IDs don't conflict with existing ones (prepend with a timestamp or unique prefix)

## Related Resources

- [BPMN Extension Syntax Reference](../../../doc/bpmn-extension-syntax/)
- [Process API Documentation](../../../doc/flow_api_doc.md)
- [BPMN Examples](../../../bpmn_examples/)
- [BPMN Tutorials](../../../bpmn_tutorials/)
