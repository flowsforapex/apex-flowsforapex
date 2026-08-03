create or replace view flow_p0008_instance_details_vw
as
  select 
       prcs_id,
       prcs_name,
       dgrm_name,
       dgrm_short_description,
       dgrm_version,
       prcs_status as status,
       prcs_priority as priority,
       prcs_init_ts at time zone sessiontimezone as initialized_on,
       prcs_last_update at time zone sessiontimezone as last_update_on,
       prcs_due_on at time zone sessiontimezone as due_on,
       prcs_business_ref as business_reference,
       prcs_was_altered as was_altered,
       prcs_logging_level as logging_level
  from flow_instances_vw
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0008_instance_details_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process instance detail with display-friendly column names for engine app page 8'
  )]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (status annotations (add content 'Process status (running, completed, error, etc.)'))]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (priority annotations (add content 'Process instance priority level'))]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (initialized_on annotations (add content 'Timestamp when the process was initialized, in session timezone'))]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (last_update_on annotations (add content 'Timestamp of the last modification, in session timezone'))]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (due_on annotations (add content 'Process due date and time in session timezone'))]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (business_reference annotations (add content 'Business reference value for this process instance'))]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (was_altered annotations (add content 'Y if the process diagram was altered while this instance was running'))]';
    execute immediate q'[alter view flow_p0008_instance_details_vw modify (logging_level annotations (add content 'Logging verbosity level configured for this process instance'))]';
  end if;
end;
/

whenever sqlerror exit failure
