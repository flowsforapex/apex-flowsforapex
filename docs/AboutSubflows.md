## Understanding the Subflow Architecture

### Introduction

Most real-world business processes contain some element of activity happening in parallel.  Subflows is the architecture that we use to create, manage, and complete parallel workflow branches.

Subflows were a major change introduced in Flows for APEX release 4.0.

This documentation explains the subflow architecture, its implementation, and how to interact with subflows to create low-code BPMN-based workflows using Flows for APEX.

### Flows,  Instances and Subflows

A *Flow* or Business Process is defined using a BPMN Diagram, which is identified by a Diagram Name and Diagram ID.  This defines the rules and sequence in which all of the tasks of business process should be executed.  For example, the following BPMN diagram below shows the business process definition for an Order Shipment process.

![Order Shipment Process](images/ShipmentProcess.png)

A *Flow Instance* is one occurrence of this Flow or business process.  Building on our Shipping example, this process model would be followed for all orders.  There would be one Flow Instance followed for each order processed.

Within that flow instance, there could be one or more *subflows* running at any time.  Each *subflow* is a branch of the process tree.  Continuing to build our example, the process instance starts with a single subflow running. Once it passes the first object, a parallel gateway, there would then be two subflows running - one with 'Decide if ...' activity as the next activity, and a second with 'Package Goods' as it's first activity.

As the flow instance continues, additional subflows can be added, multiple subflows can be synchronized and combined into one, and subflows can end.  Subflows are transient objects that are created as they are required, processed, and deleted once they are finished with.

As the process continues, and each object is completed, a record of object completion is kept in the FLOW_SUBFLOW_LOG table.  This is used to show step completion in the BPMN viewer plugin.  In addition, flow, instance, step, and variable events are logged into a series of event log tables for process monitoring and auditing purposes.

### Subflow Behavior

#### Process Instance Creation

When a Process Instance is created, a Process is created in the FLOW_PROCESSES table.  The process has a status of `created`.  At this point, it does not have any Subflows associated with it.

Instance creation is logged in the instance event log, if logging is enabled.

#### Process Instance Start

When the Process Instance is started, the Process Instance status is set to `started` and a subflow is created for the process.  This 'main' subflow has a current object of the Start Event.

All subflows are marked with where they started -- in this case, the opening StartEvent.

A subflow also has a *status* -- in this case, the status is `running`.

The Process Start automatically calls a `flow_complete_step` event on the 'main' subflow.  In our example this steps the 'main' subflow to the next object, an opening (splitting) parallel gateway.

Instance start is logged in the instance event log, if logging is enabled.

#### Standard Subflow Progression

Unless the subflow reaches a Gateway or an Event, the subflow progresses from object to object each time the user application signals that the current activity is completed by making a `flow_complete_step` call on the subflow.

As it progresses, the subflow's current object and last completed object are updated.

#### Action at an opening Exclusive Gateway

An opening Exclusive Gateway acts as a decision point, from which the process continues on just one forward path.

When a subflow reaches an Exclusive Gateway, it just continues along on the chosen path.  No additional subflows are created.  Routing instructions are provided for the gateway by setting a process variable named `<bpmn_id_of_gateway>:route` containing the bpmn_id of the required forward paths to be taken.  ([See Gateways And Parallel Flows](GatewaysAndParaaalelFlows.md) for more details and an example.)  If a Process Variable is not found with the routing instructions, the marked default path is taken.

#### Action at a Parallel Gateway

An opening Parallel Gateway acts as the launch point for multiple forward paths.  Unless each forward path continues to its own End Event, the parallel paths all meet at a closing, or synchronizing parallel gateway later in the process.

At an opening Parallel Gateway:

- the incoming subflow is suspended with a status of `split`.
- a new child subflow is created for each of the forward paths.  Each child subflow has a starting object set to the Gateway, last completed object set to the Gateway, and a `flow_complete_step` is performed to move it onto the first object in that subflow.

A merging Parallel Gateway has to synchronize the parallel child subflows, and once all of the parallel child subflows have completed (reached the Gateway), then causes the process to move forwards again on a single branch.  This then acts as a merge and a synchronization of the child subflows back into the parent.

At a merging Parallel Gateway:

- the first subflow to reach the gateway has its status changed from `running` to `waiting at gateway`.
- each subsequent subflow to reach the gateway likewise has its status changed from `running` to `waiting at gateway`.
- when all of the child subflows originating from the opening parallel gateway have a status of `waiting at gateway`, the closing parallel gateway can continue.  Each of the child subflows is completed and then deleted.  The original parent subflow, left behind at the starting parallel gateway with a status of `split`, has its status changed back to `running`, with its current object set to the merging gateway.  A `flow_complete_step` is then performed to move the parent subflow onto the next object in its sequence.

