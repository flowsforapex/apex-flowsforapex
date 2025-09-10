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
