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
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_rest_step_event_log_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Step event log entries formatted for REST API responses'
  );

alter view flow_rest_step_event_log_vw modify (lgsf_prcs_id annotations (add content 'Process instance this log entry belongs to'));
alter view flow_rest_step_event_log_vw modify (lgsf_objt_id annotations (add content 'Object ID involved in this step event'));

whenever sqlerror exit failure
