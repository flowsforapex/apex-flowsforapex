/*
  Migration Script for AQ MessageFlow incoming mesage queues

  Created  RAllen, Flowquest    28 Feb 2024


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/
PROMPT >> Create flow_t_correlated_message type

  create or replace type flow_t_correlated_message as object
  ( message_name  varchar2(200)
  , key_name      varchar2(200)
  , key_value     varchar2(200)
  , clob_payload  clob 
  , json_payload  clob
  , msub_id       number
  , prcs_id       number
  , sbfl_id       number
  , step_key      varchar2(20)
  , dgrm_id       number
  , callback      varchar2(200)
  , callback_par  varchar2(200)
  , payload_var   varchar2(50)
  , received_tstz timestamp with time zone
  , extension     clob
  );
  /

PROMPT >> Add column to FLOW_PROCESSES

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'PRCS_PROCESS_BPMN_ID'
     and upper(table_name)  = 'FLOW_PROCESSES';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_processes add 
        ( prcs_process_bpmn_id varchar2(50)
        )';
  end if;
end;
/
