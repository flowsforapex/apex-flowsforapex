/* 
-- Flows for APEX - flow_plsql_runner_pkg.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created    15-Nov-2020  Moritz Klein (MT AG)
-- Modified   12-Apr-2022  Richard Allen (Oracle)
-- Modified   20-May-2022  Moritz Klein (MT AG)
--
*/
create or replace package body flow_plsql_runner_pkg
as

  type t_runner_config is
    record
    (
      use_apex_exec varchar2(1) default 'N'
    , do_autobinds  varchar2(1) default 'N'
    , plsql_code    clob
    )
  ;

  g_current_prcs_id flow_processes.prcs_id%type;
  g_current_sbfl_id flow_subflows.sbfl_id%type;

  procedure init_globals
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  )
  as
  begin
    g_current_prcs_id := pi_prcs_id;
    g_current_sbfl_id := pi_sbfl_id;
  end init_globals;

  function get_current_prcs_id
    return flow_processes.prcs_id%type
  as
  begin
    return flow_globals.process_id;
  end get_current_prcs_id;

  function get_current_sbfl_id
    return flow_subflows.sbfl_id%type
  as
  begin
    return flow_globals.subflow_id;
  end get_current_sbfl_id;

  procedure execute_plsql
  (
    p_plsql_code in clob
  )
  as
  begin
    apex_debug.enter 
    ('execute_plsql'
    , 'p_plsql_code', dbms_lob.substr(p_plsql_code, 2000, 1)
    );
    -- Always wrap code into begin..end
    -- Developers are allowed to omit those if no declaration section needed

    execute immediate
      'begin' || apex_application.lf ||
      p_plsql_code || apex_application.lf ||
      'end;'
    ;
  end execute_plsql;

  procedure get_runner_config
  (
    pi_objt_id        in flow_objects.objt_id%type
  , po_use_apex_exec out nocopy boolean
  , po_do_autobinds  out nocopy boolean
  , po_plsql_code    out nocopy clob
  )
  as
    l_plain_json  clob;
    l_json_config sys.json_object_t;
    l_code_json   sys.json_array_t;
  begin
    select json_query( objt.objt_attributes format json, '$.apex' returning clob ) as json_data
      into l_plain_json
      from flow_objects objt
     where objt.objt_id = pi_objt_id
    ;

    l_json_config    := sys.json_object_t( l_plain_json );
    po_use_apex_exec := coalesce( l_json_config.get_boolean( 'engine' ), false );
    po_do_autobinds  := coalesce( l_json_config.get_boolean( 'autoBinds' ), false );
    l_code_json      := l_json_config.get_array( 'plsqlCode' );
    for i in 0..l_code_json.get_size - 1 loop
      po_plsql_code := po_plsql_code || l_code_json.get_string( i ) || apex_application.lf;
    end loop;
  end get_runner_config;

  procedure run_task_script
  (
    pi_prcs_id  in flow_processes.prcs_id%type
  , pi_sbfl_id  in flow_subflows.sbfl_id%type
  , pi_objt_id  in flow_objects.objt_id%type
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  )
  as
    l_use_apex_exec boolean := false;
    l_plsql_code    clob;
    l_do_autobind   boolean := false;

    l_sql_parameters apex_exec.t_parameters;
  begin
    apex_debug.enter 
    ( 'run_task_script'
    , 'pi_objt_id', pi_objt_id
    );

    flow_globals.set_context 
    ( pi_prcs_id  => pi_prcs_id
    , pi_sbfl_id  => pi_sbfl_id 
    , pi_step_key => pi_step_key
    , pi_scope    => flow_engine_util.get_scope ( p_process_id => pi_prcs_id, p_subflow_id => pi_sbfl_id)
    );

    get_runner_config
    (
      pi_objt_id       => pi_objt_id
    , po_use_apex_exec => l_use_apex_exec
    , po_do_autobinds  => l_do_autobind
    , po_plsql_code    => l_plsql_code
    );

    if l_use_apex_exec then
      apex_exec.execute_plsql
      (
        p_plsql_code      => l_plsql_code
      , p_auto_bind_items => l_do_autobind
      , p_sql_parameters  => l_sql_parameters
      );
    else
      execute_plsql
      (
        p_plsql_code => l_plsql_code
      );
    end if;

  exception
    when e_plsql_script_requested_stop then 
      apex_debug.error
      (
        p_message => 'User script run by flow_plsql_runner_pkg.run_task_script requested stop.'
      , p0        => sqlerrm
      );
      raise e_plsql_script_requested_stop;     
    when others then
      apex_debug.error
      (
        p_message => 'Error during flow_plsql_runner_pkg.run_task_script. SQLERRM: %s'
      , p0        => sqlerrm
      );
      raise e_plsql_script_failed;
  end run_task_script;

end flow_plsql_runner_pkg;
/
