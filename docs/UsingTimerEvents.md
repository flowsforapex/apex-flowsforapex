## Timer Events

### General

![Supported Timer Events](images/supportedTimerEventsV5.png "Supported Timer Events")

Timers are currently supported on the following event objects:

- Start Event - Timer controls when the process starts.
- Intermediate Catch Event - the timer delays the process flow and controls when the process moves on to the next event.
- Timer Boundary Events - interrupting and non-interrupting timer boundary events can be set on tasks, userTask, and subProcess objects to implement reminder, timeout, and period closing processes.  Non-interrupting timer boundary events can fire repetitively to create repeating reminders. 🆕
- Event Based Gateway.  Timers can be used following an Event Based Gateway.  The Event Based Gateway choses which single path is taken, based on which Event occurs first.

When using timers, the properties viewer window is used to specify the timer type and details.[](#)

Initial setup of the Timer sub-system requires additional database privileges and configuration, so you might need to configure your timer sub-system and check that it is working correctly if you have not used timers before on your system.  Timers use the Oracle DBMS_SCHEDULER mechanism, and initial Flows for APEX set-up requires privilege to create a Job and a Process.  Operation of timers inside a business process does not require users to have these privileges.

From v22.1, timers can be specified in ISO 8601 format or in Oracle date and interval formats.  [Details of the syntax and substitutions allowed are shown here](specifyingTimers.md).🆕

## Timer Start Event

The Timer Start Event allows a process start to be delayed so that it occurs at a particular date & time, after a delay, or on a regular scheduled basis.

![Simple Timer Event Start](images/simpleStartTimer.png "Simple Timer Start Event")

If you want to start a regular, repeating start event -- for example, a process that runs every week to generate a sales report -- you should use APEX automations to create a regular event, and have the Automation start a process instance by calling `flow_api_pkg.create_process()`.

## Timer Intermediate Catch Event

A Timer Intermediate Catch Event will cause the sequence flow to wait until the timer fires, thus causing a delay to the sequence flow.

![Simple Timer Intermediate Catch Event](images/simpleTimerICEsequence.png "Simple Timer Intermediate Catch Event")

## Interrupting Timer Boundary Event

These can be set on a task, a userTask, a manualTask, or a subProcess.
When this object becomes the current task, a timer is started.  If the object is still the current object when the timer fires because it has not yet been completed, the underlying task is terminated, and the timer boundary event becomes the current object.  It performs a task_complete on the boundary event, moving the process on to the next step.
These are used to perform a business process timeout -- the usual forward path is suspended, and replaced by the timeout process path.  This can also be used to move a process on after a period closes or a review period has completed.
Only one interrupting timer can be set on each object.
In the example below, task C has an attached interrupting timer.  If task C is completed before the timer fires, the timer is removed.  If the timer fires before C has completed, processing switches from the normal path and instead continues with C Timeout as the next task.

![Timer Boundary Events](images/timerBoundaryEvents.png "Timer Boundary Events")

## Non Interrupting Timer Boundary Events

These can be set on a task, a userTask, a manualTask, or a subProcess.
When this object becomes the current task, a timer is started.  If the object is still the current object when the timer fires because it has not yet been completed, the underlying task continues, and a new subflow starts to operate in parallel to execute the 'reminder' path.  The new 'reminder path' performs a task_complete on the boundary event, moving the process on to the first task on that path.
Non-Interrupting Timer Boundary Events are used to implement reminder processes, or to start time-delayed parallel process paths.  If the underlying task completes before the timer fires, the 'reminder path' timer and associated subflow are deleted.
Non-Interupting Timer Boundary Events can be configured to fire repetitively, either indefinitely or limited to a specified maximum number of repetitions / cycles.
Multiple non-interrupting timer events can be set on a single task, userTask, manualTask, or subProcess.
In the example above, task A has one non-interrupting boundary timer attached to it.  If task A is not completed in the given 20 seconds, the timer fires - which starts task 'A Reminder' on a parallel subflow to the main subflow.

## Event Based Gateway with Timer

An Event Based Gateway is followed by one or more event-based Intermediate Catch Events.  When the process flow gets to the Event Based Gateway, all of its following catch events wait for their respective event to occur.  When the event occurs, the process proceeds along that path.   All other paths forward from the Event Based Gateway are terminated.

![Example Event Based Gateway sequence](images/timerEventBasedGatewaySequence.png "Example Event Based Gateway sequence")
In this example, the Event Based Gateway is followed by 2 forward paths.

- The  route towards Activity B has a duration timer that causes a 60 second delay.  This event will fire after 60 seconds.
- The route towards Activity C has a date timer that is scheduled to fire at 01:00:00 hours on 31st December, 2020.

Let's assume that the first event to fire is the 60 second timer on route B.  When this fires, the process will move forward to Activity B.  The timer waiting on the path to activity C will be terminated, and activity C will not occur.

## Setting Up the Timer System

Use of the Timer sub-system relies on the DBMS_SCHEDULER feature of the Oracle server.

The timer subsystem requires the parsing schema to have been granted the CREATE JOB system privilege.

In addition, the schema needs to set up a program and a job in the DBMS_SCHEDULER system.

For details, please see the setup file included with the Flows for APEX distribution at /setup/DBMS_SCHEDULER_setup_for_timers.sql.
