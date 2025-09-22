create or replace view flow_rest_step_event_log_vw
      (
          lgsf_prcs_id
        , lgsf_objt_id 
      )
  as
  select  lgsf_prcs_id
        , lgsf_objt_id 
    from flow_step_event_log d;