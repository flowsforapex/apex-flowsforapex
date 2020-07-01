PROMPT >> Flows4APEX Installation
PROMPT >> =======================

PROMPT >> Please enter needed Variables

ACCEPT ws_name char default 'FLOWS4APEX' PROMPT 'Enter Workspace Name: '
ACCEPT parsing_schema char default 'FLOWS4APEX' PROMPT 'Enter Parsing Schema: '
ACCEPT app_alias char default 'F4A' PROMPT 'Enter Application Alias: '


@install_db.sql

PROMPT >> Application Installation
PROMPT >> ========================

PROMPT >> Set up environment
begin
  -- change this accordingly
  apex_application_install.set_workspace('&ws_name.');
  apex_application_install.generate_application_id;
  apex_application_install.generate_offset;
  apex_application_install.set_schema('&parsing_schema.');
  apex_application_install.set_application_alias('&app_alias.');
end;
/

PROMPT >> Install Application
@apex/install.sql

PROMPT >> Finished Installation of Flows4APEX
PROMPT >> ====================================
