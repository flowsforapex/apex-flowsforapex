# The Flows for APEX Transactional Model

### Summary

🆕 Flows for APEX v21.1 introduces a transactional model which changes behaviour from earlier releases.

Prior to v21.1, the Flows for APEX engine would execute as many forward steps as it could, stopping when it reached either an aynchronous (waiting) task requiring user input, or hit an error.  All of the processing would be inside the user's current APEX transaction, which would be committed by APEX at the end of processing;  any error inside the process would cause an error message to be presented to the user, and the entire transaction would be rolled back.  When errors occurred in forward steps, this resulted, for example,  in a user working on process step A being unable to complete step A because of an error in the following step B or Step C, which was being run automatically as a scriptTask.

Flows for APEX v21.1 still continues forward until it reaches an asynchronous (user) task, or it his an error.  However, it introduces a transaction model where each process step is either committed when it is complete, or an error occurs -- it which case the process is put into `error` status and any work in the error step is rolled back.  If an error occurs, information about the error is available from the Flows for APEX application, and the step can be restarted after any underlying error has been resolved.

### BPMN Models and Transactional Control

A BPMN Process Model represents a process, which is made up of a sequence of process steps - each of which represents a task, a process routing gateway, or an event.  In general, each process step is a transaction which should either occur and be committed, or should be rolled back.

### Flows for APEX Transaction Model

Each step that proceses a bpmn Task (task, userTask, scriptTask, manualTask, serviceTask) can be broken into 3 phases:

1. Pre-Task Phase: prepares the new step for processing by:
   1. locking the subflow and required related objects.
   2. starting any boundary event timers.
   3. evaluating any 'before task' variable expression sets.
2. Main Task Processing Phase:
   1. For an asynchronous task requiring input from the user:
      1. The pre-Task Phase is `committed`, as the engine is now waiting for the user to perform his task.
      2. a URL containing the task is made available to the user via the task inbox view, and the models waits for the user to signal that they have completed the task by calling `flow_complete_step`.
   2. For synchronous tasks, such as scriptTasks or serviceTasks:
      1. these tasks are automatically run by the engine.  Note that the script should not normally contain its own `commit` statement.
      2. on completion of the script or service call, the engine itself generates a flow_complete_step` to move into the post-task phase.
3. Post-Task Phase: The engine completes the step and prepares to move forward to the next step by:
   1. locking the subflow and required related objects if they are not already locked.
   2. removing any task reservations.
   3. evaluating any 'after task' variable expression sets.
   4. getting information about the next step.
   5. updating the subflow status to show the step as complete.
   6. `commit` the step.
      
      If the step was completed successfully, the engine then moves into the Pre-Task Phase of the next step.

Other object types, such as gateways, sub processes, and events, cause their own step transactions to occur, as appropriate.  As examples:

- splitting parallel and inclusive gateways will perform one transaction on their incoming subflow, before stepping forward with separate transactions on each of their forward paths.
- a pair of link events performs one transaction covering the link throw and link catch events, combined.

### Transactions and Errors

Errors occur for a variety of reasons, that can include:

- incorrect BPMN models (reduce this by using the model checker / linter built into the Flow Modeler before saving your model)
- errors in scriptTask and serviceTask PL/SQL code
- errors in process variable expressions, defined in your model
- process variables containing unexpected data
- other unexpected data / data quality issues.

![subflowWithError](images/subflowInError.png "Showing Errors on a Subflow")

Flows for APEX handles errors appropriately to the step it is being used on.

- if an error occurs in the user's current step of a process, such that the user's current step cannot be completed, an error message is returned to the user as soon as it is detected, and the current step does not complete.  This would occur in the Post-Task Phase of the current step - i.e., in the first Post-Task Phase processed immediately after sending a `flow_complete_step` request.
- Once the user's current step has completed it's immediate Post-Task Phase and the current step has been committed to the database, any errors that occur will be in a Subsequent Step.  There might be additional Subsequent Steps if the subflow then processes synchronous tasks, such as scriptTasks or serviceTasks, or gateways or event handlers.
- Any errors that occur when a Subsequent Step is being processed will not return an error message to the user performing the Current Step.  Instead:
  - the error will be logged in the Instance Event Log.
  - the Subsequent Step will be rolled back to the beginning.
  - the subflow containing the error will be put into `error` status.
  - the Flow Instance containing the error will be put into `error` status.
  - after finding and fixing the source of the error, the Subsequent Step can be restarted from the Flows for APEX application, or from the API using the `flow_restart_step` call.

### Concurrency Control

In general, two (or more) users shouldn't be completing the same step of a process at the same time, as only one will be able to perform the task and move the model forwards.

Applications should handle collision control by using the Reservation mechanism before a user starts work on their task, signalling to other users that they are working on a task.


