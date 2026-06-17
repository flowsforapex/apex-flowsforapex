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
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_message_subscriptions_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Active message subscriptions waiting to receive events for process continuation'
  )]';
  end if;
end;
/

whenever sqlerror exit failure
