create or replace package body flow_msg_util as
/* 
-- Flows for APEX - flow_msg_util.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created  04-Mar-2023  Richard Allen (Oracle Corporation)
--
-- Contains utility and common routines for messageFlow used by
-- bpmn:sendTask, bpmn:receiveTask, message catch and throw events, message start events, etc.
--
*/

  function get_msg_subscription_details
  ( p_msg_object_bpmn_id        flow_objects.objt_bpmn_id%type
  , p_dgrm_id                   flow_diagrams.dgrm_id%type
  , p_sbfl_info                 flow_subflows%rowtype
  ) return flow_msg_subscription.t_subscription_details
  is 
    l_message_name_json flow_types_pkg.t_bpmn_attribute_vc2;
    l_message_name      flow_message_subscriptions.msub_message_name%type;
    l_key_json          flow_types_pkg.t_bpmn_attribute_vc2;
    l_key               flow_message_subscriptions.msub_key_name%type;
    l_value_json        flow_types_pkg.t_bpmn_attribute_vc2;
    l_value             flow_message_subscriptions.msub_key_value%type;
    l_msub_id           flow_message_subscriptions.msub_id%type;
    l_msg_sub           flow_msg_subscription.t_subscription_details;


  begin
    apex_debug.enter 
    ( 'prepare_msg_subscription_details'
    , 'p_msg_object_bpmn_id', p_msg_object_bpmn_id
    );

    l_msg_sub   := flow_msg_subscription.t_subscription_details();

    -- get message and correlation settings and evaluate them
      -- get the userTask subtype  
    select objt.objt_attributes."apex"."messageName"
         , objt.objt_attributes."apex"."correlationKey"
         , objt.objt_attributes."apex"."correlationValue"
      into l_message_name_json
         , l_key_json
         , l_value_json
      from flow_objects objt
     where objt.objt_bpmn_id = p_msg_object_bpmn_id
       and objt.objt_dgrm_id = p_dgrm_id 
       ;

    apex_debug.message 
    ( p_message => '-- message settings: messageName %0, key %1, value%2'
    , p0 => l_message_name_json
    , p1 => l_key_json
    , p2 => l_value_json
    );

      if l_message_name_json is not null then
        l_msg_sub.message_name := flow_settings.get_message_name 
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_message_name_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_key_json is not null then 
        l_msg_sub.key_name     := flow_settings.get_correlation_key 
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_key_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;
      if l_value_json is not null then 
        l_msg_sub.key_value    := flow_settings.get_correlation_value
                                ( pi_prcs_id => p_sbfl_info.sbfl_prcs_id
                                , pi_sbfl_id => p_sbfl_info.sbfl_id
                                , pi_expr    => l_value_json
                                , pi_scope   => p_sbfl_info.sbfl_scope
                                );
      end if;

    apex_debug.message 
    ( p_message => '-- ReceiveTask settings: messageName "%0", key "%1", value "%2".'
    , p0 => l_msg_sub.message_name
    , p1 => l_msg_sub.key_name
    , p2 => l_msg_sub.key_value
    );

    l_msg_sub.prcs_id        := p_sbfl_info.sbfl_prcs_id;
    l_msg_sub.sbfl_id        := p_sbfl_info.sbfl_id;
    l_msg_sub.step_key       := p_sbfl_info.sbfl_step_key;
  
    return l_msg_sub;
  end get_msg_subscription_details;
  
end flow_msg_util;
/
