PROMPT >> Create Task ID by adding Step Key to logs if not present

PROMPT >> Database Changes

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SFLG_STEP_KEY'
     and upper(table_name)  = 'FLOW_SUBFLOW_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflow_log add (sflg_step_key VARCHAR2(20 CHAR))';
  end if;
end;
/

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'LGSF_STEP_KEY'
     and upper(table_name)  = 'FLOW_STEP_EVENT_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_step_event_log add (lgsf_step_key VARCHAR2(20 CHAR))';
  end if;
end;
/

