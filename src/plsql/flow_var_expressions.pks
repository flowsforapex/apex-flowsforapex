create or replace package flow_var_expressions
  authid current_user
  -- assissible by flow_engine, flow_process_vars ??
as 

  procedure process_expressions
  ( pi_objt_id      flow_objects.objt_id%type
  , pi_phase        flow_object_expressions.expr_phase%type
  , pi_prcs_id      flow_processes.prcs_id%type
  );

end flow_var_expressions;
/