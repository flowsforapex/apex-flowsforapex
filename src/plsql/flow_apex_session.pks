create or replace package flow_apex_session 
  authid current_user
-- accessible by ( flow_timers_pkg, flow_engine )
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
  ( p_dgrm_id            in flow_diagrams.dgrm_id%type default null
  , p_prcs_id            in flow_processes.prcs_id%type default null
  , p_as_business_admin  in boolean default false 
  , p_business_admin     in flow_subflows.sbfl_apex_business_admin%type default null
  ) return number;

 function create_api_session
  ( p_process_id         in flow_processes.prcs_id%type default null
  ) return number;

  function create_api_session
  ( p_subflow_id         in flow_subflows.sbfl_id%type
  ) return number;

  function create_api_session
  ( p_function          in varchar2
  ) return number;

  procedure delete_session
  ( p_session_id         in number);

end flow_apex_session;
/
