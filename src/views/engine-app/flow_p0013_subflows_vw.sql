create or replace view flow_p0013_subflows_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_prcs_id
       , sbfl.sbfl_step_key
       , sbfl.sbfl_process_level
       , sbfl.sbfl_diagram_level
       , sbfl.sbfl_scope
       , sbfl.sbfl_last_completed
       , sbfl.sbfl_current
       , sbfl.sbfl_status
       , sbfl.sbfl_became_current at time zone sessiontimezone as sbfl_became_current
       , sbfl.sbfl_work_started at time zone sessiontimezone as sbfl_work_started
       , sbfl.sbfl_reservation
       , sbfl.sbfl_last_update at time zone sessiontimezone as sbfl_last_update
       , sbfl.sbfl_apex_task_id
    from flow_subflows sbfl
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0013_subflows_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Subflows with timezone-adjusted timestamps for the debug panel in engine app page 13'
  )]';
  end if;
end;
/

whenever sqlerror exit failure
