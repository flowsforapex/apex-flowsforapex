create or replace package flow_logging
accessible by (flow_engine, flow_instances, flow_process_vars, flow_expressions)
as

  procedure log_instance_event
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_event             in flow_instance_event_log.lgpr_prcs_event%type 
  , p_comment           in flow_instance_event_log.lgpr_comment%type default null
  );


end flow_logging;