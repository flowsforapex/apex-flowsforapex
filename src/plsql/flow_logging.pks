create or replace package flow_logging
accessible by ( flow_engine, flow_instances, flow_process_vars, flow_expressions 
              , flow_boundary_events, flow_gateways
              )
as

  procedure log_instance_event
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_event             in flow_instance_event_log.lgpr_prcs_event%type 
  , p_comment           in flow_instance_event_log.lgpr_comment%type default null
  );

  procedure log_step_completion
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type
  , p_completed_object  in flow_subflow_log.sflg_objt_id%type
  , p_notes             in flow_subflow_log.sflg_notes%type default null
  );

end flow_logging;