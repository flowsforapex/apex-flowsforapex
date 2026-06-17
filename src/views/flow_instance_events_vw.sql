/* 
-- Flows for APEX - flow_instance_events_vw.sql
-- 
--
-- Created    09-Jul-2025  Louis Moreaux, Talan
--
-- This view shows logged events for a process
--
--
*/
create or replace view flow_instance_events_vw as
with events as (
     select lgpr_prcs_event as operation
     , lgpr_prcs_event description
     , coalesce (objt.objt_name, lgpr_objt_id) as objt
     , coalesce (objt.objt_tag_name, 'bpmn:process') as object_type
     , objt.objt_sub_tag_name as object_sub_type
     , nvl( objt.objt_interrupting, 2) as object_interrupting
     , lgpr_sbfl_id as subflow
     , lgpr_step_key as step_key
     , lgpr_severity as severity
     , lgpr_process_level as process_level
     , null as proc_var
     , null as value
     , lgpr_comment as event_comment
     , lgpr_timestamp as performed_on
     , lgpr_user as performed_by
     , lgpr_prcs_id as prcs_id 
  from flow_instance_event_log   
  left outer join flow_objects objt
    on lgpr_objt_id = objt.objt_bpmn_id
   and lgpr_dgrm_id = objt.objt_dgrm_id
)
select events.operation
     , events.description
     , events.objt
     , events.object_type
     , events.object_sub_type
     , bpmn.bpmn_icon
     , bpmn.bpmn_super_type as bpmn_super_type
     , events.proc_var
     , events.value
     , events.subflow
     , events.step_key
     , events.severity
     , events.process_level
     , events.event_comment
     , events.performed_on
     , events.performed_by
     , events.prcs_id
  from events
  join flow_bpmn_types bpmn
    on bpmn.bpmn_tag_name               = events.object_type
   and nvl(bpmn.bpmn_sub_tag_name, 'X') = nvl(events.object_sub_type, 'X')
   and nvl(bpmn.bpmn_interrupting, 2)   = events.object_interrupting
order by events.performed_on
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_instance_events_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Process event log with object types, severity levels, and performer information'
  )]';
    execute immediate q'[alter view flow_instance_events_vw modify (operation       annotations (add content 'Event operation type, e.g. complete, start, error, set-variable'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (description     annotations (add content 'Human-readable description of the event'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (objt            annotations (add content 'BPMN ID of the object involved in this event'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (object_type     annotations (add content 'BPMN element type of the object, e.g. bpmn:userTask'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (object_sub_type annotations (add content 'BPMN element sub-type, e.g. bpmn:messageEventDefinition'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (bpmn_icon       annotations (add content 'CSS icon class for the BPMN object type'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (bpmn_super_type annotations (add content 'High-level BPMN category: event, gateway, activity, etc.'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (proc_var        annotations (add content 'Process variable name involved in this event, if applicable'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (value           annotations (add content 'Variable value or event payload at the time of the event'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (subflow         annotations (add content 'Subflow ID on which the event occurred'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (step_key        annotations (add content 'Step key identifying the step within the process where the event occurred'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (severity        annotations (add content 'Event severity label: 1 to 8, with 1 being the most severe'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (process_level   annotations (add content 'Nesting level of the sub-diagram where the event occurred'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (event_comment   annotations (add content 'Optional descriptive comment attached to the event'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (performed_on    annotations (add content 'Timestamp when this event was recorded'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (performed_by    annotations (add content 'User or system that triggered this event'))]';
    execute immediate q'[alter view flow_instance_events_vw modify (prcs_id         annotations (add content 'Process instance this event belongs to'))]';
  end if;
end;
/

whenever sqlerror exit failure
