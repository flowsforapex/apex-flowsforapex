-- Installs test models, tests, test apps in test env

spool install_ce_test_scratch.log

PROMPT >> Installing CE Test Packages

@install_all_tests.sql

PROMPT >> Install All CE Test models

@models/sql/import.sql
commit;

PROMPT >> Install Emp/Dept
PROMPT >> Install Emp/Dept

@create_emp_dept.sql

PROMPT >> Create Timer Schedule
PROMPT >> Create Timer Schedule

BEGIN
DBMS_SCHEDULER.create_program (
   program_name        => 'APEX_FLOW_STEP_TIMERS_P',
   program_type        => 'STORED_PROCEDURE',
   program_action      => '"FLOW_TIMERS_PKG"."STEP_TIMERS"',
   number_of_arguments => 0,
   enabled             => TRUE,
   comments            => 'Update timers status and move the flow forward.'
   );
END;
/

BEGIN
DBMS_SCHEDULER.create_job (
    job_name        => 'APEX_FLOW_STEP_TIMERS_J',
    program_name    => 'APEX_FLOW_STEP_TIMERS_P',
    job_style       => 'LIGHTWEIGHT',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=SECONDLY;INTERVAL=10',
    enabled         => TRUE
);
END;
/

PROMPT >> Install App required for tests

@apps/A24_approval_comp_integration_apex22_2.sql

PROMPT >> Create FLOWTESTER1 and FLOWTESTER2 in Workspace
PROMPT >> Update test_constants.pkg with new App ID for App A24. and recompile

PROMPT >> Update Config Parameters for Workspace ID, Default User, and App ID.


spool OFF
