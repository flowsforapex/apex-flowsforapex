prompt --application/pages/page_00100
begin
--   Manifest
--     PAGE: 00100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page(
 p_id=>100
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Configuration [OLD,BACKUP]'
,p_alias=>'CONFIGURATION-OLD-BACKUP'
,p_step_title=>'Configuration [OLD,BACKUP]'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.t-Form-inlineHelp ul li {',
'    font-size: 1.1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_api.id(88199069651756122)
,p_last_updated_by=>'C##DAMTHOR'
,p_last_upd_yyyymmddhh24miss=>'20230420142259'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5301292362807367)
,p_plug_name=>'Timers'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11295717440064001)
,p_plug_name=>'Logging'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11295777694064002)
,p_plug_name=>'Engine App'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(65972703397470872)
,p_plug_name=>'Engine'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3273786813238364)
,p_button_sequence=>10
,p_button_name=>'REST_CONFIG'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'REST Config'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:RP,30::'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3273384211238364)
,p_button_sequence=>20
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3269101148238362)
,p_name=>'P100_LOGGING_LANGUAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Language'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ',
'    fmsg_lang d',
'  , fmsg_lang r',
'from flow_messages'))
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'Language used to display error messages and log events.'
,p_attribute_01=>'4'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3269559694238363)
,p_name=>'P100_LOGGING_LEVEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Level'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:off;off,standard;standard,secure;secure,full;full'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'    <li><strong>off</strong> - logging is disabled	</li>',
'    <li><strong>standard</strong> (default) - logs instance events</li>',
'    <li><strong>secure</strong> - logs model events and instance events	</li>',
'    <li><strong>full</strong> - logs model, instance and process variable events		</li>',
'</ul>'))
,p_attribute_01=>'4'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3269996682238363)
,p_name=>'P100_LOGGING_HIDE_USERID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Hide User ID'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'    <li><strong>enabled</strong> - does not capture user information about the step	</li>',
'    <li><strong>disabled</strong> (default) - captures userid of the process step as known to the Flow Engine	</li>',
'</ul>'))
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'true'
,p_attribute_03=>'Yes'
,p_attribute_04=>'false'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3270397696238363)
,p_name=>'P100_LOGGING_RETAIN_LOGS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Retain Logs (Days after Process Instance Completion)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'I Year'
,p_quick_pick_value_01=>'365'
,p_quick_pick_label_02=>'9 Months'
,p_quick_pick_value_02=>'273'
,p_quick_pick_label_03=>'6 Months'
,p_quick_pick_value_03=>'182'
,p_quick_pick_label_04=>'3 Months'
,p_quick_pick_value_04=>'90'
,p_quick_pick_label_05=>'30 Days'
,p_quick_pick_value_05=>'30'
,p_quick_pick_label_06=>'14 Days'
,p_quick_pick_value_06=>'14'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3270703706238363)
,p_name=>'P100_LOGGING_ARCHIVE_ENABLED'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Enable Instance Summary Archiving'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3271184455238363)
,p_name=>'P100_LOGGING_ARCHIVE_LOCATION'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Instance Archive Location'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3271519975238363)
,p_name=>'P100_LOGGING_MSG_FLOW_RECD'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Log Inbound MessageFlow (not yet implemented)'
,p_display_as=>'NATIVE_YES_NO'
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3271952589238363)
,p_name=>'P100_LOGGING_MSG_FLOW_RETENTION'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(11295717440064001)
,p_prompt=>'Message Flow Log Retention (Days) (not yet implemented)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when_type=>'NEVER'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3272674870238364)
,p_name=>'P100_ENGINE_APP_MODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11295777694064002)
,p_prompt=>'Mode'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Production;production,Development;development'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'    <li><strong>production</strong> (default) - prevents editing of diagram for released models</li>',
'    <li><strong>development</strong> - allows editing of diagram for released models</li>',
'</ul>'))
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3274466716238365)
,p_name=>'P100_DUPLICATE_STEP_PREVENTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(65972703397470872)
,p_prompt=>'Duplicate Step Prevention'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:strict;strict,legacy;legacy'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'    <li><strong>legacy</strong> - Use this option only to support applications that have been developped with Flows for APEX 21.1 and lower without additional development. The engine does not use the step key to prevent duplicate action on a single s'
||'tep.</li>',
'    <li><strong>strict</strong> (recommended) - Use this option for new development and/or fully migrated application. The engine uses the step key to avoid duplicate actions on a single step.</li>',
'</ul>'))
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3274892542238365)
,p_name=>'P100_DEFAULT_WORKSPACE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(65972703397470872)
,p_prompt=>'Default Workspace'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Should be set to your default APEX workspace used for Flows for APEX. This is used as a last-resort for scriptTasks and serviceTasks when creating an APEX session or looking for mail templates'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3275221261238365)
,p_name=>'P100_DEFAULT_EMAIL_SENDER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(65972703397470872)
,p_prompt=>'Default Email Sender'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Should be set to your default email sender, in case outbound mail serviceTasks do not have a sender defined.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3275605822238365)
,p_name=>'P100_DEFAULT_APPLICATION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(65972703397470872)
,p_prompt=>'Default Application Id'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'the application ID of one of your APEX apps that will be provided to create a session'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3276036417238366)
,p_name=>'P100_DEFAULT_PAGEID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(65972703397470872)
,p_prompt=>'Default Page Id'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'the page ID of one of your apps that will be provided to create a session'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3276448525238366)
,p_name=>'P100_DEFAULT_USERNAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(65972703397470872)
,p_prompt=>'Default Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'the username to be user on the APEX session to create a session if no other username is provided	'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3276827580238366)
,p_name=>'P100_TIMER_MAX_CYCLES'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(65972703397470872)
,p_prompt=>'Timer Max Cycles'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'For cycle timers, this will defined the maximum number of execution.'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3277540906238367)
,p_name=>'P100_TIMER_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5301292362807367)
,p_prompt=>'Timers Enabled'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'TRUE'
,p_attribute_03=>'enabled'
,p_attribute_04=>'FALSE'
,p_attribute_05=>'disabled'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3277996439238367)
,p_name=>'P100_TIMER_REPEAT_INTERVAL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5301292362807367)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'Hourly'
,p_quick_pick_value_01=>'FREQ=HOURLY;INTERVAL=1'
,p_quick_pick_label_02=>'10 Min'
,p_quick_pick_value_02=>'FREQ=MINUTELY;INTERVAL=10'
,p_quick_pick_label_03=>'5 Min'
,p_quick_pick_value_03=>'FREQ=MINUTELY;INTERVAL=10'
,p_quick_pick_label_04=>'1 Min'
,p_quick_pick_value_04=>'FREQ=MINUTELY;INTERVAL=10'
,p_quick_pick_label_05=>'10 Sec (Production Use - not for apex.oracle.com)'
,p_quick_pick_value_05=>'FREQ=SECONDLY;INTERVAL=10'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3281319608238368)
,p_computation_sequence=>10
,p_computation_item=>'P100_LOGGING_LANGUAGE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_language',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_language',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3281763648238368)
,p_computation_sequence=>20
,p_computation_item=>'P100_LOGGING_LEVEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_logging_level',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_level',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3282115391238369)
,p_computation_sequence=>30
,p_computation_item=>'P100_LOGGING_HIDE_USERID'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_level',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_level',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3279360474238368)
,p_computation_sequence=>40
,p_computation_item=>'P100_LOGGING_RETAIN_LOGS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_retain_logs',
'         , p_default_value => flow_constants_pkg.gc_config_default_log_retain_logs',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3279743741238368)
,p_computation_sequence=>50
,p_computation_item=>'P100_LOGGING_ARCHIVE_ENABLED'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_archive_enabled',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_archive_enabled',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3280148117238368)
,p_computation_sequence=>60
,p_computation_item=>'P100_LOGGING_ARCHIVE_LOCATION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_archive_location',
'         , p_default_value => null',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3282519076238369)
,p_computation_sequence=>70
,p_computation_item=>'P100_ENGINE_APP_MODE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_engine_app_mode',
'         , p_default_value => flow_constants_pkg.gc_config_default_engine_app_mode',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3284590448238369)
,p_computation_sequence=>80
,p_computation_item=>'P100_DUPLICATE_STEP_PREVENTION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_dup_step_prevention',
'         , p_default_value => flow_constants_pkg.gc_config_default_dup_step_prevention',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3282969427238369)
,p_computation_sequence=>90
,p_computation_item=>'P100_DEFAULT_WORKSPACE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_default_workspace',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_workspace',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3284175664238369)
,p_computation_sequence=>100
,p_computation_item=>'P100_DEFAULT_EMAIL_SENDER'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_default_email_sender',
'         , p_default_value => null ',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3283383241238369)
,p_computation_sequence=>110
,p_computation_item=>'P100_DEFAULT_APPLICATION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_default_application',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_application',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3283760405238369)
,p_computation_sequence=>120
,p_computation_item=>'P100_DEFAULT_PAGEID'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_default_pageid',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_pageid',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3284935282238370)
,p_computation_sequence=>130
,p_computation_item=>'P100_DEFAULT_USERNAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_default_username',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_username',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3285316954238370)
,p_computation_sequence=>140
,p_computation_item=>'P100_TIMER_MAX_CYCLES'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_timer_max_cycles',
'         , p_default_value => flow_constants_pkg.gc_config_default_timer_max_cycles',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3280579549238368)
,p_computation_sequence=>150
,p_computation_item=>'P100_TIMER_STATUS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>'return flow_timers_pkg.get_timer_status;'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3280978951238368)
,p_computation_sequence=>160
,p_computation_item=>'P100_TIMER_REPEAT_INTERVAL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>'return flow_timers_pkg.get_timer_repeat_interval;'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3285684485238370)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_settings(',
'  pi_logging_language => :P100_LOGGING_LANGUAGE',
', pi_logging_level => :P100_LOGGING_LEVEL',
', pi_logging_hide_userid => :P100_LOGGING_HIDE_USERID',
', pi_engine_app_mode => :P100_ENGINE_APP_MODE',
', pi_duplicate_step_prevention => :P100_DUPLICATE_STEP_PREVENTION',
', pi_default_workspace    => :P100_DEFAULT_WORKSPACE',
', pi_default_email_sender => :P100_DEFAULT_EMAIL_SENDER ',
', pi_default_application  => :P100_DEFAULT_APPLICATION ',
', pi_default_pageid       => :P100_DEFAULT_PAGEID   ',
', pi_default_username     => :P100_DEFAULT_USERNAME',
', pi_timer_max_cycles     => :P100_TIMER_MAX_CYCLES',
', pi_timer_status         => :P100_TIMER_STATUS',
', pi_timer_repeat_interval=> :P100_TIMER_REPEAT_INTERVAL',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3273384211238364)
,p_process_success_message=>'Changes saved.'
);
wwv_flow_api.component_end;
end;
/
