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

  procedure lock_child_boundary_timers
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_parent_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  ); 

  procedure handle_interrupting_boundary_event
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  );
  procedure process_boundary_event
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_info     in flow_types_pkg.flow_step_info
  , p_par_sbfl      in flow_subflows.sbfl_id%type
  , p_process_level in flow_subflows.sbfl_process_level%type
  );

end flow_boundary_events;
/
