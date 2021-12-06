create or replace package flow_expressions
  authid current_user
  -- accessible by flow_engine, flow_process_vars ??
as 
  e_var_exp_date_format_error exception;

  -- Call using objt_id if you have available
  procedure process_expressions
  ( pi_objt_id      flow_objects.objt_id%type default null
  , pi_set          flow_object_expressions.expr_set%type
  , pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  );

  -- oterwise overload provided, usung objt_bpmn_id...
  procedure process_expressions
  ( pi_objt_bpmn_id flow_objects.objt_bpmn_id%type
  , pi_set          flow_object_expressions.expr_set%type
  , pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  );

end flow_expressions;
/
