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
    , msub_payload_var
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
    , p_subscription_details.payload_var
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
    l_scope       flow_subflows.sbfl_scope%type;
    l_current     flow_subflows.sbfl_current%type;
    l_msub        flow_message_subscriptions%rowtype;
  begin
    begin
      select msub.*
        into l_msub
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

    -- validate step key and get scope and current object
    begin
      select sbfl_scope
           , sbfl_current
        into l_scope
           , l_current
        from flow_subflows
       where sbfl_id        = l_msub.msub_sbfl_id
         and sbfl_prcs_id   = l_msub.msub_prcs_id
         and sbfl_step_key  = l_msub.msub_step_key
      ;
    exception
      when no_data_found then
          -- sdd some message-specific logging capability into here.
          flow_errors.handle_general_error
          ( pi_message_key => 'msg-no-longer-current-step');
          raise no_data_found;
    end;

    -- store payload, if present
    if ( p_payload is not null 
       and l_msub.msub_payload_var is not null ) then 

      flow_proc_vars_int.set_var
      ( pi_prcs_id      => l_msub.msub_prcs_id
      , pi_sbfl_id      => l_msub.msub_sbfl_id
      , pi_var_name     => l_msub.msub_payload_var
      , pi_clob_value   => p_payload
      , pi_objt_bpmn_id => l_current
      , pi_scope        => l_scope
      );
      apex_debug.message 
      ( p_message => '-- incoming mesage payload stored in proc var %0'
      , p0 => l_msub.msub_payload_var
      );
    end if;

    case l_msub.msub_callback
    when flow_constants_pkg.gc_bpmn_receivetask then
      -- Call Back is for a bpmn:receiveTask message
      -- do the delete before the callback because the callback will do a next-step, which commits at step end
      delete from flow_message_subscriptions
       where msub_id = l_msub.msub_id;

      flow_tasks.receiveTask_callback 
      ( p_process_id    => l_msub.msub_prcs_id
      , p_subflow_id    => l_msub.msub_sbfl_id
      , p_step_key      => l_msub.msub_step_key
      , p_msub_id       => l_msub.msub_id
      );
    when flow_constants_pkg.gc_bpmn_intermediate_catch_event then
      -- Call Back is for a bpmn:intermediateCatchEvent - message subtype (Message Catch Event)
      -- do the delete before the callback because the callback will do a next-step, which commits at step end
      delete from flow_message_subscriptions
       where msub_id = l_msub.msub_id;

      flow_engine.timer_callback 
      ( p_process_id    => l_msub.msub_prcs_id
      , p_subflow_id    => l_msub.msub_sbfl_id
      , p_step_key      => l_msub.msub_step_key
      );
    end case;

  end receive_message;

end flow_msg_subscription;
/
