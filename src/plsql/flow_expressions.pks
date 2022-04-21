/* 
-- Flows for APEX - flow_expressions.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created    13-Mar-2021  Richard Allen (Flowquest, for MT AG)
-- Modified   12-Apr-2022  Richard Allen (Oracle)
--
*/


create or replace package flow_expressions
  authid current_user
  accessible by ( flow_engine, flow_boundary_events, flow_call_activities, 
                  flow_gateways, flow_instances, flow_subprocesses )
as 
  e_var_exp_date_format_error exception;

  -- Call using objt_id if you have available
  procedure process_expressions
  ( pi_objt_id      flow_objects.objt_id%type default null
  , pi_set          flow_object_expressions.expr_set%type
  , pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  , pi_var_scope    flow_subflows.sbfl_scope%type
  , pi_expr_scope   flow_subflows.sbfl_scope%type
  );

  -- oterwise overload provided, usung objt_bpmn_id...
  procedure process_expressions
  ( pi_objt_bpmn_id flow_objects.objt_bpmn_id%type
  , pi_set          flow_object_expressions.expr_set%type
  , pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  , pi_var_scope    flow_subflows.sbfl_scope%type
  , pi_expr_scope   flow_subflows.sbfl_scope%type
  );

end flow_expressions;
/
