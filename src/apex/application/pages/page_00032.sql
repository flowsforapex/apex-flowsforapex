prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
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
 p_id=>32
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Configuration - Logging'
,p_alias=>'CONFIGURATION-LOGGING'
,p_step_title=>'Configuration - Logging'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_IMAGES#lib/prismjs/js/prism.js'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.t-Form-inlineHelp ul li {',
'    font-size: 1.1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'C##LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20230625101845'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11160422865040074)
,p_plug_name=>'Logging'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(7537546705451722)
,p_name=>'JSON Configuration'
,p_parent_plug_id=>wwv_flow_api.id(11160422865040074)
,p_template=>wwv_flow_api.id(12495609856182880263)
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select json_query( (select flow_engine_util.get_config_value(',
'           p_config_key => ''logging_bpmn_location''',
'         , p_default_value => null',
'       ) from dual), ''$'' returning varchar2(4000) pretty) as d',
'from dual'))
,p_header=>'BPMN Location'
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_headings_type=>'NO_HEADINGS'
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(3791697231921401)
,p_query_column_id=>1
,p_column_alias=>'D'
,p_column_display_sequence=>10
,p_column_heading=>'D'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<pre><code class="language-json">#D#</code></pre>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(20892351125255012)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495573047450880221)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12495520300515880126)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3791980243921403)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(7537546705451722)
,p_button_name=>'EDIT_CONFIGURATION'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Edit Configuration'
,p_button_position=>'BOTTOM'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_CFIG_KEY:logging_bpmn_location'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3138033307214457)
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3307218597301243)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(20892351125255012)
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
 p_id=>wwv_flow_api.id(3133819152214452)
,p_name=>'P32_LOGGING_LANGUAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11160422865040074)
,p_prompt=>'Language'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ',
'    fmsg_lang d',
'  , fmsg_lang r',
'from flow_messages',
'order by fmsg_lang'))
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'Language used to display error messages and log events.'
,p_attribute_01=>'12'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3134229968214453)
,p_name=>'P32_LOGGING_LEVEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11160422865040074)
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
 p_id=>wwv_flow_api.id(3134666000214454)
,p_name=>'P32_LOGGING_HIDE_USERID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(11160422865040074)
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
 p_id=>wwv_flow_api.id(3136262120214455)
,p_name=>'P32_LOGGING_MESSAGE_FLOW_RECD'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(11160422865040074)
,p_prompt=>'Log Inbound MessageFlow'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'CUSTOM'
,p_attribute_02=>'true'
,p_attribute_03=>'Yes'
,p_attribute_04=>'false'
,p_attribute_05=>'No'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3136630459214455)
,p_name=>'P32_LOGGING_RETAIN_MSG_FLOW'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(11160422865040074)
,p_prompt=>'Message Flow Log Retention (Days)'
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
 p_id=>wwv_flow_api.id(3325454520527225)
,p_name=>'P32_LOGGING_RETAIN_LOGS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(11160422865040074)
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
,p_quick_pick_label_01=>'1 Year'
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
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3146072745214471)
,p_computation_sequence=>10
,p_computation_item=>'P32_LOGGING_LANGUAGE'
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
 p_id=>wwv_flow_api.id(3146443044214471)
,p_computation_sequence=>20
,p_computation_item=>'P32_LOGGING_LEVEL'
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
 p_id=>wwv_flow_api.id(3146858608214471)
,p_computation_sequence=>30
,p_computation_item=>'P32_LOGGING_HIDE_USERID'
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
 p_id=>wwv_flow_api.id(3286665275239507)
,p_computation_sequence=>40
,p_computation_item=>'P32_LOGGING_RETAIN_LOGS'
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
 p_id=>wwv_flow_api.id(3286988755239510)
,p_computation_sequence=>60
,p_computation_item=>'P32_LOGGING_MESSAGE_FLOW_RECD'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_message_flow_recd',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_recd_msg',
'       );'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3287265563239513)
,p_computation_sequence=>70
,p_computation_item=>'P32_LOGGING_RETAIN_MSG_FLOW'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_retain_msg_flow',
'         , p_default_value => flow_constants_pkg.gc_config_default_log_retain_msg_flow_logs',
'       );'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3792574755923554)
,p_name=>'On dialog close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3791980243921403)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3792909625923555)
,p_event_id=>wwv_flow_api.id(3792574755923554)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(7537546705451722)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3795925272966657)
,p_name=>'On Refresh JSON'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(7537546705451722)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3796393337966657)
,p_event_id=>wwv_flow_api.id(3795925272966657)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'Prism.highlightAll();'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3150354905214473)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_logging_settings(',
'  pi_logging_language          => :P32_LOGGING_LANGUAGE',
', pi_logging_level             => :P32_LOGGING_LEVEL',
', pi_logging_hide_userid       => :P32_LOGGING_HIDE_USERID',
', pi_logging_retain_logs       => :P32_LOGGING_RETAIN_LOGS',
', pi_logging_message_flow_recd => :P32_LOGGING_MESSAGE_FLOW_RECD',
', pi_logging_retain_msg_flow   => :P32_LOGGING_RETAIN_MSG_FLOW',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(3138033307214457)
,p_process_success_message=>'Changes saved.'
);
wwv_flow_api.component_end;
end;
/
