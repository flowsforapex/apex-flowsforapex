create or replace package flow_api_pkg
  authid definer
as

/* Flows for APEX - flow_api_pkg.pks
--
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG. 2020-22
--
-- Created    20-Jun-2020   Moritz Klein, MT AG 
-- Modified   01-May-2022   Richard Allen, Oracle
*/

/**
FLOWS FOR APEX ENGINE API
=========================

The `flow_api_pkg` package gives you access to the Flows for APEX engine, and allows you to perform:
-  Flow Instance Operations, allowing you to Create, Start, Reset, Terminate and Delete a Process Instance.
-  Flow Step Operations, allowing you to Complete, Reserve, Release, or signal Starting a Process Step.

Flow Instance Operations:
-------------------------

These API functions allow you to control a process instance, i.e., one operation of the process defined in its process model / process diagram.  These commands allow you to:
- Create a process instance
- Start an instance
- Terminate an instance (stop all processing of an instance)
- Reset an instance back to its newly created state
- Delete an instance

Flow Step Operations:
---------------------

These API functions allow you to control individual steps in a process instance.  These commands allow you to:
- Complete a Step, and move to the next process step
- Reserve a Step 
- Release a reserved step
- record that you are Starting work on a Step
- Reschedule a step that is waiting on a timer

Application Helper Functions:
-----------------------------

These API functions are provided as Application Helper functions from the Flows for APEX API.   these commands allow you to:
- get the URL of the current userTask
- get an engine Error Message in a supported language
- return the result of an APEX Approval task to its Flows for APEX process instance upon completion

**/

function flow_create
( pi_dgrm_name    in flow_diagrams.dgrm_name%type                 -- Name of the model to instanciate
, pi_dgrm_version in flow_diagrams.dgrm_version%type default null -- Version of the model to instanciate (optional)
, pi_prcs_name    in flow_processes.prcs_name%type                -- Name of the process instance to create
) return flow_processes.prcs_id%type;
/**
Function flow_create - Signature 1
This function creates a new process instance based on a diagram name and version (process specification)
If the version is not specified,
  first lookup is to use dgrm_status = 'released'
  second lookup is to use dgrm_version = '0' and dgrm_status = 'draft'
If nothing is found based on above rules an exception will be raised.  For accuracy, it is recommended that you specify a version or use the form of flow_create specifying dgrm_id directly.

This function returns the Process ID of the newly created process.

EXAMPLE

This example will create a new process instance called “My Instance Name” based on the model “My Model” in version “0”.

```sql
declare
   l_prcs_id flow_processes.prcs_id%type;
begin
   l_prcs_id := flow_api_pkg.flow_create(
        pi_dgrm_name    => 'My Model'
      , pi_dgrm_version => '0'
      , pi_prcs_name    => 'My Instance Name'
   );
end;
```
**/

function flow_create
( pi_dgrm_id   in flow_diagrams.dgrm_id%type      -- ID of the model to instanciate
, pi_prcs_name in flow_processes.prcs_name%type   -- Name of the process instance to create
) return flow_processes.prcs_id%type;
/**
Function flow_create - Signature 2
This function creates a new process instance based on a diagram id (process specification) and returns the Process ID of the newly created process

EXAMPLE

This example will create a new process instance called “My Instance Name” based on the model ID 1.

```sql
declare
   l_prcs_id flow_processes.prcs_id%type;
begin
   l_prcs_id := flow_api_pkg.flow_create (
        pi_dgrm_id    => 1
      , pi_prcs_name    => 'My Instance Name'
   );
end;
```
**/


procedure flow_create
( pi_dgrm_name    in flow_diagrams.dgrm_name%type                 -- Name of the model to instanciate
, pi_dgrm_version in flow_diagrams.dgrm_version%type default null -- Version of the model to instanciate (optional)
, pi_prcs_name    in flow_processes.prcs_name%type                -- Name of the process instance to create
);
/**
Procedure flow_create - Signature 1
Creates a new process instance based on a diagram name and version (process specification).

If the version is not specified:

  - first lookup is to use dgrm_status = ‘released’
  - second lookup is to use dgrm_version = ‘0’ and dgrm_status = ‘draft’

If nothing is found based on above rules an exception will be raised. For accuracy, it’s recommended that you specify a version or use the form of flow_create specifying dgrm_id directly.

EXAMPLE

This example will create a new process instance called “My Instance Name” based on the model “My Model” in version “0”.

```sql
begin
   flow_api_pkg.flow_create(
        pi_dgrm_name    => 'My Model'
      , pi_dgrm_version => '0'
      , pi_prcs_name    => 'My Instance Name'
   );
end;
```
**/


