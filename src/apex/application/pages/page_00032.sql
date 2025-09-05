prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
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
 p_id=>32
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
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11160422865040074)
,p_plug_name=>'Logging'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(698538188607064)
,p_plug_name=>'Flow Model Logging'
,p_title=>'Process Definition Logging'
,p_parent_plug_id=>wwv_flow_imp.id(11160422865040074)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:margin-bottom-none'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(7537546705451722)
,p_name=>'JSON Configuration'
,p_parent_plug_id=>wwv_flow_imp.id(698538188607064)
,p_template=>wwv_flow_imp.id(12495609856182880263)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
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
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(12495559701953880190)
,p_query_headings_type=>'NO_HEADINGS'
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(3791697231921401)
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(698697005607065)
,p_plug_name=>'Message Flow Logs'
,p_title=>'Message Flow Logs'
,p_parent_plug_id=>wwv_flow_imp.id(11160422865040074)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:margin-bottom-none'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>60
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(698742325607066)
,p_plug_name=>'Instance Run Time Logging'
,p_title=>'Instance Run Time Logging'
,p_parent_plug_id=>wwv_flow_imp.id(11160422865040074)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:margin-bottom-none'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(699109611607069)
,p_plug_name=>'General'
,p_parent_plug_id=>wwv_flow_imp.id(11160422865040074)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody:margin-bottom-none'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>70
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4599201032694446)
,p_plug_name=>'Automation - Purge Logs	'
,p_parent_plug_id=>wwv_flow_imp.id(11160422865040074)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>80
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'    name, ',
'    static_id, ',
'    polling_interval, ',
'    polling_status_code, ',
'    polling_status, ',
'    polling_last_run_timestamp, ',
'    polling_next_run_timestamp',
'from apex_appl_automations',
'where application_id = :app_id',
''))
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20892351125255012)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4858854781240106)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_button_name=>'ENABLE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Enable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P32_STATIC_ID.'
,p_button_condition=>'P32_POLLING_STATUS_CODE'
,p_button_condition2=>'DISABLED'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4859010098240108)
,p_button_sequence=>100
,p_button_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_button_name=>'DISABLE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Disable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P32_STATIC_ID.'
,p_button_condition=>'P32_POLLING_STATUS_CODE'
,p_button_condition2=>'ACTIVE'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4859455070240112)
,p_button_sequence=>110
,p_button_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_button_name=>'SEE_LOGS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'See Logs'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:41:P41_STATIC_ID:&P32_STATIC_ID.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3791980243921403)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(7537546705451722)
,p_button_name=>'EDIT_CONFIGURATION'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Edit Configuration'
,p_button_position=>'BOTTOM'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_CFIG_KEY:logging_bpmn_location'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3138033307214457)
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
 p_id=>wwv_flow_imp.id(3307218597301243)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(20892351125255012)
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
 p_id=>wwv_flow_imp.id(698912728607067)
