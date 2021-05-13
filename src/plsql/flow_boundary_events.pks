create or replace package flow_boundary_events
accessible by (flow_engine, flow_tasks, flow_timers_pkg)
is 

  procedure set_boundary_timers 
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  );  

  procedure unset_boundary_timers 
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  );  

  procedure lock_child_boundary_timer_subflows
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_parent_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  ); 

end flow_boundary_events;
/