procedure flow_create
( pi_dgrm_id   in flow_diagrams.dgrm_id%type      -- ID of the model to instanciate
, pi_prcs_name in flow_processes.prcs_name%type   -- Name of the process instance to create
);
/**
Procedure flow_create - Signature 2

This procedure creates a new process instance based on a diagram id and version (process specification)


EXAMPLE

This example will create a new process instance called “My Instance Name” based on the model ID 1.

```sql
begin
   flow_api_pkg.flow_create(
         pi_dgrm_id    => 1
      , pi_prcs_name    => 'My Instance Name'
   );
end;
```
**/

procedure flow_start
( p_process_id in flow_processes.prcs_id%type -- Process ID to start
);
/**
Procedure flow_start

This procedure is use to start a process that was previously created by flow_create. It will will find the none Start event in the Flow diagram, and step the instance forward from the Start event.


EXAMPLE

This example will create a new process instance called “My Instance Name” based on the model “My Model” in version “0” and start it.

```sql
declare
   l_prcs_id flow_processes.prcs_id%type;
begin
   l_prcs_id := flow_api_pkg.flow_create(
        pi_dgrm_name    => 'My Model'
      , pi_dgrm_version => '0'
      , pi_prcs_name    => 'My Instance Name'
   );

   flow_api_pkg.flow_start(
      p_process_id => l_prcs_id
   );
end;
```
**/


procedure flow_reset
( p_process_id  in flow_processes.prcs_id%type                            -- Process ID to reset
, p_comment     in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs
);
/**
Procedure flow_reset
This procedure is used, typically during model development and testing only, to reset an existing Instance to the state it would be at after it was created, but not yet started. 
All Process Variables, except built-ins, are deleted. **This is not meant for use in Production Systems.**

EXAMPLE

This example will reset the process instance that have the ID 1.

```sql
begin
   flow_api_pkg.flow_reset(
        p_process_id   => 1
      , p_comment      => 'Reset Process Instance using the PL/SQL API'
   );
end;
```
**/

procedure flow_terminate
( p_process_id  in flow_processes.prcs_id%type                            -- Process ID to terminate
, p_comment     in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs
);
/**
Procedure flow_terminate
This procedure is used, typically by an administrator, to permanently stop processing of the Instance (which will be lefty in a status of terminated).

EXAMPLE

This example will terminate the process instance that have the ID 1.

```sql
begin
   flow_api_pkg.flow_terminate(
        p_process_id    => 1
      , p_comment => 'Process Instance Terminated using the PL/SQL API'
   );
end;
```
**/

procedure flow_delete
( p_process_id  in flow_processes.prcs_id%type                            -- Process ID to delete
, p_comment     in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs   
);
/**
This procedure is used to remove an Instance from the system. All instances, subflows, and variables are deleted from the operational system. 
If event logging was enabled while the process was running, records in the event logs are maintained for auditting purposes.

EXAMPLE

This example will delete the process instance that have the ID 1.

```sql
begin
   flow_api_pkg.flow_reset(
        p_process_id => 1
      , p_comment    => 'Delete Process Instance using the PL/SQL API'
   );
end;
```
**/


procedure flow_start_step
( p_process_id    in flow_processes.prcs_id%type                    -- Process ID
, p_subflow_id    in flow_subflows.sbfl_id%type                     -- Subflow ID
, p_step_key      in flow_subflows.sbfl_step_key%type default null  -- Step Key
);
/**
Procedure flow_start_step
This procedure is an optional command that can be used in applications to signal that a user is about to start working on a task. 
This is only used to differentiate ‘waiting’ time from ‘processing’ time in system logs to aid process management and statistics. 
A ‘good-practice’ app would issue this call when work is about to start on a task, for example, from a page loading process.

EXAMPLE

This example will use this procedure to indicate that the work is started for the task that have the subflow ID 3 in the process ID 1.

```sql
begin
   flow_api_pkg.flow_start_step(
        p_process_id => 1
      , p_subflow_id => 3 
      , p_step_key   => 'NqOiEHUbAF'
   );
end;
```
**/

