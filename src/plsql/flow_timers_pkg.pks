CREATE OR REPLACE PACKAGE flow_timers_pkg AS
/******************************************************************************
 Purpose:
   Provides support to timed events in Flows for APEX.

 Grants required:
   CREATE JOB
   EXECUTE ON default_in_memory_job_class
******************************************************************************/

/******************************************************************************
 PROCEDURES
******************************************************************************/


/******************************************************************************
  START_TIMER
    Instantiate a new timer
******************************************************************************/
  PROCEDURE start_timer (
    p_process_id  IN  VARCHAR2
  , p_subflow_id    IN  VARCHAR2
  );


/******************************************************************************
  TIMER_EXPIRED
    Increment the progress in a flow pushing it to the next step.
******************************************************************************/

  PROCEDURE timer_expired (
    p_process_id  IN  VARCHAR2
  , p_subflow_id  IN  VARCHAR2 
  );


/******************************************************************************
  KILL_TIMER
    Remove a timer instance before the expiration time.
******************************************************************************/

  PROCEDURE kill_timer (
    p_process_id    IN   VARCHAR2
    p_subflow_id    IN varchar2
  , out_return_code  OUT  NUMBER
  );


/******************************************************************************
  KILL_PROCESS_TIMERS
    Remove all the timers of a process.
******************************************************************************/

  PROCEDURE kill_process_timers (
    in_process_id    IN   VARCHAR2
  , out_return_code  OUT  NUMBER
  );


/******************************************************************************
  KILL_ALL_TIMERS
    Remove all timers related to a process.
******************************************************************************/

  PROCEDURE kill_all_timers (
    in_process_id    IN   VARCHAR2
  , out_return_code  OUT  NUMBER
  );

END flow_timers_pkg;