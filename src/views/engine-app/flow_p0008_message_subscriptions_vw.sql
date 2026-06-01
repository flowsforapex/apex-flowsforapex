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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0008_message_subscriptions_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Active message subscriptions with action placeholder for engine app page 8'
  );

alter view flow_p0008_message_subscriptions_vw modify (action annotations (add content 'Null placeholder for an inline action column'));

whenever sqlerror exit failure
