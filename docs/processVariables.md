## The Process Variable System

A business process instance typically runs for some extended period of time, and might require multiple users to perform many individual tasks, often across different application sessions.  This is typically longer than a single APEX session.

Executing a process typically requires the process to have its own variable system that allows the process to manage process state for the duration of the business process instance, and which is separate from the data stored in the underlying objects that the process acts on.

The Flows for APEX Process Variable system is a flexible, persistent process variable system that allows you to create and use variables for the lifetime of  your process instance.

All process variables are accessed through the setters and getters provided in the `flow_process_vars` package.

The process variable system allows you to create process variables identified by an arbitrary name and the process_ID of their process instance.

#### Data Types

Process variables are typed, and are based on Oracle datatypes.  Allowed types are

- `varchar2`
- `number`
- `date`
- `clob`

There is a function `flow_process_vars.get_var_type()` that returns the type of a process variable.

#### Built-In Variables

Flows for APEX instances contains one built-in process variable that is created for every Instance.

BUSINESS_REF:  A process instance typically needs to know the identity of its subject - typically the primary key of the main object this process works on. BUSINESS_REF should be used to contain the primary key of the subject data.

*For example, an order handling process instance would typically need to have a unique identifier / primary key of the order that it is working on.  Each instance of the process would typically be working on a separate order.*

### Setting and Getting Process Variables.

Process Variables can be accessed via the following interfaces:

- via the flow_process_vars PL/SQL API, which allows you to set, get, and delete a process variable.
- from an APEX application, using the Flows for APEX Process Variable Plugin (*manage-flow-instance-variables* ).
- from a BPMN model, where each process step can set variables using [declarative process variable expressions](variableExpressions.md) defined in the Flow diagram, before and after the process step.

#### The Process Variable PL/SQL API

A variable is created and set using the set_var procedures.

```sql
procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_vc2_value in flow_process_variables.prov_var_vc2%type
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_num_value in flow_process_variables.prov_var_num%type
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
);
```

Process variables are retrieved using the appropriate getter functions.

```sql
function get_var_vc2
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_vc2%type;

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_num%type;

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_date%type;

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_clob%type;
```

From v21.1, 'getters' return null if the variable is not set, unless the `pi_exception_on_null` parameter is set on the get call.

#### Persistence

Process variables are persistent for the duration of the flow instance, being stored inside the database until the process is deleted with a `flow_delete` call or a `flow_reset` (with the exception of built-in variables which are retained after a flow_reset).

#### Saving Process State - Page Items or Process Variables?

If a user is going from one process step to another, all inside APEX, you are able to transfer session state from one step to another using APEX Page Items.  Flows for APEX makes APEX Page Items available in ScriptTasks, for example, if you specify in your model the option to use the APEX Engine to execute your scriptTask if you choose to bind-in the APEX variables.

However, some of your process steps might not take place in an APEX environment, and so might not have access to an APEX session.  For example, any tasks that could follow a timer will be executed by the Oracle DBMS Scheduler -- outside of an APEX session.  In these steps, outside of an APEX session, APEX Page Items and other APEX are not available.  Instead, Process Variables should be used to transfer state from one flow step to another.

When building applications in APEX, you can use the Flows for APEX *manage flow instance variables plugin*

- before the application step (at page load processing) to transfer process state from Process Variables to APEX Page Items
- after the application step (at page processing) to transfer process state from APEX Page Items back into Process Variables.

#### Accessing Process Variables in userTask APEX pages and in scriptTasks

Process variables can be substituted into the APEX page call of a userTask.
[See doc](usingTasksToImplementYourProcess.md)

Process variables can be set or got inside a PL/SQL scriptTask
or serviceTask procedure using the setters and getters above.
[See doc](usingTasksToImplementYourProcess.md)

Process variables can be substituted into the definition string for Timers.  [See doc](specifyingTimers.md)

Your application can set and get process variables by calling the appropriate setters and getters, as required.
