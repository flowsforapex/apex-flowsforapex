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

 /*       <apex:expressionType>processVariable</apex:type>       
        <apex:valueType>date</apex:valuetype>   
        <apex:value>F4A$MyVC2Var</apex:variable>
        <apex:dataType>varchar2</apex:dataType>
        <apex:formatMask>DD-MON-YYYY"T"HH24:MI:SS</apex:formatMask>
        <apex:timeZone>+8.00</apex:formatMask>
        */

  function get_next_time_of_day
  ( pi_time_of_day    flow_types_pkg.t_bpmn_attribute_vc2
  , pi_time_zone     flow_types_pkg.t_bpmn_attribute_vc2
  )return timestamp with time zone
  is
  begin
    return systimestamp;   -- tbi
  end get_next_time_of_day;

  function get_due_date
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_expr          flow_objects.objt_attributes%type
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return timestamp with time zone
  is
    l_json_def          sys.json_object_t;
    l_expression_type   flow_types_pkg.t_bpmn_attribute_vc2;
    l_value_type        flow_types_pkg.t_bpmn_attribute_vc2;
    l_value             flow_types_pkg.t_bpmn_attribute_vc2;
    l_data_type         flow_types_pkg.t_bpmn_attribute_vc2;
    l_format_mask       flow_types_pkg.t_bpmn_attribute_vc2;
    l_expression        flow_types_pkg.t_bpmn_attribute_vc2;
    l_function_body     flow_types_pkg.t_bpmn_attribute_vc2;
    l_content           flow_types_pkg.t_bpmn_attribute_vc2;
    l_return_ts         timestamp with time zone;
  begin
    -- split based on expression type
    apex_json.parse( p_source => pi_expr );

    l_expression_type    := apex_json.get_varchar2( p_path => 'expressionType' );
    l_value_type         := apex_json.get_varchar2( p_path => 'valueType' );
    l_value              := apex_json.get_varchar2( p_path => 'value' );
    l_data_type          := apex_json.get_varchar2( p_path => 'dataType' );
    l_format_mask        := apex_json.get_varchar2( p_path => 'formatMask' );
    l_expression         := apex_json.get_varchar2( p_path => 'expression' );
    l_function_body      := apex_json.get_varchar2( p_path => 'functionBody' );


    case l_expression_type 
    when flow_constants_pkg.gc_expr_type_static then
      case l_value_type
      when flow_constants_pkg.gc_date_value_type_date then
        return to_timestamp_tz ( l_value, l_format_mask);
      when flow_constants_pkg.gc_date_value_type_duration then
        return systimestamp + to_dsinterval( l_value );
      when flow_constants_pkg.gc_date_value_type_time_of_day then
        return systimestamp; -- tbi
      when flow_constants_pkg.gc_date_value_type_oracle_scheduler then
        return systimestamp; -- tbi
      else
        return systimestamp; -- tbi
      end case;

    when flow_constants_pkg.gc_expr_type_proc_var then
      case l_value_type
      when flow_constants_pkg.gc_date_value_type_date then 
        if l_data_type = flow_constants_pkg.gc_prov_var_type_varchar2 then
          l_content := flow_proc_vars_int.get_var_vc2 ( pi_prcs_id    => pi_prcs_id
                                                      , pi_var_name   => l_value
                                                      , pi_scope      => pi_scope
                                                      );
          return to_timestamp_tz ( l_content, l_format_mask );  
        elsif l_data_type = flow_constants_pkg.gc_prov_var_type_date then
          l_return_ts := cast ( flow_proc_vars_int.get_var_date ( pi_prcs_id    => pi_prcs_id
                                                                , pi_var_name   => l_value
                                                                , pi_scope      => pi_scope
                                                                )
                                as timestamp with time zone); 
          return l_return_ts;                           
        elsif l_data_type = flow_constants_pkg.gc_prov_var_type_ts then
          return flow_proc_vars_int.get_var_date  ( pi_prcs_id    => pi_prcs_id
                                                  , pi_var_name   => l_value
                                                  , pi_scope      => pi_scope
                                                  );       
        end if;


      when flow_constants_pkg.gc_date_value_type_duration then 
        return systimestamp + to_dsinterval( l_value );
      when flow_constants_pkg.gc_date_value_type_oracle_scheduler then
        return systimestamp; -- tbi
      else
        return systimestamp; -- tbi
      end case;

    when flow_constants_pkg.gc_expr_type_sql then
      null;
    when flow_constants_pkg.gc_expr_type_plsql_function_body then
      null;
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      null;
    end case;

    return systimestamp;
  end get_due_date;

  function get_priority
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return flow_processes.prcs_priority%type
  is
    l_values                          apex_json.t_values;
    l_expression_type                 flow_types_pkg.t_bpmn_attribute_vc2;
    l_expression                      flow_types_pkg.t_bpmn_attribute_vc2;
    e_param_proc_var_invalid_type     exception;
    e_param_expr_invalid_type         exception;
  begin
    apex_json.parse ( p_source => pi_expr);

    l_expression_type  := apex_json.get_varchar2 ( p_path => 'expressionType');
    l_expression       := apex_json.get_varchar2 ( p_path => 'expressionValue');

    case l_expression_type 
    when flow_constants_pkg.gc_expr_type_static then
      return to_number (l_expression);
    when flow_constants_pkg.gc_expr_type_proc_var then
      case flow_proc_vars_int.get_var_type ( pi_prcs_id   => pi_prcs_id
                                           , pi_var_name  => l_expression
                                           , pi_scope     => pi_scope
                                           )
      when flow_constants_pkg.gc_prov_var_type_varchar2 then
        return to_number ( flow_proc_vars_int.get_var_vc2 ( pi_prcs_id   => pi_prcs_id
                                                          , pi_scope     => pi_scope
                                                          , pi_var_name  => l_expression
                                                          ) );
      when flow_constants_pkg.gc_prov_var_type_number then
        return flow_proc_vars_int.get_var_num ( pi_prcs_id   => pi_prcs_id
                                              , pi_scope     => pi_scope
                                              , pi_var_name  => l_expression
                                              );
      else
        raise e_param_proc_var_invalid_type;
      end case;
    when flow_constants_pkg.gc_expr_type_sql then
      return null; -- tbi
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      return null; -- tbi
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      return null; -- tbi
    else
      raise e_param_expr_invalid_type;
    end case;
  exception
    when others then -- tbi
      return null;
  end get_priority;

  function get_vc2_expression
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  , pi_is_multi      boolean default false
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
    , 'pi_is_multi', case pi_is_multi when true then 'true' else 'false' end 
    );
    apex_json.parse ( p_source => pi_expr);

    l_expression_type  := apex_json.get_varchar2 ( p_path => 'expressionType');
    l_expression       := apex_json.get_varchar2 ( p_path => 'expressionValue');

   case l_expression_type 
    when flow_constants_pkg.gc_expr_type_static then
      l_return_value := l_expression;
    when flow_constants_pkg.gc_expr_type_proc_var then
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
    when flow_constants_pkg.gc_expr_type_sql then
      l_result_rec := flow_util.exec_flows_sql
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_sql_text     => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                      , pi_scope        => pi_scope
                      , pi_is_multi     => false
                      );
      l_return_value := l_result_rec.var_vc2;
    when flow_constants_pkg.gc_expr_type_sql_delimited_list then
      l_result_rec := flow_util.exec_flows_sql
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_sql_text     => l_expression
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                      , pi_scope        => pi_scope
                      , pi_is_multi     => true
                      );
      l_return_value := l_result_rec.var_vc2;
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      return null; -- tbi
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      return null; -- tbi
    else
      raise e_param_expr_invalid_type;
    end case;

    apex_debug.info (p_message => '  - SQL query result %0', p0 => l_return_value);
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
                              , pi_is_multi    => true
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
                              , pi_is_multi    => true
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
                              , pi_is_multi    => false
                              );
  end get_excluded_users;

end flow_settings;
/