At a combined merging and reopening Parallel Gateway, all of the incoming child subflows are processed, as for a merging Parallel Gateway, above.  Once all child flows have reached the gateway, it then performs the activities of an Opening Gateway to create a new set of child subflows for the forward path.

#### Action at an Inclusive Gateway

An opening Inclusive Gateway acts as the launch point for one or more forward paths, depending upon meeting the conditions required for each path.  Unless each forward path continues to its own End Event, the parallel paths all meet at a closing, or synchronizing inclusive gateway later in the process.

The basic subflow mechanism is similar to that for a parallel gateway, described above.

Like a Parallel Gateway, the incoming subflow is paused with a status of `split`.

A child subflow is created for each forward path that is chosen.  Routes that do not meet the Inclusive Gateway criteria are not instantiated.  Routing instructions are provided for the gateway by setting a process variable named `<bpmn_id_of_gateway>:route` with a colon separated list of the bpmn_id's of the paths to be taken.  ([See Gateways And Parallel Flows](GatewaysAndParaaalelFlows.md) for more details and an example.)  If a Process Variable is not found with the  routing instructions, the marked default path is taken.

As each parallel child subflow reaches its merging / closing Inclusive Gateway object, they are set to status `waiting at gateway`.

When *all* of the chosen child subflows have reached the merging gateway, they are complete and the original parent subflow resumes its status of `running` and continues on the forward path.

At a combined merging and reopening Inclusive Gateway, all of the incoming child subflows are processed, as for a merging Inclusive Gateway, above.  Once all child flows have reached the gateway, it then performs the activities of an Opening Gateway to create a new set of child subflows for the forward path.

#### Action at a Sub Process

When a subflow reaches an object which is a Sub Process, the parent subflow changes its status to `in subprocess` and waits.

A new subflow is created, which runs as the sub process.  It starts at the sub process Start Event, and continues to execute its sequence flow in the sub process.  It has a status of `running`.

When the sub process flow reaches the End Event in the Sub Process:

- the sub process subflow completes.
- If there are no other subflows active in the sub process, the sub process is also then deemed to have completed, and control passes back to the parent subflow.
- the parent process task, which has been waiting, changes its status from `in subprocess` to `running`, and continues to operate at the parent process level by doing a `flow_complete_step` operation.

If a sub process itself contains a sub-process object, the same process is repeated for the sub sub process -- allowing sub processes to be nested indefinitely.

#### Action at a Timer

If a subflow reaches an object with an attached timer -- such as a Timer Start Event or a Timer Intermediate Catch Event -- the subflow is given a status of `waiting for timer` until the timer has expired and the process can continue, which it does with a status of `running`.

#### Action at an Event Based Gateway

An Event Based Gateway is a decision / gateway event where the single forward path is chosen based on which event occurs first.  Once an event occurs on one of the possible forward paths, all other paths are terminated and the flow continues forward on the one chosen path.

In our subflow architecture, the event starts operating as if it was a parallel gateway.  The incoming parent subflow is suspended with a status of `split`.  A child subflow is created for each of the possible forward paths.  Each child subflow will start with a first object, which is an event-based Intermediate Catch Event -- such as a Timer Intermediate Catch Event or (in a release after 5.0...), a Message Intermediate Catch Event or a Signal Intermediate Catch Event or a Condition based Intermediate Catch Event.

Each of these child subflows will start with an Intermediate Catch Event, and while these subflows are waiting for their respective events, they will have a status of `waiting for timer` or (later...) `waiting for message` or `waiting for signal` or `waiting for condition`, as appropriate.

Once one of these Intermediate Catch Events receives its event, the following occurs:

- the event based Gateway parent subflow, which was left waiting with a status of `split`, will be used for the forward flow.  Its current object is set to the Intermediate Catch Event which fired first.  Its status is reset to `running`.  A `flow_complete_step` is performed on that subflow to move the subflow on.
- all of the child subflows forward from the gateway are terminated and removed.

#### Action at an End Event

When a subflow reaches an End Event, it completes and is removed.

At the end of a sub process, if there are no other active subflows, the sub process completes and control is passed back to its parent subflow, which resumes and steps forward by issuing a `flow_complete_step` call to move to the next object.

At the end of a process, the engine checks whether there are any other subflows still active.  If not, the Process Instance has completed and the Process has its process status set to `completed`.

If the End Event is a Terminating End Event inside a SubProcess, all processing on the subflow and all other subflows inside the SubProcess, including any lower level SubProcesses, is terminated and the parent subflow progresses to the object after the SubProcess.

If the End Event is a Terminating End Event in the top level of a Flow, all processing of the Flow Instance stops.  Depending on the definition of the Terminating End Event in the BPMN model, you can control whether the Flow Instance is marked as `terminated` or `completed`.  If you use a Terminate End Event in your model to trap a process error, you can set the resulting Instance status as `terminated` so that an administrator is aware that the process instance did not run to its normal, successful solution.

