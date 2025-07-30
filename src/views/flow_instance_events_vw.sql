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
