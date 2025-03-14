prompt --application/shared_components/plugins/process_type/com_flows4apex_return_to_flows_process
begin
--   Manifest
--     PLUGIN: COM.FLOWS4APEX.RETURN.TO.FLOWS.PROCESS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(12315927534327459869)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.RETURN.TO.FLOWS.PROCESS'
,p_display_name=>'Flows for APEX - Return to Flows for APEX'
,p_supported_component_types=>'APEX_APPL_TASKDEF_ACTIONS'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('PROCESS TYPE','COM.FLOWS4APEX.RETURN.TO.FLOWS.PROCESS'),'')
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
,p_version_scn=>1760507033
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'24.1'
,p_about_url=>'https://github.com/flowsforapex/apex-flowsforapex'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(12315927733718459871)
,p_plugin_id=>wwv_flow_imp.id(12315927534327459869)
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
begin
wwv_flow_imp.component_end;
end;
/
