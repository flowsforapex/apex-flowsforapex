# Flows for APEX Feature Spec - Adhoc SubProceses

## BPMN Syntax

- completion condition
- tasks to start - F4A setting allowing static (list), proc var (list, array), SQL single, sql multi, expression, function)

## Database Objects

### View to show startable tasks

### view to show adhoc subproc status. (available activities, completed activities, etc)

- can we add descriptions to the available tasks so that LLM can understand what each activity does
- 

Add a flag to flow_subflows sbfl_is_adhoc

Package in ee flow-adhoc-sub processes 

- start_adhoc_subflow calls start subflow  with is_adhoc set
- End_adhoc_subflow.  Checks completion condition then ends
- Start_adhoc_subproc - get starting variable, loop through starting subflows calling start_adhoc_subflow 
- Complete adhoc subproc- clear up level

? Rework terminate level code to work for an embedded adhoc

Related projects

- task description and expose through view for LLM
- JSON prov var json path. 



## PL/SQL API

 - start an adhoc task
 - set adhoc subproc complete





