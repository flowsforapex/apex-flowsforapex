create or replace package body flow_plsql_runner_pkg
as

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
    return g_current_prcs_id;
  end get_current_prcs_id;

  function get_current_sbfl_id
    return flow_subflows.sbfl_id%type
  as
  begin
    return g_current_sbfl_id;
  end get_current_sbfl_id;

  procedure execute_plsql
  (
    p_plsql_code in varchar2
  )
  as
  begin
    -- Always wrap code into begin..end
    -- Developers are allowed to omit those if no declaration section needed

    execute immediate
      'begin' || apex_application.lf ||
      p_plsql_code || apex_application.lf ||
      'end;'
    ;
  end execute_plsql;

  procedure run_task_script
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  , pi_objt_id in flow_objects.objt_id%type
  )
  as
    l_use_apex_exec boolean := false;
    l_plsql_code    flow_object_attributes.obat_vc_value%type;
    l_do_autobind   boolean := false;

    l_sql_parameters apex_exec.t_parameters;
  begin
    init_globals( pi_prcs_id => pi_prcs_id, pi_sbfl_id => pi_sbfl_id );

    for rec in ( select obat.obat_key
                      , obat.obat_vc_value
                   from flow_object_attributes obat
                  where obat.obat_objt_id = pi_objt_id
                    and obat.obat_key in ( flow_constants_pkg.gc_apex_scripttask_engine
                                         , flow_constants_pkg.gc_apex_scripttask_plsql_code
                                         , flow_constants_pkg.gc_apex_scripttask_auto_binds
                                         )
               )
    loop
      case rec.obat_key
        when flow_constants_pkg.gc_apex_scripttask_engine then
          l_use_apex_exec := ( rec.obat_vc_value = flow_constants_pkg.gc_vcbool_true );
        when flow_constants_pkg.gc_apex_scripttask_plsql_code then
          l_plsql_code := rec.obat_vc_value;
        when flow_constants_pkg.gc_apex_scripttask_auto_binds then
          l_do_autobind := ( rec.obat_vc_value = flow_constants_pkg.gc_vcbool_true );
        else
          null;
      end case;
    end loop;

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
    when others then
      apex_debug.error
      (
        p_message => 'Error during flow_plsql_runner_pkg.run_task_script. SQLERRM: %s'
      , p0        => sqlerrm
      );
      apex_error.add_error
      (
        p_message          => 'An error occured while processing defined PL/SQL. This is typically caused by an error in the given code.'
      , p_display_location => apex_error.c_inline_in_notification
      );
      raise e_plsql_call_failed;
  end run_task_script;

end flow_plsql_runner_pkg;
/
