create or replace package flow_api_pkg
   authid definer as
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

Types
=====

Type flows_api_pkg.task_list_item.

**/

type t_task_list_item is record 
   ( manager                 varchar2( 20)
   , app_id                  number
   , task_id                 number
   , task_def_id             number
   , task_def_name           varchar2( 255)
   , task_def_static_id      varchar2( 255)
   , subject                 varchar2(1000)
   , task_type               varchar2(  32)
   , details_app_id          number
   , details_app_name        varchar2( 255)
   , details_link_target     varchar2(4000)
   , due_on                  timestamp with time zone
   , due_in_hours            number
   , due_in                  varchar2( 255)
   , due_code                varchar2(  32)
   , priority                number(1)
   , priority_level          varchar2( 255)
   , initiator               varchar2( 255)
   , initiator_lower         varchar2( 255)
   , actual_owner            varchar2( 255)
   , actual_owner_lower      varchar2( 255)
   , potential_owners        varchar2(4000)
   , potential_groups        varchar2(4000)
   , excluded_owners         varchar2(4000)
   , state_code              varchar2(  32)
   , state                   varchar2( 255)
   , is_completed            varchar2(   1)
   , outcome_code            varchar2(  32)
   , outcome                 varchar2( 255)
   , badge_css_classes       varchar2( 255)
   , badge_text              varchar2( 255)
   , created_ago_hours       number
   , created_ago             varchar2( 255)
   , created_by              varchar2( 255)
   , created_on              timestamp with time zone
   , last_updated_by         varchar2( 255)
   , last_updated_on         timestamp with time zone
   , process_id              number
   , subflow_id              number
   , step_key                varchar2(20)
   , current_obj             varchar2(50)
);

 type t_task_list_items is table of t_task_list_item;

