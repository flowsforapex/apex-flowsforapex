### Using Tasks to Implement Your Process

In your BPMN process, it is the Task objects that actually do the work!  Starting with Flows for APEX V5.0, tasks can be modeled with specialty task objects that call  APEX pages, run scripts, and send messages.  This section describes those tasks and how to use and configure them.

![task types](images/taskTypes.png "Task types")

#### Supported Task Types

###### 1. bpmn:task - Task

This is the standard, generic, BPMN task.  It has no special behavior when a process is executed.

Typically these are used in the early stages of modeling a business process, but as a project moves towards creating an executable process model, tasks will get converted to more specific task types.

###### 2. bpmn:userTask - Calls an APEX Page or other URL.

userTask objects can be used for an online task to be performed by a user.  Currently, the following userTask types are enabled:

- call an APEX page.

APEX Page User Tasks:  userTasks are configured in the APEX tab of the Flows for APEX modeler properties panel with the information required to call an APEX page.  This configuration will be familiar to anyone who has configured APEX menus.

![configuration of userTasks](images/configureUserTask.png "configuring userTasks in the Flows for APEX modeler")

Page Items contains a comma-separated list of items to be set in the calling page.

Item Values contains a comma-separated list of values to be supplied.  The following items are available to be substituted into the Item Values string at runtime:

- Flows for APEX Process Variables.
  These are specified using the syntax `&F4A$<variable_name>.`
  &F4A$ is required to be upper case.
  Note the trailing period '.'.
- Flows for APEX Pseudo Variables.
  The current Process ID, Subflow ID and Step Key for the current task are also available as pseudo variables.
  These are specified as `&F4A$PROCESS_ID.` , `&F4A$SUBFLOW_ID.` and `&F4A$STEP_KEY.` respectively.

Note that you will need to pass the Process_ID, Subflow_ID, and Step Key to a page as its context.  The page will need these step the process forward when it is finished, using a flow_step_complete call.

###### 3. bpmn:scriptTask - Runs a PL/SQL script

scriptTask runs a user supplied PL/SQL function.  Good practice would be to have this call an existing procedure or package, which implements your application logic.

![configuration of scriptTasks](images/configureScriptTask.png "configuring scriptTasks in the Flows for APEX modeler")

Process variables and pseudo variables are available inside your PL/SQL procedure as follows:

- Flows for APEX Process Variables.
  Process variables can be retrieved and used inside your procedure, using the flow_process_vars setters and getters.
- Flows for APEX Pseudo Variables.
  Process ID, Subflow ID, and Step Key are available inside your procedure using following function calls

  ```sql
  flow_global.process_id
  flow_global.subflow_id
  flow_global.step_key
  ```

In earlier versions of Flows for APEX, prior to v21.1, you could have done this using the syntax flow_plsql_runner_pkg.g_current_prcs_id, which is now deprecated.

For example, where we have a process variable ordr_id that is used to link our business process to its subject order, we can retrieve the order ID inside our procedure using the following code snippet:

```sql
l_process_id := flow_globals.process_id;
l_order_id   := flow_process_vars.get_var_vc2
                ( pi_prcs_id => l_process_id, 
                  pi_var_name => 'ordr_id' );
```

APEX Page Item values are available to your procedure if you opt to bind them into your process in the modeler.  By default, they are not available.  Furthermore, using Page Items to pass values from one process step to another is not recommended, and from V22.1 is now deprecated.

Note that, depending upon your process, a scriptTask might not be executed from the context of an APEX page, and so APEX Page Items might not be available.  This would occur if a script is run (or re-run) later, after another user has performed part of the process, or if a task operates as a result of, for example, a timer firing.  Use of Page Items to pass values between steps also makes your process steps non-restartable in the event of an error.  For all these reasons, you should use Flows for APEX process variables as a variable system that is persistent for the life of your business process, rather than APEX page variables which only persist during a user session.

###### 4. bpmn:serviceTask - for running external services

Currently serviceTask can be used for the following services:

- Sending Mail defined declaratively in your process model. 🆕
- Sending Mail using an APEX_MAIL template. 🆕
- Running a PL/SQL script to run your own serviceTask.

###### 5. bpmn:manualTasks - for non-IT tasks

manualTasks do not currently have any special functionality and currently behave like a standard bpmn:task objects.

###### 6. bpmn:businessRuleTask - for automated decision making🆕

Currently businessRuleTask can be used for the following services:

- Running a PL/SQL script to run your own businessRuleTask. 🆕
