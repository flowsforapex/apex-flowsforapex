/*
Upgrades the APEX version enviroment and recompiles all PL/SQL packages
Run this after an APEX version upgrade
*/

PROMPT >> Update Flows for APEX after an APEX Version Change
PROMPT >> =================
PROMPT >> Upgrading APEX Version Info
declare
  lf  varchar2(1) := chr(10);
  vr  number;
  v   number;
  r   number;
  blk varchar(4000);

  procedure add_line ( p_line in varchar2 ) is
  begin
    blk := blk || case when blk is not null then lf end || p_line;
  end;

  function add_bool ( p_current_version in number, p_a_version in number ) return varchar2 is
  begin
    return case when p_current_version <= p_a_version then 'true' else 'false' end;
  end; 
begin
  select to_number(substr(version_no, 1, instr(version_no, '.', 1, 2) - 1), '99D9','NLS_NUMERIC_CHARACTERS=''.,''')
       , to_number(substr(version_no, 1, instr(version_no, '.', 1, 1) - 1))
       , to_number(substr(version_no, instr(version_no, '.', 1, 1) + 1, instr(version_no, '.', 1, 1) - 2))
    into vr
       , v
       , r
    from apex_release
  ;

  add_line( 'create or replace package flow_apex_env authid definer is' );
  add_line( '  version     constant pls_integer := ' || v || ';' );
  add_line( '  release     constant pls_integer := ' || r || ';' );
  add_line( '  ee          constant boolean := false;');
   
  for yr in 19..v+4 loop
    add_line('  ver_le_' || yr || '   constant boolean     := ' || add_bool(trunc(vr), yr    ) || ';');
    add_line('  ver_le_' || yr || '_1 constant boolean     := ' || add_bool(vr       , yr +.1) || ';');
    add_line('  ver_le_' || yr || '_2 constant boolean     := ' || add_bool(vr       , yr +.2) || ';');
  end loop;
   
  add_line('end;');
   
  execute immediate blk;
end;
/

PROMPT >> Recompiling Package Specifications
PROMPT >>
PROMPT >> Engine
alter package flow_apex_env compile specification;
alter package flow_types_pkg compile specification;
alter package flow_constants_pkg compile specification;
alter package flow_migrate_xml_pkg compile specification;
alter package flow_parser_util compile specification;
alter package flow_bpmn_parser_pkg compile specification;
alter package flow_message_flow compile specification;
alter package flow_message_util compile specification;
alter package flow_message_util_ee compile specification;
alter package flow_api_pkg compile specification;
alter package flow_engine_util compile specification;
alter package flow_gateways compile specification;
alter package flow_boundary_events compile specification;
alter package flow_tasks compile specification;
alter package flow_services compile specification;
alter package flow_timers_pkg compile specification;
alter package flow_instances compile specification;
alter package flow_iteration compile specification;
alter package flow_rewind compile specification;
alter package flow_engine compile specification;
alter package flow_settings compile specification;
alter package flow_reservations compile specification;
alter package flow_proc_vars_int compile specification;
alter package flow_db_exec compile specification;
alter package flow_process_vars compile specification;
alter package flow_expressions compile specification;
alter package flow_usertask_pkg compile specification;
alter package flow_plsql_runner_pkg compile specification;
alter package flow_apex_session compile specification;
alter package flow_subprocesses compile specification;
alter package flow_call_activities compile specification;
alter package flow_logging compile specification;
alter package flow_globals compile specification;
alter package flow_errors compile specification;
alter package flow_diagram compile specification;
alter package flow_log_admin compile specification;
alter package flow_admin_api compile specification;
alter package flow_statistics compile specification;
alter package flow_ai_prompt_ee compile specification;
alter package flow_instances_util_ee compile specification;

PROMPT >>
PROMPT >> Recompile REST API Support
alter package flow_rest_constants compile specification;
alter package flow_rest compile specification;
alter package flow_rest_auth compile specification;
alter package flow_rest_logging compile specification;
alter package flow_rest_response compile specification;
alter package flow_rest_errors compile specification;
alter package flow_rest_api_v1 compile specification;
alter package flow_rest_install compile specification;


PROMPT >> Recompile Package Bodies
PROMPT >>
PROMPT >> Engine
alter package flow_proc_vars_int compile body;
alter package flow_process_vars compile body;
alter package flow_expressions compile body;
alter package flow_settings compile body;
alter package flow_db_exec compile body;
alter package flow_message_flow compile body;
alter package flow_message_util compile body;
alter package flow_reservations compile body;
alter package flow_engine_util compile body;
alter package flow_gateways compile body;
alter package flow_boundary_events compile body;
alter package flow_tasks compile body;
alter package flow_services compile body;
alter package flow_instances compile body;
alter package flow_engine compile body;
alter package flow_api_pkg compile body;
alter package flow_migrate_xml_pkg compile body;
alter package flow_parser_util compile body;
alter package flow_bpmn_parser_pkg compile body;
alter package flow_timers_pkg compile body;
alter package flow_usertask_pkg compile body;
alter package flow_plsql_runner_pkg compile body;
alter package flow_apex_session compile body;
alter package flow_subprocesses compile body;
alter package flow_call_activities compile body;
alter package flow_logging compile body;
alter package flow_globals compile body;
alter package flow_errors compile body;
alter package flow_diagram compile body;
alter package flow_log_admin compile body;
alter package flow_admin_api compile body;
alter package flow_statistics compile body;

PROMPT >>
PROMPT >> REST API Support

alter package flow_rest compile body;
alter package flow_rest_auth compile body;
alter package flow_rest_logging compile body;
alter package flow_rest_response compile body;
alter package flow_rest_errors compile body;
alter package flow_rest_api_v1 compile body;
alter package flow_rest_install compile body;


PROMPT >> recompiling Engine-App Objects
PROMPT >> =============================
PROMPT >> Global App Package Specifications
alter package flow_engine_app_api compile specification;
alter package flow_theme_api compile specification;

PROMPT >> Global App Package Body
alter package flow_engine_app_api compile body;
alter package flow_theme_api compile body;

PROMPT >> Process Plugin Objects
alter package flow_plugin_manage_instance compile package;
alter package flow_plugin_manage_instance_step compile package;
alter package flow_plugin_manage_instance_variables compile package;

PROMPT >> Modeler Plugin Objects
alter package flow_modeler compile package;

PROMPT >> Viewer Plugin Objects
alter package flow_viewer compile package;

PROMPT >> Flows for APEX Packages recompiled
PROMPT >> =============================
