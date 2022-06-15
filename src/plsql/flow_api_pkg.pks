create or replace package flow_api_pkg
  authid definer
as

/********************************************************************************
**
**        FLOW INSTANCE OPERATIONS (Create, Start, Reset, Terminate, Delete)
**        STEP OPERATIONS (Reserve, Release, Complete)
**
********************************************************************************/

/***
Function flow_create
creates a new process instance based on a diagram name and version (process specification)
If the version is not specified,
  first lookup is to use dgrm_status = 'released'
  second lookup is to use dgrm_version = '0' and dgrm_status = 'draft'
If nothing is found based on above rules an exception will be raised.
For accuracy, it's recommended that you specify a version or use the form of flow_create specifying dgrm_id directly.
Returns: Process ID of the newly created process
*/
  function flow_create
  ( 
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type default null
  , pi_prcs_name in flow_processes.prcs_name%type
  ) return flow_processes.prcs_id%type;

/***
Function flow_create
creates a new process instance based on a diagram id and version (process specification)
Returns: Process ID of the newly created process
*/
  function flow_create
  (
    pi_dgrm_id   in flow_diagrams.dgrm_id%type
  , pi_prcs_name in flow_processes.prcs_name%type
  ) return flow_processes.prcs_id%type;

/***
Procedure  flow_create
creates a new process instance based on a diagram name and version (process specification)
if the version is not specified, it looks for a copy of the diagram having dgrm_status = 'released'
For accuracy, it's recommended that you specify a version or use the form of flow_create specifying dgrm_id directly.
*/
  procedure flow_create
  (
    pi_dgrm_name in flow_diagrams.dgrm_name%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type default null
  , pi_prcs_name in flow_processes.prcs_name%type
  );
/***
Procedure flow_create
creates a new process instance based on a diagram id and version (process specification)
*/
  procedure flow_create
  (
    pi_dgrm_id   in flow_diagrams.dgrm_id%type
  , pi_prcs_name in flow_processes.prcs_name%type
  );
/***
Procedure flow_start
Starts a process that was previously created by flow_create.
Flow_start will create the initial subflow, set the current event to the diagram's start event, 
then step on to the next object in the process diagram
*/
  procedure flow_start
  (
    p_process_id in flow_processes.prcs_id%type
  );
/***
Procedure flow_reserve_step
Reservation is a light-weight process for a user to indicate to other users that he/she intends to work on 
the current task in order to prevent multiple users working on the same task at the same time.
A reservation is typically made by supplying the reserving user's username as the p_reservation parameter 
(although an application could come up with some other scheme for the reservation parameter, and so it is not 
restricted to being a userid).  Other users will be able to see that a reservation has been placed on a step.
Reservations are purely a signalling mechanism;  no enforcement is taken in the engine 
to restrict other users from undertaking a task reserved by somebody.
A reservation can be released using the flow_release_step procedure.
A reservation applies only to the current task waiting to be completed.  Once the task is completed, there is 
no reservation carried forward onto future tasks in the process.
Reservation is not an authorization control, and is not security relevant / enforcing in the engine.
*/
    procedure flow_reserve_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  , p_reservation   in flow_subflows.sbfl_reservation%type
  );  
/***
Procedure flow_release_step
Release step is part of the reservation process.  See documentation for flow_reserve_step.
Flow_release_step releases a previously made reservation.
*/
     procedure flow_release_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  ); 
/***
Procedure flow_start_step
flow_start_step can optionally be called when a user is about to start working on a task.  flow_start_step records the start time for 
work on the task, which is used to distinguish betweeen time waiting for the task to get worked on and the time that it is actually 
being worked on. Flow_start_step does not perform any functional role in processing a flow instance, and is optional - but it 
just helps gather process performance statistics that distinguish queing time from processing time.  
Despite being optional, a well formed, best-practice application will use this call so that process statistics can be captured.
*/
  procedure flow_start_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  );

