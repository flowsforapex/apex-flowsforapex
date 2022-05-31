create or replace package flow_boundary_events
accessible by (flow_engine, flow_tasks, flow_timers_pkg, flow_subprocesses 
              , flow_call_activities)
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

  procedure handle_interrupting_timer
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  );
  procedure process_escalation
  ( pi_sbfl_info        in  flow_subflows%rowtype
  , pi_step_info        in  flow_types_pkg.flow_step_info
  , pi_par_sbfl         in  flow_subflows.sbfl_id%type
  , pi_source_type      in  flow_types_pkg.t_bpmn_id
  , po_step_key         out flow_subflows.sbfl_step_key%type
  , po_is_interrupting  out boolean
  );

end flow_boundary_events;
/
