create or replace package flow_globals
as

  process_id flow_processes.prcs_id%type;
  subflow_id flow_subflows.sbfl_id%type;

  procedure set_context
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type default null
  );

end flow_globals;
/