/**
package
=======

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
- Set the Instance priority
- Set the Instance Due On timestamp.

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
   function flow_create (
      pi_dgrm_name in flow_diagrams.dgrm_name%type -- Name of the model to instanciate
,
      pi_dgrm_version in flow_diagrams.dgrm_version%type default null -- Version of the model to instanciate (optional)
,
      pi_prcs_name in flow_processes.prcs_name%type -- Name of the process instance to create
,
      pi_logging_level in flow_processes.prcs_logging_level%type default null -- Logging level for the process instance
   ) return flow_processes.prcs_id%type;
 /**
Function flow_create - Signature 1
This function creates a new process instance based on a diagram name and version (process specification)
If the version is not specified,
  first lookup is to use dgrm_status = 'released'
  second lookup is to use dgrm_version = '0' and dgrm_status = 'draft'
If nothing is found based on above rules an exception will be raised.  For accuracy, it is recommended that you specify a version or use the form of flow_create specifying dgrm_id directly.

The process instance is created with a logging level  that is the higher of the logging level of the diagram and the logging level specified in the call.  If the logging level is not specified, the logging level of the diagram is used.

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
   function flow_create (
      pi_dgrm_id in flow_diagrams.dgrm_id%type -- ID of the model to instanciate
,
      pi_prcs_name in flow_processes.prcs_name%type -- Name of the process instance to create
,
      pi_logging_level in flow_processes.prcs_logging_level%type default null -- Logging level for the process instance
   ) return flow_processes.prcs_id%type;
 /**
Function flow_create - Signature 2
This function creates a new process instance based on a diagram id (process specification) and returns the Process ID of the newly created process

The process instance is created with a logging level  that is the higher of the logging level of the diagram and the logging level specified in the call.  If the logging level is not specified, the logging level of the diagram is used.

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
   procedure flow_create (
      pi_dgrm_name in flow_diagrams.dgrm_name%type -- Name of the model to instanciate
,
      pi_dgrm_version in flow_diagrams.dgrm_version%type default null -- Version of the model to instanciate (optional)
,
      pi_prcs_name in flow_processes.prcs_name%type -- Name of the process instance to create
,
      pi_logging_level in flow_processes.prcs_logging_level%type default null -- Logging level for the process instance
   );
 /**
Procedure flow_create - Signature 1
Creates a new process instance based on a diagram name and version (process specification).

If the version is not specified:

  - first lookup is to use dgrm_status = ‘released’
  - second lookup is to use dgrm_version = ‘0’ and dgrm_status = ‘draft’

If nothing is found based on above rules an exception will be raised. For accuracy, it’s recommended that you specify a version or use the form of flow_create specifying dgrm_id directly.

The process instance is created with a logging level  that is the higher of the logging level of the diagram and the logging level specified in the call.  If the logging level is not specified, the logging level of the diagram is used.

EXAMPLE

This example will create a new process instance called “My Instance Name” based on the model “My Model” in version “0”.  Logging level will be set to 4.

```sql
begin
   flow_api_pkg.flow_create(
        pi_dgrm_name    => 'My Model'
      , pi_dgrm_version => '0'
      , pi_prcs_name    => 'My Instance Name'
      , pi_logging_level => 4 
   );
end;
```
**/
   procedure flow_create (
      pi_dgrm_id in flow_diagrams.dgrm_id%type -- ID of the model to instanciate
,
      pi_prcs_name in flow_processes.prcs_name%type -- Name of the process instance to create
,
      pi_logging_level in flow_processes.prcs_logging_level%type default null -- Logging level for the process instance
   );
 /**
Procedure flow_create - Signature 2

This procedure creates a new process instance based on a diagram id and version (process specification)

The process instance is created with a logging level  that is the higher of the logging level of the diagram and the logging level specified in the call.  If the logging level is not specified, the logging level of the diagram is used.

EXAMPLE

This example will create a new process instance called “My Instance Name” based on the model ID 1, and with full logging.

```sql
begin
   flow_api_pkg.flow_create(
         pi_dgrm_id      => 1
      , pi_prcs_name     => 'My Instance Name'
      , pi_logging_level => 8
   );
end;
```
**/
   procedure flow_start (
      p_process_id in flow_processes.prcs_id%type -- Process ID to start
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
   procedure flow_reset (
      p_process_id in flow_processes.prcs_id%type -- Process ID to reset
,
      p_comment in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs
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
   procedure flow_terminate (
      p_process_id in flow_processes.prcs_id%type -- Process ID to terminate
,
      p_comment in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs
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
   procedure flow_delete (
      p_process_id in flow_processes.prcs_id%type -- Process ID to delete
,
      p_comment in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs
   );
 /**
Procedure flow_delete
This procedure is used to remove an Instance from the system. All instances, subflows, and variables are deleted from the operational system. 
If event logging was enabled while the process was running, records in the event logs are maintained for auditting purposes.

EXAMPLE

This example will delete the process instance that have the ID 1.

```sql
begin
   flow_api_pkg.flow_delete(
        p_process_id => 1
      , p_comment    => 'Delete Process Instance using the PL/SQL API'
   );
end;
```
**/
   procedure flow_set_priority (
      p_process_id in flow_processes.prcs_id%type       -- Process ID to update,
,
      p_priority   in flow_processes.prcs_priority%type -- New Instance Priority ( values 1 (highest) to 5 (lowest).)
   );
 /**
Procedure flow_set_priority.
This procedure is used to update the priority of a process instance.  The initial process priority will be set from the process diagram definition, 
but this procedure can be used to reset the priority while the instance is running.  Values from 1 (highest priority) to 5 (lowest priority)

EXAMPLE

This example will update the process instance priority to 1 (most urgent) for process instance 345.

```sql
begin
   flow_api_pkg.flow_reset(
        p_process_id => 345
      , p_priority   => 1
   );
end;
```
**/
   procedure flow_set_due_on (
      p_process_id in flow_processes.prcs_id%type     -- Process ID to update
,
      p_due_on     in flow_processes.prcs_due_on%type -- New Instance Due On timestamp
   );
 /**
Procedure flow_set_due_on
This procedure is used to update the Due On timestamp of a process instance.  The initial process Due On date (actually a timestamp with time zone) will be set from the process diagram definition, 
but this procedure can be used to reset the Due On while the instance is running. Due On date values should be a Timestamp with Time Zone.

EXAMPLE

This example will update the process instance due_on timestamp to 31 Dec 2027 at 14:30 GMT for process instance 345.

```sql
begin
   flow_api_pkg.flow_reset(
        p_process_id => 345
      , p_due_on     => to_timestamp_tz ( '31-DEC-2027 14:30:00 GMT', 'DD-MON-YYYY HH24:MI:SS TZR')
   );
end;
```
**/
   procedure flow_start_step (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
   );
 /**
Procedure flow_start_step
This procedure is an optional command that can be used in applications to signal that a user is about to start working on a task. 
This is only used to differentiate ‘waiting’ time from ‘processing’ time in system logs to aid process management and statistics. 
A ‘good-practice’ app would issue this call when work is about to start on a task, for example, from a page loading process.

Use this in conjunction with `flow_pause_step` to indicate that the work is paused on a task.

flow_start_step requires event logging to be  running at the 'detailed` level or higher to be effective.

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
   procedure flow_pause_step (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
   );
 /**
Procedure flow_pause_step
This procedure is an optional command that can be used in conjunction with flow_start_step in applications to signal that a user has paused working on a task. 
This is only used to differentiate ‘waiting’ time from ‘processing’ time in system logs to aid process management and statistics. 
A ‘good-practice’ app would issue this call when work on a task is saved but the workflow task is not completed, for example, from a page save process that did not include a 'flow_complete_step'.

If flow_start_step has not been called, this procedure will have no effect.

'flow_pause_step' requires event logging to be running at the `detailed` level or higher to be effective.

EXAMPLE

This example will use this procedure to indicate that the work has paused on the task that have the subflow ID 3 in the process ID 1.

```sql
begin
   flow_api_pkg.flow_pause_step(
        p_process_id => 1
      , p_subflow_id => 3 
      , p_step_key   => 'NqOiEHUbAF'
   );
end;
```
**/
   procedure flow_reserve_step (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
,
      p_reservation in flow_subflows.sbfl_reservation%type -- Value of the reservation, typically the username
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
   procedure flow_release_step (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
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
   procedure flow_complete_step (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
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
   procedure flow_restart_step (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
,
      p_comment in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the instance event logs
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
   procedure flow_reschedule_timer (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
,
      p_is_immediate in boolean default false -- Causes the step to occur immediately
,
      p_new_timestamp in flow_timers.timr_start_on%type default null -- Causes the step to be rescheduled at the supplied timestamp
,
      p_comment in flow_instance_event_log.lgpr_comment%type default null -- Optional comment to be added to the event logs
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

  function get_current_tasks
  ( p_context    in varchar2 default flow_constants_pkg.gc_task_list_context_my_tasks
  , p_prcs_id    in flow_processes.prcs_id%type default null
  , p_user       in varchar2 default null
  , p_groups     in varchar2 default null
  )
  return t_task_list_items pipelined;
  /**
Function get_current_tasks
This function is a pipelined table function which is used to create the Flows for APEX task list.
Depending upon the value of p_context, the data returned by the function varies.

For p_context = 'MY_TASKS', the task list generated shows the current userTasks for the user.
For p_context = 'SINGLE_PROCESS', the task list generated shows all of current userTasks and Approval tasks for process instance p_prcs_id.   This is used by the Task Monitor of the Flows for APEX application.

  **/
   function get_current_usertask_url (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type default null -- Step Key
,
      p_scope in flow_subflows.sbfl_scope%type default 0 -- Scope
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
   function message (
      p_message_key in varchar2 -- Key of the message that shoud exists in the flow_messages table
,
      p_lang in varchar2 default 'en' -- Lang code to retrieve the message, default is “en”
,
      p0 in varchar2 default null -- Value for substitution: %0 in the message will be replaced by p0, %1 by p1, etc
,
      p1 in varchar2 default null,
      p2 in varchar2 default null,
      p3 in varchar2 default null,
      p4 in varchar2 default null,
      p5 in varchar2 default null,
      p6 in varchar2 default null,
      p7 in varchar2 default null,
      p8 in varchar2 default null,
      p9 in varchar2 default null
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
   procedure return_approval_result (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_apex_task_id in number -- APEX Task ID
,
      p_result in flow_process_variables.prov_var_vc2%type default null -- Approval Outcome
   );
 /**
return_approval_result Procedure (DEPRACATED - Use procedure return_task_state_outcome
A convenience procedure for returning an APEX Approval result into a Flows for APEX process when the task has ben completed or otherwise changd state.
This procedure checks the Task ID is valid, stores p_result into the return variable (as defined in the process diagram),
then performs a flow_complete_step to move to the next step.

This can be called from an APEX Human Task (Approval Task) Action step.  Note that you can also use the APEX Approval Return Result process plug-in to do this declaratively in your application.

EXAMPLE

This code could be defined in an APEX Approval Task Action definition when a task is `completed` (on approval and on rejection).  
In this example, we have an APEX Approval parameter PROCESS_ID which contains the Flows for APEX process ID.  The values for p_task_id and p_result are 

```sql
flow_api_pkg.return_approval_result ( p_process_id      => :PROCESS_ID,
                                      p_apex_task_id    => :APEX$TASK_ID,
                                      p_result          => :APEX$TASK_OUTCOME);
```
**/
   procedure return_task_state_outcome (
      p_process_id in flow_processes.prcs_id%type -- Process ID
,
      p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID
,
      p_step_key in flow_subflows.sbfl_step_key%type -- Step Key
,
      p_apex_task_id in number -- APEX Task ID
,
      p_state_code in apex_tasks.state_code%type  -- APEX Human Task State Code
,
      p_outcome in flow_process_variables.prov_var_vc2%type default null -- APEX Approval Task Outcome
   );
 /**
return_task_state_outcome Procedure 

From Flows for APEX 25.1.   Use this in preference to return_approval_result, which is now deprecated.

A convenience procedure for returning an APEX Human Task (Approval or Action Task) result and state into a Flows for APEX process when the task has ben completed or otherwise changd state.
This procedure checks the Task ID is valid, stores p_result into the return variable (as defined in the process diagram),
then performs a flow_complete_step to move to the next step.

This can be called from an APEX Human Task (Approval or Action Task) Action step.  Note that you can also use the APEX Human Task Return State and Outcome process plug-in to do this declaratively in your application.

EXAMPLE

This code could be defined in an APEX Approval Task Action definition when a task is `completed` (on approval and on rejection).  
In this example, we have an APEX Approval parameter PROCESS_ID which contains the Flows for APEX process ID.  The values for p_task_id and p_result are 

```sql
flow_api_pkg.return_task_state_outcome ( p_process_id      => :PROCESS_ID,
                                         p_apex_task_id    => :APEX$TASK_ID,
                                         p_outcome         => :APEX$TASK_OUTCOME,
                                         p_state_code      => :APEX$TASK_STATE);
```
**/

   function task_potential_owners 
   ( p_process_id in flow_processes.prcs_id%type -- Process ID
   , p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID   
   , p_step_key in flow_subflows.sbfl_step_key%type -- Step Key
   , p_separator in varchar2 default ',' -- Separator for the list of potential owners
   ) return flow_process_variables.prov_var_vc2%type;

   /**
task_potential_owners Function
This function returns the list of potential owners for a task in a process instance.  The list is returned as a string, with the values separated by the p_separator value (default is comma).  
Intended usage is to allow an APEX Human Task to get the list of potential owners for a task from its Flows for APEX process instance.

Note that APEX Human Tasks require the list to be a comma separated list, so the default value of p_separator is a comma.  If you are using this function in a different context, you can specify a different separator.

EXAMPLE

This code could be defined in the Participants section of an APEX Human Task (Approval Task or Action Task) definition.  Having set Task Parameters for PROCESS_ID, SUBFLOW_ID and STEP_KEY, you can use this function to get the list of potential owners for the task.
Define the Participant to be:  Potential Owners
Define the type to be an:      Expression
Define the Expression to be:  
``` sql
flow_api_pkg.task_potential_owners ( p_process_id => :PROCESS_ID,
                                         p_subflow_id => :SUBFLOW_ID,
                                         p_step_key   => :STEP_KEY)
```
**/

   function task_business_admins 
   ( p_process_id in flow_processes.prcs_id%type -- Process ID
   , p_subflow_id in flow_subflows.sbfl_id%type -- Subflow ID   
   , p_step_key in flow_subflows.sbfl_step_key%type -- Step Key
   , p_separator in varchar2 default ',' -- Separator for the list of potential owners
   ) return flow_process_variables.prov_var_vc2%type;
   /**
task_business_admins Function
This function returns the list of business admins for a task in a process instance.  The list is returned as a string, with the values separated by the p_separator value (default is comma).   
Intended usage is to allow an APEX Human Task to get the list of business admins for a task from its Flows for APEX process instance.

Note that APEX Human Tasks require the list to be a comma separated list, so the default value of p_separator is a comma.  If you are using this function in a different context, you can specify a different separator.   

EXAMPLE
This code could be defined in the Participants section of an APEX Human Task (Approval Task or Action Task) definition.  Having set Task Parameters for PROCESS_ID, SUBFLOW_ID and STEP_KEY, you can use this function to get the list of business admins for the task.
Define the Participant to be:  Business Admins
Define the type to be an:      Expression    
Define the Expression to be:
``` sql
flow_api_pkg.task_business_admins      ( p_process_id => :PROCESS_ID,
                                         p_subflow_id => :SUBFLOW_ID,
                                         p_step_key   => :STEP_KEY)
```
**/


  procedure receive_message
  ( p_message_name  flow_message_subscriptions.msub_message_name%type
  , p_key_name      flow_message_subscriptions.msub_key_name%type
  , p_key_value     flow_message_subscriptions.msub_key_value%type
  , p_payload       clob default null
  );




  function intervalDStoSec (
    p_intervalDS  interval day to second
  ) return number;

    function intervalDStoHours (
    p_intervalDS  interval day to second
  ) return number;


-- Manually Step Timers forward

  procedure step_timers;


end flow_api_pkg;
/