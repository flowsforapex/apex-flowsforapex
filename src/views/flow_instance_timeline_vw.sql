/* 
-- Flows for APEX - flow_instance_timeline_vw.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    01-Feb-2023  Richard Allen (Oracle)
-- Edited     05-Jun-2023  Louis Moreaux, Insum
--
-- This view shows timeline of all logged events for a process
--
--
*/
create or replace view flow_instance_timeline_vw as
select 'created' operation
     , 'Instance Created' description
     , null as objt
     , null as subflow
     , 0 as process_level
     , null as proc_var
     , prcs.prcs_name as value
     , null as event_comment
     , prcs_init_ts performed_on
     , prcs_init_by performed_by
     , prcs_id 
  from flow_processes prcs
union
select 'started' operation
     , 'Instance Started' description
     , null as objt
     , null as subflow
     , 0 as process_level
     , null as proc_var 
     , prcs.prcs_name as value
     , null as event_comment
     , prcs_start_ts performed_on
     , null
     , prcs_id 
  from flow_processes prcs
union
select 'completed' operation
     , 'Instance completed' description
     , null as objt
     , null as subflow
     , 0 as process_level
     , null as proc_var
     , null as value
     , null as event_comment
     , prcs_start_ts performed_on
     , null
     , prcs_id 
  from flow_processes prcs
 where prcs.prcs_complete_ts is not null
union
select lgpr_prcs_event operation
     , lgpr_prcs_event 
     , lgpr_objt_id
     , null as subflow
     , null as process_level
     , null as proc_var
     , null as value
     , lgpr_comment as event_comment
     , lgpr_timestamp performed_on
     , lgpr_user
     , lgpr_prcs_id as prcs_id
  from    flow_instance_event_log lgpr
union 
select 'step current' as operation
     , 'Became Current after' as description
     , lgsf_objt_id as objt
     , lgsf_sbfl_id as subflow
     , lgsf_sbfl_process_level as process_level
     , null as proc_var
     , lgsf_last_completed as value
     , lgsf_comment as event_comment
     , lgsf_was_current as performed_on
     , null as performed_by
     , lgsf_prcs_id as prcs_id 
  from flow_step_event_log
union
select 'step started' as operation
     , 'Work Started on Step' description
     , lgsf_objt_id as objt
     , lgsf_sbfl_id as subflow
     , lgsf_sbfl_process_level as process_level
     , null as proc_var
     , null as value
     , lgsf_comment as event_comment
     , lgsf_started as performed_on
     , null as performed_by
     , lgsf_prcs_id as prcs_id 
  from flow_step_event_log
 where lgsf_started is not null
union 
select 'step completed' as operation
     , 'Step completed' description
     , lgsf_objt_id as objt
     , lgsf_sbfl_id as subflow
     , lgsf_sbfl_process_level as process_level
     , null as proc_var
     , null as value
     , lgsf_comment as event_comment
     , lgsf_completed as performed_on
     , lgsf_user as performed_by
     , lgsf_prcs_id as prcs_id 
  from flow_step_event_log   
union 
select 'variable set' as operation
     , 'Variable set' as description
     , lgvr_objt_id as objt
     , lgvr_sbfl_id as subflow
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
  from    flow_variable_event_log
order by performed_on
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_instance_timeline_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Unified timeline of all process events including creation, start, step transitions, and variable assignments'
  )]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (operation     annotations (add content 'Event operation type'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (description   annotations (add content 'Human-readable description of the event'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (objt          annotations (add content 'BPMN ID of the object involved'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (subflow       annotations (add content 'Subflow ID on which the event occurred'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (process_level annotations (add content 'Nesting level where the event occurred'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (proc_var      annotations (add content 'Process variable name, for variable assignment events'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (value         annotations (add content 'Variable value at the time of assignment'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (event_comment annotations (add content 'Optional descriptive comment'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (performed_on  annotations (add content 'Timestamp when this event occurred'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (performed_by  annotations (add content 'User or system that triggered this event'))]';
    execute immediate q'[alter view flow_instance_timeline_vw modify (prcs_id       annotations (add content 'Process instance this timeline entry belongs to'))]';
  end if;
end;
/

whenever sqlerror exit failure
