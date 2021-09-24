create or replace view flow_p0014_instance_log_vw
as
  select lgpr.lgpr_prcs_id
       , lgpr.lgpr_objt_id
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
         end as lgpr_prcs_event_icon
       , lgpr.lgpr_timestamp at time zone sessiontimezone as lgpr_timestamp
       , lgpr.lgpr_user
       , lgpr.lgpr_comment
       , lgpr_error_info
       , case when lgpr_error_info is not null then '<pre><code class="language-log">' end as pretag
       , case when lgpr_error_info is not null then '</code></pre>' end as posttag
    from flow_instance_event_log lgpr
with read only;
