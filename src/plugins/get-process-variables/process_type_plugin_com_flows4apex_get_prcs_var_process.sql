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
--   Date and Time:   12:27 Wednesday June 23, 2021
--   Exported By:     FLOWS4APEX
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 8701480126067856
--   Manifest End
--   Version:         20.1.0.00.13
--   Instance ID:     300193896399987
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/process_type/com_flows4apex_get_prcs_var_process
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(8701480126067856)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.GET_PRCS_VAR.PROCESS'
,p_display_name=>'Flows for APEX - Get Process Variables'
,p_supported_ui_types=>'DESKTOP'
,p_api_version=>2
,p_execution_function=>'flow_plugin_get_process_variables.execution'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'Process used to Getting <i>Flows for APEX</i> process variable(s) and storing it into APEX item(s).'
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/mt-ag/apex-flowsforapex'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8701693088067857)
,p_plugin_id=>wwv_flow_api.id(8701480126067856)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Flow Instance info'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'item'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>When a <i>Flows for APEX</i> task is completed, the application needs to send a <i> flow_step_complete </i> call to move the Flow Instance onto its next task / next step.  The call needs to provide the current context to the engine, so that the fl'
||'ow engine knows which task you were completing.  The context is made up of the process_id and subflow_id of the current task.</p>',
'',
'<p>Typically a <i>Flows for APEX </i> userTask (a page in APEX) will download its context when the page loads.  This download is defined in the Flow Modeller, using the Flow Modeller Properties Panel -- once you have created your userTask on your dia'
||'gram, click on the APEX tab in the Properties Panel, define the Page Items to set, and set them to the Process ID and Subflow ID.  </p>',
'',
'<blockquote>For example, one way to do this is to define Application Level items in your application named PROCESS_ID and SUBFLOW_ID.  Then in the Flow Modeller Properties Panel for your userTask, specify that the page call sets variables PROCESS_ID,'
||' SUBFLOW_ID with values of &F4A$process_id.,&F4A$subflow_id.</blockquote>',
'',
'<p>Alternatively, you could retrieve the Flow context (process_id and subflow_id) by retrieving these in a SQL Query.</p>',
'',
'<p>Specify which method you will use to supply the Flow Instance context (process_id and subflow_id)?</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8702070840067857)
,p_plugin_attribute_id=>wwv_flow_api.id(8701693088067857)
,p_display_sequence=>10
,p_display_value=>'In Page Items'
,p_return_value=>'item'
,p_help_text=>'Use this when the Flow Instance context (process_id and subflow_id) are stored in APEX Page Items.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8702516365067859)
,p_plugin_attribute_id=>wwv_flow_api.id(8701693088067857)
,p_display_sequence=>20
,p_display_value=>'from SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this when the Flow Instance context (process_id and subflow_id) are to be returned by a SQL Query.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8703063367067859)
,p_plugin_id=>wwv_flow_api.id(8701480126067856)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Process ID Page Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8701693088067857)
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
 p_id=>wwv_flow_api.id(8703496778067859)
,p_plugin_id=>wwv_flow_api.id(8701480126067856)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Subflow ID Page item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8701693088067857)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>APEX Page Item that contains the Flow Instance subflow_id.</p>',
'',
'<p>This could typically be: </p>',
'<ul>',
'<li>An Application Item, often named SUBFLOW_ID.</li>',
'<li>A Global Page Item, for example P0_SUBFLOW_ID.</li>',
'<li>A Page Item on your page.</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8703811413067859)
,p_plugin_id=>wwv_flow_api.id(8701480126067856)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>2
,p_sql_max_column_count=>2
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8701693088067857)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>SQL Query which returns one row with two columns:</p>',
'<ul>',
'<li>PROCESS_ID</li>',
'<li>SUBFLOW_ID</li>',
'</ul>',
'<p>Important: Column aliases must be <b>uppercase</b></p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8709282829075078)
,p_plugin_id=>wwv_flow_api.id(8701480126067856)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Process Variable(s) Name(s)'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Comma-separated list of process variable(s) name(s)</p>',
'',
'<p>Note that process variable name is case sensitive and the order will have an impact on which APEX item will hold that value.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8709548266075981)
,p_plugin_id=>wwv_flow_api.id(8701480126067856)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'APEX item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>true
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>APEX Items(s) that will hold the process variable value.</p>',
'',
'<p>This could typically be: </p>',
'<ul>',
'<li>An Application Item.</li>',
'<li>A Global Page Item.</li>',
'<li>A Page Item on your page.</li>',
'</ul>'))
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
