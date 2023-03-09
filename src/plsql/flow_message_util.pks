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
                , flow_engine_util )
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
  ) return flow_message_flow.t_flow_basic_message;

  procedure lock_subscription
  ( p_process_id                 flow_processes.prcs_id%type
  , p_subflow_id                 flow_subflows.sbfl_id%type
  );
  procedure cancel_subscription
  ( p_process_id                 flow_processes.prcs_id%type
  , p_subflow_id                 flow_subflows.sbfl_id%type
  );

  procedure lock_instance_subscriptions
  ( p_process_id                 flow_processes.prcs_id%type
  );
  procedure cancel_instance_subscriptions
  ( p_process_id                 flow_processes.prcs_id%type
  );
  
end flow_message_util;
/
