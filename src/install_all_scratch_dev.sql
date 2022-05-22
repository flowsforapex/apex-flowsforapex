set define '^'
set concat '.'

spool install_all_scratch_dev.log

PROMPT >> Flows4APEX Installation (Developer Edition)
PROMPT >> ===========================================

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
  apex_application_install.set_application_id( p_application_id => 100 );
  apex_application_install.set_schema( p_schema => '^parsing_schema.' );
  apex_application_install.set_application_alias( p_application_alias => '^app_alias.' );
  apex_application_install.set_application_name( p_application_name => '^app_name.' );
end;
/

PROMPT >> Install Application
@apex/install.sql

PROMPT >> Publish Translated Applications
begin
  -- Next call might fail if we do not set NUMERIC_CHARACTERS
  execute immediate q'[alter session set NLS_NUMERIC_CHARACTERS='.,']';
  apex_lang.publish_application(
    p_application_id => 100,
    p_language => 'fr' 
  );
  commit;
end;
/

PROMPT >> Finished Installation of Flows4APEX
PROMPT >> ====================================

spool off
