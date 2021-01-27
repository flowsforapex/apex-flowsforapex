set define '^'
set concat '.'

PROMPT >> Flows4APEX Installation
PROMPT >> =======================

PROMPT >> Please enter needed Variables

ACCEPT ws_name char default 'FLOWS4APEX' PROMPT 'Enter Workspace Name: [FLOWS4APEX]'
ACCEPT parsing_schema char default 'FLOWS4APEX' PROMPT 'Enter Parsing Schema: [FLOWS4APEX]'
ACCEPT app_alias char default 'FLOWS4APEX' PROMPT 'Enter Application Alias: [FLOWS4APEX]'
ACCEPT app_name char default 'Flows for APEX' PROMPT 'Enter Application Name: [Flows for APEX]'


@install_db_scratch.sql

PROMPT >> Application Installation
PROMPT >> ========================

PROMPT >> Set up environment
begin
  apex_application_install.set_workspace( p_workspace => '^ws_name.' );
  apex_application_install.generate_application_id;
  apex_application_install.generate_offset;
  apex_application_install.set_schema( p_schema => '^parsing_schema.' );
  apex_application_install.set_application_alias( p_application_alias => '^app_alias.' );
  apex_application_install.set_application_name( p_application_name => '^app_name.' );
end;
/

PROMPT >> Install Application
@apex/install.sql

PROMPT >> Finished Installation of Flows4APEX
PROMPT >> ====================================
