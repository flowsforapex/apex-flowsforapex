create or replace package body flow_settings
as 
/* 
-- Flows for APEX - flow_settings.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created    23-Nov-2022  Richard Allen (Oracle)
--
*/


  function get_due_on
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_objects.objt_attributes%type
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return timestamp with time zone
  is
    l_json_def          sys.json_object_t;
    l_result_rec        flow_proc_vars_int.t_proc_var_value;
    l_expression_type   flow_types_pkg.t_bpmn_attribute_vc2;
    l_value_type        flow_types_pkg.t_bpmn_attribute_vc2;
    l_value             flow_types_pkg.t_bpmn_attribute_vc2;
    l_data_type         flow_types_pkg.t_bpmn_attribute_vc2;
    l_format_mask       flow_types_pkg.t_bpmn_attribute_vc2;
    l_expression        flow_types_pkg.t_bpmn_attribute_vc2;
    l_function_body     flow_types_pkg.t_bpmn_attribute_vc2;
    l_content           flow_types_pkg.t_bpmn_attribute_vc2;
    l_return_tstz       timestamp with time zone;

    e_invalid_interval_spec    exception;
    pragma exception_init (e_invalid_interval_spec , -1867);  

  begin
    -- split based on expression type
    apex_json.parse( p_source => pi_expr );

    l_expression_type    := apex_json.get_varchar2( p_path => 'expressionType' );
    l_expression         := apex_json.get_varchar2( p_path => 'expression' );
    l_format_mask        := apex_json.get_varchar2( p_path => 'formatMask' );


    if l_expression_type in ( flow_constants_pkg.gc_expr_type_static 
                            , flow_constants_pkg.gc_date_value_type_duration
                            , flow_constants_pkg.gc_date_value_type_oracle_scheduler
                            ) then
      -- static types - timestamp, duration & scheduler statics - start by doing substitutions
      flow_proc_vars_int.do_substitution
        ( pi_prcs_id => pi_prcs_id
        , pi_sbfl_id => pi_sbfl_id
        , pi_scope   => pi_scope
        , pio_string => l_expression 
        );
    end if;

    case 
    when l_expression_type = flow_constants_pkg.gc_expr_type_static then    
      l_return_tstz := to_timestamp_tz ( l_expression, l_format_mask);
    when l_expression_type = flow_constants_pkg.gc_date_value_type_duration then
      l_return_tstz := systimestamp + to_dsinterval( l_expression );
    when l_expression_type = flow_constants_pkg.gc_date_value_type_oracle_scheduler then
      sys.dbms_scheduler.evaluate_calendar_string ( calendar_string   => l_expression
                                                  , start_date        => systimestamp -- to get correct TZ, should this be localtimestamp?
                                                  , return_date_after => systimestamp
                                                  , next_run_date     => l_return_tstz
                                                  );
      l_return_tstz := l_return_tstz;

    when l_expression_type = flow_constants_pkg.gc_expr_type_proc_var then
      l_return_tstz := flow_proc_vars_int.get_var_tstz  ( pi_prcs_id    => pi_prcs_id
                                                        , pi_var_name   => l_expression
                                                        , pi_scope      => pi_scope
                                                        );       
  
    when l_expression_type = flow_constants_pkg.gc_expr_type_sql then
      l_result_rec := flow_util.exec_flows_sql 
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_sql_text     => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_tstz
                      , pi_scope        => pi_scope
                      , pi_expr_type    => flow_constants_pkg.gc_expr_type_sql 
                      );
      l_return_tstz := l_result_rec.var_tstz;
    when l_expression_type in ( flow_constants_pkg.gc_expr_type_plsql_function_body 
                              , flow_constants_pkg.gc_expr_type_plsql_raw_function_body 
                              , flow_constants_pkg.gc_expr_type_plsql_expression
                              , flow_constants_pkg.gc_expr_type_plsql_raw_expression )   
    then
      l_result_rec := flow_util.exec_flows_plsql 
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_plsql_text   => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_tstz
                      , pi_scope        => pi_scope
                      , pi_expr_type    => l_expression_type 
                      );
      l_return_tstz := l_result_rec.var_tstz;
    end case;
    return l_return_tstz;
  exception
    when e_invalid_interval_spec then
      apex_debug.info 
      ( p_message => ' --- Error evaluating Due On.  Interval expression is invalid.  Interval: %0.'
      , p0 => l_expression
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'due-on-interval-error'
      , p0 => l_expression
      );  
      -- $F4AMESSAGE 'due-on-interval-error' || 'Error evaluating Due On.  Interval expression is invalid.  Interval: %0.'  
      return systimestamp;  
    when others then
      apex_debug.info 
      ( p_message => ' --- Error evaluating Due On.  Due On expression is invalid.  Interval Expression: %0.  systimestamp returned.'
      , p0 => l_expression
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'due-on-error'
      , p0 => l_expression
      );  
      -- $F4AMESSAGE 'due-on-error' || 'Error evaluating Due On.  Due On expression is invalid.  Interval Expression: %0.  systimestamp returned.'  
      return systimestamp;  
  end get_due_on;

  function get_priority
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return flow_processes.prcs_priority%type
  is
    l_values                          apex_json.t_values;
    l_result_rec                      flow_proc_vars_int.t_proc_var_value;
    l_expression_type                 flow_types_pkg.t_bpmn_attribute_vc2;
    l_expression                      flow_types_pkg.t_bpmn_attribute_vc2;
    l_priority                        flow_processes.prcs_priority%type;
    e_param_proc_var_invalid_type     exception;
    e_param_expr_invalid_type         exception;
    e_priority_invalid                exception;

  begin
    apex_json.parse ( p_source => pi_expr);

    l_expression_type  := apex_json.get_varchar2 ( p_path => 'expressionType');
    l_expression       := apex_json.get_varchar2 ( p_path => 'expression');

    case 
    when l_expression_type = flow_constants_pkg.gc_expr_type_static then
      flow_proc_vars_int.do_substitution 
      ( pi_prcs_id   => pi_prcs_id
      , pi_sbfl_id   => pi_sbfl_id
      , pi_scope     => pi_scope
      , pio_string   => l_expression
      );
      apex_debug.info (P_message => 'Process Priority Evaluation : %0 ', p0 => to_number (l_expression));
      l_priority := to_number (l_expression);
    when l_expression_type = flow_constants_pkg.gc_expr_type_proc_var then
      case flow_proc_vars_int.get_var_type ( pi_prcs_id   => pi_prcs_id
                                           , pi_var_name  => l_expression
                                           , pi_scope     => pi_scope
                                           )
      when flow_constants_pkg.gc_prov_var_type_varchar2 then
        l_priority :=  to_number ( flow_proc_vars_int.get_var_vc2 ( pi_prcs_id   => pi_prcs_id
                                                                  , pi_scope     => pi_scope
                                                                  , pi_var_name  => l_expression
                                                                  ) );
      when flow_constants_pkg.gc_prov_var_type_number then
        l_priority :=  flow_proc_vars_int.get_var_num ( pi_prcs_id   => pi_prcs_id
                                                      , pi_scope     => pi_scope
                                                      , pi_var_name  => l_expression
                                                      );
      else
        raise e_param_proc_var_invalid_type;
      end case;
    when l_expression_type = flow_constants_pkg.gc_expr_type_sql then
      l_result_rec := flow_util.exec_flows_sql 
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_sql_text     => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_number
                      , pi_scope        => pi_scope
                      , pi_expr_type    => flow_constants_pkg.gc_expr_type_sql 
                      );
      l_priority := l_result_rec.var_num;
    when l_expression_type in ( flow_constants_pkg.gc_expr_type_plsql_expression 
                              , flow_constants_pkg.gc_expr_type_plsql_raw_expression
                              , flow_constants_pkg.gc_expr_type_plsql_function_body
                              , flow_constants_pkg.gc_expr_type_plsql_raw_function_body) 
    then
      l_result_rec := flow_util.exec_flows_plsql 
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_plsql_text   => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_number
                      , pi_scope        => pi_scope
                      , pi_expr_type    => l_expression_type 
                      );
      l_priority := l_result_rec.var_num;
    else
      raise e_param_expr_invalid_type;
    end case;
    -- test priority is valid (1-5)
    if l_priority not between 1 and 5 then
      raise e_priority_invalid;
    end if;
    return l_priority;
  exception
    when e_priority_invalid then
      apex_debug.info 
      ( p_message => ' --- Error evaluating Priority.  Priority be between 1 and 5.  Priority: %0'
      , p0 => l_priority
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'apex-task-priority-error'
      , p0 => l_priority
      );  
      -- $F4AMESSAGE 'apex-task-priority-error' || 'Error evaluating Priority.  Priority must be between 1 and 5.  Priority: %0.'    
    when others then -- tbi
      return null;
  end get_priority;

  function get_vc2_expression
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return flow_types_pkg.t_bpmn_attribute_vc2
  is
    l_values                          apex_json.t_values;
    l_expression_type                 flow_types_pkg.t_bpmn_attribute_vc2;
    l_expression                      flow_types_pkg.t_bpmn_attribute_vc2;
    e_param_proc_var_invalid_type     exception;
    e_param_expr_invalid_type         exception;
    l_return_value                    flow_types_pkg.t_bpmn_attribute_vc2;
    l_result_rec                      flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter 
    ( 'get_vc2_expression'
    , 'pi_expr'   , pi_expr
    );
    apex_json.parse ( p_source => pi_expr);

    l_expression_type  := apex_json.get_varchar2 ( p_path => 'expressionType');
    l_expression       := apex_json.get_varchar2 ( p_path => 'expression');

   case 
    when l_expression_type = flow_constants_pkg.gc_expr_type_static then
      l_return_value := l_expression;
    when l_expression_type = flow_constants_pkg.gc_expr_type_proc_var then
      case flow_proc_vars_int.get_var_type ( pi_prcs_id   => pi_prcs_id
                                           , pi_var_name  => l_expression
                                           , pi_scope     => pi_scope
                                           )
      when flow_constants_pkg.gc_prov_var_type_varchar2 then
        l_return_value := ( flow_proc_vars_int.get_var_vc2  ( pi_prcs_id   => pi_prcs_id
                                                            , pi_scope     => pi_scope
                                                            , pi_var_name  => l_expression
                                                            ) );
      else
        raise e_param_proc_var_invalid_type;
      end case;
    when l_expression_type = flow_constants_pkg.gc_expr_type_sql 
      or l_expression_type = flow_constants_pkg.gc_expr_type_sql_delimited_list 
    then
      l_result_rec := flow_util.exec_flows_sql
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_sql_text     => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                      , pi_scope        => pi_scope
                      , pi_expr_type    => l_expression_type
                      );
      l_return_value := l_result_rec.var_vc2;
    when l_expression_type = flow_constants_pkg.gc_expr_type_plsql_expression 
      or l_expression_type = flow_constants_pkg.gc_expr_type_plsql_raw_expression 
      or l_expression_type = flow_constants_pkg.gc_expr_type_plsql_function_body
      or l_expression_type = flow_constants_pkg.gc_expr_type_plsql_raw_function_body
    then
      l_result_rec := flow_util.exec_flows_plsql 
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_plsql_text   => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                      , pi_scope        => pi_scope
                      , pi_expr_type    => l_expression_type 
                      );
      l_return_value := l_result_rec.var_vc2;
    else
      raise e_param_expr_invalid_type;
    end case;
    return l_return_value;
  exception
    when others then -- tbi
      return null;
  end get_vc2_expression;

  function get_potential_users
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2
  is
  begin
    return get_vc2_expression ( pi_prcs_id     => pi_prcs_id
                              , pi_sbfl_id     => pi_sbfl_id
                              , pi_expr        => pi_expr
                              , pi_scope       => pi_scope
                              );
  end get_potential_users;

  function get_potential_groups
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2
  is
  begin
    return get_vc2_expression ( pi_prcs_id     => pi_prcs_id
                              , pi_sbfl_id     => pi_sbfl_id
                              , pi_expr        => pi_expr
                              , pi_scope       => pi_scope
                              );
  end get_potential_groups;

  function get_excluded_users
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2
  is
  begin
    return get_vc2_expression ( pi_prcs_id     => pi_prcs_id
                              , pi_sbfl_id     => pi_sbfl_id
                              , pi_expr        => pi_expr
                              , pi_scope       => pi_scope
                              );
  end get_excluded_users;

end flow_settings;
/