,p_name=>'P32_LOGGING_BPMN_ENABLED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(698538188607064)
,p_prompt=>'Log Changes to Models / BPMN Diagrams'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'true'
,p_attribute_03=>'Yes'
,p_attribute_04=>'false'
,p_attribute_05=>'No'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(699024570607068)
,p_name=>'P32_LOGGING_BPMN_RETAIN_DAYS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(698538188607064)
,p_item_default=>'720'
,p_prompt=>'BPMN Diagram Log Retention (Days)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(699208407607070)
,p_name=>'P32_LOGGING_DEFAULT_LEVEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(698742325607066)
,p_prompt=>'Default Level'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:none;0,abnormal events;1,major events;2,routine;4,full/debug;8'
,p_field_template=>wwv_flow_imp.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'NO'
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'If not defined at Instance creation or inside the BPMN Model.',
'',
'<ul>',
'    <li><strong>abnormal events</strong> - errors, manual intervention, restarts, ...</li>',
'    <li><strong>major events</strong> - add process start, stop, step current, completion, ...</li>',
'    <li><strong>routine</strong> - add step reserve / release, call activity start / complete, ...</li>',
'    <li><strong>full / debug</strong> - add process variable setting </li>',
'</ul>',
''))
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'5'
,p_attribute_02=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3133819152214452)
,p_name=>'P32_LOGGING_LANGUAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(699109611607069)
,p_prompt=>'Language'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct ',
'    fmsg_lang d',
'  , fmsg_lang r',
'from flow_messages',
'order by fmsg_lang'))
,p_field_template=>wwv_flow_imp.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'YES'
,p_inline_help_text=>'Language used for error messages and log events in the event logs.'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'12'
,p_attribute_02=>'NONE'
,p_item_comment=>'This is NOT the display language for error messages in a user session, which come from the user''s environment.'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3134666000214454)
,p_name=>'P32_LOGGING_HIDE_USERID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(699109611607069)
,p_prompt=>'Hide User ID'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'    <li><strong>enabled</strong> - does not capture user information about the step	</li>',
'    <li><strong>disabled</strong> (default) - captures userid of the process step as known to the Flow Engine	</li>',
'</ul>'))
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'true'
,p_attribute_03=>'Yes'
,p_attribute_04=>'false'
,p_attribute_05=>'No'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3136262120214455)
,p_name=>'P32_LOGGING_MESSAGE_FLOW_RECD'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(698697005607065)
,p_prompt=>'Log Inbound MessageFlow'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'true'
,p_attribute_03=>'Yes'
,p_attribute_04=>'false'
,p_attribute_05=>'No'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3136630459214455)
,p_name=>'P32_LOGGING_RETAIN_MSG_FLOW'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(698697005607065)
,p_prompt=>'Message Flow Log Retention (Days)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3325454520527225)
,p_name=>'P32_LOGGING_RETAIN_LOGS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(698742325607066)
,p_prompt=>'Retain Logs (Days after Process Instance Completion)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4599469681694448)
,p_name=>'P32_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_item_source_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_prompt=>'Name'
,p_source=>'NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4599532517694449)
,p_name=>'P32_STATIC_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_item_source_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_prompt=>'Static Id'
,p_source=>'STATIC_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4599631400694450)
,p_name=>'P32_POLLING_INTERVAL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_item_source_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_prompt=>'Polling Interval'
,p_source=>'POLLING_INTERVAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4858379691240101)
,p_name=>'P32_POLLING_STATUS_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_item_source_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_source=>'POLLING_STATUS_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4858462483240102)
,p_name=>'P32_POLLING_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_item_source_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_prompt=>'Polling Status'
,p_source=>'POLLING_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4858580977240103)
,p_name=>'P32_POLLING_LAST_RUN_TIMESTAMP'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_item_source_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_prompt=>'Polling Last Run Timestamp'
,p_source=>'POLLING_LAST_RUN_TIMESTAMP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4858612652240104)
,p_name=>'P32_POLLING_NEXT_RUN_TIMESTAMP'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_item_source_plug_id=>wwv_flow_imp.id(4599201032694446)
,p_prompt=>'Polling Next Run Timestamp'
,p_source=>'POLLING_NEXT_RUN_TIMESTAMP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3146072745214471)
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
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3146858608214471)
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
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3286665275239507)
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
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3286988755239510)
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
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3287265563239513)
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
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(699251795607071)
,p_computation_sequence=>80
,p_computation_item=>'P32_LOGGING_DEFAULT_LEVEL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_logging_default_level',
'         , p_default_value => flow_constants_pkg.gc_logging_level_major_events',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(699345077607072)
,p_computation_sequence=>90
,p_computation_item=>'P32_LOGGING_BPMN_ENABLED'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_logging_bpmn_enabled',
'         , p_default_value => flow_constants_pkg.gc_vcbool_false',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(699482732607073)
,p_computation_sequence=>100
,p_computation_item=>'P32_LOGGING_BPMN_RETAIN_DAYS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_constants_pkg.gc_config_logging_bpmn_retain_days',
'         , p_default_value => ''720''',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(4858744415240105)
,p_computation_sequence=>110
,p_computation_item=>'P32_STATIC_ID'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'flows-for-apex-purge-logs'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(3792574755923554)
,p_name=>'On dialog close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(3791980243921403)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(3792909625923555)
,p_event_id=>wwv_flow_imp.id(3792574755923554)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(7537546705451722)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(3795925272966657)
,p_name=>'On Refresh JSON'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(7537546705451722)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(3796393337966657)
,p_event_id=>wwv_flow_imp.id(3795925272966657)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'Prism.highlightAll();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(4859276071240110)
,p_name=>'Close Dialog - Automation'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(4599201032694446)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(4859398961240111)
,p_event_id=>wwv_flow_imp.id(4859276071240110)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'window.location.reload();'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(3150354905214473)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_logging_settings(',
'  pi_logging_language          => :P32_LOGGING_LANGUAGE',
', pi_logging_default_level     => :P32_LOGGING_DEFAULT_LEVEL',
', pi_logging_hide_userid       => :P32_LOGGING_HIDE_USERID',
', pi_logging_retain_logs       => :P32_LOGGING_RETAIN_LOGS',
', pi_logging_message_flow_recd => :P32_LOGGING_MESSAGE_FLOW_RECD',
', pi_logging_retain_msg_flow   => :P32_LOGGING_RETAIN_MSG_FLOW',
', pi_logging_bpmn_enabled      => :P32_LOGGING_BPMN_ENABLED',
', pi_logging_bpmn_retain_days  => :p32_LOGGING_BPMN_RETAIN_DAYS',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(3138033307214457)
,p_process_success_message=>'Changes saved.'
,p_internal_uid=>3150354905214473
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4599381652694447)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(4599201032694446)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Configuration - Logging'
,p_internal_uid=>4599381652694447
);
wwv_flow_imp.component_end;
end;
/
