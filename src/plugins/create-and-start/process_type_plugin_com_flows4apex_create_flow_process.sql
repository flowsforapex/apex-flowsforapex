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
--   Date and Time:   09:43 Tuesday June 22, 2021
--   Exported By:     FLOWS4APEX
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 401104185825644229
--   Manifest End
--   Version:         20.1.0.00.13
--   Instance ID:     300193896399987
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/process_type/com_flows4apex_create_flow_process
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(401104185825644229)
,p_plugin_type=>'PROCESS TYPE'
,p_name=>'COM.FLOWS4APEX.CREATE_FLOW.PROCESS'
,p_display_name=>'Flows for APEX - Create and Start Flow'
,p_supported_ui_types=>'DESKTOP'
,p_api_version=>2
,p_execution_function=>'flow_plugin_create_and_start.execution'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'Process used to Creating and Starting a <i>Flows for APEX</i> Flow Instance declaratively.'
,p_version_identifier=>'1.2'
,p_about_url=>'https://github.com/mt-ag/apex-flowsforapex	'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(326114390548391240)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Global Flow'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_max_length=>150
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Set Flow using Name only:',
'<pre>Holiday</pre>',
'Set Flow using Name and Version:',
'<pre>Holiday,0</pre>',
'Set Flow using Id:',
'<pre>1</pre>'))
,p_help_text=>'Provide Flow (Diagram) Name (and optionally Flow Version) or Flow Id.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(367705987343402093)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Select Flow using'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'static'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>A <i>Flows for APEX</i> <b>Flow</b> is the business process diagram or business workflow diagram used to control how your business process proceeds.  These are created using the Flow Modeller in the <i>Flows for APEX</i> application.  Once you hav'
||'e created your Flow diagram, you should specify the Flow name (diagram name) you want to use to control the flow instance to be started.</p>',
'',
'<p>The Flow name can be specified using a SQL query, in an APEX Page Item, or as Static Text.</p>',
'',
'<p> <b>On Versioning.</b> If you are using flow versioning, where you can have multiple versions of a diagram, note that if you specify just the diagram name, the version of the diagram which is currently in <b>released</b> status will be used.  If n'
||'o <b>released</b> status version exists, a <b>draft</b> status having version = ''0'' will be used.  If that doesn''t exist, you will receive an error.  So in a production environment, where you want your app to run with the current <b>released</b> vers'
||'ion, just specify the flow / diagram name - and let the system find the current released version for you.  If you want to test a <b>draft</b> diagram for testing, you will need to use a query to specify which flow / model to use.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(367706796351403627)
,p_plugin_attribute_id=>wwv_flow_api.id(367705987343402093)
,p_display_sequence=>10
,p_display_value=>'APEX item'
,p_return_value=>'item'
,p_help_text=>'Use this when the Flow is contained in APEX Item(s).'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(367707187597404951)
,p_plugin_attribute_id=>wwv_flow_api.id(367705987343402093)
,p_display_sequence=>20
,p_display_value=>'SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this when you want to specify a SQL query that returns the Flow Name to be used.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326106494112901259)
,p_plugin_attribute_id=>wwv_flow_api.id(367705987343402093)
,p_display_sequence=>30
,p_display_value=>'Static Text'
,p_return_value=>'static'
,p_help_text=>'Use this when you want to specify the Flow Name to be used as text.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326137462542836342)
,p_plugin_attribute_id=>wwv_flow_api.id(367705987343402093)
,p_display_sequence=>40
,p_display_value=>'Component Setting'
,p_return_value=>'component'
,p_help_text=>'Use this when you want to specify the Flow to be used as a global component setting.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(401105776445644266)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>30
,p_prompt=>'APEX item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(367705987343402093)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>'APEX Item(s) containing the Flow Name (a dgrm_name) and optionally the Flow Version (a dgrm_version).'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(367708647199422923)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>40
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>2
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(367705987343402093)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SQL query to retrieve by Name:',
'<pre>',
'select dgrm_name',
'from flow_diagrams',
'where id = 1',
'</pre>',
'SQL query to retrieve by Name and Version:',
'<pre>',
'select dgrm_name, dgrm_id',
'from flow_diagrams',
'where id = 1',
'</pre>',
'SQL query to retrieve by ID:',
'<pre>',
'select dgrm_id',
'from flow_diagrams',
'where id = 1',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SQL Query returning depends on the Flow (Diagram) Selection choosen:</br>',
'<ul>',
'<li>The flow name to use. Returned value should be a valid Flow name, i.e., should be contained in the table FLOW_DIAGRAMS in column dgrm_name.</li>',
'<li>The flow name and the flow version to use. Returned values should be a valid Flow name and version, i.e., should be contained in the table FLOW_DIAGRAMS in columns dgrm_name and dgrm_version.</li>',
'<li>The flow id to use. Returned values should be a valid Flow ID, i.e., should be contained in the table FLOW_DIAGRAMS in columns dgrm_id</li>',
'</ul>the Flow name to use.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(368003530611558123)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>20
,p_prompt=>'Static Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>150
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(367705987343402093)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Set Flow using Name only:',
'<pre>Holiday</pre>',
'Set Flow using Name and Version:',
'<pre>Holiday,0</pre>',
'Set Flow using Id:',
'<pre>1</pre>'))
,p_help_text=>'Provide Flow Name (and optionally Flow Version, using a Comma (,) separator) or Flow Id.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(401106969686644266)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>150
,p_prompt=>'Start Flow Instance?'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>In addition to <b>creating </b> a new Flow Instance, this process step can also <b>start</b> the Flow Instance running. </p>',
'<p>Most applications will want to have this set to ''Y'' to start their Flow Instance.</p>',
'<p><b>For Advanced users</b> who need the flexibility to run their own PL/SQL process steps between <b>Creating</b> a Flow Instance and <b>Starting</b> it, set this to ''No''.  You would then follow this APEX Process by additional APEX Processes that r'
||'un your custom PL/SQL, and then Start the Flow Instance.</p>',
'<p>Note. that if you do set this to ''No'', you are then responsible for starting the Flow Instance after running your initialization PL/SQL processes.  Starting the Flow is achieved by making a PL/SQL call to flow_start using the syntax:</p>',
'<pre>flow_api_pkg.flow_start (p_process_id); </pre>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(401107330139644266)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>100
,p_prompt=>'Set Process Variables?'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'no'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p> The <i>Flows for APEX</i> system provides a <i>Process Variable</i> system to store process state for the duration of the Flow Instance.  A Flow Instance can often run over days or weeks, and might involve different users performing their tasks a'
||'s part of the flow -- and so the life of a Flow Instance can often be longer than the duration of an APEX session.  The <i>Flows for APEX</i> documentation provides more information on the process variable system. Process Variables can be set by the '
||'application, by scriptTasks, and as part of the process definition.</p>',
'<p> Some Page Variables should be set when a new Flow Instance is created, as part of Flow initiation.  These variables, their types, and values can be set up declaratively in the Process Plugin.</p>',
'',
'<p> To set any <i>Flows for APEX</i> process variables as part of the Flow initialization, set this switch to ''Using JSON'' or ''Using SQL Query'', depending upon how you want to specify the process variables and their content. </p>',
'<p> Process Variables set from this process plugin are set after the new Flow has been <b>created</b>, but before it is <b>started</b>. </p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326111304142366807)
,p_plugin_attribute_id=>wwv_flow_api.id(401107330139644266)
,p_display_sequence=>10
,p_display_value=>'No Process Variables'
,p_return_value=>'no'
,p_help_text=>'Use this option to indicate that no other process variables should to be set.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326111683046367901)
,p_plugin_attribute_id=>wwv_flow_api.id(401107330139644266)
,p_display_sequence=>20
,p_display_value=>'Using JSON'
,p_return_value=>'json'
,p_help_text=>'Use this option to use a JSON array to specify your Process Variable(s), their types and initial values.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326112076342369981)
,p_plugin_attribute_id=>wwv_flow_api.id(401107330139644266)
,p_display_sequence=>30
,p_display_value=>'SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this option to specify a SQL statement to return your process variable names, types, and initial values.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(326113919206379026)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>5
,p_prompt=>'Flow (Diagram) selection based on'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'name'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>How are you going to specify which Flow Diagram to use to start the Flow?</p>',
'',
'<p>If you are not using Flow versioning, you can specify the Flow (diagram) by its Name, its Name and Version, or by a Flow ID. If you are not using versioning, the Version will probably be "0".  ',
'',
'<p>If you are using Flow versioning, <i>Flows for APEX</i> will  run the current, <i>released</i> version of a Flow if you specify <b>Name</b> - which you would typically use in your production application.  If you want to test a specific version of '
||'the Flow that is not the current <i>released</i> Flow, you can specify the Flow using its <b>Name and Version</b>, or by using its <b>ID</b>. -- but note that the ID will change if the model is exported and imported into another system.</p>',
'',
'<p>Using Flow ID is only recommended during testing. Note that when a Flow (Diagram) is moved from one system to another, it could be allocated a different ID number, and so using the ID might not be the best solution.</p>',
'',
'<p>When a Flow (diagram) is specified by <b>Name</b> only, the rules for Flow selection are as follows:</p><ul>',
'<li>the engine will first look for a Flow with that Name and having Status of <i>released</i></li>',
'<li>if that doesn''t exist, it will look for a Flow with that Name having a Status of <i>draft</i> and a Version of <i>0</i></li>',
'<li>if that doesn''t exist, it will return an error.</li></ul>',
'',
'',
'<p>For more information on the versioning system and its rules, see the <i>Flows for APEX</i> documentation.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326135974048827826)
,p_plugin_attribute_id=>wwv_flow_api.id(326113919206379026)
,p_display_sequence=>10
,p_display_value=>'Name'
,p_return_value=>'name'
,p_help_text=>'Use this when you want to specify the Flow (diagram) giving just the Flow Name, letting <i>Flow for APEX</i> select the version. (see explanation for rules on which version will be used).'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326136503277829842)
,p_plugin_attribute_id=>wwv_flow_api.id(326113919206379026)
,p_display_sequence=>20
,p_display_value=>'Name & Version'
,p_return_value=>'name_and_version'
,p_help_text=>'Use this when you want to specify a Flow (diagram) using the Flow Name and a specific Version of the Flow. (see explanation)'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326136965778830493)
,p_plugin_attribute_id=>wwv_flow_api.id(326113919206379026)
,p_display_sequence=>30
,p_display_value=>'ID'
,p_return_value=>'id'
,p_help_text=>'Use this to specify the Flow (Diagram) to be used by giving a Flow (diagram) ID.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(401108179564644268)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>110
,p_prompt=>'JSON'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(401107330139644266)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'json'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'		"name": "Example_clob_var",',
'		"type": "clob",',
'		"value": "long text"',
'	}',
']',
'</pre>'))
,p_help_text=>'Enter a JSON array that contains one or more process variables, their types, and values.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(401305752726699796)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>110
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>1
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(401107330139644266)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'          key ''name'' value ''examnple_clob_var''',
'        , key ''type'' value ''clob''',
'        , key ''value'' value to_clob(''this is a clob'')',
'        )',
'returning clob)',
'from dual;',
'</pre>'))
,p_help_text=>'SQL query that returns the array containing the instance variables.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(401306117289704458)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>90
,p_prompt=>'Set Business Reference'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Most Flow Instances will need a Process Variable that contains a reference to its related business object.  This enables your Flow to find its associated object.</p>',
'<p>By convention, we suggest that all Flows use a process variable named ''BUSINESS_REF'' to store a reference to the associated business object in the database.  Several database views and application pages assume that this process variable exists and'
||' is set once the process knows which business object it relates to.</p>',
'<ul>',
'<li>If you know the related business object at this point in your flow, you can have the plugin set it from the contents of an APEX item before the Flow Instance is started.</li>',
'<li>If you don''t know the business object reference at this point, you can set it later in your process.  For example, if a later task creates the business object and the database returns its reference, you should then copy this into the BUSINESS_REF'
||' process variable once you do know it.  This can be done by calling flow_process_vars.set_var.</li>',
'</ul>',
'<p>',
'<p>Select an APEX Page Item containing the business reference key that you want used to set the process variable PROCESS_REF.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(401404221336770446)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>70
,p_prompt=>'APEX item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(326108545413060717)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'item'
,p_help_text=>'APEX Page Item containing the Flow Name (a dgrm_name).'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(367709695580430793)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>80
,p_prompt=>'Return Instance ID into'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Select an APEX Page Item to store the ID (process_id) of the new flow instance when it is created.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(326108545413060717)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>50
,p_prompt=>'Set Flow Instance Name using'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'static'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p> The Flow Instance name is usually a description of the Flow Instance that is being created.  This should usually contain some human  readable reference to the business process and its subject, rather than just being a primary key link to the busi'
||'ness subject (which would be stored in the BusinessKey process variable).  </p>',
'<p> For example, in an HR system that includes a Flow for requesting and accounting for vacation, the Flow Instance name might be set to ''Vacation - JScott - 13-APR-2021''. </p>',
'',
'<p> The Flow Instance name can be specified using a Static item (including substitutions), a SQL query, or from the contents of an APEX Page Item.  Use this field to select one of these methods. </p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326109034193063547)
,p_plugin_attribute_id=>wwv_flow_api.id(326108545413060717)
,p_display_sequence=>10
,p_display_value=>'Static Assignment'
,p_return_value=>'static'
,p_help_text=>'Use this option to provide the new flow instance name.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326109459667064970)
,p_plugin_attribute_id=>wwv_flow_api.id(326108545413060717)
,p_display_sequence=>20
,p_display_value=>'APEX item'
,p_return_value=>'item'
,p_help_text=>'Use this option to select an APEX item that contains the new flow intance name.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(326109830727067126)
,p_plugin_attribute_id=>wwv_flow_api.id(326108545413060717)
,p_display_sequence=>30
,p_display_value=>'SQL Query'
,p_return_value=>'sql'
,p_help_text=>'Use this option to write a SQL query to retrieve the new flow instance.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(367803435372446843)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>60
,p_prompt=>'Static Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_max_length=>150
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(326108545413060717)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'Define the new flow instance name to be created.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(367903453261450623)
,p_plugin_id=>wwv_flow_api.id(401104185825644229)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>70
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>1
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(326108545413060717)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_help_text=>'Define the new flow instance name to be created.'
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