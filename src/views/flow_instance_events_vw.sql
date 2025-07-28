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
select lgpr_prcs_event as operation
     , lgpr_prcs_event description
     , coalesce (objt.objt_name, lgpr_objt_id) as objt
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
  join flow_objects objt
    on lgpr_objt_id = objt.objt_bpmn_id
   and lgpr_dgrm_id = objt.objt_dgrm_id
/*union 
select 'variable set' as operation
     , 'Variable set' as description
     , coalesce (objt.objt_name, lgvr_objt_id) as objt
     , lgvr_sbfl_id as subflow
     , null as step_key
     , 8 as severity
     , null as process_level
     , lgvr_var_name as proc_var
     , case lgvr_var_type 
          when 'VARCHAR2' then lgvr_var_vc2
          when 'NUMBER' then to_char(lgvr_var_num)
          when 'DATE' then to_char (lgvr_var_date, 'DD-MON-YY HH24:MI:SS')
          when 'TIMESTAMP WITH TIME ZONE' then to_char (lgvr_var_tstz, 'DD-MON-YY HH24:MI:SS TZR')
          when 'CLOB' then 'CLOB Value'
          end as value
     , lgvr_expr_set as event_comment
     , lgvr_timestamp as performed_on
     , null as performed_by
     , lgvr_prcs_id as prcs_id 
  from flow_variable_event_log lgvr
  join flow_processes prcs
    on lgvr.lgvr_prcs_id = prcs.prcs_id
  join flow_objects objt
    on objt.objt_bpmn_id = lgvr.lgvr_objt_id
   and objt.objt_dgrm_id = prcs.prcs_dgrm_id */
order by performed_on
with read only;
