
create or replace package flow_timers_pkg as
/******************************************************************************
 Purpose:
   Provides support to timers in Flows for APEX.

 Grants required:
   CREATE JOB
******************************************************************************/

 -- TEST ONLY!!! Remov before merge.... --
  procedure get_duration
  (
    in_string            in     varchar2
  , in_start_ts          in     timestamp with time zone default null
  , out_start_ts            out timestamp with time zone
  , out_interv_ym        in out interval year to month
  , out_interv_ds        in out interval day to second
  );
-- END TEST ONLY --

/******************************************************************************
  CONSTANTS
******************************************************************************/
  c_created    varchar2(1) := 'C'; -- Created and waiting for the first action.
  c_active     varchar2(1) := 'A'; -- The time has already completed 1 action
                                   -- but will perform more actions.
  c_ended      varchar2(1) := 'E'; -- The timer has naturally completed his
                                   -- action/s with no external intervention.
  c_expired    varchar2(1) := 'X'; -- The timers is stopped by call from the
                                   -- flow when stepping forward, before his
                                   -- natural end.
  c_terminated varchar2(1) := 'T'; -- Abnormal termination by manual
                                   -- intervention.
  c_broken     varchar2(1) := 'B'; -- Error occured in timer flow.
                                   -- Timer will be ignored until manually
                                   -- reset to created or active.


/******************************************************************************
  step_timers
    check update status of active timers.
******************************************************************************/
  procedure step_timers;


/******************************************************************************
  start_timer
    create a new timer instance.
******************************************************************************/
  procedure start_timer
  (
    pi_prcs_id  in  flow_processes.prcs_id%type
  , pi_sbfl_id  in  flow_subflows.sbfl_id%type
  );

/******************************************************************************
  expire_timer
    increment the progress in a flow pushing it to the next step.
******************************************************************************/

  procedure expire_timer
  (
    pi_prcs_id  in  flow_processes.prcs_id%type
  , pi_sbfl_id  in  flow_subflows.sbfl_id%type
  );

/******************************************************************************
  kill_timer
    remove a timer instance before the expiration time.
******************************************************************************/

  procedure terminate_timer 
  (
    pi_prcs_id      in flow_processes.prcs_id%type
  , pi_sbfl_id      in flow_subflows.sbfl_id%type
  , po_return_code out number
  );

/******************************************************************************
  terminate_process_timers
    terminate all the timers of a process.
******************************************************************************/

  procedure terminate_process_timers
  (
    pi_prcs_id      in flow_processes.prcs_id%type
  , po_return_code out number
  );

/******************************************************************************
  delete_process_timers
    delete all the timers of a process.
******************************************************************************/

  procedure delete_process_timers
  (
    pi_prcs_id      in flow_processes.prcs_id%type
  , po_return_code out number
  );

/******************************************************************************
  terminate_all_timers
    termintate all the timers of any process.
******************************************************************************/

  procedure terminate_all_timers
  (
    po_return_code  out  number
  );


/******************************************************************************
  disable_scheduled_job
    disable the scheduled job processing of timers.
******************************************************************************/

  procedure disable_scheduled_job;

/******************************************************************************
  enable_scheduled_job
    enable the scheduled job processing of timers.
******************************************************************************/

  procedure enable_scheduled_job;

end flow_timers_pkg;
/
