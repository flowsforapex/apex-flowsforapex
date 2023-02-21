create or replace package body flow_util
as 
/* 
-- Flows for APEX - flow_util.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created  08-Dec-2022  Richard Allen (Oracle Corporation)
-- Changed  21-FEB-2023  Moritz Klein (MT GmbH)
--
*/

  function exec_flows_sql
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_sql_text       varchar2
  , pi_result_type    varchar2  
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_expr_type      flow_types_pkg.t_expr_type
  ) return flow_proc_vars_int.t_proc_var_value
  as  
    l_sql_text        varchar2(4000) := pi_sql_text;
    l_bind_parameters apex_exec.t_parameters;
    l_context         apex_exec.t_context;
    l_result_column   apex_exec.t_column;
    l_result_rec      flow_proc_vars_int.t_proc_var_value;
    l_result_set_vc2  apex_t_varchar2;
    l_result          flow_process_variables.prov_var_vc2%type;
    l_indx            pls_integer;

    e_var_exp_must_return_one_column exception;
    e_var_exp_sql_too_many_rows      exception;
  begin
      apex_debug.enter
    ( 'flow_expressions.exec_flows_sql'
    , 'type', pi_result_type
    , 'sql text' , pi_sql_text
    );
    l_result_rec.var_name   := 'result';
    l_result_rec.var_type   := pi_result_type;

    l_sql_text := rtrim ( l_sql_text, ';');
    -- substitute any F4A Process Variables
    flow_proc_vars_int.do_substitution
    ( pi_prcs_id => pi_prcs_id
    , pi_sbfl_id => pi_sbfl_id
    , pi_scope   => pi_scope
    , pio_string => l_sql_text
    );
    -- get bind parameters
    l_bind_parameters := flow_proc_vars_int.get_parameter_list
                            ( pi_expr               => l_sql_text
                            , pi_prcs_id            => pi_prcs_id
                            , pi_sbfl_id            => pi_sbfl_id
                            , pi_scope              => pi_scope
                            );
    l_context := apex_exec.open_query_context
                      ( p_location          => apex_exec.c_location_local_db
                      , p_sql_query         => l_sql_text
                      , p_sql_parameters    => l_bind_parameters
                      , p_total_row_count   => true
                      );

    -- check only 1 row and 1 column returned
    if apex_exec.get_column_count (p_context => l_context) <> 1 then
      raise e_var_exp_must_return_one_column;
    end if;
    if (   pi_expr_type = flow_constants_pkg.gc_expr_type_sql 
       and apex_exec.get_total_row_count (p_context => l_context) > 1  )    
    then
      raise e_var_exp_sql_too_many_rows;
    end if;
    -- for SQl Single we can return several datatypes, and convert to other datatypes
    -- for SQl multi, we can only return vc2 or number datatypes, but need to loop to return into array
    -- and then build concatenated colon separated string
    if pi_expr_type = flow_constants_pkg.gc_expr_type_sql  then
      -- SQl Single row
      -- result must be in only row/column returned
      if apex_exec.next_row (p_context => l_context) then
        -- if query returns values, set them.  If not, all values will be null (correctly)
        l_result_column := apex_exec.get_column ( p_context => l_context
                                                , p_column_idx => 1
                                                );
        case pi_result_type 
        when flow_constants_pkg.gc_prov_var_type_varchar2 then
          if l_result_column.data_type = apex_exec.c_data_type_varchar2 then
            l_result_rec.var_vc2 := apex_exec.get_varchar2  ( p_context => l_context
                                                            , p_column_idx => 1
                                                            );
          elsif l_result_column.data_type = apex_exec.c_data_type_date then
            l_result_rec.var_vc2 := to_char ( apex_exec.get_date ( p_context => l_context
                                                                 , p_column_idx => 1 )
                                            , flow_constants_pkg.gc_prov_default_date_format
                                            );
          elsif l_result_column.data_type = apex_exec.c_data_type_number then
            l_result_rec.var_vc2 := to_char ( apex_exec.get_number ( p_context => l_context
                                                                   , p_column_idx => 1 )
                                            );
          elsif l_result_column.data_type = apex_exec.c_data_type_timestamp_tz then
            l_result_rec.var_vc2 := to_char ( apex_exec.get_timestamp_tz ( p_context => l_context
                                                                         , p_column_idx => 1 )
                                            , flow_constants_pkg.gc_prov_default_tstz_format
                                            );
          -- add conversion CLOB to varchar2 if length OK?
          end if;

        when flow_constants_pkg.gc_prov_var_type_date then
          if l_result_column.data_type = apex_exec.c_data_type_date then
            l_result_rec.var_date := apex_exec.get_date ( p_context => l_context
                                                        , p_column_idx => 1 );
          elsif l_result_column.data_type = apex_exec.c_data_type_varchar2 then
            begin
              l_result_rec.var_date := to_date ( apex_exec.get_varchar2 ( p_context => l_context
                                                                        , p_column_idx => 1 )
                                               , flow_constants_pkg.gc_prov_default_date_format
                                               );  
            exception
              when others then
                l_result_rec.var_date := null;
            end;
          elsif l_result_column.data_type = apex_exec.c_data_type_timestamp_tz then
            l_result_rec.var_date := cast (apex_exec.get_timestamp_tz ( p_context => l_context
                                                        , p_column_idx => 1 )
                                          as date );
          end if;

        when flow_constants_pkg.gc_prov_var_type_number then
          if l_result_column.data_type = apex_exec.c_data_type_number then
            l_result_rec.var_num := apex_exec.get_number ( p_context => l_context
                                                         , p_column_idx => 1 );
          elsif l_result_column.data_type = apex_exec.c_data_type_varchar2 then
            begin
              l_result_rec.var_num := to_number ( apex_exec.get_varchar2 ( p_context => l_context
                                                                         , p_column_idx => 1 )
                                                );  
            exception
              when others then
                l_result_rec.var_num := null;
            end;
          end if;


        when flow_constants_pkg.gc_prov_var_type_tstz then
          if l_result_column.data_type = apex_exec.c_data_type_timestamp_tz then
            l_result_rec.var_tstz := apex_exec.get_timestamp_tz ( p_context => l_context
                                                              , p_column_idx => 1 );
          elsif l_result_column.data_type = apex_exec.c_data_type_varchar2 then
            begin
              l_result_rec.var_tstz := to_timestamp_tz ( apex_exec.get_varchar2 ( p_context => l_context
                                                                              , p_column_idx => 1 )
                                                     , flow_constants_pkg.gc_prov_default_tstz_format
                                                     );  
            exception
              when others then
                l_result_rec.var_tstz := null;
            end;
          elsif l_result_column.data_type = apex_exec.c_data_type_date then
            -- convert date to timestamp_tz using current session timezone
             l_result_rec.var_tstz := cast (apex_exec.get_date ( p_context => l_context
                                                              , p_column_idx => 1 )
                                          as timestamp with time zone);         
          end if;
        end case;
      end if;
    elsif pi_expr_type = flow_constants_pkg.gc_expr_type_sql_delimited_list  then
      -- get the returned column info...
      l_result_column := apex_exec.get_column ( p_context => l_context
                                              , p_column_idx => 1
                                              );
      l_result_set_vc2 := apex_t_varchar2();
      loop 
        -- result must be in only row/column returned
        exit when not apex_exec.next_row (p_context => l_context); 
        l_result_set_vc2.extend;
        l_indx := l_result_set_vc2.last;
        if l_result_column.data_type = apex_exec.c_data_type_varchar2 then
          l_result_set_vc2(l_indx)  := apex_exec.get_varchar2  ( p_context => l_context
                                                               , p_column_idx => 1
                                                               );
        elsif l_result_column.data_type = apex_exec.c_data_type_number then
          l_result_set_vc2(l_indx)  := to_char ( apex_exec.get_number ( p_context => l_context
                                                                      , p_column_idx => 1 )
                                               );
        end if;
      end loop; 
      -- create delimited string output
      l_result_rec.var_vc2 := apex_string.join
                            ( p_table => l_result_set_vc2
                            , p_sep => ':'
                            );
      apex_debug.message(p_message => 'Delimited String created %s', p0 => l_result_rec.var_vc2, p_level => 3);

    end if;
    -- close the cursor
    apex_exec.close (l_context);
    return l_result_rec;
  exception
    when e_var_exp_sql_too_many_rows then
      apex_exec.close (l_context);
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'exec_sql_too_many_rows'
      );
      -- $F4AMESSAGE 'var_exp_sql_too_many_rows' || 'Error executing SQL Query - query returns more than one row.'  
    when e_var_exp_must_return_one_column then
      apex_exec.close (l_context);
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'exec_sql_too_many_values'
      );
      -- $F4AMESSAGE 'exec_sql_too_many_cols' || 'Error executing SQl Query - query returns more than one column.'  
    when others then
      apex_debug.error
      ( p_message => 'Error executing SQL query for process id %1. SQLERRM: %2'
      , p1        => pi_prcs_id
      , p2        => sqlerrm
      );
      apex_exec.close (l_context);
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_sql_other'
      );
      -- $F4AMESSAGE 'exec_sql_other' || 'Error executing SQL Query.  SQL error shown in event log.'    
  end exec_flows_sql;

  function exec_flows_plsql_vc2
  ( pi_prcs_id         flow_processes.prcs_id%type
  , pi_sbfl_id         flow_subflows.sbfl_id%type
  , pi_plsql_text      varchar2
  , pi_scope           flow_subflows.sbfl_scope%type
  , pi_expr_type       flow_types_pkg.t_expr_type
  , pi_bind_parameters apex_exec.t_parameters
  ) return flow_proc_vars_int.t_proc_var_value
  is
    l_wrap_begin        varchar2(100);
    l_wrap_end          varchar2(100);
    l_expr              varchar2(4000) := pi_plsql_text;
    l_bind_parameters   apex_exec.t_parameters := pi_bind_parameters;
    l_result_rec        flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_util.exec_flows_plsql_vc2'
    , 'plsql text', pi_plsql_text
    );
    case 
    when pi_expr_type = flow_constants_pkg.gc_expr_type_plsql_expression 
      or pi_expr_type = flow_constants_pkg.gc_expr_type_plsql_raw_expression 
    then
      l_wrap_begin  := q'#begin :BIND_OUT_VAR := #';
      l_wrap_end    := q'# ; end;#';
    when pi_expr_type = flow_constants_pkg.gc_expr_type_plsql_function_body 
      or pi_expr_type = flow_constants_pkg.gc_expr_type_plsql_raw_function_body 
    then
      l_wrap_begin  := q'#declare function x return varchar2 is begin #';
      l_wrap_end    := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';
    end case;

    apex_exec.add_parameter ( l_bind_parameters, 'BIND_OUT_VAR','');

    apex_exec.execute_plsql(
        p_plsql_code      => l_wrap_begin||pi_plsql_text||l_wrap_end,
        p_auto_bind_items => false,
        p_sql_parameters  => l_bind_parameters );

    l_result_rec.var_vc2  := apex_exec.get_parameter_varchar2
                             ( p_parameters => l_bind_parameters
                             , p_name       => 'BIND_OUT_VAR'); 

    l_result_rec.var_name   := 'result';
    l_result_rec.var_type   := flow_constants_pkg.gc_prov_var_type_varchar2;

    return l_result_rec;   
  end exec_flows_plsql_vc2;

  function exec_flows_plsql_num
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_plsql_text     varchar2
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_expr_type      flow_types_pkg.t_expr_type
  , pi_bind_parameters apex_exec.t_parameters
  ) return flow_proc_vars_int.t_proc_var_value
  is
    l_wrap_begin      varchar2(100);
    l_wrap_end        varchar2(100);
    l_expr            varchar2(4000) := pi_plsql_text;
    l_bind_parameters apex_exec.t_parameters := pi_bind_parameters;
    l_result_rec      flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_util.exec_flows_plsql_num'
    , 'plsql text', pi_plsql_text
    );
    case 
    when pi_expr_type  = flow_constants_pkg.gc_expr_type_plsql_expression then
      l_wrap_begin  := q'#begin :BIND_OUT_VAR := #';
      l_wrap_end    := q'# ; end;#';
    when pi_expr_type = flow_constants_pkg.gc_expr_type_plsql_raw_expression then
      l_wrap_begin  := q'#begin :BIND_OUT_VAR := to_char( #';
      l_wrap_end    := q'# ) ; end;#';
    when pi_expr_type  = flow_constants_pkg.gc_expr_type_plsql_function_body then
      l_wrap_begin  := q'#declare function x return varchar2 is begin #';
      l_wrap_end    := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';
    when pi_expr_type  = flow_constants_pkg.gc_expr_type_plsql_raw_function_body then
      l_wrap_begin  := q'#declare function x return number is begin #';
      l_wrap_end    := q'#return null; end; begin :BIND_OUT_VAR := cast (x as varchar2); end;#';
    end case;

    apex_exec.add_parameter ( l_bind_parameters, 'BIND_OUT_VAR','');

    apex_exec.execute_plsql(
        p_plsql_code      => l_wrap_begin||pi_plsql_text||l_wrap_end,
        p_auto_bind_items => false,
        p_sql_parameters  => l_bind_parameters );

    l_result_rec.var_num  := cast ( apex_exec.get_parameter_varchar2
                                    ( p_parameters => l_bind_parameters
                                    , p_name       => 'BIND_OUT_VAR')
                                  as number ); 

    l_result_rec.var_name   := 'result';
    l_result_rec.var_type   := flow_constants_pkg.gc_prov_var_type_number;

    apex_debug.message(p_message => 'Number result %0', p0 => l_result_rec.var_num, p_level => 3);

    return l_result_rec;   
  end exec_flows_plsql_num;

  function exec_flows_plsql_date
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_plsql_text     varchar2
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_expr_type      flow_types_pkg.t_expr_type
  , pi_bind_parameters apex_exec.t_parameters
  ) return flow_proc_vars_int.t_proc_var_value
  is
    l_wrap_begin      varchar2(100);
    l_wrap_end        varchar2(100);
    l_expr            varchar2(4000) := pi_plsql_text;
    l_bind_parameters apex_exec.t_parameters := pi_bind_parameters;
    l_result_rec      flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_util.exec_flows_plsql_date'
    , 'plsql text', pi_plsql_text
    );
    case pi_expr_type 
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      -- legacy mode - expression will return a vc2 in our format
      l_wrap_begin  := q'#begin :BIND_OUT_VAR := #';
      l_wrap_end    := q'#; end;#';
    when flow_constants_pkg.gc_expr_type_plsql_raw_expression then
      -- new 'raw' mode - expression will return a date
      l_wrap_begin  := q'#begin :BIND_OUT_VAR := to_char( #';
      l_wrap_end    := q'# ,'#'||flow_constants_pkg.gc_prov_default_date_format||q'#'); end;#';
    when flow_constants_pkg.gc_expr_type_plsql_function_body then
      -- legacy mode - function will return a vc2 in our format
      l_wrap_begin  := q'#declare function x return varchar2 is begin #';
      l_wrap_end    := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';
    when flow_constants_pkg.gc_expr_type_plsql_raw_function_body then
      -- new 'raw' mode - function will return a date
      l_wrap_begin  := q'#declare function x return date is begin #';
      l_wrap_end    := q'#return null; end; begin :BIND_OUT_VAR := to_char(x, '#'||flow_constants_pkg.gc_prov_default_date_format||q'#'); end;#';
    end case;

    apex_exec.add_parameter ( l_bind_parameters, 'BIND_OUT_VAR','');

    apex_exec.execute_plsql(
        p_plsql_code      => l_wrap_begin||pi_plsql_text||l_wrap_end,
        p_auto_bind_items => false,
        p_sql_parameters  => l_bind_parameters );

    l_result_rec.var_date  := to_date ( apex_exec.get_parameter_varchar2
                                      ( p_parameters => l_bind_parameters
                                      , p_name       => 'BIND_OUT_VAR')
                                     , flow_constants_pkg.gc_prov_default_date_format ); 

    l_result_rec.var_name   := 'result';
    l_result_rec.var_type   := flow_constants_pkg.gc_prov_var_type_date;

    return l_result_rec;   
  end exec_flows_plsql_date;

  function exec_flows_plsql_tstz
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_plsql_text     varchar2
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_expr_type      flow_types_pkg.t_expr_type
  , pi_bind_parameters apex_exec.t_parameters
  ) return flow_proc_vars_int.t_proc_var_value
  is
    l_wrap_begin      varchar2(100);
    l_wrap_end        varchar2(100);
    l_expr            varchar2(4000) := pi_plsql_text;
    l_bind_parameters apex_exec.t_parameters := pi_bind_parameters;
    l_result_rec      flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_util.exec_flows_plsql_tstz'
    , 'plsql text', pi_plsql_text
    );
    case pi_expr_type 
    when flow_constants_pkg.gc_expr_type_plsql_expression then
      -- legacy mode - expression will return a vc2 in our format     
      l_wrap_begin  := q'#begin :BIND_OUT_VAR := #';
      l_wrap_end    := q'# ; end;#';
    when flow_constants_pkg.gc_expr_type_plsql_raw_expression then
      -- new 'raw' mode - expression will return a tstz      
      l_wrap_begin  := q'#begin :BIND_OUT_VAR := to_char( #';
      l_wrap_end    := q'# ,'#'||flow_constants_pkg.gc_prov_default_tstz_format||q'#'); end;#';
    when flow_constants_pkg.gc_expr_type_plsql_function_body then
      -- legacy mode - function will return a vc2 in our format   
      l_wrap_begin  := q'#declare function x return varchar2 is begin #';
      l_wrap_end    := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';
    when flow_constants_pkg.gc_expr_type_plsql_raw_function_body then
      -- new 'raw' mode - function will return a tstz
      l_wrap_begin  := q'#declare function x return timestamp with time zone is begin #';
      l_wrap_end    := q'#return null; end; begin :BIND_OUT_VAR := to_char(x, '#'||flow_constants_pkg.gc_prov_default_tstz_format||q'#'); end;#';
    end case;

    apex_exec.add_parameter ( l_bind_parameters, 'BIND_OUT_VAR','');

    apex_exec.execute_plsql(
        p_plsql_code      => l_wrap_begin||pi_plsql_text||l_wrap_end,
        p_auto_bind_items => false,
        p_sql_parameters  => l_bind_parameters );

    l_result_rec.var_tstz  := to_timestamp_tz ( apex_exec.get_parameter_varchar2
                                                ( p_parameters => l_bind_parameters
                                                , p_name       => 'BIND_OUT_VAR')
                                              , flow_constants_pkg.gc_prov_default_tstz_format ); 

    l_result_rec.var_name   := 'result';
    l_result_rec.var_type   := flow_constants_pkg.gc_prov_var_type_tstz;

    return l_result_rec;   
  end exec_flows_plsql_tstz;

  function exec_flows_plsql
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_plsql_text     varchar2
  , pi_result_type    varchar2  
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_expr_type      flow_types_pkg.t_expr_type
  ) return flow_proc_vars_int.t_proc_var_value
  is
    l_wrap_begin      varchar2(100);
    l_wrap_end        varchar2(100);
    l_bind_parameters apex_exec.t_parameters;
    l_expr            varchar2(4000) := pi_plsql_text;
    l_result_rec      flow_proc_vars_int.t_proc_var_value;
  begin
    apex_debug.enter
    ( 'flow_util.exec_flows_plsql'
    , 'plsql text', pi_plsql_text
    , 'plsql type' , pi_expr_type 
    );
    -- substitute any F4A Process Variables
    flow_proc_vars_int.do_substitution
    ( pi_prcs_id => pi_prcs_id
    , pi_sbfl_id => pi_sbfl_id
    , pi_scope   => pi_scope
    , pio_string => l_expr
    );
    -- get bind parameters
    l_bind_parameters := flow_proc_vars_int.get_parameter_list
                            ( pi_expr               => l_expr
                            , pi_prcs_id            => pi_prcs_id
                            , pi_sbfl_id            => pi_sbfl_id
                            , pi_scope              => pi_scope
                            );    

    case pi_result_type 
    when flow_constants_pkg.gc_prov_var_type_varchar2 then 
      l_result_rec := exec_flows_plsql_vc2  ( pi_prcs_id         => pi_prcs_id
                                            , pi_sbfl_id         => pi_sbfl_id
                                            , pi_plsql_text      => l_expr
                                            , pi_scope           => pi_scope
                                            , pi_expr_type       => pi_expr_type
                                            , pi_bind_parameters => l_bind_parameters
                                            );
    when flow_constants_pkg.gc_prov_var_type_number then
      l_result_rec := exec_flows_plsql_num  ( pi_prcs_id         => pi_prcs_id
                                            , pi_sbfl_id         => pi_sbfl_id
                                            , pi_plsql_text      => l_expr
                                            , pi_scope           => pi_scope
                                            , pi_expr_type       => pi_expr_type 
                                            , pi_bind_parameters => l_bind_parameters
                                            );
    when flow_constants_pkg.gc_prov_var_type_date then
      l_result_rec := exec_flows_plsql_date ( pi_prcs_id         => pi_prcs_id
                                            , pi_sbfl_id         => pi_sbfl_id
                                            , pi_plsql_text      => l_expr
                                            , pi_scope           => pi_scope
                                            , pi_expr_type       => pi_expr_type 
                                            , pi_bind_parameters => l_bind_parameters
                                            );
    when flow_constants_pkg.gc_prov_var_type_tstz then
      l_result_rec := exec_flows_plsql_tstz ( pi_prcs_id         => pi_prcs_id
                                            , pi_sbfl_id         => pi_sbfl_id
                                            , pi_plsql_text      => l_expr
                                            , pi_scope           => pi_scope
                                            , pi_expr_type       => pi_expr_type 
                                            , pi_bind_parameters => l_bind_parameters
                                            );
    end case;    
    return l_result_rec;
  exception
    when others then
      apex_debug.error
      ( p_message => 'Error executing PL/SQL (%0) for process id %1. SQLERRM: %2'
      , p0        => l_wrap_begin||pi_plsql_text||l_wrap_end
      , p1        => pi_prcs_id
      , p2        => sqlerrm
      );
      flow_errors.handle_instance_error
      ( pi_prcs_id        => pi_prcs_id
      , pi_sbfl_id        => pi_sbfl_id
      , pi_message_key    => 'var_exp_plsql_other'
      );
      -- $F4AMESSAGE 'exec_plsql_other' || 'Error executing PL/SQL.  PL/SQL error shown in event log.'    

  end exec_flows_plsql;

  function clob_to_blob
  ( 
    pi_clob in clob
  ) return blob
  as
  $if flow_apex_env.ver_le_22_1 $then
    l_blob   blob;
    l_dstoff pls_integer := 1;
    l_srcoff pls_integer := 1;
    l_lngctx pls_integer := 0;
    l_warn   pls_integer;
  $end
  begin

  $if flow_apex_env.ver_le_22_1 $then
    sys.dbms_lob.createtemporary
    ( lob_loc => l_blob
    , cache   => true
    , dur     => sys.dbms_lob.call
    );    

    sys.dbms_lob.converttoblob
    ( dest_lob     => l_blob
    , src_clob     => pi_clob
    , amount       => sys.dbms_lob.lobmaxsize
    , dest_offset  => l_dstoff
    , src_offset   => l_srcoff
    , blob_csid    => nls_charset_id( 'AL32UTF8' )
    , lang_context => l_lngctx
    , warning      => l_warn
    );

    return l_blob;
  $else
    return apex_util.clob_to_blob( p_clob => pi_clob );
  $end

  end clob_to_blob;

end flow_util;
/
