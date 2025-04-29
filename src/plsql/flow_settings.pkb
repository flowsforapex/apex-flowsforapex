create or replace package body flow_settings
as 
/* 
-- Flows for APEX - flow_settings.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
-- (c) Copyright Flowquest Limited. 2024
--
-- Created    23-Nov-2022  Richard Allen (Oracle)
-- Modified   13-Apr-2023  Moritz Klein (MT GmbH)
-- Modified   11-Feb-2024  Richard Allen (Flowquest Limited)
--
*/

  type expression_details_t is
    record
    (
      expr_type         flow_types_pkg.t_bpmn_attribute_vc2
    , expr_value        clob
    , expr_fmt          flow_types_pkg.t_bpmn_attribute_vc2
    , expr_inside_var   flow_types_pkg.t_bpmn_attribute_vc2
    , expr_description  flow_types_pkg.t_bpmn_attribute_vc2
    );

  function get_expression_details( pi_expr_json in json_object_t )
    return expression_details_t
  as
    l_return    expression_details_t;
  begin
    apex_debug.enter ('get_expression_details','pi_expr_json',pi_expr_json.to_string);
    l_return.expr_type := pi_expr_json.get_string( key => 'expressionType' );

    case pi_expr_json.get_type( key => 'expression' )
      when 'SCALAR' then
        l_return.expr_value := pi_expr_json.get_string( key => 'expression' );
      when 'ARRAY' then
        l_return.expr_value := flow_engine_util.json_array_join( pi_expr_json.get_array( key => 'expression' ) );
      else
       null;
    end case;
    
    l_return.expr_fmt               := pi_expr_json.get_string( key => 'formatMask' );
    l_return.expr_inside_var        := pi_expr_json.get_string( key => 'insideVariable' );
    l_return.expr_description       := pi_expr_json.get_string( key => 'description');

    apex_debug.message (p_message => 'get_expression_details - results.  expr_value %0 expr_type %1 expr_fmt %2 expr_inside_var %3 expr_desc %4'
    , p0 => l_return.expr_value
    , p1 => l_return.expr_type
    , p2 => l_return.expr_fmt
    , p3 => l_return.expr_inside_var
    , p4 => l_return.expr_description
    );
    return l_return;
  end get_expression_details;

  function get_expression_details( pi_expr_data in flow_objects.objt_attributes%type )
    return expression_details_t
  as
    l_expr_json sys.json_object_t;
    l_return    expression_details_t;
  begin
    l_expr_json        := sys.json_object_t( jsn => pi_expr_data );
    return get_expression_details (pi_expr_json => l_expr_json);
  end get_expression_details;

  function get_due_on
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_objects.objt_attributes%type
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return timestamp with time zone
  is

    l_expr_details      expression_details_t;
    l_result_rec        flow_proc_vars_int.t_proc_var_value;
    l_return_tstz       timestamp with time zone;

    e_invalid_interval_spec    exception;
    pragma exception_init (e_invalid_interval_spec , -1867);  

  begin
    apex_debug.enter
    ( p_routine_name => 'flow_settings.get_due_on'
    , p_name01       => 'scope'
    , p_value01      => pi_scope
    , p_name02       => 'expr'
    , p_value02      => substr(pi_expr, 4000)
    );

    l_expr_details := get_expression_details( pi_expr_data  => pi_expr );

    apex_debug.message
    ( p_message => ' --- JSON Content - expression type: %1, expression :%0, formatMask :%2'
    , p0        => substr(l_expr_details.expr_value, 4000)
    , p1        => l_expr_details.expr_type
    , p2        => l_expr_details.expr_fmt
    );

    if l_expr_details.expr_type in ( flow_constants_pkg.gc_expr_type_static 
                                   , flow_constants_pkg.gc_date_value_type_interval
                                   , flow_constants_pkg.gc_date_value_type_oracle_scheduler
                                   ) then
      -- static types - timestamp, duration and scheduler statics - start by doing substitutions
      flow_proc_vars_int.do_substitution
        ( pi_prcs_id => pi_prcs_id
        , pi_sbfl_id => pi_sbfl_id
        , pi_scope   => pi_scope
        , pio_string => l_expr_details.expr_value 
        );
    end if;

    case 
    when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_static then    
      if l_expr_details.expr_fmt is null then
        -- log warning then try to use the F4A default mask
        flow_logging.log_step_event ( p_process_id      => pi_prcs_id
                                    , p_subflow_id      => pi_sbfl_id
                                    , p_event           => flow_constants_pkg.gc_step_event_warning
                                    , p_event_level     => flow_constants_pkg.gc_logging_level_routine
                                    , p_comment         => 'Timestamp formatMask not present.   Attempting to convert using default Flows for APEX format'
                                    );
        l_expr_details.expr_fmt := flow_constants_pkg.gc_prov_default_tstz_format;
      end if;
      l_return_tstz := to_timestamp_tz ( l_expr_details.expr_value, l_expr_details.expr_fmt);
    when l_expr_details.expr_type = flow_constants_pkg.gc_date_value_type_interval then
      l_return_tstz := systimestamp + to_dsinterval( l_expr_details.expr_value );
    when l_expr_details.expr_type = flow_constants_pkg.gc_date_value_type_oracle_scheduler then
      sys.dbms_scheduler.evaluate_calendar_string ( calendar_string   => l_expr_details.expr_value
                                                  , start_date        => systimestamp -- to get correct TZ, should this be localtimestamp?
                                                  , return_date_after => systimestamp
                                                  , next_run_date     => l_return_tstz
                                                  );
      l_return_tstz := l_return_tstz;

    when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_proc_var then
      l_return_tstz := flow_proc_vars_int.get_var_tstz  ( pi_prcs_id    => pi_prcs_id
                                                        , pi_var_name   => l_expr_details.expr_value
                                                        , pi_scope      => pi_scope
                                                        );       
  
    when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_sql then
      l_result_rec := flow_db_exec.exec_flows_sql 
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_sql_text     => l_expr_details.expr_value
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_tstz
                      , pi_scope        => pi_scope
                      , pi_expr_type    => flow_constants_pkg.gc_expr_type_sql 
                      );
      l_return_tstz := l_result_rec.var_tstz;
    when l_expr_details.expr_type in ( flow_constants_pkg.gc_expr_type_plsql_function_body 
                                     , flow_constants_pkg.gc_expr_type_plsql_raw_function_body 
                                     , flow_constants_pkg.gc_expr_type_plsql_expression
                                     , flow_constants_pkg.gc_expr_type_plsql_raw_expression )   
    then
      l_result_rec := flow_db_exec.exec_flows_plsql 
                      ( pi_prcs_id      => pi_prcs_id
                      , pi_sbfl_id      => pi_sbfl_id
                      , pi_plsql_text   => l_expr_details.expr_value
                      , pi_result_type  => flow_constants_pkg.gc_prov_var_type_tstz
                      , pi_scope        => pi_scope
                      , pi_expr_type    => l_expr_details.expr_type 
                      );
      l_return_tstz := l_result_rec.var_tstz;
    else 
      l_return_tstz := null;
    end case;
    return l_return_tstz;
  exception
    when e_invalid_interval_spec then
      apex_debug.info 
      ( p_message => ' --- Error evaluating Due On.  Interval expression is invalid.  Interval: %0.'
      , p0        => substr(l_expr_details.expr_value, 4000)
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'due-on-interval-error'
      , p0                => substr(l_expr_details.expr_value, 4000)
      );  
      -- $F4AMESSAGE 'due-on-interval-error' || 'Error evaluating Due On.  Interval expression is invalid.  Interval: %0.'  
      return null;  
    when others then
      apex_debug.info 
      ( p_message => ' --- Error evaluating Due On.  Due On expression is invalid.  Interval Expression: %0.  '
      , p0 => substr(l_expr_details.expr_value, 4000)
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'due-on-error'
      , p0 => substr(l_expr_details.expr_value, 4000)
      );  
      -- $F4AMESSAGE 'due-on-error' || 'Error evaluating Due On.  Due On expression is invalid.  Interval Expression: %0.'  
      return null;  
  end get_due_on;

  function get_priority
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return flow_processes.prcs_priority%type
  is
    l_expr_details                expression_details_t;
    l_result_rec                  flow_proc_vars_int.t_proc_var_value;
    l_priority                    flow_processes.prcs_priority%type;

    e_param_proc_var_invalid_type exception;
    e_param_expr_invalid_type     exception;
    e_priority_invalid            exception;
  begin

    l_expr_details := get_expression_details( pi_expr_data  => pi_expr );

    case 
      when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_static then
        flow_proc_vars_int.do_substitution 
        ( pi_prcs_id   => pi_prcs_id
        , pi_sbfl_id   => pi_sbfl_id
        , pi_scope     => pi_scope
        , pio_string   => l_expr_details.expr_value
        );
        apex_debug.info (P_message => 'Set Priority Evaluation : %0 ', p0 => to_number (l_expr_details.expr_value));
        l_priority := to_number (l_expr_details.expr_value);
      when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_proc_var then
        if l_expr_details.expr_value = flow_constants_pkg.gc_substitution_process_priority then
          select prcs_priority
            into l_priority
            from flow_processes
          where prcs_id = pi_prcs_id; 
        else
          case flow_proc_vars_int.get_var_type ( pi_prcs_id   => pi_prcs_id
                                              , pi_var_name  => l_expr_details.expr_value
                                              , pi_scope     => pi_scope
                                              )
          when flow_constants_pkg.gc_prov_var_type_varchar2 then
            l_priority :=  to_number ( flow_proc_vars_int.get_var_vc2 ( pi_prcs_id   => pi_prcs_id
                                                                      , pi_scope     => pi_scope
                                                                      , pi_var_name  => l_expr_details.expr_value
                                                                      ) );
          when flow_constants_pkg.gc_prov_var_type_number then
            l_priority :=  flow_proc_vars_int.get_var_num ( pi_prcs_id   => pi_prcs_id
                                                          , pi_scope     => pi_scope
                                                          , pi_var_name  => l_expr_details.expr_value
                                                          );
          else
            raise e_param_proc_var_invalid_type;
          end case;
        end if;
      when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_sql then
        l_result_rec := flow_db_exec.exec_flows_sql 
                        ( pi_prcs_id      => pi_prcs_id
                        , pi_sbfl_id      => pi_sbfl_id
                        , pi_sql_text     => l_expr_details.expr_value
                        , pi_result_type  => flow_constants_pkg.gc_prov_var_type_number
                        , pi_scope        => pi_scope
                        , pi_expr_type    => flow_constants_pkg.gc_expr_type_sql 
                        );
        l_priority := l_result_rec.var_num;
      when l_expr_details.expr_type in ( flow_constants_pkg.gc_expr_type_plsql_expression 
                                , flow_constants_pkg.gc_expr_type_plsql_raw_expression
                                , flow_constants_pkg.gc_expr_type_plsql_function_body
                                , flow_constants_pkg.gc_expr_type_plsql_raw_function_body) 
      then
        l_result_rec := flow_db_exec.exec_flows_plsql 
                        ( pi_prcs_id      => pi_prcs_id
                        , pi_sbfl_id      => pi_sbfl_id
                        , pi_plsql_text   => l_expr_details.expr_value
                        , pi_result_type  => flow_constants_pkg.gc_prov_var_type_number
                        , pi_scope        => pi_scope
                        , pi_expr_type    => l_expr_details.expr_type 
                        );
        l_priority := l_result_rec.var_num;
      else
        pragma coverage ('not_feasible');
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
      -- $F4AMESSAGE 'apex-task-priority-error' || 'Error evaluating Priority.  Priority must be between 1 and 5.  Priority: %0. Priority 3 used instead.'   
      return null; 
    when others then 
      apex_debug.info 
      ( p_message => ' --- Error evaluating Priority.  Priority expression is invalid.  Expression: %0.  priority 3 returned.'
      , p0        => substr(l_expr_details.expr_value, 4000)
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_message_key => 'settings-priority-error'
      , p0             => substr(l_expr_details.expr_value, 4000)
      );  
      -- $F4AMESSAGE 'settings-priority-error' || 'Error evaluating Priority. Priority expression is invalid.  Expression: %0.  Priority 3 used instead.'  
      return 3;
  end get_priority;

  function get_vc2_expression
  ( pi_prcs_id       flow_processes.prcs_id%type default null
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2 default null
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  , pi_step_key      flow_subflows.sbfl_step_key%type default null
  ) return flow_types_pkg.t_bpmn_attribute_vc2
  is
    l_expr_details expression_details_t;
    l_result_rec   flow_proc_vars_int.t_proc_var_value;
    l_return_value flow_types_pkg.t_bpmn_attribute_vc2;

    e_param_proc_var_invalid_type exception;
    e_param_expr_invalid_type     exception;
    e_param_type_requires_prcs_id exception;
  begin
    apex_debug.enter 
    ( 'get_vc2_expression'
    , 'pi_expr'   , pi_expr
    );
    
    if pi_expr is null then
      return null;
    end if;

    l_expr_details := get_expression_details( pi_expr_data  => pi_expr );

   case 
      when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_static then
        flow_proc_vars_int.do_substitution 
        ( pi_prcs_id   => pi_prcs_id
        , pi_sbfl_id   => pi_sbfl_id
        , pi_scope     => pi_scope
        , pi_step_key  => pi_step_key
        , pio_string   => l_expr_details.expr_value
        );
        l_return_value := l_expr_details.expr_value;
      when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_proc_var then
        if pi_prcs_id is null then 
          -- proc var setting type cannot be used without a prcs_id
          raise e_param_type_requires_prcs_id; 
        end if;
        case flow_proc_vars_int.get_var_type ( pi_prcs_id   => pi_prcs_id
                                             , pi_var_name  => l_expr_details.expr_value
                                             , pi_scope     => pi_scope
                                             )
          when flow_constants_pkg.gc_prov_var_type_varchar2 then
            l_return_value := ( flow_proc_vars_int.get_var_vc2  ( pi_prcs_id   => pi_prcs_id
                                                                , pi_scope     => pi_scope
                                                                , pi_var_name  => l_expr_details.expr_value
                                                                ) );
          when flow_constants_pkg.gc_prov_var_type_number then
            l_return_value := to_char ( flow_proc_vars_int.get_var_num  ( pi_prcs_id   => pi_prcs_id
                                                                , pi_scope     => pi_scope
                                                                , pi_var_name  => l_expr_details.expr_value
                                                                ) );
          when flow_constants_pkg.gc_prov_var_type_clob then
            l_return_value := ( flow_proc_vars_int.get_var_clob ( pi_prcs_id   => pi_prcs_id
                                                                , pi_scope     => pi_scope
                                                                , pi_var_name  => l_expr_details.expr_value
                                                                ) );                                                         
          else
            raise e_param_proc_var_invalid_type;
          end case;
      when l_expr_details.expr_type in ( flow_constants_pkg.gc_expr_type_sql, flow_constants_pkg.gc_expr_type_sql_delimited_list ) then
        l_result_rec := flow_db_exec.exec_flows_sql
                        ( pi_prcs_id      => pi_prcs_id
                        , pi_sbfl_id      => pi_sbfl_id
                        , pi_sql_text     => l_expr_details.expr_value
                        , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                        , pi_scope        => pi_scope
                        , pi_expr_type    => l_expr_details.expr_type
                        );
        l_return_value := l_result_rec.var_vc2;
      when l_expr_details.expr_type in ( flow_constants_pkg.gc_expr_type_plsql_expression 
                                       , flow_constants_pkg.gc_expr_type_plsql_raw_expression 
                                       , flow_constants_pkg.gc_expr_type_plsql_function_body
                                       , flow_constants_pkg.gc_expr_type_plsql_raw_function_body
                                       )
      then
        l_result_rec := flow_db_exec.exec_flows_plsql 
                        ( pi_prcs_id      => pi_prcs_id
                        , pi_sbfl_id      => pi_sbfl_id
                        , pi_plsql_text   => l_expr_details.expr_value
                        , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                        , pi_scope        => pi_scope
                        , pi_expr_type    => l_expr_details.expr_type 
                        );
        l_return_value := l_result_rec.var_vc2;
      else
        raise e_param_expr_invalid_type;
    end case;
    return l_return_value;
  exception
    when e_param_type_requires_prcs_id then
      flow_errors.handle_general_error (pi_message_key => 'settings-procvar-no-prcs');
      return null;
      -- $F4AMESSAGE 'settings-procvar-no-prcs' || 'Settings cannot specify Process Variable without a Process ID.'
    when others then 
      apex_debug.info 
      ( p_message => ' --- Error evaluating Setting.  Expression is invalid.  Expression: %0. SQL Error: %1'
      , p0 => substr(l_expr_details.expr_value, 4000)
      , p1 => sqlerrm
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_message_key    => 'settings-error'
      , p0 => substr(l_expr_details.expr_value, 4000)
      , p1 => sqlerrm
      ); 
      return null;
      -- $F4AMESSAGE 'settings-error' || 'Error evaluating Setting. Expression is invalid.  Expression: %0. SQL Error: %1' 
  end get_vc2_expression;

  function get_clob_expression
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          clob
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  , pi_step_key      flow_subflows.sbfl_step_key%type default null
  ) return clob
  is
    l_expr_details expression_details_t;
    l_return_value clob;
    l_result_rec   flow_proc_vars_int.t_proc_var_value;

    e_param_proc_var_invalid_type exception;
    e_param_expr_invalid_type     exception;
  begin
    apex_debug.enter 
    ( p_routine_name => 'get_clob_expression'
    , p_name01       => 'pi_expr'
    , p_value01      => dbms_lob.substr(pi_expr, 4000)
    );

    l_expr_details := get_expression_details( pi_expr_data  => pi_expr );

   case 
      when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_static then
        flow_proc_vars_int.do_substitution 
        ( pi_prcs_id   => pi_prcs_id
        , pi_sbfl_id   => pi_sbfl_id
        , pi_scope     => pi_scope
        , pi_step_key  => pi_step_key
        , pio_string   => l_expr_details.expr_value
        );
        l_return_value := l_expr_details.expr_value;
      when l_expr_details.expr_type = flow_constants_pkg.gc_expr_type_proc_var then
        case flow_proc_vars_int.get_var_type ( pi_prcs_id   => pi_prcs_id
                                             , pi_var_name  => l_expr_details.expr_value
                                             , pi_scope     => pi_scope
                                             )
        when flow_constants_pkg.gc_prov_var_type_varchar2 then
          l_return_value := ( flow_proc_vars_int.get_var_vc2  ( pi_prcs_id   => pi_prcs_id
                                                              , pi_scope     => pi_scope
                                                              , pi_var_name  => l_expr_details.expr_value
                                                              ) );
        when flow_constants_pkg.gc_prov_var_type_clob then
          l_return_value := ( flow_proc_vars_int.get_var_clob ( pi_prcs_id   => pi_prcs_id
                                                              , pi_scope     => pi_scope
                                                              , pi_var_name  => l_expr_details.expr_value
                                                              ) );
        else
          raise e_param_proc_var_invalid_type;
        end case;
      when l_expr_details.expr_type in ( flow_constants_pkg.gc_expr_type_sql, flow_constants_pkg.gc_expr_type_sql_delimited_list ) then
        l_result_rec := flow_db_exec.exec_flows_sql
                        ( pi_prcs_id      => pi_prcs_id
                        , pi_sbfl_id      => pi_sbfl_id
                        , pi_sql_text     => l_expr_details.expr_value
                        , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                        , pi_scope        => pi_scope
                        , pi_expr_type    => l_expr_details.expr_type
                        );
        l_return_value := l_result_rec.var_vc2;
      when l_expr_details.expr_type in ( flow_constants_pkg.gc_expr_type_plsql_expression 
                                       , flow_constants_pkg.gc_expr_type_plsql_raw_expression 
                                       , flow_constants_pkg.gc_expr_type_plsql_function_body
                                       , flow_constants_pkg.gc_expr_type_plsql_raw_function_body
                                       )
      then
        l_result_rec := flow_db_exec.exec_flows_plsql 
                        ( pi_prcs_id      => pi_prcs_id
                        , pi_sbfl_id      => pi_sbfl_id
                        , pi_plsql_text   => l_expr_details.expr_value
                        , pi_result_type  => flow_constants_pkg.gc_prov_var_type_varchar2
                        , pi_scope        => pi_scope
                        , pi_expr_type    => l_expr_details.expr_type 
                        );
        l_return_value := l_result_rec.var_vc2;
      else
        raise e_param_expr_invalid_type;
    end case;
    return l_return_value;
  exception
    when others then
      apex_debug.info 
      ( p_message => ' --- Error evaluating Setting.  Expression is invalid.  Expression: %0. '
      , p0        => substr(l_expr_details.expr_value, 4000)
      );  
      flow_errors.handle_instance_error
      ( pi_prcs_id     => pi_prcs_id
      , pi_message_key => 'settings-error'
      , p0             => substr(l_expr_details.expr_value, 4000)
      );  
      -- $F4AMESSAGE 'settings-error' || 'Error evaluating Setting. Expression is invalid.  Expression: %0.' 
      return null;
  end get_clob_expression;

  function get_endpoint
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
  end get_endpoint;

  function get_iteration_settings
  ( pi_expr          sys.json_object_t
  ) return   flow_types_pkg.t_iteration_vars
  is
    l_settings       flow_types_pkg.t_iteration_vars;
    l_details        expression_details_t;
  begin
    apex_debug.enter ( 'get_iteration_settings');
    l_details := get_expression_details ( pi_expr_json  => pi_expr);

    l_settings.type              := l_details.expr_type;
    case  l_settings.type 
    when flow_constants_pkg.gc_expr_type_sql_json_array then
          l_settings.collection_expr   := l_details.expr_value;
    else 
          l_settings.collection_var    := l_details.expr_value;
    end case;
    l_settings.inside_var        := l_details.expr_inside_var;
    l_settings.description       := l_details.expr_description;
    return l_settings;
  end get_iteration_settings;   

end flow_settings;
/
