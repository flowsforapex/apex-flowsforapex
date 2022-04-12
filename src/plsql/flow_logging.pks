/* 
-- Flows for APEX - flow_logging.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created 29-Jul-2021  Richard Allen (Flowquest) for  MT AG  
--
*/
create or replace package flow_logging
accessible by ( flow_engine, flow_instances, flow_proc_vars_int, flow_process_vars,flow_expressions 
              , flow_boundary_events, flow_gateways, flow_tasks, flow_errors, flow_timers_pkg
              )
as

  procedure log_instance_event
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_objt_bpmn_id      in flow_objects.objt_bpmn_id%type default null
  , p_event             in flow_instance_event_log.lgpr_prcs_event%type 
  , p_comment           in flow_instance_event_log.lgpr_comment%type default null
  , p_error_info        in flow_instance_event_log.lgpr_error_info%type default null
  );

  procedure log_step_completion
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type
  , p_completed_object  in flow_subflow_log.sflg_objt_id%type
  , p_notes             in flow_subflow_log.sflg_notes%type default null
  );

  procedure log_variable_event -- logs process variable set events
  ( p_process_id        in flow_subflow_log.sflg_prcs_id%type
  , p_scope             in flow_process_variables.prov_scope%type
  , p_var_name          in flow_process_variables.prov_var_name%type
  , p_objt_bpmn_id      in flow_objects.objt_bpmn_id%type default null
  , p_subflow_id        in flow_subflow_log.sflg_sbfl_id%type default null
  , p_expr_set          in flow_object_expressions.expr_set%type default null
  , p_var_type          in flow_process_variables.prov_var_type%type
  , p_var_vc2           in flow_process_variables.prov_var_vc2%type default null
  , p_var_num           in flow_process_variables.prov_var_num%type default null
  , p_var_date          in flow_process_variables.prov_var_date%type default null
  , p_var_clob          in flow_process_variables.prov_var_clob%type default null
  );

end flow_logging;
/
