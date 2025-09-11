set define '^'
set concat '.'

spool migrate_all_scratch.log

PROMPT >> Flows4APEX Installation
PROMPT >> =======================

PROMPT >> Please enter needed Variables

ACCEPT ws_name char default 'FLOWS4APEX' PROMPT 'Enter Workspace Name: [FLOWS4APEX]'
ACCEPT parsing_schema char default 'FLOWS4APEX' PROMPT 'Enter Parsing Schema: [FLOWS4APEX]'
ACCEPT app_alias char default 'FLOWS4APEX' PROMPT 'Enter Application Alias (Use current Alias to overwrite existing Application): [FLOWS4APEX]'
ACCEPT app_name char default 'Flows for APEX' PROMPT 'Enter Application Name: [Flows for APEX]'
ACCEPT from_version char PROMPT 'Enter current installed release (e.g., 21.1):'
ACCEPT to_version char PROMPT 'Enter next release to upgrade to (e.g., 22.1):'


@migrate_db.sql ^from_version. ^to_version.

PROMPT >> Application Installation
PROMPT >> ========================

PROMPT >> Set up environment
declare
  l_app_id number;
begin
  begin
    select application_id
      into l_app_id
      from apex_applications
     where alias = upper('^app_alias.')
     and workspace = upper('^ws_name')
    ;
  exception
    when no_data_found then
      l_app_id := null;
  end;

  apex_application_install.set_workspace( p_workspace => '^ws_name.' );

  if l_app_id is null then
    apex_application_install.generate_application_id;
    apex_application_install.generate_offset;
  else
    apex_application_install.set_application_id( p_application_id => l_app_id );
  end if;

  apex_application_install.set_schema( p_schema => '^parsing_schema.' );
  apex_application_install.set_application_alias( p_application_alias => '^app_alias.' );
  apex_application_install.set_application_name( p_application_name => '^app_name.' );
end;
/

PROMPT >> Install Application
@apex/install.sql

PROMPT >> Publish Translated Applications
declare
  c_main_app_id number := apex_application_install.get_application_id;
begin
  -- Next call might fail if we do not set NUMERIC_CHARACTERS
  execute immediate q'[alter session set NLS_NUMERIC_CHARACTERS='.,']';

  for rec in ( select translated_app_language as lang
                 from apex_application_trans_map
                where primary_application_id = c_main_app_id
             )
  loop
    apex_lang.publish_application
    (
      p_application_id => c_main_app_id,
      p_language => rec.lang 
    );
  end loop;
  commit;
end;
/

PROMPT >> Finished Installation of Flows4APEX
PROMPT >> ====================================

spool off
