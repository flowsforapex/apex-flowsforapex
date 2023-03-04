create or replace package flow_tasks
  authid definer
--  accessible by (flow_engine, flow_engine_util, flow_api_pkg)
as  

  procedure process_task
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  procedure process_userTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  procedure process_scriptTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  procedure process_serviceTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  procedure process_manualTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  procedure process_businessRuleTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  procedure process_sendTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );
  
  procedure process_receiveTask
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  procedure receiveTask_callback
  ( p_process_id    flow_processes.prcs_id%type
  , p_subflow_id    flow_subflows.sbfl_id%type
  , p_step_key      flow_subflows.sbfl_step_key%type
  , p_msub_id       flow_message_subscriptions.msub_id%type
  , p_payload       clob default null
  );
  
end flow_tasks;
/
