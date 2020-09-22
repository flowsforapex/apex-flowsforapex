create or replace package flow_engine
accessible by (flow_api_pkg, flow_timers_pkg)
as 

type flow_step_info is record
( dgrm_id           flow_diagrams.dgrm_id%type
, source_objt_tag   flow_objects.objt_tag_name%type
, target_objt_id    flow_objects.objt_id%type
, target_objt_ref   flow_objects.objt_bpmn_id%type
, target_objt_tag   flow_objects.objt_tag_name%type
, target_objt_subtag flow_objects.objt_sub_tag_name%type
);

procedure flow_handle_event
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ); 

procedure flow_start_process
    ( p_process_id    in flow_processes.prcs_id%type
    );

procedure flow_next_step
( p_process_id    in flow_processes.prcs_id%type
, p_subflow_id    in flow_subflows.sbfl_id%type
, p_forward_route in flow_connections.conn_bpmn_id%type default null   
);

procedure flow_reset
  ( p_process_id in flow_processes.prcs_id%type
  );

procedure flow_delete
  ( p_process_id in flow_processes.prcs_id%type
  );

end flow_engine;