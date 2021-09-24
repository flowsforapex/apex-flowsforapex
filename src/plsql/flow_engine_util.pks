create or replace package flow_engine_util
-- accessible by (flow_engine, flow_gateways, flow_boundary_events, flow_timers_pkg, flow_logging)
as 

  function get_dgrm_id
  (
    p_prcs_id in flow_processes.prcs_id%type
  ) return flow_processes.prcs_dgrm_id%type;

  function get_config_value
  ( 
    p_config_key    in flow_configuration.cfig_key%type,
    p_default_value in flow_configuration.cfig_value%type
  ) return flow_configuration.cfig_value%type;

  function check_subflow_exists
  (
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean;

  function get_subprocess_parent_subflow
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_current    in flow_objects.objt_bpmn_id%type -- an object in the subprocess
  ) return number;

  procedure get_number_of_connections
  ( pi_dgrm_id                  in flow_diagrams.dgrm_id%type
  , pi_target_objt_id           in flow_connections.conn_tgt_objt_id%type
  , pi_conn_type                in flow_connections.conn_tag_name%type 
  , po_num_forward_connections  out number
  , po_num_back_connections     out number
  );
  
  function get_subflow_info
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_lock_subflow  in boolean default false
  , p_lock_process  in boolean default false
  ) return flow_subflows%rowtype;

  procedure subflow_complete
  ( p_process_id        in flow_processes.prcs_id%type
  , p_subflow_id        in flow_subflows.sbfl_id%type
  );

  procedure terminate_level
  ( p_process_id    in flow_processes.prcs_id%type
  , p_process_level in flow_subflows.sbfl_process_level%type
  );

  function subflow_start
    ( 
      p_process_id                in flow_processes.prcs_id%type
    , p_parent_subflow            in flow_subflows.sbfl_id%type
    , p_starting_object           in flow_objects.objt_bpmn_id%type
    , p_current_object            in flow_objects.objt_bpmn_id%type
    , p_route                     in flow_subflows.sbfl_route%type
    , p_last_completed            in flow_objects.objt_bpmn_id%type
    , p_status                    in flow_subflows.sbfl_status%type default flow_constants_pkg.gc_sbfl_status_running
    , p_parent_sbfl_proc_level    in flow_subflows.sbfl_process_level%type
    , p_new_proc_level            in boolean default false
    , p_dgrm_id                   in flow_diagrams.dgrm_id%type
    ) return flow_subflows.sbfl_id%type
    ;

  function lock_subflow
  ( p_subflow_id    in flow_subflows.sbfl_id%type
  ) return boolean;

end flow_engine_util;
/
