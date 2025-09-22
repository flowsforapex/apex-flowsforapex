prompt --application/pages/page_00035
begin
--   Manifest
--     PAGE: 00035
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_page.create_page(
 p_id=>35
,p_name=>'Configuration - Engine'
,p_alias=>'CONFIGURATION-ENGINE'
,p_step_title=>'Configuration - Engine'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.t-Form-inlineHelp ul li {',
'    font-size: 1.1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24202901353579047)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(65920170325464220)
,p_plug_name=>'Engine'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3221271791231712)
,p_button_sequence=>10
,p_button_name=>'REST_CONFIG'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'REST Config'
,p_button_position=>'LEGACY_ORPHAN_COMPONENTS'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:RP,30::'
,p_button_condition_type=>'NEVER'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3220853426231712)
,p_button_sequence=>20
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'LEGACY_ORPHAN_COMPONENTS'
,p_button_alignment=>'RIGHT'
,p_button_condition_type=>'NEVER'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3310860026324035)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24202901353579047)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(2609073604291449)
,p_name=>'P35_DEFAULT_BUSINESS_ADMIN'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(65920170325464220)
,p_prompt=>'Default APEX Business Admin'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'The username to be used as Business Administrator on APEX Human Tasks when no Business Admin is specified in a Task or in the process diagram. 	'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3221987342231713)
,p_name=>'P35_DUPLICATE_STEP_PREVENTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(65920170325464220)
,p_prompt=>'Duplicate Step Prevention'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:strict;strict,legacy;legacy'
,p_field_template=>wwv_flow_imp.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'    <li><strong>legacy</strong> - Use this option only to support applications that have been developped with Flows for APEX 21.1 and lower without additional development. The engine does not use the step key to prevent duplicate action on a single s'
||'tep.</li>',
'    <li><strong>strict</strong> (recommended) - Use this option for new development and/or fully migrated application. The engine uses the step key to avoid duplicate actions on a single step.</li>',
'</ul>'))
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3222333263231713)
,p_name=>'P35_DEFAULT_WORKSPACE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(65920170325464220)
,p_prompt=>'Default Workspace'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Should be set to your default APEX workspace used for Flows for APEX. This is used as a last-resort for scriptTasks and serviceTasks when creating an APEX session or looking for mail templates.'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3222763777231713)
,p_name=>'P35_DEFAULT_EMAIL_SENDER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(65920170325464220)
,p_prompt=>'Default Email Sender'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Should be set to your default email sender, in case outbound mail serviceTasks do not have a sender defined.'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'EMAIL'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3223134552231713)
,p_name=>'P35_DEFAULT_APPLICATIONID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(65920170325464220)
,p_prompt=>'Default Application Id'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'The application ID of one of your APEX apps that will be provided to create a session'
,p_encrypt_session_state_yn=>'N'
,p_attribute_03=>'right'
,p_attribute_04=>'text'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3223533554231713)
,p_name=>'P35_DEFAULT_PAGEID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(65920170325464220)
,p_prompt=>'Default Page Id'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'The page ID of one of your apps that will be provided to create a session'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3223946439231713)
,p_name=>'P35_DEFAULT_USERNAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(65920170325464220)
,p_prompt=>'Default Username'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'The username to be user on the APEX session to create a session if no other username is provided	'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3232080558231716)
,p_computation_sequence=>80
,p_computation_item=>'P35_DUPLICATE_STEP_PREVENTION'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_dup_step_prevention',
'         , p_default_value => flow_constants_pkg.gc_config_default_dup_step_prevention',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3230456644231715)
,p_computation_sequence=>90
,p_computation_item=>'P35_DEFAULT_WORKSPACE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_default_workspace',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_workspace',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3231617409231716)
,p_computation_sequence=>100
,p_computation_item=>'P35_DEFAULT_EMAIL_SENDER'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_default_email_sender',
'         , p_default_value => null ',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3230878635231716)
,p_computation_sequence=>110
,p_computation_item=>'P35_DEFAULT_APPLICATIONID'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_default_application',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_application',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3231247954231716)
,p_computation_sequence=>120
,p_computation_item=>'P35_DEFAULT_PAGEID'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_default_pageid',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_pageid',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3232449117231716)
,p_computation_sequence=>130
,p_computation_item=>'P35_DEFAULT_USERNAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_default_username',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_username',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(2609118871291450)
,p_computation_sequence=>140
,p_computation_item=>'P35_DEFAULT_BUSINESS_ADMIN'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_default_apex_business_admin',
'         , p_default_value => flow_constants_pkg.gc_config_default_default_username',
'       );'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(3233135486231716)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_engine_settings(',
'  pi_duplicate_step_prevention => :P35_DUPLICATE_STEP_PREVENTION',
', pi_default_workspace         => :P35_DEFAULT_WORKSPACE',
', pi_default_email_sender      => :P35_DEFAULT_EMAIL_SENDER',
', pi_default_application       => :P35_DEFAULT_APPLICATIONID',
', pi_default_pageid            => :P35_DEFAULT_PAGEID',
', pi_default_username          => :P35_DEFAULT_USERNAME',
', pi_default_business_admin    => :P35_DEFAULT_BUSINESS_ADMIN',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(3220853426231712)
,p_process_success_message=>'Changes saved.'
,p_internal_uid=>3233135486231716
);
wwv_flow_imp.component_end;
end;
/
