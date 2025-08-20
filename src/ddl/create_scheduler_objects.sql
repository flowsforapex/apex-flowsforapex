/* Flows for APEX - create_scheduler_objects.sql
   This script creates the necessary scheduler objects for Flows for APEX
   It includes creating a program for canceling APEX tasks.

   (c) Flowquest Limited and / or its affiliates.  2025.

   Created by Richard Allen, Flowquest Limited 23-Apr-2025
*/


-- Flows for APEX Timer Job Creation

BEGIN
   sys.DBMS_SCHEDULER.create_program (
   program_name        => 'APEX_FLOW_STEP_TIMERS_P',
   program_type        => 'STORED_PROCEDURE',
   program_action      => '"FLOW_TIMERS_PKG"."STEP_TIMERS"',
   number_of_arguments => 0,
   enabled             => TRUE,
   comments            => 'Update timers status and move the flow forward.'
   );
END;
/

-------------
-- RUN JOB
-- See Documentation at url https://flowsforapex.org/latest/about-timer-execution/
-- For Production Jobs, decide on your required frequency.  No more often than 'FREQ=SECONDLY;INTERVAL=10'
-- We will install a default job that runs every 5 minutes.  You can configure through the Flows for APEX Application.
-- For Production Environments:  Consider reducing this to 10 seconds or higher.   See doc.

-- For Demo Environments/ POC / sample apps:
-- For Oracle shared environments apex.oracle.com, oracleapex.com, apex.oraclecorp.com, minimum interval is once per minute
-- Please use the Flows for APEX Application to Disable timers if you are not going to be using your demo environment
-- for several days.
-------------
BEGIN
   sys.DBMS_SCHEDULER.create_job (
    job_name        => 'APEX_FLOW_STEP_TIMERS_J',
    program_name    => 'APEX_FLOW_STEP_TIMERS_P',
    job_style       => 'LIGHTWEIGHT',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=5',
    enabled         => TRUE
);
END;
/


-- APEX Human Task Cancel Program
begin
  sys.dbms_scheduler.create_program (
    program_name        => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'FLOW_USERTASK_PKG.CANCEL_APEX_TASK_FROM_SCHEDULER',
    number_of_arguments => 6,
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
    argument_type     => 'VARCHAR2' -- p_app_id
  );

  sys.dbms_scheduler.define_program_argument (
    program_name      => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    argument_position => 5,
    argument_type     => 'VARCHAR2' -- p_page_id
  );

  sys.dbms_scheduler.define_program_argument (
    program_name      => 'APEX_FLOW_CANCEL_APEX_TASK_P',
    argument_position => 6,
    argument_type     => 'VARCHAR2' -- p_objt_bpmn_id
  );

  -- Enable the program
  sys.dbms_scheduler.enable('APEX_FLOW_CANCEL_APEX_TASK_P');
end;
/
