--------------------------------------------------------------------------------
-- Name: Sample Approvals
-- Copyright (c)2012, 2022 Oracle and/or its affiliates.
-- Licensed under the Universal Permissive License v 1.0 as shown 
-- at https://oss.oracle.com/licenses/upl/
--------------------------------------------------------------------------------
prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_220100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.3'
,p_default_workspace_id=>5197447565017350539
,p_default_application_id=>130063
,p_default_id_offset=>5896986503359738946
,p_default_owner=>'WKSP_FLOWSINTEGRATION'
);
end;
/
 
prompt APPLICATION 130063 - Sample Approvals
--
-- Application Export:
--   Application:     130063
--   Name:            Sample Approvals
--   Date and Time:   16:42 Wednesday July 27, 2022
--   Exported By:     RALLEN2010@GMAIL.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 12299989234989334020
--   Manifest End
--   Version:         22.1.3
--   Instance ID:     63113759365424
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/process_type/com_flows4apex_return_to_flows_process
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(12299989234989334020)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.RETURN.TO.FLOWS.PROCESS'
,p_display_name=>'Flows for APEX - Return to Flows for APEX'
,p_supported_ui_types=>'DESKTOP'
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
'    l_attribute1 p_process.attribute_01%type := p_process.attribute_01;',
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
'    flow_api_pkg.return_approval_result ( p_process_id   => apex_util.get_session_state(l_attribute1),',
'                                          p_apex_task_id => apex_util.get_session_state(''APEX$TASK_ID''),',
'                                          p_result       => apex_util.get_session_state(''APEX$TASK_OUTCOME''));',
'',
'    return l_result;',
'end execution;    '))
,p_api_version=>2
,p_execution_function=>'execution'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/flowsforapex/apex-flowsforapex'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(12299989434380334022)
,p_plugin_id=>wwv_flow_imp.id(12299989234989334020)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Parameter Name containing Process ID'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'PROCESS_ID'
,p_is_translatable=>false
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
