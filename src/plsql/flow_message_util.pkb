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
  lock_timeout exception;
  pragma exception_init (lock_timeout, -3006);

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
         , l_payload_variable
      from flow_objects objt
     where objt.objt_bpmn_id = p_msg_object_bpmn_id
       and objt.objt_dgrm_id = p_dgrm_id 
       ;

    apex_debug.message 
    ( p_message => '-- message settings: messageName %0, key %1, value %2, payload var %3'
    , p0 => l_message_name_json
    , p1 => l_key_json
    , p2 => l_value_json
    , p3 => l_payload_variable
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
    , p3 => l_payload_variable
    );

    l_msg_sub.prcs_id        := p_sbfl_info.sbfl_prcs_id;
    l_msg_sub.sbfl_id        := p_sbfl_info.sbfl_id;
    l_msg_sub.step_key       := p_sbfl_info.sbfl_step_key;
    l_msg_sub.payload_var    := l_payload_variable;
  
    return l_msg_sub;
  end get_msg_subscription_details;
  
  function prepare_message
  ( p_msg_object_bpmn_id        flow_objects.objt_bpmn_id%type
  , p_dgrm_id                   flow_diagrams.dgrm_id%type
  , p_sbfl_info                 flow_subflows%rowtype
  ) return flow_message_flow.t_flow_basic_message
  is
    l_endpoint_json     flow_types_pkg.t_bpmn_attribute_vc2;
    l_endpoint          flow_types_pkg.t_vc200;
    l_message_name_json flow_types_pkg.t_bpmn_attribute_vc2;
    l_message_name      flow_message_subscriptions.msub_message_name%type;
    l_key_json          flow_types_pkg.t_bpmn_attribute_vc2;
    l_key               flow_message_subscriptions.msub_key_name%type;
    l_value_json        flow_types_pkg.t_bpmn_attribute_vc2;
    l_value             flow_message_subscriptions.msub_key_value%type;
    l_payload_json      flow_types_pkg.t_bpmn_attribute_vc2;
    l_payload           clob;
    l_message           flow_message_flow.t_flow_basic_message;

  begin
    apex_debug.enter 
    ( 'prepare_message'
    , 'p_msg_object_bpmn_id', p_msg_object_bpmn_id
    );

    l_message   := flow_message_flow.t_flow_basic_message();

    -- get message and correlation settings and evaluate them
      -- get the userTask subtype  
    select objt.objt_attributes."apex"."endPoint"
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
        l_message.endpoint    := flow_settings.get_endpoint
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
