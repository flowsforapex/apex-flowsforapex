create or replace package flow_apex_session 
-- accessible by ( flow_timers_pkg, flow_engine )
authid current_user
as

  procedure set_async_proc_vars
  ( p_process_id         in flow_processes.prcs_id%type
  , p_subflow_id         in flow_subflows.sbfl_id%type
  );

  function create_async_session
  ( p_process_id         in flow_processes.prcs_id%type
  , p_subflow_id         in flow_subflows.sbfl_id%type
  ) return number;

  function create_api_session
  ( p_process_id         in flow_processes.prcs_id%type
  ) return number;

  function create_api_session
  ( p_subflow_id         in flow_subflows.sbfl_id%type
  ) return number;

  procedure delete_session
  ( p_session_id         in number);

end flow_apex_session;