procedure flow_reserve_step
( p_process_id    in flow_processes.prcs_id%type                    -- Process ID
, p_subflow_id    in flow_subflows.sbfl_id%type                     -- Subflow ID
, p_step_key      in flow_subflows.sbfl_step_key%type default null  -- Step Key
, p_reservation   in flow_subflows.sbfl_reservation%type            -- Value of the reservation, typically the username
);  
/**
Procedure flow_reserve_step
This procedure is used to signal to other users that a user is going to handle this task (see the documentation on reservations).

EXAMPLE

This example will reserve the step in proces ID 1 and subflow ID 3 for the current user.

```sql
begin
   flow_api_pkg.flow_reserve_step(
        p_process_id  => 1
      , p_subflow_id  => 3 
      , p_step_key    => 'NqOiEHUbAF'
      , p_reservation => :APP_USER
   );
end;
```
**/


procedure flow_release_step
( p_process_id    in flow_processes.prcs_id%type                    -- Process ID
, p_subflow_id    in flow_subflows.sbfl_id%type                     -- Subflow ID
, p_step_key      in flow_subflows.sbfl_step_key%type default null  -- Step Key
); 
/**
Procedure flow_release_step
This procedure is used to remove a reservation (see the documentation on reservations).

EXAMPLE

This example will release the reservation for a step in proces ID 1 and subflow ID 3 for the current user.

```sql
begin
   flow_api_pkg.flow_release_step(
        p_process_id => 1
      , p_subflow_id => 3 
      , p_step_key   => 'NqOiEHUbAF'
   );
end;
```
**/


procedure flow_complete_step
( p_process_id    in flow_processes.prcs_id%type                    -- Process ID
, p_subflow_id    in flow_subflows.sbfl_id%type                     -- Subflow ID
, p_step_key      in flow_subflows.sbfl_step_key%type default null  -- Step Key
); 
/**
Procedure flow_complete_step
This procedure is used to tell the flow engine that the current step is complete, and to move the instance forward to the next step.

EXAMPLE

This example will complete a step in proces ID 1 and subflow ID 3 for the current user.

```sql
begin
   flow_api_pkg.flow_complete_step(
        p_process_id  => 1
      , p_subflow_id  => 3 
      , p_step_key    => 'NqOiEHUbAF'
   );
end;
```
**/

procedure flow_restart_step
( p_process_id    in flow_processes.prcs_id%type                            -- Process ID
, p_subflow_id    in flow_subflows.sbfl_id%type                             -- Subflow ID
, p_step_key      in flow_subflows.sbfl_step_key%type default null          -- Step Key
, p_comment       in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs
);
/** Procedure flow_restart_step
This procedure is designed to be called by an administrator to restart, for example, a scriptTask or serviceTask that has failed due to an error. 
The intended usage is that the adminstrator can fix the script or edit the process data that caused the task to fail, and then restart the task using this call.
A comment can optionally be provided, which will be added to the task event log entry. It should only be used on a subflow having a status of ‘error’

EXAMPLE

This example will restart a step in proces ID 1 and subflow ID 3.

```sql
begin
   flow_api_pkg.flow_restart_step(
        p_process_id  => 1
      , p_subflow_id  => 3
      , p_step_key    => 'NqOiEHUbAF' 
   );
end;
```
**/



