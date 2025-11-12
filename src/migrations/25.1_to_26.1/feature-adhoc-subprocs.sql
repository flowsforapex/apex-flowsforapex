/*
  Migration Script for Adhoc Sub processes feature

  Created  RAllen, Flowquest    10 Nov 2025 


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/
PROMPT >> Schema Changes for Adhoc Sub
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
                          add ( sbfl_is_adhoc                   varchar22(1 char) 
                              , sbfl_adhoc_child_process_level  number
                              )';
      execute immediate 'alter table flow_subflows 
                          add constraint sbfl_ck_adhoc_yn check (sbfl_is_adhoc in (''Y'',''N''))';
  end if;
end;
/


PROMPT >> >> Schema Changes Completed
PROMPT >> --------------------------------------------------- 

