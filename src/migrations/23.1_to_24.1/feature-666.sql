/*
  Migration Script for Feature 666 - Iterations, Loops, and JSON Process Variables

  Created  RAllen, Flowquest    11 Jan 2024


  (c) Copyright Flowquest Consulting Limited and/or its affiliates.  2024.

*/
PROMPT >> Create Iterations

PROMPT >> Database Changes

  CREATE TABLE flow_iterations (
      fita_prcs_id        NUMBER NOT NULL,
      fita_diagram_level  NUMBER NOT NULL,
      fita_dgrm_id        NUMBER NOT NULL,
      fita_parent_bpmn_id VARCHAR2(50 CHAR) not null,
      fita_step_key       VARCHAR2(20 CHAR) not null,
      fita_iteration_var  VARCHAR2(50 CHAR) not null,
      fita_var_scope      NUMBER not null
  );

  alter table flow_iterations
    add constraint flow_fita_pk primary key ( fita_prcs_id
                                            , fita_iteration_var
                                            , fita_var_scope);

  create index flow_fita_step_key_ix on flow_iterations 
                                        ( fita_prcs_id
                                        , fita_step_key);
                                        
declare
  v_column_exists number := 0;  
  v_table_exists  number := 0;  
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
                         sbfl_iteration_path             VARCHAR2(4000 CHAR)                     
                         )';
  end if;

    select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SBFL_ITERATION_VAR'
     and upper(table_name)  = 'FLOW_SUBFLOWS';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflows add (
                         sbfl_iteration_var              VARCHAR2(50 CHAR)               
                         )';
  end if;

    select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SBFL_ITERATION_VAR_SCOPE'
     and upper(table_name)  = 'FLOW_SUBFLOWS';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflows add (
                         sbfl_iteration_var_scope     NUMBER                   
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
   where upper(column_name) = 'SFLG_SBFL_ITERATION_PATH'
     and upper(table_name)  = 'FLOW_SUBFLOW_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflow_log add (
                             sflg_sbfl_iteration_path    VARCHAR2(4000 CHAR)                    
                         )';
  end if;

  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SFLG_ITERATION_VAR'
     and upper(table_name)  = 'FLOW_SUBFLOW_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflow_log add (
                             sflg_iteration_var    VARCHAR2(50 CHAR)                    
                         )';
  end if;

  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SFLG_SCOPE'
     and upper(table_name)  = 'FLOW_SUBFLOW_LOG';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflow_log add (
                             sflg_scope    NUMBER                   
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


