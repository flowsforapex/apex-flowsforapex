-- Enable timers in BPMN --

-- As sys, please first grant "create job" to your workspace schema first
-- GRANT CREATE JOB TO <my_workspace_schema>;

-- execute in your workspace schema

BEGIN
  DBMS_SCHEDULER.create_program
  ( program_name        => 'APEX_FLOW_STEP_TIMERS_P'
  , program_type        => 'STORED_PROCEDURE'
  , program_action      => '"FLOW_TIMERS_PKG"."STEP_TIMERS"'
  , number_of_arguments => 0
  , enabled             => TRUE
  , comments            => 'Update timers status and move the flow forward.'
  );
END;

BEGIN
  DBMS_SCHEDULER.create_job
  ( job_name        => 'APEX_FLOW_STEP_TIMERS_J'
  , program_name    => 'APEX_FLOW_STEP_TIMERS_P'
  , job_style       => 'LIGHTWEIGHT'
  , start_date      => SYSTIMESTAMP
  , repeat_interval => 'FREQ=SECONDLY;INTERVAL=10'
  , enabled         => TRUE
);
END;