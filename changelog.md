# Flows for APEX - Changelog

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
