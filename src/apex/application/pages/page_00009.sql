prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_name=>'Configuration'
,p_alias=>'CONFIGURATION'
,p_step_title=>'Configuration'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.t-Form-inlineHelp ul li {',
'    font-size: 1.1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'06'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3286177375239502)
,p_plug_name=>'Sections'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_list_id=>wwv_flow_imp.id(3291351989268379)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_imp.id(12495537187789880157)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17585395174953770)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(8026807639825637)
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
', pi_default_email_sender => :P9_DEFAULT_EMAIL_SENDER ',
', pi_default_application  => :P9_DEFAULT_APPLICATION ',
', pi_default_pageid       => :P9_DEFAULT_PAGEID   ',
', pi_default_username     => :P9_DEFAULT_USERNAME',
', pi_timer_max_cycles     => :P9_TIMER_MAX_CYCLES',
', pi_timer_status         => :P9_TIMER_STATUS',
', pi_timer_repeat_interval=> :P9_TIMER_REPEAT_INTERVAL',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Changes saved.'
,p_internal_uid=>8026807639825637
);
wwv_flow_imp.component_end;
end;
/
