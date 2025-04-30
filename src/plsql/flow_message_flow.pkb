create or replace package body flow_message_flow as
/* 
-- Flows for APEX - flow_message_flow.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
-- (c) Copyright Flowquest Limited, 2023-25
--
-- Created  04-Mar-2023  Richard Allen (Oracle Corporation)
-- Edited      May-2024  Richard Allen, (Flowquest)
--
*/
  e_lock_timeout exception;
  pragma exception_init (e_lock_timeout, -3006);


  function subscribe
  ( p_subscription_details     in t_subscription_details
  ) return flow_message_subscriptions.msub_id%type
  is
    l_msub_id      flow_message_subscriptions.msub_id%type;
  begin
    apex_debug.message ( p_message => 'Trying to create subscription for Message %0 Key %1 Value %2 Payload %3'
    , p0 => p_subscription_details.message_name
    , p1 => p_subscription_details.key_name
    , p2 => p_subscription_details.key_value
    , p3 => p_subscription_details.payload_var
    );

    insert into flow_message_subscriptions
    ( msub_message_name
    , msub_key_name
    , msub_key_value
    , msub_prcs_id
    , msub_sbfl_id
    , msub_step_key
    , msub_dgrm_id
    , msub_callback
    , msub_callback_par
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
    , p_subscription_details.dgrm_id
    , p_subscription_details.callback
    , p_subscription_details.callback_par
    , systimestamp
    , p_subscription_details.payload_var
    ) returning msub_id into l_msub_id;

    apex_debug.message ( p_message => '..Message subscription %0 created for Message %1 Key %2 Value %3 Payload %4'
    , p0 => l_msub_id
    , p1 => p_subscription_details.message_name
    , p2 => p_subscription_details.key_name
    , p3 => p_subscription_details.key_value
    , p4 => p_subscription_details.payload_var
    );
    return l_msub_id;
  end subscribe;

  procedure receive_message
    ( p_message_name  flow_message_subscriptions.msub_message_name%type
    , p_key_name      flow_message_subscriptions.msub_key_name%type
    , p_key_value     flow_message_subscriptions.msub_key_value%type
    , p_payload       clob default null
    )
  is
    l_received_message    t_flow_simple_message;
    l_corr_msg            flow_t_correlated_message;
    l_session_id          number;
  begin
      l_received_message := t_flow_simple_message();

      l_received_message.message_name     := p_message_name;
      l_received_message.key_name         := p_key_name;   
      l_received_message.key_value        := p_key_value;
      l_received_message.payload_is_json  := false;
      l_received_message.payload          := p_payload;

      -- Correlate and Log Message
      l_corr_msg := flow_message_util.correlate_received_message (p_msg => l_received_message);      

      -- message is correlated.  create an APEX session if coming from outside
      if v('APP_SESSION') is null then
        l_session_id := flow_apex_session.create_api_session (p_subflow_id => l_corr_msg.sbfl_id);
      end if; 

      $IF flow_apex_env.ee $THEN
        -- Enterprise Edition - queue into correlated message AQ
        flow_message_util_ee.enqueue_correlated_message  ( p_corr_msg => l_corr_msg);  
        -- remove  the subscription as part of the enqueue transaction, unless a start event
        if l_corr_msg.callback != flow_constants_pkg.gc_bpmn_start_event then
                delete from flow_message_subscriptions
                where       msub_id = l_corr_msg.msub_id;
        end if;
      $ELSE
        -- Community Edition - synchronous message handling
        flow_message_util.handle_correlated_message  ( p_corr_msg => l_corr_msg);   
      $END                                             

      -- tear down APEX Session if this was an external call.
      if l_session_id is not null then
        flow_apex_session.delete_session (p_session_id => l_session_id );
      end if;      
  exception
    when others then
      if l_session_id is not null then
        flow_apex_session.delete_session (p_session_id => l_session_id );
      end if;
      raise;
  end receive_message;

  procedure send_message
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  )
  is
    l_message               flow_message_flow.t_flow_simple_message;
    e_msgflow_bad_endpoint  exception;
  begin
    apex_debug.enter 
    ( '> send_message'
    , 'p_msg_object_bpmn_id', p_step_info.target_objt_ref
    );
    l_message := flow_message_util.prepare_message( p_msg_object_bpmn_id  => p_step_info.target_objt_ref
                                              , p_dgrm_id             => p_sbfl_info.sbfl_dgrm_id
                                              , p_sbfl_info           => p_sbfl_info 
                                              );

    apex_debug.trace
    (
      p_message => '..Received message details -- name %0 ;key %1 ;value %2 ;payload %3'
    , p0 => l_message.message_name
    , p1 => l_message.key_name
    , p2 => l_message.key_value
    , p3 => l_message.payload
    );

    case l_message.endpoint 
    when 'local' then
      begin
        flow_message_flow.receive_message
        ( p_message_name    => l_message.message_name
        , p_key_name        => l_message.key_name
        , p_key_value       => l_message.key_value
        , p_payload         => l_message.payload
        );
      exception
        when e_msgflow_msg_not_correlated then
          -- message sent did not match an existing subscription
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id      => p_sbfl_info.sbfl_id
          , pi_message_key  => 'msgflow-not-correlated' 
          );
        when e_msgflow_correlated_msg_locked then
          -- message sent correated but is locked by another message
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id      => p_sbfl_info.sbfl_id
          , pi_message_key  => 'msgflow-lock-timeout-msub' 
          );
        when e_msgflow_mag_already_consumed then
          -- message correlated but receiving object is no longer the current object in its subflow
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id      => p_sbfl_info.sbfl_id
          , pi_message_key  => 'msgflow-no-longer-current-step'
          );
        when e_msgflow_feature_requires_ee then
          -- feature not supported without Enterprise Edition licence
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id      => p_sbfl_info.sbfl_id
          , pi_message_key  => 'feature-requires-ee'
          );
      end;
    else
      begin
        raise e_msgflow_bad_endpoint;
      exception
        when e_msgflow_bad_endpoint then
          flow_errors.handle_instance_error
          ( pi_prcs_id      => p_sbfl_info.sbfl_prcs_id
          , pi_sbfl_id      => p_sbfl_info.sbfl_id
          , pi_message_key  => 'msgflow-endpoint-not-supported' 
          , p0 => l_message.endpoint
          );
      end;
    end case;

  end;

end flow_message_flow;
/
