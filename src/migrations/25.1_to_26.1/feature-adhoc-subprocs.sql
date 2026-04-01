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
                              , sbfl_ahsp_id  number
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

PROMPT >> > Adding columns to Table flow_object_expressions

declare
  v_column_exists          number := 0;
begin
  select count(*)
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'EXPR_SOURCE_TYPE'
     and upper(table_name)  = 'FLOW_OBJECT_EXPRESSIONS';
  if (v_column_exists = 0) then
      execute immediate 'alter table flow_object_expressions
                          add ( expr_source_type varchar2(50 char)
                              , expr_source      varchar2(50 char)
                              )';
  end if;
end;
/

PROMPT >> > Creating Table flow_adhoc_subprocs

create table flow_adhoc_subprocs (
    ahsp_id                     NUMBER
        GENERATED ALWAYS AS IDENTITY ( START WITH 1 NOCACHE )
    NOT NULL,
    ahsp_prcs_id                NUMBER NOT NULL,
    ahsp_sbfl_id                NUMBER NOT NULL,
    ahsp_dgrm_id                NUMBER NOT NULL,
    ahsp_bpmn_id                VARCHAR2(50 CHAR) NOT NULL,
    ahsp_step_key               VARCHAR2(20 CHAR) NOT NULL,
    ahsp_process_level          NUMBER NOT NULL,
    ahsp_control                VARCHAR2(20 CHAR) DEFAULT 'manual' NOT NULL,
    ahsp_last_ai_check          TIMESTAMP WITH TIME ZONE,
    ahsp_check_interval_minutes NUMBER,
    ahsp_iteration_count        NUMBER,
    ahsp_status                 VARCHAR2(20 CHAR),
    ahsp_next_recommended_check TIMESTAMP WITH TIME ZONE,
    ahsp_next_check_reason      VARCHAR2(500 CHAR),
    ahsp_turns_per_session      NUMBER,
    ahsp_max_total_turns        NUMBER
);

alter table flow_adhoc_subprocs
  add constraint flow_ahsp_pk primary key ( ahsp_id );

alter table flow_adhoc_subprocs
  add constraint flow_ahsp_control_ck check ( ahsp_control in ('manual', 'ai', 'hybrid') );

alter table flow_adhoc_subprocs
    add constraint flow_ahsp_prcs_fk FOREIGN KEY ( ahsp_prcs_id )
        references flow_processes (prcs_id)
            ON DELETE CASCADE;

alter table flow_adhoc_subprocs
    add constraint flow_ahsp_dgrm_fk FOREIGN KEY ( ahsp_dgrm_id )
        references flow_diagrams (dgrm_id);

-- Create index for AI scheduling queries
create index ahsp_next_check_idx on flow_adhoc_subprocs (ahsp_next_recommended_check); 

PROMPT >> > Creating Table flow_adhoc_subflows

create table flow_adhoc_subflows (
    ahsf_sbfl_id                NUMBER NOT NULL,
    ahsf_ahsp_id                NUMBER NOT NULL,
    ahsf_asad_id                NUMBER,
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

alter table flow_adhoc_subflows add constraint ahsf_unique_uk unique  ( ahsf_ahsp_id
                                                                     , ahsf_starting_object
                                                                     , ahsf_repeat_count );

alter table flow_adhoc_subflows
    add constraint flow_ahsf_ahsp_fk FOREIGN KEY ( ahsf_ahsp_id )
        references flow_adhoc_subprocs ( ahsp_id )
            ON DELETE CASCADE;

PROMPT >> > Creating table flow_adhoc_subproc_ai_decisions


create table flow_adhoc_subproc_ai_decisions (
    asad_id                     number generated always as identity
        constraint asad_pk primary key,
    asad_ahsp_id               number                  not null
        constraint asad_ahsp_id_fk
        references flow_adhoc_subprocs (ahsp_id)
        on delete cascade,
    asad_turn                  number                  not null,
    asad_rationale             varchar2(4000 byte),
    asad_actions               clob
        constraint asad_actions_is_json check (asad_actions is json),
    asad_timestamp             timestamp with time zone default systimestamp not null,
    asad_dispatch_completed    timestamp with time zone,
    asad_partial_review        timestamp with time zone,
    asad_created_by            varchar2(64 byte) default coalesce(
                                   sys_context('apex$session','app_user'),
                                   sys_context('userenv','os_user'), 
                                   sys_context('userenv','session_user')
                               )
);

  alter table flow_adhoc_subflows
    add constraint flow_ahsf_asad_fk FOREIGN KEY ( ahsf_asad_id )
      references flow_adhoc_subproc_ai_decisions ( asad_id )
        on delete set null;

  create index ahsf_asad_id_idx on flow_adhoc_subflows (ahsf_asad_id, ahsf_status);

-- Create index for foreign key
create index asad_ahsp_id_idx on flow_adhoc_subproc_ai_decisions (asad_ahsp_id, asad_turn);

-- Create index for timestamps
create index asad_timestamp_idx on flow_adhoc_subproc_ai_decisions (asad_timestamp);

comment on table flow_adhoc_subproc_ai_decisions is 'Tracks AI decisions and reasoning for autonomous adhoc subprocess management';
comment on column flow_adhoc_subproc_ai_decisions.asad_id is 'Primary key for AI decision record';
comment on column flow_adhoc_subproc_ai_decisions.asad_ahsp_id is 'Foreign key to flow_adhoc_subprocs';
comment on column flow_adhoc_subproc_ai_decisions.asad_turn is 'Turn/iteration number for this subprocess';
comment on column flow_adhoc_subproc_ai_decisions.asad_rationale is 'AI reasoning/rationale for the decision';
comment on column flow_adhoc_subproc_ai_decisions.asad_actions is 'JSON array of actions recommended by AI (CLOB with IS JSON constraint)';
comment on column flow_adhoc_subproc_ai_decisions.asad_timestamp is 'When this AI decision was made';
comment on column flow_adhoc_subproc_ai_decisions.asad_dispatch_completed is 'When this AI wave finished dispatching all recommended activities';
comment on column flow_adhoc_subproc_ai_decisions.asad_partial_review is 'When this AI wave triggered a partial re-evaluation while other activities were still running';
comment on column flow_adhoc_subproc_ai_decisions.asad_created_by is 'User/system that created the record';
comment on column flow_adhoc_subprocs.ahsp_next_recommended_check is 'AI-recommended timestamp for next check/wake-up';
comment on column flow_adhoc_subprocs.ahsp_next_check_reason is 'AI-provided reason for the recommended check timing';

PROMPT >> >> Schema Changes Completed
PROMPT >> --------------------------------------------------- 

