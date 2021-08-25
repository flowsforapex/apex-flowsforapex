create or replace view flow_p0014_instance_log_vw
as
  select lgpr.lgpr_prcs_id
       , lgpr.lgpr_prcs_name
       , lgpr.lgpr_business_id
       , lgpr.lgpr_prcs_event
       , lgpr.lgpr_timestamp
       , lgpr.lgpr_user
       , lgpr.lgpr_comment
    from flow_instance_event_log lgpr
with read only;
