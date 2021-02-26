create or replace package flow_engine
accessible by (flow_api_pkg, flow_timers_pkg)
as 

procedure flow_handle_event
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ); 

function flow_create
  ( p_dgrm_id   in flow_diagrams.dgrm_id%type
  , p_prcs_name in flow_processes.prcs_name%type
  ) return flow_processes.prcs_id%type;

procedure flow_start_process
  ( p_process_id    in flow_processes.prcs_id%type
  );

procedure flow_complete_step
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_forward_route in flow_connections.conn_bpmn_id%type default null   
  );

procedure flow_reserve_step
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_reservation   in flow_subflows.sbfl_reservation%type
  );  

procedure flow_release_step
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ); 

procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  );

procedure flow_delete
  ( p_process_id in flow_processes.prcs_id%type
  );

end flow_engine;
/
