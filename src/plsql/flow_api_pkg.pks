create or replace package flow_api_pkg
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
    p_process_id in flow_processes.prcs_id%type
  );
  /***
Procedure flow_terminate
flow_delete ends all processing of a process instance, and has the same effect as processing a Terminating End Event inside a Flow Diagram.
It ends all subflows, but retains the process definition and the subflow logs for the process.
*/
  procedure flow_terminate
  ( 
    p_process_id in flow_processes.prcs_id%type
  );
  /***
Procedure flow_delete
flow_delete ends all processing of a process instance.  It removes all subflows and subflow logs of the process.
*/
  procedure flow_delete
  ( 
    p_process_id in flow_processes.prcs_id%type
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
  ) return varchar2;

end flow_api_pkg;
/
