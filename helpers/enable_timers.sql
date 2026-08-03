-- Enable timers in BPMN --
--
-- execute in your workspace schema
--
-- Make sure you have the privilege "create job"
-- If not, execute the following statement as sys first:
-- grant create job to <my_workspace_schema>;

begin
  dbms_scheduler.create_program
  ( program_name        => 'APEX_FLOW_STEP_TIMERS_P'
  , program_type        => 'STORED_PROCEDURE'
  , program_action      => '"FLOW_TIMERS_PKG"."STEP_TIMERS"'
  , number_of_arguments => 0
  , enabled             => true
  , comments            => 'Update timers status and move the flow forward.'
  );

  dbms_scheduler.create_job
  ( job_name        => 'APEX_FLOW_STEP_TIMERS_J'
  , program_name    => 'APEX_FLOW_STEP_TIMERS_P'
  , job_style       => 'LIGHTWEIGHT'
  , start_date      => systimestamp
  , repeat_interval => 'FREQ=SECONDLY;INTERVAL=10'
  , enabled         => true
);
end;
/
