prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>101
,p_default_id_offset=>8300483976062845
,p_default_owner=>'FLOWS4APEX'
);
end;
/
 
prompt APPLICATION 101 - Holiday Approval (demo app to show how to integrate Flows for APEX)
--
-- Application Export:
--   Application:     101
--   Name:            Holiday Approval (demo app to show how to integrate Flows for APEX)
--   Date and Time:   11:32 Monday June 28, 2021
--   Exported By:     FLOWS4APEX
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 14100275316790089
--   Manifest End
--   Version:         20.1.0.00.13
--   Instance ID:     300193896399987
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/process_type/com_flows4apex_start_process
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(14100275316790089)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.START.PROCESS'
,p_display_name=>'Flows for APEX - Start Flow'
,p_supported_ui_types=>'DESKTOP'
,p_api_version=>2
,p_execution_function=>'flow_plugin_start.execution'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'Process used to Deleting a <i>Flows for APEX</i> Flow Instance Step.'
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/mt-ag/apex-flowsforapex'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(14100419050790106)
,p_plugin_id=>wwv_flow_api.id(14100275316790089)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Flow Instance info'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'item'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Define the way you want to retrieve the flow process instance Id you want to delete.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(14100867037790106)
,p_plugin_attribute_id=>wwv_flow_api.id(14100419050790106)
,p_display_sequence=>10
,p_display_value=>'In Page Items'
,p_return_value=>'item'
,p_help_text=>'Use this when the Flow Instance Process Id is stored in APEX Page Items.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(14101304183790107)
,p_plugin_attribute_id=>wwv_flow_api.id(14100419050790106)
,p_display_sequence=>20
,p_display_value=>'from SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this when the Flow Instance Process Id is to be returned by a SQL Query.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(14101842464790107)
,p_plugin_id=>wwv_flow_api.id(14100275316790089)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Process ID Page Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(14100419050790106)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>APEX Page Item that contains the Flow Instance process_id.</p>',
'',
'<p>This could typically be: </p>',
'<ul>',
'<li>An Application Item, often named PROCESS_ID.</li>',
'<li>A Global Page Item, for example P0_PROCESS_ID.</li>',
'<li>A Page Item on your page.</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(14102226355790107)
,p_plugin_id=>wwv_flow_api.id(14100275316790089)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>1
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(14100419050790106)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_help_text=>'<p>SQL Query which returns one row with one column containing the Flow Instance Process Id.</p>'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
