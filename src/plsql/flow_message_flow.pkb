create or replace package body flow_message_flow as
/* 
-- Flows for APEX - flow_message_flow.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
-- (c) Copyright Flowquest Limited, 2023-24
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

    apex_debug.message ( p_message => 'Message subscription %0 created for Message %1 Key %2 Value %3 Payload %4'
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
    l_prcs_id           flow_processes.prcs_id%type;
    l_scope             flow_subflows.sbfl_scope%type;
    l_current           flow_subflows.sbfl_current%type;
    l_msub              flow_message_subscriptions%rowtype;
    l_log_msg           flow_configuration.cfig_value%type;
    l_was_correlated    flow_types_pkg.t_single_vc2 := flow_constants_pkg.gc_false;
    l_session_id        number;
  begin
    if (p_key_name is null and p_key_value is null) then
      $IF flow_apex_env.ee $THEN
        l_msub := flow_message_util_ee.correlate_start_event ( p_message_name => p_message_name);
        l_was_correlated  := flow_constants_pkg.gc_true;
        -- message is correlated.  create an APEX session if coming from outside
        if v('APP_SESSION') is null then
          l_session_id := flow_apex_session.create_api_session (p_subflow_id => l_msub.msub_sbfl_id);
        end if; 
      $ELSE
        raise e_msgflow_feature_requires_ee;
      $END
    else
      -- intermediate message catch / receive
      l_msub := flow_message_util.correlate_catch_event  ( p_message_name => p_message_name
                                                        , p_key_name      => p_key_name
                                                        , p_key_value     => p_key_value  
                                                        );
      apex_debug.message ( p_message => 'intermediate catch or receive correlated');                                                  
      -- message is correlated.  create an APEX session if coming from outside
      -- and then validate the step key to make sure the receive / catch is still current
      if v('APP_SESSION') is null then
        l_session_id := flow_apex_session.create_api_session (p_subflow_id => l_msub.msub_sbfl_id);
      end if; 
      -- validate step key, get scope and current object, and lock subflow
      begin
        select sbfl_scope
             , sbfl_current
          into l_scope
             , l_current
          from flow_subflows
         where sbfl_id        = l_msub.msub_sbfl_id
           and sbfl_prcs_id   = l_msub.msub_prcs_id
           and sbfl_step_key  = l_msub.msub_step_key
           for update of sbfl_current
        ;
        l_was_correlated  := flow_constants_pkg.gc_true;
        apex_debug.message ( p_message => 'intermediate catch or receive step key validated');                                                  

      exception
        when no_data_found then
            -- add some message-specific logging capability into here.
            raise e_msgflow_mag_already_consumed ;
        when e_lock_timeout then
            raise e_msgflow_correlated_msg_locked;          
      end;
    end if;

    l_log_msg := flow_engine_util.get_config_value ( p_config_key     => flow_constants_pkg.gc_config_logging_message_flow_recd
                                                   , p_default_value  => flow_constants_pkg.gc_config_default_logging_recd_msg 
                                                   );

    if l_log_msg = flow_constants_pkg.gc_vcbool_true then
      flow_message_util.autonomous_write_to_messageflow_log
      ( p_message_name        => p_message_name 
      , p_key_name            => p_key_name
      , p_key_value           => p_key_value
      , p_payload             => p_payload
      , p_was_correlated      => l_was_correlated
      , p_prcs_id             => l_msub.msub_prcs_id
      , p_sbfl_id             => l_msub.msub_sbfl_id   
      );
    end if;

    case 
    when l_msub.msub_callback = flow_constants_pkg.gc_bpmn_receivetask then
      apex_debug.message 
      ( p_message => 'receivetask callback. prcs_id %0 sbfl_id %1 l_current %2 scope %3 msub_id %4'
      , p0 => l_msub.msub_prcs_id
      , p1 => l_msub.msub_sbfl_id
      , p2 => l_current
      , p3 => l_scope
      , p4 => l_msub.msub_id
      );
      -- Call Back is for a bpmn:receiveTask message
      flow_message_util.save_payload
      ( p_process_id      => l_msub.msub_prcs_id
      , p_subflow_id      => l_msub.msub_sbfl_id
      , p_payload_var     => l_msub.msub_payload_var
      , p_payload         => p_payload
      , p_objt_bpmn_id    => l_current
      , p_scope           => l_scope
      );

      -- do the delete before the callback because the callback will do a next-step, which commits at step end
      delete from flow_message_subscriptions
       where msub_id = l_msub.msub_id;

      flow_tasks.receiveTask_callback 
      ( p_process_id    => l_msub.msub_prcs_id
      , p_subflow_id    => l_msub.msub_sbfl_id
      , p_step_key      => l_msub.msub_step_key
      , p_msub_id       => l_msub.msub_id
      );
    when l_msub.msub_callback = flow_constants_pkg.gc_bpmn_intermediate_catch_event then
      apex_debug.message 
      ( p_message => 'ICE callback. prcs_id %0 sbfl_id %1 l_current %2 scope %3 msub_id %4 callback param: %5'
      , p0 => l_msub.msub_prcs_id
      , p1 => l_msub.msub_sbfl_id
      , p2 => l_current
      , p3 => l_scope
      , p4 => l_msub.msub_id
      , p5 => l_msub.msub_callback_par
      );
      flow_message_util.intermed_save_payload_and_callback
      ( p_msub     => l_msub
      , p_payload  => p_payload
      , p_current  => l_current
      , p_scope    => l_scope
      );
    when  l_msub.msub_callback = flow_constants_pkg.gc_bpmn_boundary_event then
      $IF flow_apex_env.ee $THEN
        flow_message_util_ee.b_event_save_payload_and_callback
        ( p_msub     => l_msub
        , p_payload  => p_payload
        , p_current  => l_current
        , p_scope    => l_scope
        );
      $ELSE
        raise e_msgflow_feature_requires_ee;
      $END
    when l_msub.msub_callback = flow_constants_pkg.gc_bpmn_start_event then
      $IF flow_apex_env.ee $THEN
        flow_message_util_ee.start_event_save_payload_and_callback
        ( p_msub     => l_msub
        , p_payload  => p_payload
        );
      $ELSE
        raise e_msgflow_feature_requires_ee;
      $END

    end case;

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
    ( 'send_message'
    , 'p_msg_object_bpmn_id', p_step_info.target_objt_ref
    );
    l_message := flow_message_util.prepare_message( p_msg_object_bpmn_id  => p_step_info.target_objt_ref
                                              , p_dgrm_id             => p_sbfl_info.sbfl_dgrm_id
                                              , p_sbfl_info           => p_sbfl_info 
                                              );

    apex_debug.trace
    (
      p_message => 'Received message details -- %0;%1;%2;%3'
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
