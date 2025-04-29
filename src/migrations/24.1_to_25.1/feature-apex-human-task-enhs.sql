/*
  Migration Script for 25.1 CE APEX Hman Task Enhancements

  Created  RAllen   14 Apr 2025


  (c) Copyright Flowquest Limited and/or its affiliates.  2025.

*/

PROMPT >> Add new config values for APEX Human Task Enhancements
begin
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_apex_business_admin'                   ,p_value => 'FLOWS4APEX');

  commit;
end;
/

PROMPT >> Add Business Admin to Subflows table

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

PROMPT >> Add DBMS_SCHEDULER program for APEX Tasks cancellation
begin
  sys.dbms_scheduler.create_program (
    program_name        => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'FLOW_USERTASK_PKG.CANCEL_APEX_TASK_FROM_SCHEDULER',
    number_of_arguments => 5,
    enabled             => FALSE,
    comments            => 'Flows for APEX  APEX Task Cancel Program'
  );

  -- Define arguments (match the procedure signature and order)
  sys.dbms_scheduler.define_program_argument (
    program_name      => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    argument_position => 1,
    argument_type     => 'VARCHAR2' -- p_process_id
  );

  sys.dbms_scheduler.define_program_argument (
    program_name      => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    argument_position => 2,
    argument_type     => 'VARCHAR2' -- p_apex_task_id
  );

  sys.dbms_scheduler.define_program_argument (
    program_name      => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    argument_position => 3,
    argument_type     => 'VARCHAR2' -- p_apex_user
  );

  sys.dbms_scheduler.define_program_argument (
    program_name      => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    argument_position => 4,
    argument_type     => 'VARCHAR2' -- p_dgrm_id
  );

  sys.dbms_scheduler.define_program_argument (
    program_name      => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    argument_position => 5,
    argument_type     => 'VARCHAR2' -- p_objt_bpmn_id
  );

  -- Enable the program
  sys.dbms_scheduler.enable('APEX_FLOW_CANCEL_APEX_TASK_P');
end;
/
