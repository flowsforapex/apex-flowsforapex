create or replace package body flow_plsql_runner_pkg
as
/* 
-- Flows for APEX - flow_plsql_runner_pkg.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created    15-Nov-2020  Moritz Klein (MT AG)
-- Modified   12-Apr-2022  Richard Allen (Oracle)
-- Modified   20-May-2022  Moritz Klein (MT AG)
-- Modified   2022-07-18   Moritz Klein (MT AG)
--
*/

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
    po_plsql_code    := flow_engine_util.json_array_join( p_json_array => l_code_json );
  end get_runner_config;

  procedure run_task_script
  (
    pi_sbfl_rec in flow_subflows%rowtype
  , pi_objt_id  in flow_objects.objt_id%type
  )
  as
    l_use_apex_exec boolean := false;
    l_plsql_code    clob;
    l_do_autobind   boolean := false;
    l_input_parameter_definitions clob;
    l_input_parameters            clob;

    l_sql_parameters apex_exec.t_parameters;
  begin
    apex_debug.enter 
    ( 'run_task_script'
    , 'pi_objt_id', pi_objt_id
    , 'pi_sbfl_id', pi_sbfl_rec.sbfl_id
    );

    -- AHSP starts may provide precomputed input parameters. For standard PL/SQL tasks,
    -- compute them from the BPMN definitions at execution time.
    l_input_parameters := pi_sbfl_rec.sbfl_task_input_parameters;

    if l_input_parameters is null then
      l_input_parameter_definitions := flow_parameters.get_input_parameter_definitions
                                       ( pi_objt_id => pi_objt_id );

      if l_input_parameter_definitions is not null
         and l_input_parameter_definitions is json then
        l_input_parameters := flow_parameters.process_input_parameters
                              ( pi_parameter_definitions => l_input_parameter_definitions
                              , pi_user_input_data       => null
                              , pi_process_id            => pi_sbfl_rec.sbfl_prcs_id
                              , pi_subflow_id            => pi_sbfl_rec.sbfl_id
                              , pi_scope                 => pi_sbfl_rec.sbfl_scope
                              , pi_allow_user_input      => (pi_sbfl_rec.sbfl_is_adhoc = flow_constants_pkg.gc_true)
                              );

        update flow_subflows
           set sbfl_task_input_parameters = l_input_parameters
         where sbfl_id = pi_sbfl_rec.sbfl_id;
      end if;
    end if;

    flow_globals.set_context
    ( pi_prcs_id          => pi_sbfl_rec.sbfl_prcs_id
    , pi_sbfl_id          => pi_sbfl_rec.sbfl_id
    , pi_step_key         => pi_sbfl_rec.sbfl_step_key
    , pi_scope            => flow_engine_util.get_scope ( p_process_id => pi_sbfl_rec.sbfl_prcs_id, p_subflow_id => pi_sbfl_rec.sbfl_id)
    , pi_loop_counter     => flow_engine_util.get_loop_counter (pi_sbfl_id => pi_sbfl_rec.sbfl_id)
    , pi_input_parameters => l_input_parameters
    );

    apex_debug.message
    ( p_message => 'run_task_script input parameters JSON (first 2000 chars): %0'
    , p0        => dbms_lob.substr(l_input_parameters, 2000, 1)
    );

    get_runner_config
    (
      pi_objt_id       => pi_objt_id
    , po_use_apex_exec => l_use_apex_exec
    , po_do_autobinds  => l_do_autobind
    , po_plsql_code    => l_plsql_code
    );

    flow_proc_vars_int.do_substitution
    (
      pi_prcs_id  => pi_sbfl_rec.sbfl_prcs_id
    , pi_sbfl_id  => pi_sbfl_rec.sbfl_id
    , pi_scope    => flow_globals.scope
    , pi_step_key => pi_sbfl_rec.sbfl_step_key
    , pio_string  => l_plsql_code
    );

    if not l_do_autobind then
      -- bind in process variables rather than APEX session state
      l_sql_parameters := flow_proc_vars_int.get_parameter_list
                          ( pi_expr       => l_plsql_code
                          , pi_prcs_id     => pi_sbfl_rec.sbfl_prcs_id
                          , pi_sbfl_id    => pi_sbfl_rec.sbfl_id
                          , pi_step_key   => pi_sbfl_rec.sbfl_step_key
                          , pi_scope      => flow_globals.scope
                          );
    end if;
      
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

    apex_debug.message
    ( p_message => 'run_task_script output parameters JSON: %0'
    , p0        => flow_globals.get_output_parameters
    );

    -- Save output parameters back to the database if any were set
    if flow_globals.get_output_parameters is not null then
      update flow_subflows
         set sbfl_task_output_parameters = flow_globals.get_output_parameters
       where sbfl_id = pi_sbfl_rec.sbfl_id;
    end if;

  exception
    when e_plsql_script_requested_stop then 
      apex_debug.error
      (
        p_message => 'User script run by flow_plsql_runner_pkg.run_task_script requested stop.'
      , p0        => sqlerrm
      );
      raise flow_globals.request_stop_engine;  
    when flow_globals.request_stop_engine then   
      apex_debug.error
      (
        p_message => 'User script run by flow_plsql_runner_pkg.run_task_script requested stop.'
      , p0        => sqlerrm
      );
      raise flow_globals.request_stop_engine;  
    when flow_globals.throw_bpmn_error_event then
      apex_debug.error
      (
        p_message => 'User script run by flow_plsql_runner_pkg.run_task_script threw BPMN error.'
      , p0        => sqlerrm
      );
      raise flow_globals.throw_bpmn_error_event;
    when others then
      -- common error is that l_plsql_code is missing a final semicolon. Test if final char is a semicolon and give a helpful message if not.
      if l_plsql_code is not null and dbms_lob.substr(l_plsql_code,-1) <> ';' then
        apex_debug.error
        (
          p_message => 'Error during flow_plsql_runner_pkg.run_task_script. Possible missing semicolon at end of PL/SQL code. Code: "%1" SQLERRM: %0'
        , p0        => sqlerrm
        , p1        => l_plsql_code
        );
      else
        apex_debug.error
        (
          p_message => 'Error during flow_plsql_runner_pkg.run_task_script. Code: "%1" SQLERRM: %0'
        , p0        => sqlerrm
        , p1        => l_plsql_code
        );
      end if;
      raise e_plsql_script_failed;
  end run_task_script;

end flow_plsql_runner_pkg;
/
