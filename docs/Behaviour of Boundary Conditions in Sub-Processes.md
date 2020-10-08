# Behavior of Boundary Conditions in Sub-Processes

This is where things get a little complex - but understanding and mastering this complexity will help you build powerful business processes without getting distracted by all of the painful details of handing process errors, escallation, and all of those other things that turn your simple process model into spagetti!

One of the good practice modeling concepts  in BPMN is to focus the model on the usual, happy-case path.  So your model should flow, left to right, along the happy case scenario.  The mess of

Boundary Conditions come in several flavours, to handle:

- process errors
- process escallation
- timeouts
- reminders
- interruptions

Boundary Conditions can be attached to tasks (and task like activities) and to sub-processes.  This setion covers behaviour of boundary conditions when applied to sub-processes only.

### Error EndEvents and Error Boundary Events.

![Error Boundary Events](images/ErrorBoundaryInSubProcess.png "Error Boundary Events")

This process has a SubProcess A.  In the sub-process, there is an exclusive gateway which tests for a process error.  If there is a *process error*, the process ends at an Error End Event.

Note that an error in this context is a *process error*, not a technical error in the application -- which would be handled by the application technology.

Behaviour is:

- An Error End always interupts processing in the sub-process.  Processing in the sub-process, and any of its running child sub-processes, are terminated.
- Terminated objects are not marked as having been completed.
- If the immediate parent process contains an Error Boundary Event, processing continues on that path in the immediate parent.
  - In the  example above, the path would be: Error A -> A error End -> Error Boundary Event -> Error Handler in Parent -> Error End.
- If the immediate parent process doesn't contain an Error Boundary Event, processing continues on the normal path in the immediate parent.
  - In the example above, if there is an errorEnd but NOT a error Boundary Event defined, the path would be: Error A -> A Error End -> B -> Normal End.

### Timer Boundary Events

![Timer Boundary Event Types](images/timerBoundaryEventTypes.png "Timer Boundary Event Types")

Timer Boundary Events can be *interrupting* or *non-interrupting*.

- An *interrupting timer boundary event* can be used to create a "timeout" after a specified time period or at a specified time.  When the timer fires at the specified time, processing of the sub-process and any child sub-processes is interrupted.  The parent subflow continues along the route forward from the interrupting timer boundary event.
- A *non-interrupting timer boundary event* can be used to create a reminder  after the process step has been started for a specified time period, or at a specified time.  When the timer fires, processing of the parent task continues.  In addition, a new subflow processes tasks on the reminder route.

A more complex example of how these can be used together is shown below.

![Timer Boundary Event Example](images/timerBoundaryConditionsExample.png "Timer Boundary Event Example")
In this example, sub-Process B has 3 boundaryEvents attached to it.  In addition to the Error Exit Event and corresponding Error Boundary Event for handling the error in the parent process, there are 2 timer booundary events.

The Reminder Timer is set to fire after 2 days.  This is a non-interrupting timer.  When it fires, a reminder is sent to the user on a new subflow.

The TimeOut Timer is  set to fire after 5 days.  This is an interrupting timer.  when it fires, and processing inside sub-process B is terminated.  The subflows that are running to process inside sub-process B are terminated.  The main subflow (which went from Start -> A -> B) proceeds to Timeout Handler.  C and D will not be executed.