Completion is logged in the instance event log, if logging is enabled.

#### Action at an Interrupting Boundary Event.

Boundary Events can be Interrupting or Non-Interrupting.

An Interrupting Boundary Event, when fired, becomes the new forward path for the subflow that it is placed on.  Processing on the original path of the subflow is interrupted immediately, the interrupting boundary event becomes the current event, and a `flow_step_complete` call is then made on the subflow to step the process onto the event following the boundary event.

#### Action at a Non-Interrupting Boundary Event.

Boundary Events can be Interrupting or Non-Interrupting.

A Non-Interrupting Boundary Event adds a new subflow starting at the triggering boundary event.  This subflow will operate in parallel with the triggering subflow, until it completes.

Timer Non-Interrupting Boundary Event.  When an object has an attached non-interrupting timer boundary event and that object becomes the current object, a new subflow is forked with the timer as its current object.  This happens as soon as the parent object becomes the current object; the new timer is started on the forked subflow.

- If the parent object completes before the timer fires, the timer and its subflow is deleted before the next object on the subflow becomes current.
- If the timer fires while the parent is still the current object on its subflow, the forked subflow proceeds to its next object.  If the parent then proceeds on its subflow, the forked boundary event subflow continues until it completes.

Non-Timer Non-Interrupting Boundary Events.  For example, a non-interrupting escalation boundary event.  These boundary events only fork off a new subflow if the relevant event event fires.  For example, if a sub process had an attached Non-Interrupting Escalation Boundary Event, the escalation subflow is only created if an escalation event is fired from inside the sub process, which is then caught by the matching boundary event.

#### Action when a ScriptTask or ServiceTask Fails (new in v21.1)

A ScriptTask or ServiceTask can fail due to an error in the script or encountering unexpected data.  The script can also request that processing stop by raising a predefined Flows for APEX exception.  When this occurs, the subflow will be set to a status of `error`, and the instance will also be set to status of `error`.

When an `error` occurs, an administrator can investigate the cause of the error by examining debug logs, the error codes, and process variable state.  Once the error has been fixed, the current ScriptTask or ServiceTask can be restarted from the Flow Monitor application or from the PL/SQL API using `flow_restart_step`.  This will reset the subflow status to `running`, set the instance status to `running` if there are no other error subflows, and attempt to re-run the script task or service task.

#### Action when a Process is Reset

***Note that resetting a process is not intended to be a common, day-to-day operation, and is included as an administrator function.  A process should be re-run by creating a new process instance in most normal operational cases.***

When a process is reset:

- any event handlers, such as timers, are terminated.
- any current subflows are removed.
- process progress is reset to the beginning, showing which objects were completed when the process ran.
- any process variables attached to the instance, except for built-ins like BUSINESS_REF, are deleted.
- **Note that this behavior has changed in v21 - previously all process variables were retained on a reset.**
- the process status is reset to `created`.
- the reset is logged in the instance event log, if logging is enabled.

#### Action when a Process is Terminated

When a process is terminated from the PL/SQL API, the effect is the same as if the Flow had processed a Terminate End Event at its current position:

- any event handlers, such as timers, are terminated and deleted.
- any current subflows are removed.
- process progress recorded in the subflow log (FLOWS_SUBFLOW_LOG) is retained.
- all associated process variables are retained.
- the process instance is set to `terminated`.
- termination is logged in the instance event log, if logging is enabled.

#### Action when a Process is Deleted

When a process is deleted:

- any event handlers, such as timers, are terminated and deleted.
- any current subflows are removed.
- process progress recorded in the subflow log (FLOWS_SUBFLOW_LOG) is removed.
- all associated process variables are deleted.
- the process instance record is removed.
- deletion is logged in the instance event log, if logging is enabled.

### On Performance, Auditing and Logging...

The Subflow architecture implemented from V4 onwards is designed to be performant and the working tables holding Process Instances, Subflows, Timers, and Subflow Progress have been designed with the intention that they should stay small, un-cluttered, and hopefully cached!

The Flow, Instance, Subflow and Variable event log tables are designed to hold longer term [event logging and audit trail](eventLoggingAndauditing.md) data for your system.  Depending upon the logging level set for your system, these logs can grow to become quite large, especially if process variable logging is enabled.

- The event logs will grow continuously, and are not deleted by the system when the subject instance is deleted.
- If you have audit requirements, you should develop a retention plan to archive and manage these logs to meet your requirements.
- Any log data can be deleted without damaging your system.  However, removing log data for Instances that are still active or completed (i.e., have not yet been deleted) will remove information about the instance from the engine application.
