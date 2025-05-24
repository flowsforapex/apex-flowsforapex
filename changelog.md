# Flows for APEX - Change Log

## v25.1 Community Edition
- Adds an AI-generation Service Task, using the APEX_AI services.
- Adds Event-based logging of step events for audit trail and debugging.
- Adds a process instance logging level to allow event logging to be specified on a per-diagram and per-instance basis.
- Adds error boundary event on PL/SQL script tasks. Raise flow_globals.throw_bpmn_error_event exception in script to trigger.  flow_globals.request_stop_engine also added - functionality as for existing flow_plsql_runner_pkg.e_plsql_script_requested_stop (simpler naming).
- Enhancements to process instance naming.  prcs_name no longer mandatory on flow_api_pkg.flow_create. On creation, defaults to dgrm_name||sysdate.  Process name can be specified on bpmn:process object in diagram as substitutable string, executed during instance start (after variable expressions have run) if defined.
- Changes behavior for flow_api_pkg.start_step.  Previously start_step could be used once to optionally used to log the time that work started on a step.  Now you can start and pause (flow_api_pkg.pause_step) multiple times, with timings logged in the event log.
- Add support for start_step and pause_step calls in the manage-flow-instance-step plugin.
- Added flow_api_pkg.get_task_potential_owners and get_task_business_admins so that an APEX Human Task can set its potential owners and business admin from the workflow.
- Added new Task Action plugin return-task-state-outcome to return task state and task outcome from APEX Human Tasks.  Can be used on task completion, cancellation and task expiry.
- Added new cleanup routines to cancel any APEX Human Tasks left after a process instance is reset, terminated, deleted or the process flow cancels an active task.
- Step Key is now available for substitution or binding in most places, including variable expression.
- Fixed a bug where Scope previously couldn't be substituted.
- Added an APEX Component Group containing all of the components required in a Flows for APEX application.  Application items for PROCESS_ID, SUBFLOW_ID, STEP_KEY.  All plugins for use in customer applications.
- Scheduler objects for timers and APEX task cleanup are now created automatically.  Flows for APEX user is now assumed to have CREATE JOB privilege.
- Deprecates update, upload, upload and parse functions (all except parse) in bpmn_parser_pkg.   These have been available through flow_diagrams package since 23.1, and will be removed from bpmn_parser_pkg in a future release.
- Required APEX version increased to APEX v24.1, in line with Oracle's support policy for APEX.
- Privileges.  Flows for APEX user now requires CREATE JOB database system privilege.  
- 

## v24.1 Community Edition

- Adds JSON-typed process variables.
- Adds APEX Simple Form type of BPMN UserTask, allowing a user input form to be specified as a JSON document.
- Adds BPMN-Color support into the Modeler and Viewer, allowing shading of BPMN objects on a diagram.  Colors can optionally then also be shown in the process viewer.
- Enables Flows for APEX Enterprise Edition features for loops and iterations, BPMN Message Flow start, end and boundary events.
- Enhancements to BPMN Viewer to support visualization of nested iterations and loops.
- Enhancement to BPMN Viewer to allow task start from the viewer.
- Enhances flow_admin_api so that a diagram can be 'released' from the API.  This is useful for remote deployment of diagrams into production environments.
- Change internal storage of the APEX Task Id from a process variable to flow_subflows.sbfl_apex_task_id when APEX Human Tasks are used in UserTasks.
- Fixes a bug preventing rescheduling interruptible timers on subflows having a previous interrupting timer event.
- Adds a new example application that can be used as a process hub for end users to start new processes.
- Required APEX version increased to APEX v22.1

## v23.1

- Adds Due Dates and Priorities to bpmn:processes and to bpmn:userTasks, allowing declarative tracking of scheduling, priority and due dates.
- Adds Task Assignment to bpmn:userTasks, allowing easier declarative assignment of tasks to potential users and groups.
- Adds REST-enabling of the Flows for APEX API
- Major upgrade to the BPMN Modeler, with new, modern-looking properties panel.
- Enhanced support for modeling and viewing of collapsed subProcesses that can be easily expanded / collapsed.
- Adds support for BPMN Child Lane sets, allowing nesting of lane sets inside parent lanes.
- Adds explicit definition of relationship (or not) between Lanes and APEX roles/groups.
- Adds Timestamp with Time Zone datatype option for Process Variables.
- Adds binding of Process Variables into PL/SQL scripts, variable expressions, and element settings.
- Adds support for binding non-varchar2 typed (i.e., number, date, timestamp with time zone) process variables.
- Allows process variable substitutions to be used in all of the parameters of an APEX Page task.
- Adds 'is Startable' information to Processes, along with users and groups that can start a process.
- Allows BPMN diagrams to contain Groups and attached Annotations.
- Adds Automation to create daily, month-to-date, monthly, and quarterly statistics on process and step performance.
- Enhances Flows for APEX Application dashboard to display process and step performance, errors, and waiting time statistics.
- Adds auditing / logging of changes made to process diagrams, to complete the existing logging capabilities
- Adds the ability to create a summary document, as a JSON document, describing all actions taken to run a process instance.
- Adds an Automation creating archive summaries for all recently completed process instances into an archive table or OCI Object Storage.
- Adds an automation for automated purging of old logging data and statistics summaries.
- Allows an administrator to easily change the timer polling frequency, or temporarily enable / disable timers on non-production systems.
- Experimental Feature - Adds MessageFlow between sendTasks, receiveTasks, Intermediate Message Catch and Throw events. Phase 1 of more...
- Adds support for additional languages Italian, Simplified Chinese, Traditional Chinese, Korean.
- Required APEX version increased to APEX v20.2

