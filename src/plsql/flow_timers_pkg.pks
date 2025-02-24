create or replace package flow_timers_pkg
/* 
-- Flows for APEX - flow_timers_pkg.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates. 2022-23.
--
-- Created 2020        Franco Soldaro
-- Edited  2020        Moritz Klein - MT AG  
-- Edited  24-Feb-2023 Richard Allen, Oracle
--
Purpose:
   Provides support to timers in Flows for APEX.

 Grants required:
   CREATE JOB


******************************************************************************/
  authid definer
-- accessible by ( flow_engine, flow_instances, flow_boundary_events, flow_api_pkg
--               , flow_admin_api , flow_instances_util_ee )
as


/******************************************************************************
  CONSTANTS
******************************************************************************/
  c_created    constant varchar2(1) := 'C'; -- Created and waiting for the first action.
  c_active     constant varchar2(1) := 'A'; -- The time has already completed 1 action
                                            -- but will perform more actions.
                                            -- NO LONGER USED
  c_ended      constant varchar2(1) := 'E'; -- The timer has naturally completed his
                                            -- action/s with no external intervention.
  c_expired    constant varchar2(1) := 'X'; -- The timers is stopped by call from the
                                            -- flow when stepping forward, before his
                                            -- natural end.
  c_terminated constant varchar2(1) := 'T'; -- Abnormal termination by manual
                                            -- intervention.
  c_broken     constant varchar2(1) := 'B'; -- Error occured in timer flow.
                                            -- Timer will be ignored until manually
                                            -- reset to created or active.
  c_suspended  constant varchar2(1) := 'S'; -- Timer is suspended as it is part of a
                                            -- process instance which has been suspended.


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
    pi_prcs_id      in flow_processes.prcs_id%type
  , pi_sbfl_id      in flow_subflows.sbfl_id%type
  , pi_step_key     in flow_subflows.sbfl_step_key%type default null
  , pi_callback     in flow_timers.timr_callback%type
  , pi_callback_par in flow_timers.timr_callback_par%type default null
  , pi_run          in flow_timers.timr_run%type default 1 -- 1 original, 2-> repeats
  , pi_timr_id      in flow_timers.timr_id%type default null -- only set on repeats
  );

/******************************************************************************
  reschedule_timer
    change the time that a timer is scheduled to fire to a new time, or now.
******************************************************************************/

procedure reschedule_timer
(
    p_process_id        in flow_processes.prcs_id%type
  , p_subflow_id        in flow_subflows.sbfl_id%type
  , p_step_key          in flow_subflows.sbfl_step_key%type default null
  , p_is_immediate      in boolean default false
  , p_restart_immediate in boolean default false
  , p_new_timestamp     in flow_timers.timr_start_on%type default null
  , p_comment           in flow_instance_event_log.lgpr_comment%type default null
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
  lock_timer
    locks the specified timer.
******************************************************************************/

  procedure lock_timer
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
  suspend_process_timers
    suspend all timers for a process instance
******************************************************************************/

  procedure suspend_process_timers
  (
    pi_prcs_id  in  flow_processes.prcs_id%type
  );

/******************************************************************************
  resume_process_timers
    resume all timers for a process instance    
******************************************************************************/

  procedure resume_process_timers
  (
    pi_prcs_id  in  flow_processes.prcs_id%type
  );


/******************************************************************************
  lock_process_timers
    locks all the timers of a process.
******************************************************************************/

  procedure lock_process_timers
  (
    pi_prcs_id  in  flow_processes.prcs_id%type
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
    termintate all the timers of all processes.
******************************************************************************/

  procedure terminate_all_timers
  (
    po_return_code  out  number
  );


/******************************************************************************
  get_timer_repeat_interval
    get the repeat interval of the timer scheduler job.
******************************************************************************/
  function get_timer_repeat_interval
  return sys.all_scheduler_jobs.repeat_interval%type
  ;

/******************************************************************************
  set_timer_repeat_interval
    set the repeat interval of the timer scheduler job (uses dbms_scheduler syntax)
******************************************************************************/

  procedure set_timer_repeat_interval 
  ( p_repeat_interval  in  varchar2
  );

/******************************************************************************
  get_timer_status
    disable the scheduled job processing of timers.
******************************************************************************/

  function get_timer_status
  return varchar2;

/******************************************************************************
  timer_job_exists
    Tells if the job for running timers exists.
******************************************************************************/
  function timer_job_exists
    return boolean;

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
