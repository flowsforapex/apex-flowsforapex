create or replace package flow_msg_subscription as
/* 
-- Flows for APEX - flow_msg_subscription.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created  04-Mar-2034  Richard Allen (Oracle Corporation)
--
*/

  type t_subscription_details is record
  ( message_name  flow_message_subscriptions.msub_message_name%type
  , key_name      flow_message_subscriptions.msub_key_name%type
  , key_value     flow_message_subscriptions.msub_key_value%type
  , prcs_id       flow_message_subscriptions.msub_prcs_id%type
  , sbfl_id       flow_message_subscriptions.msub_sbfl_id%type
  , step_key      flow_message_subscriptions.msub_step_key%type
  , callback      flow_message_subscriptions.msub_callback%type
  , payload_var   flow_message_subscriptions.msub_payload_var%type
  );   

  function subscribe
  ( p_subscription_details     in t_subscription_details
  ) return flow_message_subscriptions.msub_id%type;

  procedure receive_message
  ( p_message_name  flow_message_subscriptions.msub_message_name%type
  , p_key_name      flow_message_subscriptions.msub_key_name%type
  , p_key_value     flow_message_subscriptions.msub_key_value%type
  , p_payload       clob default null
  );

end flow_msg_subscription;
/
