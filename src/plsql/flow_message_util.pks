create or replace package flow_message_util
/* 
-- Flows for APEX - flow_message_util
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created  04-Mar-2023  Richard Allen (Oracle Corporation)
--
-- Contains utility and common routines for messageFlow used by
-- bpmn:sendTask, bpmn:receiveTask, message catch and throw events, message start events, etc.
--
*/
  accessible by ( flow_message_flow, flow_tasks, flow_engine , flow_instances 
                , flow_engine_util , flow_boundary_events , flow_diagram, flow_message_util_ee )
as  

  function get_msg_subscription_details
  ( p_msg_object_bpmn_id        flow_objects.objt_bpmn_id%type
  , p_dgrm_id                   flow_diagrams.dgrm_id%type
  , p_sbfl_info                 flow_subflows%rowtype
  ) return flow_message_flow.t_subscription_details;

  function prepare_message
  ( p_msg_object_bpmn_id        flow_objects.objt_bpmn_id%type
  , p_dgrm_id                   flow_diagrams.dgrm_id%type
  , p_sbfl_info                 flow_subflows%rowtype
  ) return flow_message_flow.t_flow_simple_message;

  procedure lock_subscription
  ( p_process_id                 flow_processes.prcs_id%type
  , p_subflow_id                 flow_subflows.sbfl_id%type
  );
  
  procedure cancel_subscription
  ( p_process_id                 flow_processes.prcs_id%type
  , p_subflow_id                 flow_subflows.sbfl_id%type
  );

  procedure cancel_subscription
  ( p_msub_id                    flow_message_subscriptions.msub_id%type
  );

  procedure lock_instance_subscriptions
  ( p_process_id                 flow_processes.prcs_id%type
  );
  procedure cancel_instance_subscriptions
  ( p_process_id                 flow_processes.prcs_id%type
  );

  procedure save_payload
  ( p_process_id             in  flow_processes.prcs_id%type
  , p_subflow_id             in  flow_subflows.sbfl_id%type default null
  , p_payload_var            in  flow_process_variables.prov_var_name%type
  , p_payload                in  clob
  , p_scope                  in  flow_subflows.sbfl_scope%type default 0
  , p_objt_bpmn_id           in  flow_objects.objt_bpmn_id%type 
  );

  procedure autonomous_write_to_messageflow_log
  ( p_message_name           in  flow_message_received_log.lgrx_message_name%type 
  , p_key_name               in  flow_message_received_log.lgrx_key_name%type   
  , p_key_value              in  flow_message_received_log.lgrx_key_value%type 
  , p_payload                in  flow_message_received_log.lgrx_payload%type 
  , p_was_correlated         in  flow_message_received_log.lgrx_was_correlated%type    
  , p_prcs_id                in  flow_message_received_log.lgrx_prcs_id%type 
  , p_sbfl_id                in  flow_message_received_log.lgrx_sbfl_id%type    
  );

  procedure intermed_save_payload_and_callback
   ( p_msub           in flow_message_subscriptions%rowtype
   , p_payload        in clob default null
   , p_current        in flow_subflows.sbfl_id%type 
   , p_scope          in flow_subflows.sbfl_scope%type
   );

  function correlate_catch_event
    ( p_message_name  flow_message_subscriptions.msub_message_name%type 
    , p_key_name      flow_message_subscriptions.msub_key_name%type
    , p_key_value     flow_message_subscriptions.msub_key_value%type
    ) return flow_message_subscriptions%rowtype;
  
end flow_message_util;
/
