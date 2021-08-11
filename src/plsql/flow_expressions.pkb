create or replace package body flow_expressions
as 
  

  type t_expr_set is table of flow_object_expressions%rowtype;


  function get_expression_set
  ( pi_objt_id      flow_objects.objt_id%type
  , pi_set          flow_object_expressions.expr_set%type
  ) return t_expr_set
  as
    l_expressions   t_expr_set;
  begin
    select *
    bulk collect into l_expressions
      from flow_object_expressions expr
     where expr.expr_objt_id = pi_objt_id
       and expr.expr_set = pi_set
     order by expr.expr_order asc
    ;
    return l_expressions;
  end get_expression_set;

  /**********************************************************************
  **
  ** Process various expression types
  **
  ***********************************************************************
  */

  procedure set_static
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  , pi_expression   flow_object_expressions%rowtype
  )
  as 
    l_expression_text   flow_object_expressions.expr_expression%type;
  begin
    apex_debug.enter
    ( 'flow_expressions.set_static'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'pi_expression_text' , l_expression_text
    );

    l_expression_text := pi_expression.expr_expression;
    -- substitute any F4A Process Variables
    flow_process_vars.do_substitution
    ( pi_prcs_id => pi_prcs_id
    , pi_sbfl_id => pi_sbfl_id
    , pio_string => l_expression_text
    );
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_vc2_value => l_expression_text
        );
    when flow_constants_pkg.gc_prov_var_type_number then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_num_value => l_expression_text
        );
    when flow_constants_pkg.gc_prov_var_type_date then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_date_value => l_expression_text
        );
    when flow_constants_pkg.gc_prov_var_type_clob then
        -- does this one make sense?
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_clob_value => l_expression_text
        );  
    end case;
  end set_static;

  procedure set_proc_var
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  )
  as 
  begin
    apex_debug.enter
    ( 'flow_expressions.set_proc_var'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'proc var' , pi_expression.expr_expression
    );
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_vc2_value => flow_process_vars.get_var_vc2 
                          ( pi_prcs_id => pi_prcs_id
                          , pi_var_name => pi_expression.expr_expression
                          )
        );      
    when flow_constants_pkg.gc_prov_var_type_date then
        flow_process_vars.set_var 
        ( pi_prcs_id    => pi_prcs_id
        , pi_var_name   => pi_expression.expr_var_name
        , pi_date_value => flow_process_vars.get_var_date 
                           ( pi_prcs_id  => pi_prcs_id
                           , pi_var_name => pi_expression.expr_expression
                           )
        );     
    when flow_constants_pkg.gc_prov_var_type_number then
        flow_process_vars.set_var 
        ( pi_prcs_id      => pi_prcs_id
        , pi_var_name     => pi_expression.expr_var_name
        , pi_num_value    => flow_process_vars.get_var_num
                             ( pi_prcs_id  => pi_prcs_id
                             , pi_var_name => pi_expression.expr_expression
                             )
        );    
    when flow_constants_pkg.gc_prov_var_type_clob then
        flow_process_vars.set_var 
        ( pi_prcs_id    => pi_prcs_id
        , pi_var_name   => pi_expression.expr_var_name
        , pi_clob_value => flow_process_vars.get_var_clob 
                          ( pi_prcs_id  => pi_prcs_id
                          , pi_var_name => pi_expression.expr_expression
                          )
        );    
    end case;         
  end set_proc_var;

  procedure set_sql
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_sql_text      flow_object_expressions.expr_expression%type;
    l_result_vc2    flow_process_variables.prov_var_vc2%type;
    l_result_date   flow_process_variables.prov_var_date%type;
    l_result_num    flow_process_variables.prov_var_num%type;
  begin
    l_sql_text := pi_expression.expr_expression;
    -- substitute any F4A Process Variables
    flow_process_vars.do_substitution
    ( pi_prcs_id => pi_prcs_id
    , pi_sbfl_id => null
    , pio_string => l_sql_text
    );
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
        begin
        execute immediate l_sql_text 
                    into l_result_vc2;
        exception
        when no_data_found then
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  No data found in query.'
            , p_display_location => apex_error.c_on_error_page
            );
        when too_many_rows then
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  Query returns multiple rows.'
            , p_display_location => apex_error.c_on_error_page
            );
        when others then
            apex_debug.error
            ( p_message => 'Error setting process variable %s for process id %s. SQLERRM: %s'
            , p0        => pi_expression.expr_var_name
            , p1        => pi_prcs_id
            , p2        => sqlerrm
            );
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  SQL error shown in debug output.'
            , p_display_location => apex_error.c_on_error_page
            );
        end;
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_vc2_value => l_result_vc2
        );
    when flow_constants_pkg.gc_prov_var_type_date then
        begin
        execute immediate l_sql_text 
                    into l_result_date;
        exception
        when no_data_found then
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  No data found in query.'
            , p_display_location => apex_error.c_on_error_page
            );
        when too_many_rows then
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  Query returns multiple rows.'
            , p_display_location => apex_error.c_on_error_page
            );
        when others then
            apex_debug.error
            ( p_message => 'Error setting process variable %s for process id %s. SQLERRM: %s'
            , p0        => pi_expression.expr_var_name
            , p1        => pi_prcs_id
            , p2        => sqlerrm
            );
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  SQL error shown in debug output.'
            , p_display_location => apex_error.c_on_error_page
            );
        end;
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_date_value => l_result_date
        );
    when flow_constants_pkg.gc_prov_var_type_number then
        begin
        execute immediate l_sql_text 
                    into l_result_num;
        exception
        when no_data_found then
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  No data found in query.'
            , p_display_location => apex_error.c_on_error_page
            );
        when too_many_rows then
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  Query returns multiple rows.'
            , p_display_location => apex_error.c_on_error_page
            );
        when others then
            apex_debug.error
            ( p_message => 'Error setting process variable %0 for process id %1. SQLERRM: %2'
            , p0        => pi_expression.expr_var_name
            , p1        => pi_prcs_id
            , p2        => sqlerrm
            );
            apex_error.add_error
            ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  SQL error shown in debug output.'
            , p_display_location => apex_error.c_on_error_page
            );
        end;
        flow_process_vars.set_var 
        ( pi_prcs_id   => pi_prcs_id
        , pi_var_name  => pi_expression.expr_var_name
        , pi_num_value => l_result_num
        );
    end case;
  end set_sql;

  procedure set_sql_delimited
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_sql_text        flow_object_expressions.expr_expression%type;
    l_result_set_vc2  apex_t_varchar2;
    l_result          flow_process_variables.prov_var_vc2%type;
  begin
    l_sql_text := pi_expression.expr_expression;
    -- substitute any F4A Process Variables
    flow_process_vars.do_substitution
    ( pi_prcs_id => pi_prcs_id
    , pi_sbfl_id => pi_sbfl_id
    , pio_string => l_sql_text
    );
    begin
        execute immediate l_sql_text 
        bulk collect into  l_result_set_vc2;
    exception
    when no_data_found then
        apex_error.add_error
        ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'s.  No data found in query.'
        , p_display_location => apex_error.c_on_error_page
        );
    when others then
        apex_debug.error
        ( p_message => 'Error setting process variable %s for process id %s. SQLERRM: %s'
        , p0        => pi_expression.expr_var_name
        , p1        => pi_prcs_id
        , p2        => sqlerrm
        );
        apex_error.add_error
        ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  SQL error shown in debug output.'
        , p_display_location => apex_error.c_on_error_page
        );
    end;
    -- create delimited string output
    begin 
        l_result := apex_string.join
        ( p_table => l_result_set_vc2
        , p_sep => ':'
        );
    exception
    when others then
        apex_debug.error
        ( p_message => 'Error setting process variable %s for process id %s. SQLERRM: %s'
        , p0        => pi_expression.expr_var_name
        , p1        => pi_prcs_id
        , p2        => sqlerrm
        );
        apex_error.add_error
        ( p_message          => 'Error setting process variable '||pi_expression.expr_var_name||' for process id '||pi_prcs_id||'.  SQL error shown in debug output.'
        , p_display_location => apex_error.c_on_error_page
        );
    end;
    apex_debug.message(p_message => 'Delimited String created %s', p0 => l_result, p_level => 3);
    -- set proc variable
    flow_process_vars.set_var 
    ( pi_prcs_id   => pi_prcs_id
    , pi_var_name  => pi_expression.expr_var_name
    , pi_vc2_value => l_result
    );
  end set_sql_delimited;

  procedure set_plsql_expression         
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_result_vc2    flow_process_variables.prov_var_vc2%type;
    l_result_date   flow_process_variables.prov_var_date%type;
    l_result_num    flow_process_variables.prov_var_num%type;
  begin
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
      l_result_vc2 := apex_plugin_util.get_plsql_expression_result 
                      ( p_plsql_expression => pi_expression.expr_expression
                      );
      flow_process_vars.set_var 
      ( pi_prcs_id   => pi_prcs_id
      , pi_var_name  => pi_expression.expr_var_name
      , pi_vc2_value => l_result_vc2
      );
    when flow_constants_pkg.gc_prov_var_type_date then
      l_result_vc2 := apex_plugin_util.get_plsql_expression_result 
                      ( p_plsql_expression => pi_expression.expr_expression
                      );
      -- a date value must be returned using our specified format
      flow_process_vars.set_var 
      ( pi_prcs_id   => pi_prcs_id
      , pi_var_name  => pi_expression.expr_var_name
      , pi_date_value => to_date(l_result_vc2,'DD-MON-YYYY HH24:MI:SS')
      );
    when flow_constants_pkg.gc_prov_var_type_number then
      l_result_vc2 := apex_plugin_util.get_plsql_expression_result 
                      ( p_plsql_expression => pi_expression.expr_expression
                      );
      flow_process_vars.set_var 
      ( pi_prcs_id   => pi_prcs_id
      , pi_var_name  => pi_expression.expr_var_name
      , pi_num_value => to_number(l_result_vc2)
      ); 
    else
      apex_error.add_error
      ( p_message          => 'Error setting process variable.  Incorrect datatype for variable '||pi_expression.expr_var_name||'.  SQL error shown in debug output.'
      , p_display_location => apex_error.c_on_error_page
      );
    end case;
  end set_plsql_expression;  

  procedure set_plsql_function        
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   flow_object_expressions%rowtype
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_result_vc2    flow_process_variables.prov_var_vc2%type;
    l_result_date   flow_process_variables.prov_var_date%type;
    l_result_num    flow_process_variables.prov_var_num%type;
  begin
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
      l_result_vc2 := apex_plugin_util.get_plsql_function_result 
                      ( p_plsql_function => pi_expression.expr_expression
                      );
      flow_process_vars.set_var 
      ( pi_prcs_id   => pi_prcs_id
      , pi_var_name  => pi_expression.expr_var_name
      , pi_vc2_value => l_result_vc2
      );
    when flow_constants_pkg.gc_prov_var_type_date then
      l_result_vc2 := apex_plugin_util.get_plsql_function_result 
                      ( p_plsql_function => pi_expression.expr_expression
                      );
      -- a date value must be returned using our specified format
      flow_process_vars.set_var 
      ( pi_prcs_id   => pi_prcs_id
      , pi_var_name  => pi_expression.expr_var_name
      , pi_date_value => to_date(l_result_vc2,'DD-MON-YYYY HH24:MI:SS')
      );
    when flow_constants_pkg.gc_prov_var_type_number then
      l_result_vc2 := apex_plugin_util.get_plsql_function_result 
                      ( p_plsql_function => pi_expression.expr_expression
                      );
      flow_process_vars.set_var 
      ( pi_prcs_id   => pi_prcs_id
      , pi_var_name  => pi_expression.expr_var_name
      , pi_num_value => to_number(l_result_vc2)
      ); 
    else
      apex_error.add_error
      ( p_message          => 'Error setting process variable.  Incorrect datatype for variable '||pi_expression.expr_var_name||'.  SQL error shown in debug output.'
      , p_display_location => apex_error.c_on_error_page
      );
    end case;
  end set_plsql_function;

  /**********************************************************************
  **
  ** Main Procedure
  **
  ***********************************************************************
  */

  procedure process_expressions
  ( pi_objt_id      flow_objects.objt_id%type
  , pi_set          flow_object_expressions.expr_set%type
  , pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as
    l_expressions   t_expr_set;
  begin
    apex_debug.enter
    ( 'process_expressions'
    , 'pi_objt_id', pi_objt_id
    , 'pi_set' , pi_set
    );
    l_expressions := get_expression_set
    ( pi_objt_id => pi_objt_id
    , pi_set     => pi_set
    );
    -- step through expressions
    for i in 1..l_expressions.count loop
      -- process expression
      case l_expressions(i).expr_type
        when flow_constants_pkg.gc_expr_type_static then
          set_static 
          ( pi_prcs_id => pi_prcs_id
          , pi_sbfl_id => pi_sbfl_id
          , pi_expression => l_expressions(i));
        when flow_constants_pkg.gc_expr_type_proc_var then
          set_proc_var
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i));
        when flow_constants_pkg.gc_expr_type_sql  then
          set_sql
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i)
          , pi_sbfl_id => pi_sbfl_id);
        when flow_constants_pkg.gc_expr_type_sql_delimited_list  then
          set_sql_delimited
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i)
          , pi_sbfl_id => pi_sbfl_id);     
        when flow_constants_pkg.gc_expr_type_plsql_expression then
          set_plsql_expression
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i)
          , pi_sbfl_id => pi_sbfl_id); 
        when flow_constants_pkg.gc_expr_type_plsql_function_body then
          set_plsql_function
          ( pi_prcs_id => pi_prcs_id
          , pi_expression => l_expressions(i)
          , pi_sbfl_id => pi_sbfl_id);  
        else
            null;
      end case;
    end loop;
  end process_expressions;
  
end flow_expressions;
/