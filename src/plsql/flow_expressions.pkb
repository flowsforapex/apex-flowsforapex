create or replace package body flow_expressions
as 
  
  type t_expr_rec is record
  ( expr_id             flow_object_expressions.expr_id%type
  , expr_objt_id        flow_object_expressions.expr_objt_id%type
  , expr_set            flow_object_expressions.expr_set%type
  , expr_order          flow_object_expressions.expr_order%type
  , expr_var_name       flow_object_expressions.expr_var_name%type
  , expr_var_type       flow_object_expressions.expr_var_type%type
  , expr_type           flow_object_expressions.expr_type%type
  , expr_expression     flow_object_expressions.expr_expression%type
  , expr_objt_bpmn_id   flow_objects.objt_bpmn_id%type
  );

  type t_expr_set is table of t_expr_rec;


  function get_expression_set
  ( pi_objt_id      flow_objects.objt_id%type
  , pi_set          flow_object_expressions.expr_set%type
  ) return t_expr_set
  as
    l_expressions   t_expr_set;
  begin
    select expr.expr_id
         , expr.expr_objt_id
         , expr.expr_set
         , expr.expr_order
         , expr.expr_var_name
         , expr.expr_var_type
         , expr.expr_type
         , expr.expr_expression
         , objt.objt_bpmn_id as expr_objt_bpmn_id
    bulk collect into l_expressions
      from flow_object_expressions expr
      join flow_objects objt
        on objt.objt_id = expr.expr_objt_id
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
  , pi_expression   t_expr_rec
  )
  as 
    l_expression_text   flow_object_expressions.expr_expression%type;
  begin
    apex_debug.enter
    ( 'flow_expressions.set_static'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'pi_expression.expr_var_type', pi_expression.expr_var_type
    , 'pi_expression.expr_expression' , pi_expression.expr_expression
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
        ( pi_prcs_id        => pi_prcs_id
        , pi_var_name       => pi_expression.expr_var_name
        , pi_vc2_value      => l_expression_text
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );
    when flow_constants_pkg.gc_prov_var_type_number then
        flow_process_vars.set_var 
        ( pi_prcs_id        => pi_prcs_id
        , pi_var_name       => pi_expression.expr_var_name
        , pi_num_value      => l_expression_text
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );
    when flow_constants_pkg.gc_prov_var_type_date then
        -- test date is in our required format
        begin
          if l_expression_text != to_char  ( to_date ( l_expression_text
                                                    , flow_constants_pkg.gc_prov_default_date_format )
                                          , flow_constants_pkg.gc_prov_default_date_format ) then 
          raise e_var_exp_date_format_error;
          end if;
        exception
          when others then
            raise e_var_exp_date_format_error;
        end;

        flow_process_vars.set_var 
        ( pi_prcs_id        => pi_prcs_id
        , pi_var_name       => pi_expression.expr_var_name
        , pi_date_value     => to_date(l_expression_text, flow_constants_pkg.gc_prov_default_date_format)
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        ); 
    end case;
  exception
    when e_var_exp_date_format_error then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_date_format'
      , p0 => pi_sbfl_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_date_format' || 'Error setting Process Variable %1: Incorrect Date Format (Subflow: %0, Set: %3.)'      
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_static_general'
      , p0 => pi_prcs_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_static_general' || 'Error setting %2 process variable %1 in process id %0.  See error in event log.'

  end set_static;

  procedure set_proc_var
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  , pi_expression   t_expr_rec
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
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );      
    when flow_constants_pkg.gc_prov_var_type_date then
        flow_process_vars.set_var 
        ( pi_prcs_id    => pi_prcs_id
        , pi_var_name   => pi_expression.expr_var_name
        , pi_date_value => flow_process_vars.get_var_date 
                           ( pi_prcs_id  => pi_prcs_id
                           , pi_var_name => pi_expression.expr_expression
                           )
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );     
    when flow_constants_pkg.gc_prov_var_type_number then
        flow_process_vars.set_var 
        ( pi_prcs_id      => pi_prcs_id
        , pi_var_name     => pi_expression.expr_var_name
        , pi_num_value    => flow_process_vars.get_var_num
                             ( pi_prcs_id  => pi_prcs_id
                             , pi_var_name => pi_expression.expr_expression
                             )
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );    
    when flow_constants_pkg.gc_prov_var_type_clob then
        flow_process_vars.set_var 
        ( pi_prcs_id    => pi_prcs_id
        , pi_var_name   => pi_expression.expr_var_name
        , pi_clob_value => flow_process_vars.get_var_clob 
                          ( pi_prcs_id  => pi_prcs_id
                          , pi_var_name => pi_expression.expr_expression
                          )
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );    
    end case; 
  exception
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_static_general'
      , p0 => pi_prcs_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_static_general' || 'Error setting %2 process variable %1 in process id %0.  See error in event log.'
        
  end set_proc_var;

  procedure set_sql
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   t_expr_rec
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_sql_text      flow_object_expressions.expr_expression%type;
    l_result_vc2    flow_process_variables.prov_var_vc2%type;
    l_result_date   flow_process_variables.prov_var_date%type;
    l_result_num    flow_process_variables.prov_var_num%type;
  begin
      apex_debug.enter
    ( 'flow_expressions.set_sql'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'sql text' , pi_expression.expr_expression
    );

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
          l_result_vc2 := null;
        when too_many_rows then
            flow_errors.handle_instance_error
            ( pi_prcs_id        => pi_prcs_id
            , pi_sbfl_id        => pi_sbfl_id
            , pi_message_key    => 'var_exp_sql_too_many_rows'
            , p0 => pi_prcs_id
            , p1 => pi_expression.expr_var_name
            , p2 => pi_expression.expr_set
            );
            -- $F4AMESSAGE 'var_exp_sql_too_many_rows' || 'Error setting %2 process variable %1 in process id %0.  Query returns multiple rows.'            
        when others then
            apex_debug.error
            ( p_message => 'Error setting process variable %s for process id %s. SQLERRM: %s'
            , p0        => pi_expression.expr_var_name
            , p1        => pi_prcs_id
            , p2        => sqlerrm
            );

            flow_errors.handle_instance_error
            ( pi_prcs_id        => pi_prcs_id
            , pi_sbfl_id        => pi_sbfl_id
            , pi_message_key    => 'var_exp_sql_other'
            , p0 => pi_prcs_id
            , p1 => pi_expression.expr_var_name
            , p2 => pi_expression.expr_set
            );
            -- $F4AMESSAGE 'var_exp_sql_other' || 'Error setting %2 process variable %1 in process id %0.  SQL error shown in event log.'               
        end;
        flow_process_vars.set_var 
        ( pi_prcs_id        => pi_prcs_id
        , pi_var_name       => pi_expression.expr_var_name
        , pi_vc2_value      => l_result_vc2
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );
    when flow_constants_pkg.gc_prov_var_type_date then
        begin
        execute immediate l_sql_text 
                    into l_result_date;
        exception
        when no_data_found then
            l_result_date := null;
        when too_many_rows then
            flow_errors.handle_instance_error
            ( pi_prcs_id        => pi_prcs_id
            , pi_sbfl_id        => pi_sbfl_id
            , pi_message_key    => 'var_exp_sql_too_many_rows'
            , p0 => pi_prcs_id
            , p1 => pi_expression.expr_var_name
            , p2 => pi_expression.expr_set
            );
            -- $F4AMESSAGE 'var_exp_sql_too_many_rows' || 'Error setting %2 process variable %1 in process id %0.  Query returns multiple rows.'            
        when others then
            apex_debug.error
            ( p_message => 'Error setting process variable %s for process id %s. SQLERRM: %s'
            , p0        => pi_expression.expr_var_name
            , p1        => pi_prcs_id
            , p2        => sqlerrm
            );

            flow_errors.handle_instance_error
            ( pi_prcs_id        => pi_prcs_id
            , pi_sbfl_id        => pi_sbfl_id
            , pi_message_key    => 'var_exp_sql_other'
            , p0 => pi_prcs_id
            , p1 => pi_expression.expr_var_name
            , p2 => pi_expression.expr_set
            );
            -- $F4AMESSAGE 'var_exp_sql_other' || 'Error setting %2 process variable %1 in process id %0.  SQL error shown in event log.'   
        end;
        flow_process_vars.set_var 
        ( pi_prcs_id        => pi_prcs_id
        , pi_var_name       => pi_expression.expr_var_name
        , pi_date_value     => l_result_date
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );
    when flow_constants_pkg.gc_prov_var_type_number then
        begin
        execute immediate l_sql_text 
                    into l_result_num;
        exception
        when no_data_found then
            l_result_num := null;
        when too_many_rows then
            flow_errors.handle_instance_error
            ( pi_prcs_id        => pi_prcs_id
            , pi_sbfl_id        => pi_sbfl_id
            , pi_message_key    => 'var_exp_sql_too_many_rows'
            , p0 => pi_prcs_id
            , p1 => pi_expression.expr_var_name
            , p2 => pi_expression.expr_set
            );
            -- $F4AMESSAGE 'var_exp_sql_too_many_rows' || 'Error setting %2 process variable %1 in process id %0.  Query returns multiple rows.'  
        when others then
            apex_debug.error
            ( p_message => 'Error setting process variable %0 for process id %1. SQLERRM: %2'
            , p0        => pi_expression.expr_var_name
            , p1        => pi_prcs_id
            , p2        => sqlerrm
            );

            flow_errors.handle_instance_error
            ( pi_prcs_id        => pi_prcs_id
            , pi_sbfl_id        => pi_sbfl_id
            , pi_message_key    => 'var_exp_sql_other'
            , p0 => pi_prcs_id
            , p1 => pi_expression.expr_var_name
            , p2 => pi_expression.expr_set
            );
            -- $F4AMESSAGE 'var_exp_sql_other' || 'Error setting %2 process variable %1 in process id %0.  SQL error shown in event log.'   
        end;
        flow_process_vars.set_var 
        ( pi_prcs_id        => pi_prcs_id
        , pi_var_name       => pi_expression.expr_var_name
        , pi_num_value      => l_result_num
        , pi_sbfl_id        => pi_sbfl_id
        , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
        , pi_expr_set       => pi_expression.expr_set
        );
    end case;
  end set_sql;

  procedure set_sql_delimited
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   t_expr_rec
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_sql_text        flow_object_expressions.expr_expression%type;
    l_result_set_vc2  apex_t_varchar2;
    l_result          flow_process_variables.prov_var_vc2%type;
  begin
      apex_debug.enter
    ( 'flow_expressions.set_sql_delimited'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'sql text' , pi_expression.expr_expression
    );
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
          l_result_set_vc2 := null;
    when others then
        apex_debug.error
        ( p_message => 'Error setting process variable %s for process id %s. SQLERRM: %s'
        , p0        => pi_expression.expr_var_name
        , p1        => pi_prcs_id
        , p2        => sqlerrm
        );
        flow_errors.handle_instance_error
        ( pi_prcs_id        => pi_prcs_id
        , pi_sbfl_id        => pi_sbfl_id
        , pi_message_key    => 'var_exp_sql_other'
        , p0 => pi_prcs_id
        , p1 => pi_expression.expr_var_name
        , p2 => pi_expression.expr_set
        );
        -- $F4AMESSAGE 'var_exp_sql_other' || 'Error setting %2 process variable %1 in process id %0.  SQL error shown in event log.'   
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
        flow_errors.handle_instance_error
        ( pi_prcs_id        => pi_prcs_id
        , pi_sbfl_id        => pi_sbfl_id
        , pi_message_key    => 'var_exp_sql_other'
        , p0 => pi_sbfl_id
        , p1 => pi_expression.expr_var_name
        , p2 => pi_expression.expr_set
        );
        -- $F4AMESSAGE 'var_exp_sql_other' || 'Error setting %2 process variable %1 in process id %0.  SQL error shown in event log.'
    end;
    apex_debug.message(p_message => 'Delimited String created %s', p0 => l_result, p_level => 3);
    -- set proc variable
    flow_process_vars.set_var 
    ( pi_prcs_id        => pi_prcs_id
    , pi_var_name       => pi_expression.expr_var_name
    , pi_vc2_value      => l_result
    , pi_sbfl_id        => pi_sbfl_id
    , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
    , pi_expr_set       => pi_expression.expr_set    
    );
  end set_sql_delimited;

  procedure set_plsql_expression         
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   t_expr_rec
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_result_vc2    flow_process_variables.prov_var_vc2%type;
    l_result_date   flow_process_variables.prov_var_date%type;
    l_result_num    flow_process_variables.prov_var_num%type;
  begin
    apex_debug.enter
    ( 'flow_expressions.set_plsql_expression'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'plsql expression' , pi_expression.expr_expression
    );
    -- evaluate the expression
    l_result_vc2 := apex_plugin_util.get_plsql_expression_result 
                    ( p_plsql_expression => pi_expression.expr_expression
                    );
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then

      flow_process_vars.set_var 
      ( pi_prcs_id        => pi_prcs_id
      , pi_var_name       => pi_expression.expr_var_name
      , pi_vc2_value      => l_result_vc2
      , pi_sbfl_id        => pi_sbfl_id
      , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
      , pi_expr_set       => pi_expression.expr_set
      );
    when flow_constants_pkg.gc_prov_var_type_date then
      -- test date value returned using our specified format
      if l_result_vc2 != to_char  ( to_date ( l_result_vc2 
                                            , flow_constants_pkg.gc_prov_default_date_format )
                                  , flow_constants_pkg.gc_prov_default_date_format ) then 
         raise e_var_exp_date_format_error;
      end if;
      flow_process_vars.set_var 
      ( pi_prcs_id        => pi_prcs_id
      , pi_var_name       => pi_expression.expr_var_name
      , pi_date_value     => to_date(l_result_vc2,flow_constants_pkg.gc_prov_default_date_format)
      , pi_sbfl_id        => pi_sbfl_id
      , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
      , pi_expr_set       => pi_expression.expr_set
      );
    when flow_constants_pkg.gc_prov_var_type_number then
      flow_process_vars.set_var 
      ( pi_prcs_id        => pi_prcs_id
      , pi_var_name       => pi_expression.expr_var_name
      , pi_num_value      => to_number(l_result_vc2)
      , pi_sbfl_id        => pi_sbfl_id
      , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
      , pi_expr_set       => pi_expression.expr_set
      ); 
    else
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_datatype'
      , p0 => pi_expression.expr_var_name
      );
      -- $F4AMESSAGE 'var_exp_datatype' || 'Error setting process variable.  Incorrect datatype for variable %0.  SQL error shown in debug output.'  
    end case;
  exception
    when e_var_exp_date_format_error then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_date_format'
      , p0 => pi_sbfl_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_date_format' || 'Error setting Process Variable %1: Incorrect Date Format (Subflow: %0, Set: %3.)'      
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_plsql_error'
      , p0 => pi_sbfl_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_plsql_error' || 'Subflow : %0 Error in %2 expression for Variable : %1'
  end set_plsql_expression;  

  procedure set_plsql_function        
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   t_expr_rec
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  as 
    l_result_vc2    flow_process_variables.prov_var_vc2%type;
    l_result_date   flow_process_variables.prov_var_date%type;
    l_result_num    flow_process_variables.prov_var_num%type;
  begin
    apex_debug.enter
    ( 'flow_expressions.set_plsql_function'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'plsql function body' , pi_expression.expr_expression
    );

    -- evaluate the function
    l_result_vc2 := apex_plugin_util.get_plsql_function_result 
                      ( p_plsql_function => pi_expression.expr_expression
                      );
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
      flow_process_vars.set_var 
      ( pi_prcs_id        => pi_prcs_id
      , pi_var_name       => pi_expression.expr_var_name
      , pi_vc2_value      => l_result_vc2
      , pi_sbfl_id        => pi_sbfl_id
      , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
      , pi_expr_set       => pi_expression.expr_set
      );
    when flow_constants_pkg.gc_prov_var_type_date then
      -- a date value must be returned using our specified format
      -- add a test that format is good?
      begin
        if l_result_vc2 != to_char  ( to_date ( l_result_vc2 
                                              , flow_constants_pkg.gc_prov_default_date_format )
                                    , flow_constants_pkg.gc_prov_default_date_format ) then 
        raise e_var_exp_date_format_error;
        end if;
      exception
        when others then
          raise e_var_exp_date_format_error;
      end;

      flow_process_vars.set_var 
      ( pi_prcs_id        => pi_prcs_id
      , pi_var_name       => pi_expression.expr_var_name
      , pi_date_value     => to_date(l_result_vc2, flow_constants_pkg.gc_prov_default_date_format)
      , pi_sbfl_id        => pi_sbfl_id
      , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
      , pi_expr_set       => pi_expression.expr_set
      );
    when flow_constants_pkg.gc_prov_var_type_number then
      flow_process_vars.set_var 
      ( pi_prcs_id        => pi_prcs_id
      , pi_var_name       => pi_expression.expr_var_name
      , pi_num_value      => to_number(l_result_vc2)
      , pi_sbfl_id        => pi_sbfl_id
      , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
      , pi_expr_set       => pi_expression.expr_set 
      ); 
    else
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_datatype'
      , p0 => pi_expression.expr_var_name
      );
      -- $F4AMESSAGE 'var_exp_datatype' || 'Error setting process variable.  Incorrect datatype for variable %0.  SQL error shown in debug output.'  
    end case;
  exception
    when e_var_exp_date_format_error then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_date_format'
      , p0 => pi_sbfl_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_date_format' || 'Error setting Process Variable %1: Incorrect Date Format (Subflow: %0, Set: %3.)'    
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_plsql_error'
      , p0 => pi_sbfl_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_plsql_error' || 'Subflow : %0 Error in %2 expression for Variable : %1'
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
    if l_expressions.count > 0 then 
      -- set context
      flow_globals.set_context
      ( pi_prcs_id => pi_prcs_id
      , pi_sbfl_id => pi_sbfl_id
      );
      apex_debug.trace 
      ( p_message => 'l_expressions.count: %0'
      , p0        => l_expressions.count
      );
      -- step through expressions
      for i in 1..l_expressions.count loop
        -- process expression
        case l_expressions(i).expr_type
          when flow_constants_pkg.gc_expr_type_static then
            set_static 
            ( pi_prcs_id      => pi_prcs_id
            , pi_sbfl_id      => pi_sbfl_id
            , pi_expression   => l_expressions(i)
            );
          when flow_constants_pkg.gc_expr_type_proc_var then
            set_proc_var
            ( pi_prcs_id    => pi_prcs_id
            , pi_sbfl_id    => pi_sbfl_id
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
    end if;
  end process_expressions;

  -- overloaded process_expressions that accepts a objt_bpmn_id rather than an objt_id
  procedure process_expressions
  ( pi_objt_bpmn_id flow_objects.objt_bpmn_id%type
  , pi_set          flow_object_expressions.expr_set%type
  , pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  )
  is 
    l_objt_id       flow_objects.objt_id%type;
  begin 
    apex_debug.enter
    ( 'process_expressions'
    , 'pi_objt_bpmn_id', pi_objt_bpmn_id
    , 'pi_set' , pi_set
    );
    -- look up the objt_id
    select objt.objt_id
      into l_objt_id
      from flow_objects objt
      join flow_subflows sbfl 
        on sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
     where sbfl.sbfl_id = pi_sbfl_id
       and objt.objt_bpmn_id = pi_objt_bpmn_id
    ;
    process_expressions
    ( pi_objt_id      => l_objt_id
    , pi_set          => pi_set
    , pi_prcs_id      => pi_prcs_id
    , pi_sbfl_id      => pi_sbfl_id
    );
  exception
    when no_data_found then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_object_not_found'
      , p0 => pi_objt_bpmn_id
      );
      -- $F4AMESSAGE 'var_exp_object_not_found' || 'Internal error looking up object %0 in process_expressions.  SQL error shown in debug output.'  
  end process_expressions; 
  
end flow_expressions;
/
