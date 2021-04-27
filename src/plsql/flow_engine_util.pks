create or replace package flow_engine_util
accessible by (flow_engine, flow_timers_pkg)
as 

  function get_dgrm_id
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return flow_processes.prcs_dgrm_id%type;

  procedure log_step_completion
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type
  , p_completed_object  in flow_subflow_log.sflg_objt_id%type
  , p_notes             in flow_subflow_log.sflg_notes%type default null
  );

  function check_subflow_exists
  ( 
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean;

  function get_gateway_route
  ( pi_process_id     in flow_processes.prcs_id%type
  , pi_objt_bpmn_id   in flow_objects.objt_bpmn_id%type
  ) return varchar2;

  function get_subprocess_parent_subflow
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_current    in flow_objects.objt_bpmn_id%type -- an object in the subprocess
  ) return number;

  procedure get_number_of_connections
  ( pi_dgrm_id in flow_diagrams.dgrm_id%type
  , pi_target_objt_id flow_connections.conn_tgt_objt_id%type
  , po_num_forward_connections out number
  , po_num_back_connections out number
  );
  
  function get_and_lock_subflow_info
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  ) return flow_subflows%rowtype;

end flow_engine_util;