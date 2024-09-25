create or replace package body flow_message_util as
/* 
-- Flows for APEX - flow_message_util.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created  04-Mar-2023  Richard Allen (Oracle Corporation)
--
-- Contains utility and common routines for messageFlow used by
-- bpmn:sendTask, bpmn:receiveTask, message catch and throw events, message start events, etc.
--
*/
  e_lock_timeout exception;
  pragma exception_init (e_lock_timeout, -3006);

  procedure autonomous_write_to_messageflow_log
    ( p_message_name     in flow_message_received_log.lgrx_message_name%type 
    , p_key_name         in flow_message_received_log.lgrx_key_name%type   
    , p_key_value        in flow_message_received_log.lgrx_key_value%type 
    , p_payload          in flow_message_received_log.lgrx_payload%type 
    , p_was_correlated   in flow_message_received_log.lgrx_was_correlated%type    
    , p_prcs_id          in flow_message_received_log.lgrx_prcs_id%type 
    , p_sbfl_id          in flow_message_received_log.lgrx_sbfl_id%type    
    )
  is
    pragma autonomous_transaction;
  begin

      insert into flow_message_received_log
      ( lgrx_message_name
      , lgrx_key_name
      , lgrx_key_value
      , lgrx_payload
      , lgrx_was_correlated
      , lgrx_prcs_id
      , lgrx_sbfl_id
      , lgrx_received_on
      )
      values
      ( p_message_name
      , p_key_name
      , p_key_value
      , p_payload
      , p_was_correlated
      , p_prcs_id
      , p_sbfl_id
      , systimestamp
      );
      -- commit as an autonomous transaction
      commit;
  end autonomous_write_to_messageflow_log;

  function get_msg_subscription_details
  ( p_msg_object_bpmn_id        flow_objects.objt_bpmn_id%type
  , p_dgrm_id                   flow_diagrams.dgrm_id%type
  , p_sbfl_info                 flow_subflows%rowtype
  ) return flow_message_flow.t_subscription_details
  is 
    l_message_name_json flow_types_pkg.t_bpmn_attribute_vc2;
    l_message_name      flow_message_subscriptions.msub_message_name%type;
    l_key_json          flow_types_pkg.t_bpmn_attribute_vc2;
    l_key               flow_message_subscriptions.msub_key_name%type;
    l_value_json        flow_types_pkg.t_bpmn_attribute_vc2;
    l_value             flow_message_subscriptions.msub_key_value%type;
    l_msub_id           flow_message_subscriptions.msub_id%type;
    l_msg_sub           flow_message_flow.t_subscription_details;
    l_payload_variable  flow_process_variables.prov_var_name%type;

  begin
    apex_debug.enter 
    ( 'get_msg_subscription_details'
    , 'p_msg_object_bpmn_id', p_msg_object_bpmn_id
    );

    l_msg_sub   := flow_message_flow.t_subscription_details();

    -- get message and correlation settings and evaluate them
      -- get the userTask subtype  
    select objt.objt_attributes."apex"."messageName"
         , objt.objt_attributes."apex"."correlationKey"
         , objt.objt_attributes."apex"."correlationValue"
         , objt.objt_attributes."apex"."payloadVariable"
      into l_message_name_json
         , l_key_json
         , l_value_json
         , l_msg_sub.payload_var
      from flow_objects objt
     where objt.objt_bpmn_id = p_msg_object_bpmn_id
       and objt.objt_dgrm_id = p_dgrm_id 
       ;

    apex_debug.message 
    ( p_message => '-- message settings: messageName %0, key %1, value %2, payload var %3'
    , p0 => l_message_name_json
    , p1 => l_key_json
    , p2 => l_value_json
    , p3 => l_msg_sub.payload_var
    );

      if l_message_name_json is not null then
        l_msg_sub.message_name := flow_settings.get_vc2_expression 
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_message_name_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_key_json is not null then 
        l_msg_sub.key_name     := flow_settings.get_vc2_expression 
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_key_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_value_json is not null then 
        l_msg_sub.key_value    := flow_settings.get_vc2_expression
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_value_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;

    apex_debug.message 
    ( p_message => '-- ReceiveTask settings: messageName "%0", key "%1", value "%2", payload var "%3".'
    , p0 => l_msg_sub.message_name
    , p1 => l_msg_sub.key_name
    , p2 => l_msg_sub.key_value
    , p3 => l_msg_sub.payload_var
    );

    l_msg_sub.prcs_id        := p_sbfl_info.sbfl_prcs_id;
    l_msg_sub.sbfl_id        := p_sbfl_info.sbfl_id;
    l_msg_sub.step_key       := p_sbfl_info.sbfl_step_key;
  
    return l_msg_sub;
  end get_msg_subscription_details;
  
  function prepare_message
  ( p_msg_object_bpmn_id        flow_objects.objt_bpmn_id%type
  , p_dgrm_id                   flow_diagrams.dgrm_id%type
  , p_sbfl_info                 flow_subflows%rowtype
  ) return flow_message_flow.t_flow_simple_message
  is
    l_endpoint_json     flow_types_pkg.t_bpmn_attribute_vc2;
    l_endpoint          flow_types_pkg.t_vc200;
    l_message_name_json flow_types_pkg.t_bpmn_attribute_vc2;
    l_message_name      flow_message_subscriptions.msub_message_name%type;
    l_key_json          flow_types_pkg.t_bpmn_attribute_vc2;
    l_key               flow_message_subscriptions.msub_key_name%type;
    l_value_json        flow_types_pkg.t_bpmn_attribute_vc2;
    l_value             flow_message_subscriptions.msub_key_value%type;
    l_payload_json      clob;
    l_payload           clob;
    l_message           flow_message_flow.t_flow_simple_message;

  begin
    apex_debug.enter 
    ( 'prepare_message'
    , 'p_msg_object_bpmn_id', p_msg_object_bpmn_id
    );

    l_message   := flow_message_flow.t_flow_simple_message();

    -- get message and correlation settings and evaluate them
      -- get the userTask subtype  
    select objt.objt_attributes."apex"."endpoint"
         , objt.objt_attributes."apex"."messageName"
         , objt.objt_attributes."apex"."correlationKey"
         , objt.objt_attributes."apex"."correlationValue"
         , objt.objt_attributes."apex"."payload"
      into l_endpoint_json
         , l_message_name_json
         , l_key_json
         , l_value_json
         , l_payload_json
      from flow_objects objt
     where objt.objt_bpmn_id = p_msg_object_bpmn_id
       and objt.objt_dgrm_id = p_dgrm_id 
       ;

    apex_debug.message 
    ( p_message => '-- message settings: messageName %0, key %1, value %2, payload %3, endpoint %4'
    , p0 => l_message_name_json
    , p1 => l_key_json
    , p2 => l_value_json
    , p3 => l_payload_json
    , p4 => l_endpoint_json
    );

      if l_message_name_json is not null then
        l_message.message_name := flow_settings.get_vc2_expression 
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_message_name_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_key_json is not null then 
        l_message.key_name     := flow_settings.get_vc2_expression 
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_key_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_value_json is not null then 
        l_message.key_value    := flow_settings.get_vc2_expression
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_value_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_payload_json is not null then 
        l_message.payload    := flow_settings.get_clob_expression
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_payload_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_endpoint_json is not null then 
        l_message.endpoint    := flow_settings.get_vc2_expression
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_endpoint_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;      

    apex_debug.message 
    ( p_message => '-- ReceiveTask settings: messageName "%0", key "%1", value "%2", payload "%3", endpoint "%4%".'
    , p0 => l_message.message_name
    , p1 => l_message.key_name
    , p2 => l_message.key_value
    , p3 => l_message.payload
    , p4 => l_message.endpoint
    );
  
    return l_message;
  end prepare_message;


  procedure save_payload
  ( p_process_id             in  flow_processes.prcs_id%type
  , p_subflow_id             in  flow_subflows.sbfl_id%type default null
  , p_payload_var            in  flow_process_variables.prov_var_name%type
  , p_payload                in  clob
  , p_scope                  in  flow_subflows.sbfl_scope%type default 0
  , p_objt_bpmn_id           in  flow_objects.objt_bpmn_id%type
  )
  is
  begin
    apex_debug.enter 
    ( 'save_payload'
    , 'p_payload_var', p_payload_var
    , 'p_payload', p_payload
    );

    if ( p_payload is not null 
       and p_payload_var is not null ) then 

      flow_proc_vars_int.set_var
      ( pi_prcs_id      => p_process_id
      , pi_sbfl_id      => p_subflow_id
      , pi_var_name     => p_payload_var
      , pi_clob_value   => p_payload
      , pi_objt_bpmn_id => p_objt_bpmn_id
      , pi_scope        => p_scope
      );
      apex_debug.message 
      ( p_message => '-- incoming mesage payload stored in proc var %0'
      , p0 => p_payload_var
      );    
    end if;
  end save_payload;

  function correlate_catch_event
    ( p_message_name  flow_message_subscriptions.msub_message_name%type 
    , p_key_name      flow_message_subscriptions.msub_key_name%type
    , p_key_value     flow_message_subscriptions.msub_key_value%type
    ) return flow_message_subscriptions%rowtype
  is
    l_msub              flow_message_subscriptions%rowtype;
  begin
    begin
      -- attempt the correlation based on 100% match of message name, key and value
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
          raise flow_message_flow.e_msgflow_msg_not_correlated;
          -- logging of incorrect message handled in procedure exceptions below...
        when e_lock_timeout then
          raise flow_message_flow.e_msgflow_correlated_msg_locked;          
    end;
    return l_msub;
  end correlate_catch_event;

  procedure intermed_save_payload_and_callback
   ( p_msub           in flow_message_subscriptions%rowtype
   , p_payload        in clob default null
   , p_current        in flow_objects.objt_bpmn_id%type 
   , p_scope          in flow_subflows.sbfl_scope%type
   ) 
  is
  begin
      -- Call Back is for a bpmn:intermediateCatchEvent - message subtype (Message Catch Event)
      save_payload
      ( p_process_id      => p_msub.msub_prcs_id
      , p_subflow_id      => p_msub.msub_sbfl_id
      , p_payload_var     => p_msub.msub_payload_var
      , p_payload         => p_payload
      , p_objt_bpmn_id    => p_current
      , p_scope           => p_scope
      );

      -- do the delete before the callback because the callback will do a next-step, which commits at step end
      delete from flow_message_subscriptions
       where msub_id = p_msub.msub_id;

      flow_engine.timer_callback 
      ( p_process_id    => p_msub.msub_prcs_id
      , p_subflow_id    => p_msub.msub_sbfl_id
      , p_step_key      => p_msub.msub_step_key
      , p_callback      => p_msub.msub_callback
      , p_callback_par  => p_msub.msub_callback_par
      , p_event_type    => flow_constants_pkg.gc_bpmn_message_event_definition
      );

  end intermed_save_payload_and_callback;

  procedure lock_subscription
  ( p_process_id                    flow_processes.prcs_id%type
  , p_subflow_id                    flow_subflows.sbfl_id%type
  )
  is
    cursor c_lock_sub is
      select msub_id
        from flow_message_subscriptions
       where msub_prcs_id = p_process_id
         and msub_sbfl_id = p_subflow_id
         for update of msub_id;
  begin
    apex_debug.enter
    ( 'lock_subscription'
    , 'process_id', p_process_id
    , 'subflow_id', p_subflow_id
    );
    open c_lock_sub;
    close c_lock_sub;
  end lock_subscription;
  
  procedure cancel_subscription
  ( p_process_id                    flow_processes.prcs_id%type
  , p_subflow_id                    flow_subflows.sbfl_id%type
  )
  is
  begin
    delete from flow_message_subscriptions
          where msub_prcs_id = p_process_id
            and msub_sbfl_id = p_subflow_id;
  end cancel_subscription;
  
  procedure cancel_subscription
  ( p_msub_id                       flow_message_subscriptions.msub_id%type
  )
  is
  begin
    delete from flow_message_subscriptions
          where msub_id = p_msub_id;
  end cancel_subscription;

  procedure lock_instance_subscriptions
  ( p_process_id                    flow_processes.prcs_id%type
  )
  is
    cursor c_lock_subs is
      select msub_id
        from flow_message_subscriptions
       where msub_prcs_id = p_process_id
         for update of msub_id;
  begin
    apex_debug.enter
    ( 'lock_subscription'
    , 'process_id', p_process_id
    );
    open c_lock_subs;
    close c_lock_subs;

  end lock_instance_subscriptions;

  procedure cancel_instance_subscriptions
  ( p_process_id                    flow_processes.prcs_id%type
  )
  is
  begin
    delete from flow_message_subscriptions
          where msub_prcs_id = p_process_id;
  end cancel_instance_subscriptions;

end flow_message_util;
/
