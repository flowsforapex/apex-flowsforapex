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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_rest_message_subscriptions_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Active message subscriptions with simplified column names for REST API client consumption'
  )]';
    execute immediate q'[alter view flow_rest_message_subscriptions_vw modify (msub_id  annotations (add content 'Unique message subscription identifier'))]';
    execute immediate q'[alter view flow_rest_message_subscriptions_vw modify (name     annotations (add content 'Message name this subscription is listening for'))]';
    execute immediate q'[alter view flow_rest_message_subscriptions_vw modify (key      annotations (add content 'Correlation key name for message routing'))]';
    execute immediate q'[alter view flow_rest_message_subscriptions_vw modify (value    annotations (add content 'Correlation key value for message routing'))]';
    execute immediate q'[alter view flow_rest_message_subscriptions_vw modify (prcs_id  annotations (add content 'Process instance waiting for this message'))]';
    execute immediate q'[alter view flow_rest_message_subscriptions_vw modify (sbfl_id  annotations (add content 'Subflow waiting for this message'))]';
    execute immediate q'[alter view flow_rest_message_subscriptions_vw modify (step_key annotations (add content 'Step key of the receiving message event'))]';
  end if;
end;
/

whenever sqlerror exit failure
