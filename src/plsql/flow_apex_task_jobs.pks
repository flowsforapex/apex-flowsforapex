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
