create or replace view flow_p0013_step_events_vw
as 
  select lgpr_prcs_id as lgpr_Process_ID
       , lgpr_objt_id as lgpr_Object_BPMN_ID
       , lgpr_sbfl_id as lgpr_Subflow_ID
       , lgpr_dgrm_id as lgpr_Diagram_ID
       , lgpr_step_key as lgpr_Step_Key
       , lgpr_prcs_event as lgpr_Event_type
       , lgpr_severity as Severity
       , lgpr_timestamp at time zone sessiontimezone as lgpr_Timestamp
       , lgpr_user as Lgpr_User
       , lgpr_error_info as lgpr_Error_Info
       , lgpr_apex_task_id as lgpr_APEX_Task_ID
       , lgpr_duration as lgpr_Duration
       , lgpr_comment as lgpr__Comment
    from flow_instance_event_log lgpr
    where lgpr_objt_id is not null
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0013_step_events_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Step-level events with display-friendly column aliases for engine app page 13'
  )]';
  end if;
end;
/

whenever sqlerror exit failure
