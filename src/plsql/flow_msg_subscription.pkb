create or replace package body flow_msg_subscription as
/* 
-- Flows for APEX - flow_msg_subscription.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created  04-Mar-2034  Richard Allen (Oracle Corporation)
--
*/

  function subscribe
  ( p_subscription_details     in t_subscription_details
  ) return flow_message_subscriptions.msub_id%type
  is
    l_msub_id      flow_message_subscriptions.msub_id%type;
  begin
    insert into flow_message_subscriptions
    ( msub_message_name
    , msub_key_name
    , msub_key_value
    , msub_prcs_id
    , msub_sbfl_id
    , msub_step_key
    , msub_callback
    , msub_created
    )
    values 
    ( p_subscription_details.message_name
    , p_subscription_details.key_name
    , p_subscription_details.key_value
    , p_subscription_details.prcs_id
    , p_subscription_details.sbfl_id
    , p_subscription_details.step_key
    , p_subscription_details.callback
    , systimestamp
    ) returning msub_id into l_msub_id;
    return l_msub_id;
  end subscribe;

  procedure receive_message
    ( p_message_name  flow_message_subscriptions.msub_message_name%type
    , p_key_name      flow_message_subscriptions.msub_key_name%type
    , p_key_value     flow_message_subscriptions.msub_key_value%type
    , p_payload       clob default null
    )
  is
    l_process_id  flow_processes.prcs_id%type;
    l_subflow_id  flow_subflows.sbfl_id%type;
    l_step_key    flow_subflows.sbfl_step_key%type;
    l_msub_id     flow_message_subscriptions.msub_id%type;
    l_callback    flow_message_subscriptions.msub_callback%type;
  begin
    begin
      select msub.msub_prcs_id
           , msub.msub_sbfl_id
           , msub.msub_step_key
           , msub.msub_id
           , msub.msub_callback
        into l_process_id
           , l_subflow_id
           , l_step_key
           , l_msub_id
           , l_callback
        from flow_message_subscriptions msub
       where msub.msub_message_name    = p_message_name
         and msub.msub_key_name        = p_key_name
         and msub.msub_key_value       = p_key_value
         for update of msub_id wait 2
      ;
    exception
        when no_data_found then
          -- sdd some message-specific logging capability into here.
          flow_errors.handle_general_error
          ( pi_message_key => 'msg-not-correlated');
          raise no_data_found;
        -- add exceptions for lock time outs
    end;

    case l_callback
    when flow_constants_pkg.gc_bpmn_receivetask then
      -- Call Back is for a bpmn:receiveTask message
      -- do the delete before the callback because the callback will do a next-step, which commits at step end
      delete from flow_message_subscriptions
       where msub_id = l_msub_id;

      flow_tasks.receiveTask_callback 
      ( p_process_id    => l_process_id
      , p_subflow_id    => l_subflow_id
      , p_step_key      => l_step_key
      , p_msub_id       => l_msub_id
      , p_payload       => p_payload
      );
    when 'MessageICE' then
      -- Call Back is for a bpmn:intermediateCatchEvent - message subtype (Message Catch Event)
      -- do the delete before the callback because the callback will do a next-step, which commits at step end
      delete from flow_message_subscriptions
       where msub_id = l_msub_id;

      flow_engine.message_ICE_callback 
      ( p_process_id    => l_process_id
      , p_subflow_id    => l_subflow_id
      , p_step_key      => l_step_key
      , p_msub_id       => l_msub_id
      , p_payload       => p_payload
      );
    end case;

  end receive_message;

end flow_msg_subscription;
/
