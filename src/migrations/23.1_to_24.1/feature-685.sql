PROMPT >> MessageFlow - add message Start, message Boundary Events and message End Events

PROMPT >> Database Changes

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'MSUB_DGRM_ID'
     and upper(table_name)  = 'FLOW_MESSAGE_SUBSCRIPTIONS';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_message_subscriptions add 
        ( msub_DGRM_ID number
        , constraint flow_msub_dgrm_fk FOREIGN KEY ( msub_dgrm_id )
          references flow_diagrams (dgrm_id) ON DELETE CASCADE
        )';
  end if;
end;
/
