create or replace view flow_rest_step_event_log_vw
      (
          lgsf_prcs_id
        , lgsf_objt_id 
      )
  as
  select  lgsf_prcs_id
        , lgsf_objt_id 
    from flow_step_event_log d;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_rest_step_event_log_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Step event log entries formatted for REST API responses'
  )]';
    execute immediate q'[alter view flow_rest_step_event_log_vw modify (lgsf_prcs_id annotations (add content 'Process instance this log entry belongs to'))]';
    execute immediate q'[alter view flow_rest_step_event_log_vw modify (lgsf_objt_id annotations (add content 'Object ID involved in this step event'))]';
  end if;
end;
/

whenever sqlerror exit failure
