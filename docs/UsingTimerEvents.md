## Timer Events

### General

![Supported Timer Events](images/supportedTimerEventsV5.png "Supported Timer Events")

Timers are currently supported on the following event objects:

- Start Event - Timer controls when the process starts.
- Intermediate Catch Event - the timer delays the process flow and controls when the process moves on to the next event.
- Timer Boundary Events - interrupting and non-interrupting timer boundary events can be set on tasks, userTask, and subProcess objects to implement reminder, timeout, and period closing processes.
- Event Based Gateway.  Timers can be used following an Event Based Gateway.  The Event Based Gateway choses which single path is taken, based on which Event occurs first.

When using timers, the properties viewer window is used to specify the timer type and details.[](#)

The Timer sub-system requires additional database privileges and configuration, so you might need to configure your timer sub-system and check that it is working correctly if you have not used timers before on your system.

## Timer Start Event

The Timer Start Event allows a process start to be delayed so that it occurs at a particular date & time, after a delay, or on a regular scheduled basis.

![Simple Timer Event Start](images/simpleStartTimer.png "Simple Timer Start Event")

## Timer Intermediate Catch Event

A Timer Intermediate Catch Event will cause the sequence flow to wait until the timer fires, thus causing a delay to the sequence flow.

![Simple Timer Intermediate Catch Event](images/simpleTimerICEsequence.png "Simple Timer Intermediate Catch Event")

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

## Timer Syntax

To define a Timer Event, first drag the Event onto your new process canvas.   Select the 'Change Type' spanner icon on the pop-up menu, and select Timer version of that from the menu.  To then specify the Timer Configuration, use the Properties Panel on the right of the screen.  Under Timer, select the type of timer you want.  Under Timer Definition, specific the required time or interval, as below.

- Date:  specifies a date and time for the process to start, using an [ISO 8601 date/time string](https://en.wikipedia.org/wiki/ISO_8601#Combined_date_and_time_representations).  For example:

  ```
  2007-04-05T14:30
  ```
- Duration:  specifies a delay from the current time or the process to start, using an [ISO 8601 duration](https://en.wikipedia.com/wiki/ISO_8601#Durations) string.  For example:

  ```
  P3Y6M4DT12H30M5S" represents a duration of "three years, six months, four days, twelve hours, thirty minutes, and five seconds".
  P3M represents 3 months.
  PT5M represents 5 minutes.
  PT30S represents 30 seconds.
  ```
- Cycle Timer: for an initial run and then repeats an definied intervals, using a [ISO 8601 Repeating Interval](https://en.wikipedia.org/wiki/ISO_8601#Repeating_intervals) specifier.  The alternate BPMN syntax for repeating intervals using CRON syntax is not currently supported.  For example:

  ```
  R5/P1Y2M10DT2H30M
  ```

![Timer Event Start](images/timerStartEvent.png "Timer Start Event")

## Substituting Process Variables into Timer Definitions

Starting in V5 (5.0.1), the timer definition defined in your process diagram can be a Flows for APEX process variable.  This provides considerable process flexibility, especially with Date type timers.

To specify a process variable in the BPMN Modeller - Properties Panel, you specify the variable with &F4A$ prefix and a period (.) suffix.  So the process variable

```
my_timer    could be specified as &F4A$my_timer.
```

For a Timer Definition Type 'Date', the process variable should be of type DATE.

For a Timer Definition Type of 'Duration' or 'Cycle', the process variable should be of type VARCHAR2.

![Using Process Variables in Timer Event](images/procVarsInTimerDef.png "Using Process Variables for Timer Event")
