create or replace package flow_engine_util
  authid definer
-- accessible by (flow_engine, flow_gateways, flow_boundary_events, flow_timers_pkg, flow_logging, flow_instances, flow_plsql_runner_pkg, flow_admin_api)
as 
/* 
-- Flows for APEX - flow_engine_util.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Consulting Limited. 2024-2025
--
-- Created  April-2021  Richard Allen (Flowquest) - for  MT AG
-- Modified 2022-07-18  Moritz Klein (MT AG)
-- Modified 09-Jan-2024  Richard Allen, Flowquest Consulting
--
*/

  function get_config_value
  ( 
    p_config_key    in flow_configuration.cfig_key%type,
    p_default_value in flow_configuration.cfig_value%type
  ) return flow_configuration.cfig_value%type;

  procedure set_config_value
  ( p_config_key      in flow_configuration.cfig_key%type,
    p_value           in flow_configuration.cfig_value%type,
    p_update_if_set   in boolean default true
  );

  function get_object_tag
  ( p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_dgrm_id      in flow_diagrams.dgrm_id%type  
  ) return flow_objects.objt_tag_name%type;

  function get_object_tag
  ( p_sbfl_info   in flow_subflows%rowtype
  ) return flow_objects.objt_tag_name%type;
  
  function get_object_subtag
  (
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_dgrm_id      in flow_diagrams.dgrm_id%type  
  )
  return varchar2;

  function check_subflow_exists
  (
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  ) return boolean;

  --function is_multi_instance
  --( 
  --  p_objt_attribute   in flow_objects.objt_attributes%type
  --) return boolean;

  function get_subprocess_parent_subflow
  ( p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_current    in flow_objects.objt_bpmn_id%type -- an object in the subprocess
  ) return flow_types_pkg.t_subflow_context;

  procedure get_number_of_connections
  ( pi_dgrm_id                  in flow_diagrams.dgrm_id%type
  , pi_objt_bpmn_id             in flow_objects.objt_bpmn_id%type
  , pi_conn_type                in flow_connections.conn_tag_name%type 
  , po_num_forward_connections  out number
  , po_num_back_connections     out number
  , po_objt_tag_name            out flow_objects.objt_tag_name%type
  );
  
  function get_subflow_info
  ( p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_lock_subflow  in boolean default false
  , p_lock_process  in boolean default false
  ) return flow_subflows%rowtype;

  function get_iteration_type
  ( p_step_info     in flow_types_pkg.flow_step_info
  ) return varchar2;

  function get_loop_counter
  ( pi_sbfl_id       in  flow_subflows.sbfl_id%type
  ) return flow_subflows.sbfl_loop_counter%type;

  function step_key
  ( pi_sbfl_id        in flow_subflows.sbfl_id%type default null
  , pi_current        in flow_subflows.sbfl_current%type default null
  , pi_became_current in flow_subflows.sbfl_became_current%type default null
  ) return flow_subflows.sbfl_step_key%type;

  function step_key_valid
  ( pi_prcs_id              in flow_processes.prcs_id%type
  , pi_sbfl_id              in flow_subflows.sbfl_id%type
  , pi_step_key_supplied    in flow_subflows.sbfl_step_key%type
  , pi_step_key_required    in flow_subflows.sbfl_step_key%type default null
  ) return boolean;

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
    , p_new_scope                 in boolean default false
    , p_new_diagram               in boolean default false
    , p_dgrm_id                   in flow_diagrams.dgrm_id%type
    , p_follows_ebg               in boolean default false
    , p_loop_counter              in number default null
    , p_iteration_type            in flow_subflows.sbfl_iteration_type%type default null
    , p_loop_total_instances      in flow_subflows.sbfl_loop_total_instances%type default null
    , p_iteration_var             in flow_process_variables.prov_var_name%type default null
    , p_iteration_var_scope       in flow_subflows.sbfl_scope%type default null
    , p_iter_id                   in flow_iterations.iter_id%type default null
    , p_iterated_object           in flow_iterated_objects.iobj_id%type default null
    ) return flow_types_pkg.t_subflow_context
    ;

  procedure lock_all_for_process 
  ( p_process_id    in flow_processes.prcs_id%type
  ); 

  function lock_subflow
  ( p_subflow_id    in flow_subflows.sbfl_id%type
  ) return boolean;

  function get_scope
  (  p_process_id  in flow_processes.prcs_id%type
  ,  p_subflow_id  in flow_subflows.sbfl_id%type
  ) return flow_subflows.sbfl_scope%type;

  function json_array_join
  (
    p_json_array in sys.json_array_t
  ) return clob;

  function json_array_join
  (
    p_json_array in clob
  ) return clob;

  function apex_json_array_join
  ( p_json_array in apex_t_varchar2
  )
  return clob;

  function clob_to_blob
  ( 
    pi_clob in clob
  ) return blob;

end flow_engine_util;
/
