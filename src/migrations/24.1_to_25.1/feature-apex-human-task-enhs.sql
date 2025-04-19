/*
  Migration Script for 25.1 CE APEX Hman Task Enhancements

  Created  RAllen   14 Apr 2025


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/

-- Add new config values for APEX Human Task Enhancements
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_apex_business_admin'                   ,p_value => 'FLOWS4APEX');

 
-- Add Business Admin to Subflows table

PROMPT >> Database Changes

declare
  v_column_exists number := 0;  
begin
  select count(*) 
    into v_column_exists
    from user_tab_cols
   where upper(column_name) = 'SBFL_APEX_BUSINESS_ADMIN'
     and upper(table_name)  = 'FLOW_SUBFLOWS';

  if (v_column_exists = 0) then
      execute immediate 'alter table flow_subflows add 
        ( sbfl_apex_business_admin  varchar2(4000)
        )';
  end if;
end;
/
