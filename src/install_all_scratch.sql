whenever sqlerror exit rollback

set define '^'
set concat '.'
set serveroutput on

spool install_all_scratch.log

PROMPT >> Flows4APEX Installation
PROMPT >> =======================

PROMPT >> Checking for required privileges

declare
  l_actual_privs  apex_t_varchar2;
  l_needed_privs  apex_t_varchar2;
  l_missing_privs apex_t_varchar2;
begin
  -- set up needed privileges
  l_needed_privs :=
    apex_t_varchar2
    (
      'CREATE TABLE'
    , 'CREATE PROCEDURE'
    , 'CREATE SEQUENCE'
    , 'CREATE VIEW'
    , 'CREATE TYPE'
    , 'CREATE JOB'
    )
  ;

  -- Collect actual privileges
  select privilege
    bulk collect into l_actual_privs
    from user_sys_privs
  ;

  -- deduct actual from needed privileges
  l_missing_privs := l_needed_privs multiset except l_actual_privs;

  if l_missing_privs.count > 0 then
    dbms_output.put_line( 'Required Privileges Missing.' );
    for i in 1 .. l_missing_privs.count loop
      dbms_output.put_line( 'Missing: ' || l_missing_privs(i) );
    end loop;
    dbms_output.put_line( 'Please grant the missing privileges to the parsing schema.' );
    raise_application_error ( -20001, 'Required Privileges Missing.  Please check the log.');
  else
    dbms_output.put_line( 'All Required Privileges present.' );
  end if;
    
end;
/

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