procedure flow_reschedule_timer
( p_process_id    in flow_processes.prcs_id%type                            -- Process ID
, p_subflow_id    in flow_subflows.sbfl_id%type                             -- Subflow ID
, p_step_key      in flow_subflows.sbfl_step_key%type default null          -- Step Key
, p_is_immediate  in boolean default false                                  -- Causes the step to occur immediately
, p_new_timestamp in flow_timers.timr_start_on%type default null            -- Causes the step to be rescheduled at the supplied timestamp
, p_comment       in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the event logs
);
/**
Procedure flow_reschedulule_timer
flow_reschedule_timer can be called to change the next scheduled time of a timer on a running timer. 
It can change the currently scheduled time to a future time, or can instruct the timer to fire immediately. 
If the Timer event is a single event timer (timer types Date or Duration), it will change the time at which the event is scheduled to occur to the new time. 
If the timer is a Cycle Timer, this changes the time that the next firing is scheduled to occur.  If later cycles exist, the following cycle will be scheduled at the new firing time + the repeat interval. 
To fire the timer immediately, set p_is_immediate = true. It should then run on the next timer cycle, usually within a few seconds.
To change the firing time to another future time, supply a new timestamp with time zone contaiing the new time. 
A comment can be provided, which is passed to the log file for explanation of any rescheduling.

EXAMPLE

This example causes a waiting step in proces ID 1 and subflow ID 3 to occur immediately.

```sql
begin
   flow_api_pkg.flow_reschedule_timer(
        p_process_id   => 1
      , p_subflow_id   => 3 
      , p_step_key     => 'NqOiEHUbAF'
      , p_is_immediate => true
   );
end;
```

This example causes a waiting step in proces ID 1 and subflow ID 3 to be rescheduled for a future time (+2 days).

```sql
begin
   flow_api_pkg.flow_reschedule_timer(
        p_process_id    => 1
      , p_subflow_id    => 3 
      , p_step_key      => 'NqOiEHUbAF'
      , p_new_timestamp => systimestamp + 2
   );
end;
```
**/

function get_current_usertask_url
( p_process_id in flow_processes.prcs_id%type                   -- Process ID
, p_subflow_id in flow_subflows.sbfl_id%type                    -- Subflow ID
, p_step_key   in flow_subflows.sbfl_step_key%type default null -- Step Key
, p_scope      in flow_subflows.sbfl_scope%type default 0       -- Scope
) return varchar2;
/** get_current_usertask_url
This function returns the URL for the current task on the specified subflow.

EXAMPLE

This example show how to get the current task url for process ID 1 and subflow ID 3.

```sql
declare
   l_url varchar2(4000);
begin
   l_url := flow_api_pkg.get_current_usertask_url(
        p_process_id => 1
      , p_subflow_id => 3
      , p_step_key   => 'NqOiEHUbAF'
   );
end;
```
**/

function message
( p_message_key     in varchar2               -- Key of the message that shoud exists in the flow_messages table
, p_lang            in varchar2 default 'en'  -- Lang code to retrieve the message, default is “en”
, p0                in varchar2 default null  -- Value for substitution: %0 in the message will be replaced by p0, %1 by p1, etc
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
/** message function
This function returns a Flows for APEX error message with p0…p9 substitutions in p_lang.

EXAMPLE

This example show how to get the “gateway-no-route” message in french.

```sql
declare
   l_message varchar2(4000);
begin
   l_message := flow_api_pkg.message(
        p_message_key => 'gateway-no-route'
      , p_lang        => 'fr'
      , p0            => 'Variable Name'
   );
end;
```
**/

procedure return_approval_result
( p_process_id    in flow_processes.prcs_id%type                            -- Process ID
, p_apex_task_id  in number                                                 -- APEX Task ID
, p_result        in flow_process_variables.prov_var_vc2%type default null  -- Approval Result
);
/**
return_approval_result Procedure
A convenience procedure for returning an APEX Approval result into a Flows for APEX process when the task has ben completed.
This procedure checks the Task ID is valid, stores p_result into the return variable (as defined in the process diagram),
then performs a flow_complete_step to move to the next step.

This can be called from an APEX Approval Task Action step.  Note that you can also use the APEX Approval Return Result process plug-in to do this declaratively in your application.

EXAMPLE

This code could be defined in an APEX Approval Task Action definition when a task is `completed` (on approval and on rejection).  
In this example, we have an APEX Approval parameter PROCESS_ID which contains the Flows for APEX process ID.  The values for p_task_id and p_result are 

```sql
flow_api_pkg.return_approval_result ( p_process_id      => :PROCESS_ID,
                                      p_apex_task_id    => :APEX$TASK_ID,
                                      p_result          => :APEX$TASK_OUTCOME);
```
**/

end flow_api_pkg;
/
