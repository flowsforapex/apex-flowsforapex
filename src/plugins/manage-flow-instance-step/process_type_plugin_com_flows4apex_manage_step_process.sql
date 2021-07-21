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
--   Date and Time:   09:59 Wednesday July 21, 2021
--   Exported By:     FLOWS4APEX
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 16800404467823826
--   Manifest End
--   Version:         20.1.0.00.13
--   Instance ID:     300193896399987
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/process_type/com_flows4apex_manage_step_process
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(16800404467823826)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.MANAGE_STEP.PROCESS'
,p_display_name=>'Flows for APEX - Manage Flow Instance Step'
,p_supported_ui_types=>'DESKTOP'
,p_api_version=>2
,p_execution_function=>'flow_plugin_manage_instance_step.execution'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'Process used to Manage a <i>Flows for APEX</i> Flow Instance Step. This plug-in allows you to either complete, reserve or release a Flow Instance Step.'
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/mt-ag/apex-flowsforapex'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16800634434823837)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
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
'<p>For example, one way to do this is to define Application Level items in your application named PROCESS_ID and SUBFLOW_ID.  Then in the Flow Modeller Properties Panel for your userTask, specify that the page call sets variables PROCESS_ID, SUBFLOW_'
||'ID with values of &F4A$process_id.,&F4A$subflow_id.</p>',
'',
'<p>Alternatively, you could retrieve the Flow context (process_id and subflow_id) by retrieving these in a SQL Query.</p>',
'',
'<p>Specify which method you will use to supply the Flow Instance context (process_id and subflow_id)?</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(16801079503823837)
,p_plugin_attribute_id=>wwv_flow_api.id(16800634434823837)
,p_display_sequence=>10
,p_display_value=>'In Page Items'
,p_return_value=>'item'
,p_help_text=>'Use this when the Flow Instance context (process_id and subflow_id) are stored in APEX Page Items.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(16801588109823839)
,p_plugin_attribute_id=>wwv_flow_api.id(16800634434823837)
,p_display_sequence=>20
,p_display_value=>'from SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this when the Flow Instance context (process_id and subflow_id) are to be returned by a SQL Query.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16802005166823839)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Process ID Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16800634434823837)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>APEX Item that contains the Flow Instance process_id.</p>',
'',
'<p>This could typically be: </p>',
'<ul>',
'<li>An Application Item, often named PROCESS_ID.</li>',
'<li>A Global Page Item, for example P0_PROCESS_ID.</li>',
'<li>A Page Item on your page.</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16802480606823839)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Subflow ID item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16800634434823837)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>APEX Item that contains the Flow Instance subflow_id.</p>',
'',
'<p>This could typically be: </p>',
'<ul>',
'<li>An Application Item, often named SUBFLOW_ID.</li>',
'<li>A Global Page Item, for example P0_SUBFLOW_ID.</li>',
'<li>A Page Item on your page.</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16802845203823839)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>2
,p_sql_max_column_count=>2
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16800634434823837)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>SQL Query which returns one row with two columns:</p>',
'<ul>',
'<li>First column needs to contain the Instance Id (prcs_id)</li>',
'<li>Second column needs to contain the Subflow Id (sbfl_id)</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16806822324830979)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>5
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'complete'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Allows you to define the action you want to apply to the Flow Instance.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(16807173118834164)
,p_plugin_attribute_id=>wwv_flow_api.id(16806822324830979)
,p_display_sequence=>10
,p_display_value=>'Complete Step'
,p_return_value=>'complete'
,p_help_text=>'This option is used to complete a Flow Instance Step.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(16807520874836440)
,p_plugin_attribute_id=>wwv_flow_api.id(16806822324830979)
,p_display_sequence=>20
,p_display_value=>'Reserve Step'
,p_return_value=>'reserve'
,p_help_text=>'This option is used to reserve a Flow Instance Step.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(16807952633838504)
,p_plugin_attribute_id=>wwv_flow_api.id(16806822324830979)
,p_display_sequence=>30
,p_display_value=>'Release Step'
,p_return_value=>'release'
,p_help_text=>'This option is used to release a Flow Instance Step.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16803217078823839)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Set Gateway Routing?'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16806822324830979)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'complete'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Use this Process to also set up the routing for a data driven Gateway?</p>',
'<p>BPMN Flow Diagrams contain two gateway types that are data-driven gateways.  These are ',
'<ul>',
'<li>Exclusive Gateways - which choose 1 forward route from several options.</li>',
'<li>Inclusive Gateways - which choose 1 or more routes from several options.</li>',
'</ul></p>',
'<p>In <i>Flows for APEX,</i> the routing instruction for a gateway is set up by creating a Process Variable (named <gateway_bpmn_name>||'':route'') with the BPMN name of the paths to be chosen.</p>',
'<p>If you want this APEX process to set up routing for a forward gateway using information that is known on this page, you can get up the gateway routing here.</p>',
'<p>Set the switch to ''On'' to set up routing for a future Inclusive Gateway or Exclusive Gateway.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16803615562823839)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Gateway ID'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16803217078823839)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enter the Gateway ID of the Gateway to set.  If the field is empty, the plugin will automatically fill it with the next object id, if it is an Inclusive or Exclusive Gateway.</p>',
'',
'<p>Note that BPMN objects have an Object ID and an Object Name -  the routing variable needs the Object ID.</p>',
'<p>The plug-in will create a Flows for APEX Process Variable with a name of this field with '':route'' appended to it, as required by the gateway.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16804092016823839)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Route ID'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16803217078823839)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><b>Example 1:</b>  Inclusive Gateway with required route in Page Item named ''approval_decision'':</p>',
'',
'<pre>&approval_decision.</pre>',
'',
'<p> Page Item approval_decision contains the approval decision route, ''Flow_yes'' or ''Flow_no''. </p>',
'<p><b>Example 2:</b>  Exclusive Gateway with required route in Page Item named ''ship_modes'':</p>',
'',
'<pre>&ship_modes.</pre>',
'',
'<p> Page Item ship_modes contains the required shipping modes for the order.  In this case, the order is to ship by ''air'' and ''sea'', the routes for which have IDs of ''Flow_air'' and ''Flow_sea''.  The contents of Page Item ship_modes would have been set'
||' to ''Flow_air:Flow_sea''. </p>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enter the ID of the route(s) that you want the Flow Instance to take at the Gateway.</p>',
'',
'<p>The Route ID is the ID (not the name) of the sequence Flow leaving the gateway.  To get this from your Flow diagram, open your Flow diagram with the Flow Modeller, select the outbound path (line) from the gateway object.  The Properties Panel will'
||' show its ID and name.  </p>',
'<ul>',
'<li>An Exclusive Gateway (+ sign) allows only 1 forward path.  Set the Routing field to the ID of the path you want, or a substitution variable for a Page Item containing the required link ID.</li>',
'<li>An Inclusive Gateway (o sign) allows multiple forward paths.  If there are more than 1 desired paths, these should be colon (:) delimited.  Set the Routing field to a colon delimited list of the paths you want, or a substitution variable for a Pa'
||'ge Item containing the list IDs of the required links.</li>',
'<ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16804421656823839)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Auto-Branching?'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16806822324830979)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'complete'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>After issuing the step_complete instruction to the Flow engine, Auto Branching will then branch your APEX application to the application page required for the next userTask in the Flow -- without the user needing to return to a task inbox.',
'<p>Auto Branching will only occur when:',
'<ul>',
'<li>the next object in the Flow is also a userTask</li>',
'<li>if Lanes are defined for the Flow, both the last and next task are in the same lane</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(26900255252418609)
,p_plugin_id=>wwv_flow_api.id(16800404467823826)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Reservation'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(16806822324830979)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'reserve'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Reserve with the connected user name</p>',
'<pre>&APP_USER.</pre>'))
,p_help_text=>'Use this to define the value for the reservation.'
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
