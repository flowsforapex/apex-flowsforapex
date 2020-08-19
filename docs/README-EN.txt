***************************************************
*                                                 *
*            Flows for APEX v4.0.0                *
*          Installation instructions              *
*                                                 *
*                                                 *
***************************************************

PREREQUISITES
- Oracle Database 12c (all editions supported)
- Oracle Application Express 20.1 or higher
- Workspace with at least 10 MB space

INSTALLING THE APPLICATION
- Logon to the APEX workspace
- In the Application Builder, click on "Import"
- Import the application file using Unicode UTF-8 as file character set
- Let APEX choose an application ID for you (default)
- When asked to install the supporting objects, select "Yes"
- Optionally, you can now import the demo app in the same way

HISTORY
v4.0.0
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
- New Documentation, now also hosted on github pages at https://mt-ag.github.io/apex-flowsforapex/
- Prototype lab Feature
  - Timed Start Events
  - Timer Intermediate Catch Events

v3.0.0
- XML parsing now done using PL/SQL only
- Upgraded all bpmn.io libraries to 7.2.0
- Support for subprocesses (one level deep)
- Fixed minor bugs and adopted coding standards

v2.0.0
- Reworked API package
- Added demo app
- Checked for coding standards

v1.0.1
- Fixed a few bugs
- Annotations in Flows are now supported

v1.0
- Initial Release
