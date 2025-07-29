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
     , to_char(performed_on, 'YYYY-MM-DD HH24:MI:SSXFF TZR') event_date
     , lower(performed_by) user_name
     , case operation
        when 'variable set' then 'Variable "'||proc_var||'" set to "'||value||'".'
        when 'current step' then 'Step '||objt||' became Current'
        when 'step started' then 'Step '||objt||' started work'
        when 'step completed' then 'Step '||objt||' completed'
        when 'created' then 'Process Instance Created'
        when 'started' then 'Process Instance Started'
        else description
       end as event_title
     , operation as event_type
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
        when 'current step' then 'subflow '||subflow|| ' • process level '||process_level||nvl2(value,' • previous step  '||value,'')
        when 'step started' then 'subflow '||subflow|| nvl2(value,' • reserved by '||value,' • not reserved')
        when 'step completed' then null
        when 'created' then 'process '||prcs_id||nvl2(value,' • name '||value,'')
        when 'started' then 'process '||prcs_id||nvl2(value,' • name '||value,'')    
        when 'variable set' then 
                  nvl2(objt,'step '||objt||' ','')
                ||nvl2(subflow,'• subflow '||subflow||' ','')
                ||nvl2(event_comment,'• expression set '||event_comment,'')
        when 'Gateway Processed' then 'subflow '||subflow||' • forward paths - '||event_comment
        when 'start called model' then event_comment
        when 'finish called model' then event_comment
        else 'Object '||objt||'  subflow ' ||subflow||' • variable '||proc_var||' • value '||value        
       end as event_desc
     , 'u-color-44 fa fa-clock-o' as USER_COLOR
     , case operation
        when 'current step' then 'fa fa-circle-o'
        when 'step started' then 'fa fa-play-circle-o'
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
     , operation
     , objt
     , object_type
     , object_sub_type
     , bpmn_icon
     , bpmn_super_type
     , proc_var
     , value
     , subflow
     , step_key
     , process_level
     , severity
     , performed_by
from flow_instance_events_vw;
