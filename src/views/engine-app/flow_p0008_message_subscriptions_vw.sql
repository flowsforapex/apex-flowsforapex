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
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0008_message_subscriptions_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Active message subscriptions with action placeholder for engine app page 8'
  )]';
    execute immediate q'[alter view flow_p0008_message_subscriptions_vw modify (action annotations (add content 'Null placeholder for an inline action column'))]';
  end if;
end;
/

whenever sqlerror exit failure
