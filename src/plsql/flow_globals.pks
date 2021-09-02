create or replace package flow_globals
as

  process_id flow_processes.prcs_id%type;
  subflow_id flow_subflows.sbfl_id%type;

  procedure set_context
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type default null
  );

  procedure set_step_error
  ( p_has_error  in boolean default false
  );

  function get_step_error
  return boolean;

  procedure set_is_recursive_step
  ( p_is_recursive_step  in boolean default false
  );

  function get_is_recursive_step
  return boolean;

end flow_globals;
/
