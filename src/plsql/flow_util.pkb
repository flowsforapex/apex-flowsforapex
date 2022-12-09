create or replace package body flow_util
as 
/* 
-- Flows for APEX - flow_util.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created  08-Dec-2022  Richard Allen (Oracle Corporation)
--
*/

  function exec_flows_sql
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_sql_text       varchar2
  , pi_result_type    varchar2  
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_is_multi       boolean default false
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
    if not pi_is_multi and apex_exec.get_total_row_count (p_context => l_context) > 1 then
      raise e_var_exp_sql_too_many_rows;
    end if;
    -- for SQl Single we can return several datatypes, and convert to other datatypes
    -- for SQl multi, we can only return vc2 or number datatypes, but need to loop to return into array
    -- and then build concatenated colon separated string
    if not pi_is_multi then
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
            l_result_rec.var_vc2 := to_char ( apex_exec.get_number ( p_context => l_context
                                                                   , p_column_idx => 1 )
                                            , flow_constants_pkg.gc_prov_default_ts_format
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


        when flow_constants_pkg.gc_prov_var_type_ts then
          if l_result_column.data_type = apex_exec.c_data_type_timestamp_tz then
            l_result_rec.var_ts := apex_exec.get_timestamp_tz ( p_context => l_context
                                                              , p_column_idx => 1 );
          elsif l_result_column.data_type = apex_exec.c_data_type_varchar2 then
            begin
              l_result_rec.var_ts := to_timestamp_tz ( apex_exec.get_varchar2 ( p_context => l_context
                                                                              , p_column_idx => 1 )
                                                     , flow_constants_pkg.gc_prov_default_ts_format
                                                     );  
            exception
              when others then
                l_result_rec.var_ts := null;
            end;
          elsif l_result_column.data_type = apex_exec.c_data_type_date then
            -- convert date to timestamp_tz using current session timezone
             l_result_rec.var_ts := cast (apex_exec.get_date ( p_context => l_context
                                                              , p_column_idx => 1 )
                                          as timestamp with time zone);         
          end if;
        end case;
      end if;
    elsif pi_is_multi then
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

end flow_util;