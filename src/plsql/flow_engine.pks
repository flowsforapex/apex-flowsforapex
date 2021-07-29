create or replace package flow_engine
accessible by (flow_api_pkg, flow_instances, flow_gateways, flow_tasks, 
               flow_boundary_events, flow_timers_pkg)
as 
  procedure flow_handle_event
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ); 
procedure flow_complete_step
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_forward_route in flow_connections.conn_bpmn_id%type default null   
  );

procedure start_step
  ( p_process_id          in flow_processes.prcs_id%type
  , p_subflow_id          in flow_subflows.sbfl_id%type
  , p_called_internally   in boolean default false
  );

end flow_engine;
/
