create or replace view flow_p0014_instance_log_vw
as
  select lgpr.lgpr_prcs_id
       , lgpr.lgpr_prcs_name
       , lgpr.lgpr_business_id
       , lgpr.lgpr_prcs_event
       , case lgpr.lgpr_prcs_event
           when 'started' then 'fa-play'
           when 'created' then 'fa-plus'
           when 'completed' then 'fa-check'
           when 'terminated' then 'fa-stop-circle-o'
           when 'error' then 'fa-warning'
           when 'reset' then 'fa-undo'
         end as lgpr_prcs_event_icon
       , lgpr.lgpr_timestamp
       , lgpr.lgpr_user
       , lgpr.lgpr_comment
    from flow_instance_event_log lgpr
with read only;
