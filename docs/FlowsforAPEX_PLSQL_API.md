# The Flows for APEX PL/SQL API

### Introduction

Flow Instances are controlled in Flows for APEX through the PL/SQL API.

API Commands fall into the followig categories:

- Instance operations, to create, start, stop, reset, terminate and delete an instance
- Step operations, to conrol forward progress through an Instance
- Instance Variable (Process Variable) operations, to set, get, and delete Instance state.

For fuller instructions, see the commented PL/SQL package specification files.

### Instance Operations

Instance operations control the creation, operation, and ending of a Flow Instance.

Instance operations are all contained in the PL/SQL package `flow_api_pkg`.

This comprises:

- `flow_create` - to instantiate an instance of a Flow using a particular diagram.
- `flow_start` - to start an instance running.  This will find the none Start event in the Flow diagram, and step the instance forward from the Start event.
- `flow_terminate` - is used, typically by an adminstrator, to permanently stop processing of the Instance (which will be lefty in a status of `terminated`).
- `flow_reset` - is used, typically during model development and testing only, to reset an existing Instance to the state it would be at after it was created, but not yet started.  All Process Variables, except built-ins, are deleted.
- `flow_delete` - is used to remove an Instance from the system.  All instances, sybflows, and variables are deleted from the operational system.  If event logging was enabled while the process was running, records in the event logs are maintained for auditting purposes.

### Step Operations

Step operations are used to control the current step in the Flow Instance.

Step Operations are also contained in the PL/SQL package `flow_api_pkg`.

These comprise:

- `flow_start_step` - an optional command that can be used in applications to signal that a user is about to start working on a task.  This is only used to differentiate 'waiting' time from 'processing' time in process managent and statistics.  A 'good-practice' app would issue this call when work is about to start on a task.
- `flow_reserve_task` - is used to signal to other users that a user is going to handle this task (see the [documentation on reservations](reservations.md).
- `flow_release_step` - is used to remove a reservation (see [documentation on reservations](reservations.md).
- `flow_complete_step` - is used to tell the flow engine that the current step is complete, and to move the instance forward to the next step.

### Instance Variable (Process Variable) Operations

Process Variable operations are used to set, get, and delete Process Variables.

Process Variable operations are contained in the PL/SQL package `flow_process_vars`.

The process variable stystem and its PL/SQL API is [detailed in documentation here](ProcessVariables.md).

Certain Process Variables are pre-defined with the intention that every Instance is likely to use them, and so having a naming convention and a variable which is accessible both as a Flows for APEX Process Variable and also through pre-defined PL/SQL procedures.  Currently, there is one built-in process variable, `BUSINESS_REF`, which can also be accessed directly through the PL/SQL function `flow_process_vars.get_business_ref()`.
