create or replace package flow_tasks
  authid definer
  accessible by (flow_engine, flow_engine_util)
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
  procedure cancel_apex_task
  ( p_process_id    in flow_processes.prcs_id%type
  , p_objt_bpmn_id  in flow_objects.objt_bpmn_id%type
  , p_apex_task_id  in number    
  );

end flow_tasks;
/
