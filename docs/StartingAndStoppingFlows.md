## Starting and Ending Processes

### General

All process diagrams must start with a Start Event and with one or more End Events.

![Start and End Events](images/startEndEvents.png "Start and End Events")

### Start Event

All processes must start with One (and only one) Start Event.

Good BPMN style would say that a Start Event should be named with a verb and a noun to describe the starting status.  Examples would be 'Receive Order' or 'Employee Resigns.'

### Start Event with Timer Event

A Start Event may contain an optional Timer Event.  This will delay the start ofthe process until a defined time, until a delay occurs (duration), or on a repetitive basis (cycle).

To define a Timer Start Event, first drag a Start Event onto your new process canvas.   Select the 'Change Type' spanner icon on the pop-up menu, and select Timer Start Event from the menu.  To then specify the Timer Configuration, use the Properties Panel on the right of the screen.  Under Timer, select the type of timer you want.  Under Timer Definition, specific the required time or interval, as below.

- Date:  specifies a date and time for the process to start, using an [ISO 8601 date/time string](https://en.wikipedia.org/wiki/ISO_8601#Combined_date_and_time_representations).
- Duration:  specifies a delay from the current time or the process to start, using an [ISO 8601 duration](https://en.wikipedia.com/wiki/ISO_8601#Durations) string.
- Cycle Timer: for an initial run and then repeats an definied intervals, using a [ISO 8601 Repeating Interval](https://en.wikipedia.org/wiki/ISO_8601#Repeating_intervals) specifier.  The alternate BPMN syntax for repeating intervals using CRON syntax is not currently supported.

![start Timer Definition](images/timerStartEvent.png "Start Timer Definition screen")

For more information on Timer Events, see the documentation Timer Events page.

### End Event

A process must be defined with at least one end event, which ends the process on that process branch.

A process can be defined with more than one end event if it has multiple branches.  Each branch shuld have an End Event.

![Multiple End Events](images/parallelSeparateEnds.png "Multiple End Events are OK")

When the final End Event is met for a Process, the Process Instance is complete.

### Terminate End Event

A Terminate End Event will terminate all current branches rnning in the process, and cause the Process to complete.

![Terminate End Event](images/terminateEnd.png "Terminate End Event")

Currently, Terminate End Events should only be placed in the top level process on any diagram, and not in any sub-process.
