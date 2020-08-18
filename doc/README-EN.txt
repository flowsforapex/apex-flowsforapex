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
- We recommend that you also install the demo app (same procedure as written above)

HISTORY
v4.0.0
- Support for sub processes (n levels deep)
- Support for parallel flows, including waiting to merge
- Enhanced Region Plugin "BPMN Viewer"

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
