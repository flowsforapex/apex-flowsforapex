create or replace package flow_expressions
  authid current_user
  -- accessible by flow_engine, flow_process_vars ??
as 

  procedure process_expressions
  ( pi_objt_id      flow_objects.objt_id%type
  , pi_set          flow_object_expressions.expr_set%type
  , pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  );

end flow_expressions;
/