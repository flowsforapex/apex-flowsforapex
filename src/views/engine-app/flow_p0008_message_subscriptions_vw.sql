create or replace view flow_p0008_message_subscriptions_vw
as
   select mes.msub_id,
          mes.msub_message_name,
          mes.msub_key_name,
          mes.msub_key_value,
          mes.msub_prcs_id,
          mes.msub_payload_var,
          mes.msub_created,
          null as action
     from flow_message_subscriptions_vw mes
with read only;