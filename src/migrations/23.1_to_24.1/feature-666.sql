PROMPT >> Create Iterations

PROMPT >> Database Changes

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SBFL_LOOP_COUNTER'
     and upper(table_name)  = 'FLOW_SUBFLOWS';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflows add (
                         sbfl_iteration_type             VARCHAR2(10 CHAR),
                         sbfl_loop_counter               NUMBER,
                         sbfl_loop_total_instances       NUMBER,
                         sbfl_loop_active_instances      NUMBER,
                         sbfl_loop_completed_instances   NUMBER,
                         sbfl_loop_terminated_instances  NUMBER                         
                         )';
  end if;

  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'PROV_VAR_JSON'
     and upper(table_name)  = 'FLOW_PROCESS_VARIABLES';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_process_variables add (
                         prov_var_json     clob,
                         constraint prov_is_json check ( prov_var_json is json)                       
                         )';
  end if;

  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'LGVR_VAR_JSON'
     and upper(table_name)  = 'FLOW_VARIABLE_EVENT_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_variable_event_log add (
                         lgvr_var_json     clob                     
                         )';
  end if;
end;
/

