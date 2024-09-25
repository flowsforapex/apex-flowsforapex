create or replace package body flow_expressions
as 
  /* 
  -- Flows for APEX - flow_expressions.pkb
  -- 
  -- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
  -- (c) Copyright MT AG, 2021-2022.
  -- (c) Copyright Flowquest Limited. 2021-2024.
  --
  -- Created    22-Mar-2021  Richard Allen (Flowquest, for MT AG)
  -- Modified   12-Apr-2022  Richard Allen (Oracle)
  -- Modified   11-Feb-2024  Richard Allen (Flowquest)
  --
  */  
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
  , pi_var_scope    flow_subflows.sbfl_scope%type
  , pi_expr_scope   flow_subflows.sbfl_scope%type  
  )
  as 
    l_expression_text   flow_object_expressions.expr_expression%type;
    l_result_rec        flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_expressions.set_static'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'pi_expression.expr_var_type', pi_expression.expr_var_type
    , 'pi_expression.expr_expression' , pi_expression.expr_expression
    );

    l_expression_text := pi_expression.expr_expression;
    -- substitute any F4A Process Variables
    flow_proc_vars_int.do_substitution
    ( pi_prcs_id => pi_prcs_id
    , pi_sbfl_id => pi_sbfl_id
    , pi_scope   => pi_expr_scope
    , pio_string => l_expression_text
    );

    l_result_rec.var_name := pi_expression.expr_var_name;
    l_result_rec.var_type := pi_expression.expr_var_type;
    
    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
        l_result_rec.var_vc2   := l_expression_text;
    when flow_constants_pkg.gc_prov_var_type_number then
        l_result_rec.var_num   := l_expression_text;
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
        l_result_rec.var_date   := to_date(l_expression_text, flow_constants_pkg.gc_prov_default_date_format);
    when flow_constants_pkg.gc_prov_var_type_tstz then
        -- test timestamp is in our required format
        begin
          if l_expression_text != to_char ( to_timestamp_tz ( l_expression_text
                                          , flow_constants_pkg.gc_prov_default_tstz_format )
                                          , flow_constants_pkg.gc_prov_default_tstz_format ) then 
            raise e_var_exp_date_format_error;
          end if;
        exception
          when others then
            raise e_var_exp_date_format_error;
        end;
        l_result_rec.var_tstz := to_timestamp_tz(l_expression_text, flow_constants_pkg.gc_prov_default_tstz_format);
    when flow_constants_pkg.gc_prov_var_type_json then
        -- test is correct json (lax)
        begin
          if l_expression_text is not json then
            raise e_var_exp_json_format_error;
          end if;
        exception
          when others then
            raise e_var_exp_json_format_error;
        end;
        l_result_rec.var_json := l_expression_text;
    end case;
    -- set proc variable
    flow_proc_vars_int.set_var 
    ( pi_prcs_id        => pi_prcs_id
    , pi_var_value      => l_result_rec
    , pi_sbfl_id        => pi_sbfl_id
    , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
    , pi_expr_set       => pi_expression.expr_set    
    , pi_scope          => pi_var_scope
    );
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
    when e_var_exp_json_format_error then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_json_format'
      , p0 => pi_sbfl_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_json_format' || 'Error setting Process Variable %1: Incorrect JSON Format (Subflow: %0, Set: %3.)'     
    when others then
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_static_general'
      , p0 => pi_prcs_id
      , p1 => pi_expression.expr_var_name
      , p2 => pi_expression.expr_set
      );
      -- $F4AMESSAGE 'var_exp_static_general' || 'Error setting process variable %1 in process id %0 (set %2).  See error in event log.'
  end set_static;

  procedure set_proc_var
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  , pi_expression   t_expr_rec
  , pi_var_scope    flow_subflows.sbfl_scope%type
  , pi_expr_scope   flow_subflows.sbfl_scope%type
  )
  as 
    l_result_rec        flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_expressions.set_proc_var'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'proc var' , pi_expression.expr_expression
    );

    l_result_rec.var_name := pi_expression.expr_var_name;
    l_result_rec.var_type := pi_expression.expr_var_type;

    case pi_expression.expr_var_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then
        l_result_rec.var_vc2 :=   flow_proc_vars_int.get_var_vc2 
                                    ( pi_prcs_id  => pi_prcs_id
                                    , pi_var_name => pi_expression.expr_expression
                                    , pi_scope    => pi_expr_scope
                                    );    
    when flow_constants_pkg.gc_prov_var_type_date then
        l_result_rec.var_date  := flow_proc_vars_int.get_var_date 
                                    ( pi_prcs_id  => pi_prcs_id
                                    , pi_var_name => pi_expression.expr_expression
                                    , pi_scope    => pi_expr_scope
                                    );  
    when flow_constants_pkg.gc_prov_var_type_number then
        l_result_rec.var_num   := flow_proc_vars_int.get_var_num
                                    ( pi_prcs_id  => pi_prcs_id
                                    , pi_var_name => pi_expression.expr_expression
                                    , pi_scope    => pi_expr_scope                             
                                    );   
    when flow_constants_pkg.gc_prov_var_type_clob then
        l_result_rec.var_clob  := flow_proc_vars_int.get_var_clob 
                                    ( pi_prcs_id  => pi_prcs_id
                                    , pi_var_name => pi_expression.expr_expression
                                    , pi_scope    => pi_expr_scope
                                    );
    when flow_constants_pkg.gc_prov_var_type_tstz then
        l_result_rec.var_tstz :=  flow_proc_vars_int.get_var_tstz
                                    ( pi_prcs_id  => pi_prcs_id
                                    , pi_var_name => pi_expression.expr_expression
                                    , pi_scope    => pi_expr_scope
                                    );  
    when flow_constants_pkg.gc_prov_var_type_json then
        l_result_rec.var_json  := flow_proc_vars_int.get_var_json 
                                    ( pi_prcs_id  => pi_prcs_id
                                    , pi_var_name => pi_expression.expr_expression
                                    , pi_scope    => pi_expr_scope
                                    );
    end case; 
    -- set proc variable
    flow_proc_vars_int.set_var 
    ( pi_prcs_id        => pi_prcs_id
    , pi_var_value      => l_result_rec
    , pi_sbfl_id        => pi_sbfl_id
    , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
    , pi_expr_set       => pi_expression.expr_set    
    , pi_scope          => pi_var_scope
    );
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
      -- $F4AMESSAGE 'var_exp_static_general' || 'Error setting process variable %1 in process id %0 (set %2).  See error in event log.'      
  end set_proc_var;

  procedure set_sql
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_expression     t_expr_rec
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_var_scope      flow_subflows.sbfl_scope%type
  , pi_expr_scope     flow_subflows.sbfl_scope%type
  ) 
  as  
    l_result_rec      flow_proc_vars_int.t_proc_var_value;
  begin
      apex_debug.enter
    ( 'flow_expressions.set_sql'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'sql text' , pi_expression.expr_expression
    );

    l_result_rec := flow_db_exec.exec_flows_sql
                    ( pi_prcs_id      => pi_prcs_id
                    , pi_sbfl_id      => pi_sbfl_id
                    , pi_sql_text     => pi_expression.expr_expression
                    , pi_result_type  => pi_expression.expr_var_type
                    , pi_scope        => pi_expr_scope
                    , pi_expr_type    => pi_expression.expr_type
                    );

    l_result_rec.var_name   := pi_expression.expr_var_name;

    flow_proc_vars_int.set_var 
    ( pi_prcs_id        => pi_prcs_id
    , pi_var_value      => l_result_rec
    , pi_sbfl_id        => pi_sbfl_id
    , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
    , pi_expr_set       => pi_expression.expr_set
    , pi_scope          => pi_var_scope
    );

  exception
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
      -- $F4AMESSAGE 'var_exp_sql_other' || 'Error setting process variable %1 in process id %0 (set %2).  SQL error shown in event log.'    
  end set_sql;

  procedure set_plsql         
  ( pi_prcs_id      flow_processes.prcs_id%type
  , pi_expression   t_expr_rec
  , pi_sbfl_id      flow_subflows.sbfl_id%type
  , pi_var_scope    flow_subflows.sbfl_scope%type
  , pi_expr_scope   flow_subflows.sbfl_scope%type
  )
  as 
    l_result_rec                flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_expressions.set_plsql'
    , 'expr_var_name', pi_expression.expr_var_name
    , 'plsql text' , pi_expression.expr_expression
    );

    l_result_rec := flow_db_exec.exec_flows_plsql
                    ( pi_prcs_id      => pi_prcs_id
                    , pi_sbfl_id      => pi_sbfl_id
                    , pi_plsql_text   => pi_expression.expr_expression
                    , pi_result_type  => pi_expression.expr_var_type
                    , pi_scope        => pi_expr_scope
                    , pi_expr_type   => pi_expression.expr_type
                    );
    l_result_rec.var_name   := pi_expression.expr_var_name;

    -- set proc variable
    flow_proc_vars_int.set_var 
    ( pi_prcs_id        => pi_prcs_id
    , pi_var_value      => l_result_rec
    , pi_sbfl_id        => pi_sbfl_id
    , pi_objt_bpmn_id   => pi_expression.expr_objt_bpmn_id
    , pi_expr_set       => pi_expression.expr_set    
    , pi_scope          => pi_var_scope
    );

  exception
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
  end set_plsql;  

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
  , pi_var_scope    flow_subflows.sbfl_scope%type
  , pi_expr_scope   flow_subflows.sbfl_scope%type
  )
  as
    l_expressions   t_expr_set;
  begin
    apex_debug.enter
    ( 'process_expressions'
    , 'pi_objt_id', pi_objt_id
    , 'pi_set' , pi_set
    , 'pi_var_scope' , pi_var_scope
    , 'pi_expr_scope', pi_expr_scope
    );

    l_expressions := get_expression_set
    ( pi_objt_id => pi_objt_id
    , pi_set     => pi_set
    );
    if l_expressions.count > 0 then 
      -- set context
      flow_globals.set_context
      ( pi_prcs_id      => pi_prcs_id
      , pi_sbfl_id      => pi_sbfl_id
      , pi_scope        => pi_expr_scope
      , pi_loop_counter => flow_engine_util.get_loop_counter(pi_sbfl_id => pi_sbfl_id)
      );
      apex_debug.trace 
      ( p_message => 'l_expressions.count: %0'
      , p0        => l_expressions.count
      );
      -- step through expressions
      for i in 1..l_expressions.count loop
        -- process expression
        case 
          when l_expressions(i).expr_type = flow_constants_pkg.gc_expr_type_static then
            set_static 
            ( pi_prcs_id      => pi_prcs_id
            , pi_sbfl_id      => pi_sbfl_id
            , pi_expression   => l_expressions(i)
            , pi_var_scope    => pi_var_scope
            , pi_expr_scope   => pi_expr_scope 
            );
          when l_expressions(i).expr_type = flow_constants_pkg.gc_expr_type_proc_var then
            set_proc_var
            ( pi_prcs_id      => pi_prcs_id
            , pi_sbfl_id      => pi_sbfl_id
            , pi_expression   => l_expressions(i)
            , pi_var_scope    => pi_var_scope
            , pi_expr_scope   => pi_expr_scope 
            );
          when l_expressions(i).expr_type = flow_constants_pkg.gc_expr_type_sql  
            or l_expressions(i).expr_type = flow_constants_pkg.gc_expr_type_sql_delimited_list
            or l_expressions(i).expr_type = flow_constants_pkg.gc_expr_type_sql_json_array
          then
            set_sql
            ( pi_prcs_id      => pi_prcs_id
            , pi_expression   => l_expressions(i)
            , pi_sbfl_id      => pi_sbfl_id
            , pi_var_scope    => pi_var_scope
            , pi_expr_scope   => pi_expr_scope             
            );  
          when l_expressions(i).expr_type in ( flow_constants_pkg.gc_expr_type_plsql_expression
                                             , flow_constants_pkg.gc_expr_type_plsql_raw_expression
                                             , flow_constants_pkg.gc_expr_type_plsql_function_body
                                             , flow_constants_pkg.gc_expr_type_plsql_raw_function_body )
          then
            set_plsql
            ( pi_prcs_id      => pi_prcs_id
            , pi_expression   => l_expressions(i)
            , pi_sbfl_id      => pi_sbfl_id
            , pi_var_scope    => pi_var_scope
            , pi_expr_scope   => pi_expr_scope             
            );  
          else
              pragma coverage ('not_feasible');
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
  , pi_var_scope    flow_subflows.sbfl_scope%type
  , pi_expr_scope   flow_subflows.sbfl_scope%type
  )
  is 
    l_objt_id       flow_objects.objt_id%type;
  begin 
    apex_debug.enter
    ( 'process_expressions'
    , 'pi_objt_bpmn_id', pi_objt_bpmn_id
    , 'pi_set' , pi_set
    , 'pi_var_scope' , pi_var_scope
    , 'pi_expr_scope', pi_expr_scope
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
    , pi_var_scope    => pi_var_scope
    , pi_expr_scope   => pi_expr_scope 
    );
  exception
    when no_data_found then
      pragma coverage ('not_feasible');
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
