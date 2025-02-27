/*
  Migration Script for Rewind Feature xxx - Suspend, Rewind and Resume

  Created  RAllen, Flowquest    21 Feb 2025 


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/
PROMPT >> Schema Changes for Rewind and Event Logging Feature
PROMPT >> ---------------------------------------------------

create table flow_step_events
( lgse_prcs_id              NUMBER NOT NULL
, lgse_step_key             VARCHAR2(20 CHAR) NOT NULL
, lgse_sbfl_id              NUMBER NOT NULL
, lgse_dgrm_id              NUMBER NOT NULL 
, lgse_objt_bpmn_id         VARCHAR2(50 CHAR) NOT NULL
, lgse_event_type           VARCHAR2(20 CHAR) NOT NULL
, lgse_timestamp            TIMESTAMP WITH TIME ZONE NOT NULL
, lgse_user                 VARCHAR2(255 CHAR)
, lgse_comment              VARCHAR2(2000 CHAR)
);

create index flow_lgse_ix on flow_step_events (lgse_prcs_id, lgse_objt_bpmn_id );

declare
  v_column_exists          number := 0; 
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'PRCS_WAS_ALTERED'
     and upper(table_name)  = 'FLOW_PROCESSES';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_processes 
                          add (prcs_was_altered varchar2(1)
                              , constraint flow_processes_was_altered_ck check (prcs_was_altered in (''Y'', ''N''))
                              )';
  end if;

end;
/



