prompt --application/shared_components/plugins/process_type/com_flows4apex_manage_ins_vars_process
begin
--   Manifest
--     PLUGIN: COM.FLOWS4APEX.MANAGE_INS_VARS.PROCESS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(84719765847460987)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.MANAGE_INS_VARS.PROCESS'
,p_display_name=>'Flows for APEX - Manage Flow Instance Variables'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_PROC'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('PROCESS TYPE','COM.FLOWS4APEX.MANAGE_INS_VARS.PROCESS'),'')
,p_api_version=>1
,p_execution_function=>'flow_plugin_manage_instance_variables.execution'
,p_substitute_attributes=>true
,p_version_scn=>3139074521
,p_subscribe_plugin_settings=>true
,p_help_text=>'Process used to Manage <i>Flows for APEX</i> Flow Instance Variable(s). The plug-in allows you to get or set variable(s).'
,p_version_identifier=>'25.1'
,p_about_url=>'https://github.com/flowsforapex/apex-flowsforapex'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84720010618460990)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
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
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(84720344241460990)
,p_plugin_attribute_id=>wwv_flow_imp.id(84720010618460990)
,p_display_sequence=>10
,p_display_value=>'In Page Items'
,p_return_value=>'item'
,p_help_text=>'Use this when the Flow Instance context (process_id and subflow_id) are stored in APEX Page Items.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(84720839343460990)
,p_plugin_attribute_id=>wwv_flow_imp.id(84720010618460990)
,p_display_sequence=>20
,p_display_value=>'from SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this when the Flow Instance context (process_id and subflow_id) are to be returned by a SQL Query.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84721419455460990)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Process ID Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84720010618460990)
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
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84721742466460990)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>2
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84720010618460990)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>SQL Query which returns one row with one or or two columns:</p>',
'<ul>',
'<li>First column needs to contain the Instance Id (prcs_id)</li>',
'<li>Second column may contain the Subflow Id (sbfl_id)</li>',
'</ul>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84820717881541566)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>5
,p_prompt=>'Action'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'set'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'This attributes allows you to define if you want to set or to get the process variables.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(84820967609542287)
,p_plugin_attribute_id=>wwv_flow_imp.id(84820717881541566)
,p_display_sequence=>10
,p_display_value=>'Set'
,p_return_value=>'set'
,p_help_text=>'Use this when you want to set a process variable(s)'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(84821401852542882)
,p_plugin_attribute_id=>wwv_flow_imp.id(84820717881541566)
,p_display_sequence=>20
,p_display_value=>'Get'
,p_return_value=>'get'
,p_help_text=>'Use this when you want to get a process variable(s)'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84722146745460990)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Manage Variable(s) using'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'item'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'This attribute allows you to define the way to manage the variables.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(84722577900460991)
,p_plugin_attribute_id=>wwv_flow_imp.id(84722146745460990)
,p_display_sequence=>10
,p_display_value=>'APEX item(s)'
,p_return_value=>'item'
,p_help_text=>'Use this when you want to manage a process variable(s) using APEX item(s)'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(84723065598460991)
,p_plugin_attribute_id=>wwv_flow_imp.id(84722146745460990)
,p_display_sequence=>20
,p_display_value=>'JSON'
,p_return_value=>'json'
,p_help_text=>'Use this when you want to manage a process variable(s) using JSON.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(84723558763460991)
,p_plugin_attribute_id=>wwv_flow_imp.id(84722146745460990)
,p_display_sequence=>30
,p_display_value=>'SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this when you want to manage a process variable(s) using a SQL Query.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84724051277460991)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Process Variable(s) Name(s)'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84722146745460990)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Comma-separated list of process variable(s) name(s)</p>',
'',
'<p>Note that process variable name is case sensitive and the order will have an impact on which APEX item will manage that value.</p>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84724525114460991)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'APEX item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84722146745460990)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>APEX Items(s) that will be used to manage the process variable value.</p>',
'',
'<p>This could typically be: </p>',
'<ul>',
'<li>An Application Item.</li>',
'<li>A Global Page Item.</li>',
'<li>A Page Item on your page.</li>',
'</ul>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84724858440460993)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'JSON'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84722146745460990)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'json'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>JSON when action is set</p>',
'<pre>',
'[',
'	{',
'		"name": "Example_vc2_var",',
'		"type": "varchar2",',
'		"value": "text"',
'	},',
'	{',
'		"name": "Example_num_var",',
'		"type": "number",',
'		"value": 200',
'	},',
'	{',
'		"name": "Example_date_var",',
'		"type": "date",',
'		"value": "2021-04-07T22:07:29.961Z"',
'	},',
'	{',
'		"name": "Example_timestamp_var",',
'		"type": "timestamp",',
'		"value": "2021-04-07T22:07:29.961Z"',
'	},',
'	{',
'		"name": "Example_clob_var",',
'		"type": "clob",',
'		"value": "long text"',
'	},',
'	{',
'		"name": "Example_json_var",',
'		"type": "json",',
'		"value": "{\"myAttribue\":\"myAttributeValue\"}"',
'	}',
']',
'</pre>',
'',
'<p>JSON when action is get</p>',
'<pre>',
'[',
'	{',
'		"name": "Example_vc2_var",',
'		"type": "varchar2",',
'		"item": "ITEM_NAME"',
'	},',
'	{',
'		"name": "Example_num_var",',
'		"type": "number",',
'		"item": "ITEM_NAME"',
'	},',
'	{',
'		"name": "Example_date_var",',
'		"type": "date",',
'		"item": "ITEM_NAME"',
'	},',
'	{',
'		"name": "Example_clob_var",',
'		"type": "clob",',
'		"item": "ITEM_NAME"',
'	},',
'        {',
'		"name": "Example_json_var",',
'		"type": "json",',
'		"item": "ITEM_NAME"',
'	}',
']',
'</pre>'))
,p_help_text=>'Enter a JSON array that contains one or more process variables, their types, and values (when action is set) or item (when action is get).'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(84725241650460993)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>1
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84722146745460990)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>SQL Query when action is Set</p>',
'<pre>',
'select json_array(',
'    json_object(',
'          key ''name'' value ''example_vc2_var''',
'        , key ''type'' value ''varchar2''',
'        , key ''value'' value ''test_vc2''',
'        ),',
'    json_object(',
'          key ''name'' value ''example_num_var''',
'        , key ''type'' value ''number''',
'        , key ''value'' value 200',
'        ),',
'    json_object(',
'          key ''name'' value ''example_date_var''',
'        , key ''type'' value ''date''',
'        , key ''value'' value ''2021-04-07T22:07:29.961Z''',
'        ),',
'    json_object(',
'          key ''name'' value ''example_timestamp_var''',
'        , key ''type'' value ''timestamp''',
'        , key ''value'' value ''2021-04-07T22:07:29.961Z''',
'        ),',
'    json_object(',
'          key ''name'' value ''example_clob_var''',
'        , key ''type'' value ''clob''',
'        , key ''value'' value to_clob(''this is a clob'')',
'        ),',
'    json_object(',
'          key ''name'' value ''example_json_var''',
'        , key ''type'' value ''json''',
'        , key ''value'' value ''{"myAttribue":"myAttributeValue"}''',
'    )',
'returning clob) as json',
'from dual;',
'</pre>',
'<p>SQL Query when action is Get</p>',
'<pre>',
'select json_array(',
'    json_object(',
'          key ''name'' value ''example_vc2_var''',
'        , key ''type'' value ''varchar2''',
'        , key ''item'' value ''ITEM_NAME''',
'        ),',
'    json_object(',
'          key ''name'' value ''example_num_var''',
'        , key ''type'' value ''number''',
'       , key ''item'' value ''ITEM_NAME''',
'        ),',
'    json_object(',
'          key ''name'' value ''example_date_var''',
'        , key ''type'' value ''date''',
'        , key ''item'' value ''ITEM_NAME''',
'        ),',
'    json_object(',
'          key ''name'' value ''example_timestamp_var''',
'        , key ''type'' value ''timestamp''',
'        , key ''item'' value ''ITEM_NAME''',
'        ),',
'    json_object(',
'          key ''name'' value ''examnple_clob_var''',
'        , key ''type'' value ''clob''',
'        , key ''item'' value ''ITEM_NAME''',
'        ),',
'    json_object(',
'          key ''name'' value ''examnple_json_var''',
'        , key ''type'' value ''json''',
'        , key ''item'' value ''ITEM_NAME''',
'        )',
'returning clob) as json',
'from dual;',
'</pre>'))
,p_help_text=>'SQL query that returns the array containing the instance variables.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(100919570706200019)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Return Flow Instance ID into [deprecated]'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'This attribute is deprecated starting from Flows for APEX 22.2 and will probably be removed in a future release.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(62243875274673859)
,p_plugin_id=>wwv_flow_imp.id(84719765847460987)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>25
,p_prompt=>'Subflow ID Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(84720010618460990)
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
end;
/
begin
wwv_flow_imp.component_end;
end;
/
