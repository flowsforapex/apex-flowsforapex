create or replace package flow_rewind
/* 
-- Flows for APEX Community Edition - flow_rewind .pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
-- Package Spec released under Flows for APEX Community Edition MIT licence.
--
-- Created    03-Feb-2025  Richard Allen (Flowquest)
--
*/
  authid definer
--  accessible by ( flow_admin_api, flow_instances_util_ee)
as


  procedure mark_subflow_for_deletion
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure delete_marked_subflow 
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  );

  procedure return_to_prior_gateway
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure return_to_prior_step
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_new_step    in flow_objects.objt_bpmn_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  function get_prior_exclusive_gateway
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  ) return flow_objects.objt_bpmn_id%type;

  procedure rewind_from_subprocess
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure rewind_from_call_activity
  (
    p_process_id  in flow_processes.prcs_id%type
  , p_subflow_id  in flow_subflows.sbfl_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure flow_force_next_step
  ( p_process_id                    in flow_processes.prcs_id%type
  , p_subflow_id                    in flow_subflows.sbfl_id%type
  , p_step_key                      in flow_subflows.sbfl_step_key%type
  , p_execute_variable_expressions  in boolean default true
  , p_comment                       in flow_instance_event_log.lgpr_comment%type default null
  );
  
end flow_rewind;