create or replace package flow_plsql_runner_pkg
  authid current_user
as

  e_plsql_script_requested_stop exception;
  e_plsql_script_failed exception;

  pragma deprecate (get_current_prcs_id, 'flow_plsql_runner_pkg.get_current_prcs_id is deprecated.  Use flow_globals.process_id instead');
  pragma deprecate (get_current_sbfl_id, 'flow_plsql_runner_pkg.get_current_sbfl_id is deprecated.  Use flow_globals.subflow_id instead');

  function get_current_prcs_id
    return flow_processes.prcs_id%type
  ;

  function get_current_sbfl_id
    return flow_subflows.sbfl_id%type
  ;
  
  procedure run_task_script
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  , pi_objt_id in flow_objects.objt_id%type
  );

end flow_plsql_runner_pkg;
/
