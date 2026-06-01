/* 
-- Flows for APEX - flow_p0020_instance_timeline_vw.sql
-- 
--
-- Modified    09-Jul-2025  Louis Moreaux, Talan
--
-- This view is used in the page 20 of the engine app
-- Don't use it in your own application
--
--
*/
create or replace view flow_p0020_instance_timeline_vw as
  select prcs_id
     , subflow
     , step_key
     , process_level
     , objt
     , object_type
     , object_sub_type
     , bpmn_icon
     , bpmn_super_type
     , performed_on
     , lower(performed_by) user_name
     , severity
     , operation as event_type
     , event_comment
     , case operation
        when 'current step' then 'is-new'
        when 'step started' then 'is-updated'
        when 'step completed' then 'is-new'
        when 'completed' then 'is-removed'
        when 'started' then 'is-new'
        when 'created' then 'is-new'
        when 'reset' then 'is-removed'
        when 'error' then 'is-removed'
        when 'variable set' then 'is-updated'
        when 'Gateway Processed' then 'is-updated'
        when 'start called model' then 'is-new'
        when 'finish called model' then 'is-new'
       end as event_status
     , case operation
        when 'current step' then 'fa fa-circle-o'
        when 'step started' then 'fa fa-play-circle-o'
        when 'step interrupted' then 'fa fa-pause-circle-o'
        when 'step completed' then 'fa fa-check-circle-o'
        when 'completed' then 'fa fa-dot-circle-o'
        when 'started' then 'fa fa-circle-o'
        when 'created' then 'fa fa-server-new'
        when 'reset' then 'fa fa-fast-backward'
        when 'error' then 'fa fa-exclamation-circle'
        when 'variable set' then 'fa fa-window-terminal'
        when 'Gateway Processed' then 'fa fa-index'   
        when 'start called model' then 'fa fa-box-arrow-in-south'
        when 'finish called model' then 'fa fa-box-arrow-out-north'
       end as event_icon
from flow_instance_events_vw;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0020_instance_timeline_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Timeline of process instance events with operation types, icons, and APEX timeline CSS classes for engine app page 20'
  , add note    'This view is intended for use in the engine application and may be subject to change. Use only for single instance timelines, not for querying across multiple instances or for other applications.'
  );

alter view flow_p0020_instance_timeline_vw modify (user_name annotations (add content 'Username in lowercase'));
alter view flow_p0020_instance_timeline_vw modify (event_type annotations (add content 'Event operation type label (aliased from operation)'));
alter view flow_p0020_instance_timeline_vw modify (event_status annotations (add content 'APEX timeline CSS class for the event (is-new, is-updated, is-removed)'));
alter view flow_p0020_instance_timeline_vw modify (event_icon annotations (add content 'FA icon CSS class representing the event operation type'));

whenever sqlerror exit failure
