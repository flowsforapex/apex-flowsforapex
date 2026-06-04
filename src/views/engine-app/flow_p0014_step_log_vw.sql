create or replace view flow_p0014_step_log_vw
as
  select distinct lgsf.lgsf_prcs_id
                , coalesce(objt.objt_name, lgsf.lgsf_objt_id) as completed_object
                , lgsf.lgsf_step_key
                , lgsf.lgsf_sbfl_id
                , lgsf.lgsf_sbfl_process_level
                , lgsf.lgsf_last_completed
                , lgsf.lgsf_status_when_complete
                , lgsf.lgsf_was_current at time zone sessiontimezone as lgsf_was_current
                , lgsf.lgsf_started at time zone sessiontimezone as lgsf_started
                , lgsf.lgsf_completed at time zone sessiontimezone as lgsf_completed
                , lgsf.lgsf_reservation
                , lgsf.lgsf_user
                , lgsf.lgsf_apex_task_id
                , lgsf.lgsf_comment
             from flow_step_event_log lgsf
             join flow_objects objt
               on lgsf.lgsf_objt_id = objt.objt_bpmn_id
              and lgsf.lgsf_sbfl_dgrm_id = objt.objt_dgrm_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0014_step_log_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Step completion log with object name lookup and timezone-adjusted timestamps for engine app page 14'
  )]';
    execute immediate q'[alter view flow_p0014_step_log_vw modify (completed_object annotations (add content 'Display name of the completed BPMN object, falling back to the BPMN ID'))]';
  end if;
end;
/

whenever sqlerror exit failure
