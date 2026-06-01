create or replace view flow_message_subscriptions_vw
as
   select mes.msub_id,
          mes.msub_message_name,
          mes.msub_key_name,
          mes.msub_key_value,
          mes.msub_prcs_id,
          mes.msub_sbfl_id,
          mes.msub_step_key,
          mes.msub_dgrm_id,
          mes.msub_callback,
          mes.msub_callback_par,
          mes.msub_payload_var,
          mes.msub_created
     from flow_message_subscriptions mes
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_message_subscriptions_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Active message subscriptions waiting to receive events for process continuation'
  );

whenever sqlerror exit failure
