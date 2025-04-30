prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.10'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
end;
/
 
prompt APPLICATION 100 - Flows for APEX
--
-- Application Export:
--   Application:     100
--   Name:            Flows for APEX
--   Date and Time:   08:33 Wednesday April 30, 2025
--   Exported By:     RALLEN2010@GMAIL.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 5348613982934
--   Manifest End
--   Version:         24.1.10
--   Instance ID:     716670337569372
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/process_type/com_flows4apex_return_task_state_process
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(5348613982934)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.RETURN.TASK.STATE.PROCESS'
,p_display_name=>'Flows for APEX - Return APEX Human Task State and Outcome '
,p_supported_component_types=>'APEX_APPL_TASKDEF_ACTIONS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function execution',
'  ( p_process in apex_plugin.t_process',
'  , p_plugin  in apex_plugin.t_plugin ',
'  )',
'return apex_plugin.t_process_exec_result',
'as',
'    l_result     apex_plugin.t_process_exec_result;',
'',
'    --attributes',
'    l_attribute1 p_process.attribute_01%type  := p_process.attribute_01;',
'    l_attribute2 p_process.attribute_02%type  := p_process.attribute_02;',
'    l_attribute3 p_process.attribute_03%type  := p_process.attribute_03;',
'',
'begin',
'',
'    --debug',
'    if apex_application.g_debug ',
'    then',
'        apex_plugin_util.debug_process',
'          ( p_plugin         => p_plugin',
'          , p_process        => p_process',
'          );',
'    end if;',
'',
'    flow_api_pkg.return_task_state_outcome ( p_process_id   => apex_util.get_session_state(l_attribute1),',
'                                             p_subflow_id   => apex_util.get_session_state(l_attribute2),',
'                                             p_step_key     => apex_util.get_session_state(l_attribute3),',
'                                             p_apex_task_id => apex_util.get_session_state(''APEX$TASK_ID''),',
'                                             p_state_code   => apex_util.get_session_state(''APEX$TASK_STATE''),',
'                                             p_outcome      => apex_util.get_session_state(''APEX$TASK_OUTCOME''));',
'',
'    return l_result;',
'end execution;    '))
,p_api_version=>1
,p_execution_function=>'execution'
,p_substitute_attributes=>true
,p_version_scn=>2473266682
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'25.1'
,p_about_url=>'https://github.com/flowsforapex/apex-flowsforapex'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(5666423982932)
,p_plugin_id=>wwv_flow_imp.id(5348613982934)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Task Parameter containing Process ID'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'PROCESS_ID'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6198453820638)
,p_plugin_id=>wwv_flow_imp.id(5348613982934)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Task Parameter containing Subflow ID'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'SUBFLOW_ID'
,p_supported_component_types=>'APEX_APPL_TASKDEF_ACTIONS'
,p_is_translatable=>true
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(6505956816363)
,p_plugin_id=>wwv_flow_imp.id(5348613982934)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Task Parameter containing Step Key'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'STEP_KEY'
,p_supported_component_types=>'APEX_APPL_TASKDEF_ACTIONS'
,p_is_translatable=>false
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
