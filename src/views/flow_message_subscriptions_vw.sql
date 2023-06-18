create or replace view flow_message_subscriptions_vw
as
   select mes.msub_id,
          mes.msub_message_name,
          mes.msub_key_name,
          mes.msub_key_value,
          mes.msub_prcs_id,
          mes.msub_sbfl_id,
          mes.msub_step_key,
          mes.msub_callback,
          mes.msub_callback_par,
          mes.msub_payload_var,
          mes.msub_created
     from flow_message_subscriptions mes
with read only;