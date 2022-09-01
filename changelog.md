# Flows for APEX - Changelog

## v22.2

- Adds BPMN Call Activities, allowing a process diagram to call another process diagram, passing and returning in/out variables.
- Adds scoping to process variables at diagram level to support call activities.
- Support for timer, escalation, and error boundary events on call activities.
- Adds support for Oracle APEX Approval Tasks when running with APEX v22.1 and above.  Approvals are called as a type of bpmn:userTask.
- Adds an Approval Result Return process plug-in for declarative configuration of Approval Tasks.
- Adds support for Gateway Routing Expressions, defined as part of each forward path from an Inclusive Gateway or Exclusive Gateway.
- Adds process variable bind syntax (:F4A$myvar) to bind varchar2, number, and date variables into Gateway Routing Expressions.
- Adds error detection to Inclusive and Exclusive Gateways when no Routing Variable is detected and Gateway Routing Expressions are present.
- Makes processVariable naming case-independant, so that myVar and MYVAR are the same variable.
- Creates an APEX session for non-APEX originated end points, ensuring that variable expressions, debugging, etc. work correctly from non-APEX API calls, after timers, from test engines, etc.
- Internally enhances storage of parsed BPMN object attributes using JSON structures in place of the flow_object_attributes table.
- Simplifies translation framework, allowing contributors to more easily supply translations to be incorporated into the product.
- Adds new translations to support Brazilian Portuguese (pt-BR), German (de), and Japanese (ja).
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
  - Manage Flow Instance Step, for controlling step statrt, reservation, release and completion.
  - Manage Flow Instance Variables, for transferring process variable content to and from APEX page items.
- Introduces Transaction Safety, making each process step a separate database transaction.
- Introduces new Instance Status of 'error' and 'terminated' to signal abnormal instance conditions.
- Introduces new Subflow status of 'error' signalling an abnormal condition.
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
- Modifies behaviour of flow_reset to delete all non-built-in process variables.
- Disables (non-operative) cycle timers from all timer event types.
- Allows Inclusive Gateways to be used as 'merge-then-resplit' gateways.
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

- Fixed several bugs occuring when all of the objects after an event object or a gateway are scriptTasks or serviceTasks, causing process not to be marked as Completed when finished.
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
- Support for Parallel Gateways (AND) and parallel flows, including process re-synchronisation
- Support for Inclusive Gateways (OR) and optional parallel flows, including process re-synchronisation
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
