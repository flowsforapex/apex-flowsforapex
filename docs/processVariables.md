## The Process Variable System

A business process instance typically runs over some extended period of time, and might require multiple users to perform many individual tasks, often across different application sessions.
The process typically requires its own variable system that persists over the life of the business process instance, and which is separate from the underlying objects that the process acts on.
Flows for APEX includes a flexible, persistant process variable system for you use across your process.

A process instance would typically need to know the identity of its subject - typically the primary key of the main object this process works on.

*For example, an order handling process instance would typically need to have a unique identifier / primary key of the order that it is working on.  Each instance of the process would typically be working on a separate order.*

All process variables are accessed through the setters and getters provided in the `flow_process_vars` package.

The process variable system allows you to create process variables identified by an arbitrary name and the process_ID of their process instance.

Each process variable can hold one value, which can be of type `varchar2`, `number`, `date`, or `clob`.

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
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_vc2%type;

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_num%type;

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_date%type;

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_clob%type;
```

#### Persistence

Process variables are persistent, and exist until the process is deleted with a `flow_delete` call.

#### Accessing Process Variables in userTask APEX pages and in scriptTasks

Process variables can be substituted into the APEX page call of a userTask.
[See doc](usingTasksToImplementYourProcess.md)

Process variables can be set or got inside a PL/SQL scriptTask
or serviceTask procedure using the setters and getters above.
[See doc](usingTasksToImplementYourProcess.md)

Process variables can be substituted into the definition string for Timers.  [See doc](usingTimerEvents.md)

Your application can set and get process variables by calling the appropriate setters and getters, as required.
