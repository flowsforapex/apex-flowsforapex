/*
  Migration Script for Adhoc Sub processes feature

  Created  RAllen, Flowquest    10 Nov 2025 


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/
PROMPT >> Schema Changes for Adhoc Sub Processes Feature
PROMPT >> ---------------------------------------------------
PROMPT >> > Adding columns to Table flow_subflows

declare
  v_column_exists          number := 0; 
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SBFL_IS_ADHOC'
     and upper(table_name)  = 'FLOW_SUBFLOWS';    
  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflows 
                          add ( sbfl_is_adhoc                   varchar2(1 char) 
                              , sbfl_adhoc_child_process_level  number
                              , sbfl_hide_in_task_list          varchar2(1 char)
                              , sbfl_task_input_parameters      CLOB
                              , sbfl_task_output_parameters     CLOB
                              )';
      execute immediate 'alter table flow_subflows 
                          add constraint sbfl_ck_adhoc_yn check (sbfl_is_adhoc in (''Y'',''N''))';
      execute immediate 'alter table flow_subflows 
                          add constraint sbfl_task_input_param_is_json_ck check ( sbfl_task_input_parameters is json )';
      execute immediate 'alter table flow_subflows 
                          add constraint sbfl_task_output_param_is_json_ck check ( sbfl_task_output_parameters is json )';
  end if;
end;
/

PROMPT >> > Creating Table flow_adhoc_subflows

create table flow_adhoc_subflows (
    ahsf_sbfl_id                NUMBER NOT NULL,
    ahsf_prcs_id                NUMBER NOT NULL,
    ahsf_dgrm_id                NUMBER NOT NULL,
    ahsf_subproc_sbfl_id        NUMBER NOT NULL,
    ahsf_subproc_bpmn_id        VARCHAR2(50 CHAR) NOT NULL,
    ahsf_subproc_step_key       VARCHAR2(20 CHAR) NOT NULL,
    ahsf_starting_object        VARCHAR2(50 CHAR) NOT NULL,
    ahsf_starting_step_key      VARCHAR2(20 CHAR) NOT NULL,
    ahsf_repeat_count           NUMBER NOT NULL,
    ahsf_status                 VARCHAR2(20 CHAR) NOT NULL,
    ahsf_start_time             TIMESTAMP WITH TIME ZONE NOT NULL,
    ahsf_complete_time          TIMESTAMP WITH TIME ZONE,
    ahsf_inputs                 CLOB,
    ahsf_outputs                CLOB
);

alter table flow_adhoc_subflows
  add constraint flow_ahsf_pk primary key ( ahsf_sbfl_id );

alter table flow_adhoc_subflows add constraint ahsf_inputs_is_json_ck check ( ahsf_inputs is json );    
alter table flow_adhoc_subflows add constraint ahsf_outputs_is_json_ck check ( ahsf_outputs is json );

alter table flow_adhoc_subflows add constraint ahsf_unique_uk unique  ( ahsf_prcs_id
                                                                    , ahsf_starting_object
                                                                    , ahsf_repeat_count );

PROMPT >> >> Schema Changes Completed
PROMPT >> --------------------------------------------------- 

