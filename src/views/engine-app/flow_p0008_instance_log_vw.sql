create or replace view flow_p0008_instance_log_vw
as
  select lgpr.lgpr_prcs_id
       , lgpr.lgpr_prcs_name
       , lgpr.lgpr_business_id
       , lgpr.lgpr_prcs_event
       , case lgpr.lgpr_prcs_event
           when 'started' then 'fa-play-circle-o'
           when 'running' then 'fa-play-circle-o'
           when 'created' then 'fa-plus-circle-o'
           when 'completed' then 'fa-check-circle-o'
           when 'terminated' then 'fa-stop-circle-o'
           when 'error' then 'fa-exclamation-circle-o'
           when 'reset' then 'fa-undo'
           when 'restart step' then 'fa-undo'
           when 'rescheduled' then 'fa-clock-o'
         end as lgpr_prcs_event_icon
       , lgpr.lgpr_timestamp at time zone sessiontimezone as lgpr_timestamp
       , lgpr.lgpr_user
       , lgpr.lgpr_comment
       , lgpr_error_info
       , case when lgpr_error_info is not null then '<pre><code class="language-log">' end as pretag
       , case when lgpr_error_info is not null then '</code></pre>' end as posttag
       , lgpr.lgpr_objt_id
       , lgpr.lgpr_severity
    from flow_instance_event_log lgpr
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0008_instance_log_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Process instance event log with event icons and error HTML formatting for engine app page 8'
  )]';
    execute immediate q'[alter view flow_p0008_instance_log_vw modify (lgpr_prcs_event_icon annotations (add content 'FA icon CSS class representing the event type'))]';
    execute immediate q'[alter view flow_p0008_instance_log_vw modify (pretag annotations (add content 'HTML pre/code open tag for error info syntax display; null when no error'))]';
    execute immediate q'[alter view flow_p0008_instance_log_vw modify (posttag annotations (add content 'HTML pre/code close tag for error info syntax display; null when no error'))]';
  end if;
end;
/

whenever sqlerror exit failure
