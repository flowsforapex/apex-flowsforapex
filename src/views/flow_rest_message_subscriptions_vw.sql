create or replace view flow_rest_message_subscriptions_vw
      (
         msub_id
       , name
       , key
       , value
       , prcs_id
       , sbfl_id
       , step_key    
      )
  as
  select ms.msub_id
       , ms.msub_message_name as name
       , ms.msub_key_name     as key
       , ms.msub_key_value    as value
       , ms.msub_prcs_id      as prcs_id
       , ms.msub_sbfl_id      as sbfl_id
       , ms.msub_step_key     as step_key
  from flow_message_subscriptions ms;