## v22.2

- Adds BPMN Call Activities, allowing a process diagram to call another process diagram, passing and returning in/out variables.
- Adds scoping to process variables at diagram level to support call activities.
- Support for timer, escalation, and error boundary events on call activities.
- Adds support for Oracle APEX Approval Tasks when running with APEX v22.1 and above.  Approvals are called as a type of bpmn:userTask.
- Adds an Approval Result Return process plug-in for declarative configuration of Approval Tasks.
- Adds support for Gateway Routing Expressions, defined as part of each forward path from an Inclusive Gateway or Exclusive Gateway.
- Adds process variable bind syntax (:F4A$myvar) to bind varchar2, number, and date variables into Gateway Routing Expressions.
- Adds error detection to Inclusive and Exclusive Gateways when no Routing Variable is detected and Gateway Routing Expressions are present.
- Adds support for integration of Flows for APEX userTasks into the APEX v22.1+ Unified Task Inbox through custom Task Inbox views.   (Note that this functionality may change in upcoming APEX and Flows for APEX releases).
- Makes processVariable naming case-independent, so that myVar and MYVAR are the same variable.
- Creates an APEX session for non-APEX originated end points, ensuring that variable expressions, debugging, etc. work correctly from non-APEX API calls, after timers, from test engines, etc.
- Changes Lane processing from parse-time to step-run-time to facilitate call activities with or without lanes in any involved diagram.
- Internally enhances storage of parsed BPMN object attributes using JSON structures in place of the flow_object_attributes table.
- Simplifies translation framework, allowing contributors to more easily supply translations to be incorporated into the product.
- Adds new translations to support Brazilian Portuguese (pt-BR), German (de), Spanish (es), and Japanese (ja).
- Enhanced engine testing regime now introduced through utPLSQL regression test suites.
- Enhanced sample app "Expense Claims" to reflect features added to Flows for APEX v22.2.

## v22.1

- Adds repeating timers for non-interrupting boundary events - facilitating repeated reminders.
- Adds BPMN Business Rules Task type, which can accept user-defined PL/SQL script for linking to credit scoring, ML models or other automated decision tasks.
- Adds the ability to declaratively define sending an email from a Service Task
- Improves Timer Usability, by allowing timers to be specified using Oracle data and interval syntax in addition to ISO 8601 format.
- Improves multi-user integrity by adding a unique Step Key as part of the context for each process object.
- Improvements to the Flow Engine Application, with enhancements to the Flow Modeler:

  - Addition of the Monaco text editor for PL/SQL input to variable expressions and script code entry.
  - Use of APEX metadata in UI for specifying links to APEX pages and page items.
- Enhances the step operations plugin so that it can issue the flow_start_step command.
- Separates private and public calls and views used by the Flow Engine Application to ease reuse by customer apps.
- Added flow_globals.step_key and flow_globals.business_ref to get these values.
- Enhanced the sample app "Expense Claims" to reflect all features added to Flows for APEX 22.1.

## v21.1

- Introduces model-based declarative process variable expressions to set process variables before and after each step.
- Introduces 3 process plugins to ease application integration:

  - Manage Flow Instance, for controlling instance creation, starting, termination, reset and deletion.
  - Manage Flow Instance Step, for controlling step start, reservation, release and completion.
  - Manage Flow Instance Variables, for transferring process variable content to and from APEX page items.
- Introduces Transaction Safety, making each process step a separate database transaction.
- Introduces new Instance Status of 'error' and 'terminated' to signal abnormal instance conditions.
- Introduces new Subflow status of 'error' signaling an abnormal condition.
- Steps halted with error status can be re-started after an administrator fixes the problem.
- Introduces Monitoring and Auditing event logs of Instances, instance steps, and process variables
- Major upgrade of the Flow Engine Application, with enhancements to the modeler, viewer, and the app UI.

  - App: enhanced UI, including support for dark mode
  - App: Flow Monitor additionally supports side-by-side and multi-monitor support for administering larger systems.
  - Modeler: Properties panel can now be expanded by dragging
  - Modeler: Supports Cut, paste, zoom, keyboard shortcuts, and save of model components
  - Viewer: Clicking on an object opens pop-up containing definition, status and history.
  - Viewer: Allows export of process status diagrams.