/*** Procedure flow_restart_step
flow_restart_step is procedure that is designed to be called by an administrator to restart a scriptTask or serviceTask that has 
failed due to an error.  The intended usage is that the adminstrator can fix the script or edit the process data that caused the 
task to fail, and then restart the task using this call.  
A comment can optionally be provided, which will be added to the task event log entry.
It should only be used on a subflow having a status of 'error'
*/
  procedure flow_restart_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null
  );

/***
Procedure flow_complete_step
Flow_complete_step is called when a process step has been completed.  Calling flow_complete_step moves the process 
forward to the next object(s) in the process diagram, in acordance with the behaviour rules for the objects.
History:  Flow_complete_step replaces the flow_next_step call in versions prior to V5.  Unlike flow_next_step, flow_complete_step 
is used to move a process forward, regardless of the object type. 
*/
   procedure flow_complete_step
  (
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  ); 

/*** 
Procedure flow_reschedulule_timer
flow_reschedule_timer can be called to change the next scheduled time of a timer on a running timer.
It can change the currently scheduled time to a future time, or can instruct the timer to fire immediately.
If the Timer event is a single event timer (timer types Date or Duration), it will change the time at which the event is 
scheduled to occur to the new time.
If the timer is a Cycle Timer, this changes the time that the next firoing is scheduled to occur.  If later cycles exist, the following cycle will 
be scheduled at the new firing time + the repeat interval.
To fire the timer immediately, set p_is_immediate = true.
To change the firing time to another future time, supply a new timestamp with time zone contaiing the new time.
A comment can be provided, which is passed to the log file for explanation of any rescheduling.
*/
procedure flow_reschedule_timer
(
    p_process_id    in flow_processes.prcs_id%type
  , p_subflow_id    in flow_subflows.sbfl_id%type
  , p_step_key      in flow_subflows.sbfl_step_key%type default null
  , p_is_immediate  in boolean default false
  , p_new_timestamp in flow_timers.timr_start_on%type default null
  , p_comment       in flow_instance_event_log.lgpr_comment%type default null

);


/***
Procedure flow_reset
flow_reset aborts all processing on a process instance, and returns it to the state when it was
initially created.  After a reset, you then need to call flow_start to re-start the process instance.
flow_reset is only provided for debug and test usage; for production usage, always delete and start a new process
After a reset: 
- process instance status is reset to created.  
- process instance progress is deleted.
- process variables are LEFT untouched.
This is not meant for use in Production Systems.
*/
  procedure flow_reset
  ( 
    p_process_id  in flow_processes.prcs_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  /***
Procedure flow_terminate
flow_delete ends all processing of a process instance, and has the same effect as processing a Terminating End Event inside a Flow Diagram.
It ends all subflows, but retains the process definition and the subflow logs for the process.
*/
  procedure flow_terminate
  ( 
    p_process_id  in flow_processes.prcs_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null
  );

  /***
Procedure flow_delete
flow_delete ends all processing of a process instance.  It removes all subflows and subflow logs of the process.
*/
  procedure flow_delete
  ( 
    p_process_id  in flow_processes.prcs_id%type
  , p_comment     in flow_instance_event_log.lgpr_comment%type default null    
  );

 /********************************************************************************
**
**        APPLICATION HELPERS (URL Builder, etc.)
**
********************************************************************************/ 

  -- get_current_usertask_url
  -- used to build a URL for the current task on the specified subflow
  -- this is used in, for example, task inboxes to create link to the APEX page that 
  -- should be called by the user to perform the current userTask object
  function get_current_usertask_url
  (
    p_process_id in flow_processes.prcs_id%type
  , p_subflow_id in flow_subflows.sbfl_id%type
  , p_step_key   in flow_subflows.sbfl_step_key%type default null
  ) return varchar2;

  -- message
  -- returns a Flows for APEX error message with p0...p9 substitutions in p_lang
  function message
  ( p_message_key     in varchar2 
  , p_lang            in varchar2 default 'en'
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  ) return varchar2;

end flow_api_pkg;
/
