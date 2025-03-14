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