- Addition of (optional) flow_start_step API call used to gather wait time vs. processing time statistics.
- Addition of flow_terminate API call to allow an administrator to stop an instance without having to delete it.
- Adds a built-in process variable BUSINESS_REF to link a flow instance to its underlying business object.
- Adds a configuration option to allow editing of models in a development environment without strict versioning enforcement.
- Makes process_id and subflow_id available to scripts and expressions through flow_globals.
- New sample app "Expense Claims".
- Modifies behavior of flow_reset to delete all non-built-in process variables.
- Disables (non-operative) cycle timers from all timer event types.
- Allows Inclusive Gateways to be used as 'merge-then-re-split' gateways.
- Allows process variables to be deleted.
- Introduces a flow_configuration table containing configuration parameters, initially for audit and language settings.
- Makes Engine App and engine error messages available in French language.
- Removes deprecated v4 API calls flow_next_step, flow_next_branch.
- Removes next_step_type from subflow view (non longer required since V4)

## v5.1.2

- Added business reference to views
  - flow_task_inbox_vw
  - flow_instances_vw
  - flow_instance_details_vw
- Introduced the demo app "Holiday Approval"
- The demo app "Order Shipment" is now deprecated

## v5.1.1

- Fixed several bugs occurring when all of the objects after an event object or a gateway are scriptTasks or serviceTasks, causing process not to be marked as Completed when finished.
- Fixed a bug causing the first task after an Interrupting Escalation Boundary Event to be skipped
- Fixed bug preventing flow monitor showing process progress in extremely large and repetitive models
- Fixed a problem with diagram export file names being too long
- Fixed serviceTask missing engine option for type "Run PL/SQL code"

## v5.1.0

- Introduces process diagram versioning and lifecycle management.
- Supports diagram import and export to XML or SQL files from the Flows for APEX application.
- Adds process categories to aid management of business processes.
- Enhanced user interface to support versioning and categories.
- Adds plain PL/SQL option for Script Tasks and Service Tasks to allow automated tasks to execute following a timer.
- Fixed bug preventing processes with nested open parallel gateways from completing.
- Fixed bug preventing long duration (months, years) timers from starting.
- Updated bpmn.io libraries.
- Added upgrade support to installation process.
- Hey, we even have our own logo now!

## v5.0.1

- Enables process variables to be used when specifying timer definitions
- Fixed bug that rises when reusing an ID across flows
- Added tutorial Flows for beginners in BPMN 2.0
- Added pagination on the flow control page
- Added a Getting Started page
- When processing timers errors that occur mark respective timer as broken but don't break job anymore
- Added "Add Gateway Route" to Flow Control for convenience when adding a process variable for a gateway

## v5.0.0

- Support for userTask objects that can now run an APEX page, defined inside modeler
- Support for scriptTask objects that can run a PL/SQL script, defined inside modeler
- Support for serviceTask objects that can run a PL/SQL script, defined inside modeler
- Support for Timer Boundary Events on Tasks, User Tasks, and Sub Processes (interrupting and non-interrupting)
- Support for Escalation Boundary Events on Sub Processes (interrupting and non-interrupting), along with Escalation Throw Events and Escalation End Events.
- Support for Error Boundary Events on Sub Processes, along with Error End Events.
- Support for Timer Events on startEvents, intermediate Catch Events, and Boundary Events.
- Support for Sub Processes with multiple end events.
- Support for Terminate End Event inside a Sub Process.
- Support for Link Events.
- New plugin for BPMN Modeler removes size limits for models and eases modeler integration.
- Model Linting in the Modeler
- Process Variable System providing persistent process variables.
- Task Inbox view
- Task Reservation System to support multi-user lanes.
- PL/SQL API Changes to support reservation.
- Processes now flow through automatically, using process variables to decide on gateway routing.
- Enhanced "Order Shipment" demo.
- Enhanced Flows for APEX Monitoring app.
- Enhanced documentation.
- Cleaner flow_api_pkg by separation of engine components into flow_engine

## v4.0.0

- New Subflow architecture to support Parallel Gateways, Sub Processes
- Support for subprocesses (n levels deep)
- Support for Parallel Gateways (AND) and parallel flows, including process re-synchronization
- Support for Inclusive Gateways (OR) and optional parallel flows, including process re-synchronization
- Support for IntermediateCatchEvents and eventBasedGateways
- Support for Terminate Stop Events in top level processes
- Process viewer now shows all present and completed steps, and expanded views of sub-processes
- Basic support for process lanes
- PL/SQL API changes to support subflow architecture
- New demo app "Order Shipment"
- New Documentation, now also hosted using [Github Pages](https://mt-ag.github.io/apex-flowsforapex/)
- Prototype Lab Features
  - Timed Start Events
  - Timer Intermediate Catch Events

## v3.0.0

- XML parsing now done using PL/SQL only
- Upgraded all bpmn.io libraries to 7.2.0
- Support for subprocesses (one level deep)
- Fixed minor bugs and adopted coding standards

## v2.0.0

- Reworked API package
- Added demo app
- Checked for coding standards

## v1.0.1

- Fixed a few bugs
- Annotations in Flows are now supported

## v1.0

- Initial Release
