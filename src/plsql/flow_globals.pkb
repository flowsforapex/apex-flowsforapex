create or replace package body flow_globals
as

  procedure set_context
  ( pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type default null
  )
  is
  begin 
    process_id := pi_prcs_id;
    subflow_id := pi_sbfl_id;
  
  end set_context;

end flow_globals;
/
