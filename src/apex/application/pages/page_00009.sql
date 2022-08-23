prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page(
 p_id=>9
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Configuration'
,p_alias=>'CONFIGURATION'
,p_step_title=>'Configuration'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.t-Form-inlineHelp ul li {',
'    font-size: 1.1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20220824004123'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8027146440825640)
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
 p_id=>wwv_flow_api.id(8027206694825641)
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
 p_id=>wwv_flow_api.id(17585395174953770)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495573047450880221)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12495520300515880126)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(62704132398232511)
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
 p_id=>wwv_flow_api.id(8026761271825636)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(17585395174953770)
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
 p_id=>wwv_flow_api.id(8025840557825627)
,p_name=>'P9_LOGGING_LANGUAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8027146440825640)
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
 p_id=>wwv_flow_api.id(8025977827825628)
,p_name=>'P9_LOGGING_LEVEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8027146440825640)
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
 p_id=>wwv_flow_api.id(8026058435825629)
,p_name=>'P9_LOGGING_HIDE_USERID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8027146440825640)
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
 p_id=>wwv_flow_api.id(8026117068825630)
,p_name=>'P9_ENGINE_APP_MODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8027206694825641)
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
 p_id=>wwv_flow_api.id(60865099550537248)
,p_name=>'P9_DEFAULT_WORKSPACE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(62704132398232511)
,p_prompt=>'Default Workspace'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Default workspace, application and page id are used to create an APEX session if they are not defined at the activity or diagram level.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(60865167757537249)
,p_name=>'P9_DEFAULT_APPLICATION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(62704132398232511)
,p_prompt=>'Default Application Id'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(60865213001537250)
,p_name=>'P9_DEFAULT_PAGEID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(62704132398232511)
,p_prompt=>'Default Page Id'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62611455436485301)
,p_name=>'P9_DEFAULT_EMAIL_SENDER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(62704132398232511)
,p_prompt=>'Default Email Sender'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Use as a sender for emails if it is not defined on the service task.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62611542240485302)
,p_name=>'P9_TIMER_MAX_CYCLES'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(62704132398232511)
,p_prompt=>'Timer Max Cycles'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>2
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'For cycle timers, this will defined a maximum number of execution.'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62704280409232512)
,p_name=>'P9_DUPLICATE_STEP_PREVENTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(62704132398232511)
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
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(8026380531825632)
,p_computation_sequence=>10
,p_computation_item=>'P9_LOGGING_LANGUAGE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_language',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_language',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(8026429923825633)
,p_computation_sequence=>20
,p_computation_item=>'P9_LOGGING_LEVEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_logging_level',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_level',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(8026570088825634)
,p_computation_sequence=>30
,p_computation_item=>'P9_LOGGING_HIDE_USERID'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_level',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_level',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(8026635814825635)
,p_computation_sequence=>40
,p_computation_item=>'P9_ENGINE_APP_MODE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_engine_app_mode',
'         , p_default_value => flow_constants_pkg.gc_config_default_engine_app_mode',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(62704342094232513)
,p_computation_sequence=>50
,p_computation_item=>'P9_DUPLICATE_STEP_PREVENTION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_dup_step_prevention',
'         , p_default_value => flow_constants_pkg.gc_config_default_dup_step_prevention',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(62611635971485303)
,p_computation_sequence=>60
,p_computation_item=>'P9_DEFAULT_WORKSPACE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_default_workspace',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_workspace',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(62611793257485304)
,p_computation_sequence=>70
,p_computation_item=>'P9_DEFAULT_APPLICATION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_default_application',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_application',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(62611879621485305)
,p_computation_sequence=>80
,p_computation_item=>'P9_DEFAULT_PAGEID'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_default_pageid',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_pageid',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(62611912263485306)
,p_computation_sequence=>90
,p_computation_item=>'P9_DEFAULT_EMAIL_SENDER'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_default_email_sender',
'         , p_default_value => null ',
'       );'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(8026807639825637)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_settings(',
'  pi_logging_language => :P9_LOGGING_LANGUAGE',
', pi_logging_level => :P9_LOGGING_LEVEL',
', pi_logging_hide_userid => :P9_LOGGING_HIDE_USERID',
', pi_engine_app_mode => :P9_ENGINE_APP_MODE',
', pi_duplicate_step_prevention => :P9_DUPLICATE_STEP_PREVENTION',
', pi_default_workspace    => :P9_DEFAULT_WORKSPACE',
', pi_default_application  => :P9_DEFAULT_APPLICATION ',
', pi_default_pageid       => :P9_DEFAULT_PAGEID   ',
', pi_default_email_sender => :P9_DEFAULT_EMAIL_SENDER ',
', pi_timer_max_cycles     => :P9_TIMER_MAX_CYCLES',
');'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(8026761271825636)
,p_process_success_message=>'Changes saved.'
);
wwv_flow_api.component_end;
end;
/
