/*
  Migration Script for Rewind Feature xxx - Suspend, Rewind and Resume

  Created  RAllen, Flowquest    21 Feb 2025 


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/
PROMPT >> Schema Changes for Rewind Feature
PROMPT >> -----------------------------------

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



