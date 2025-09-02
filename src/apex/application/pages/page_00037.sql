prompt --application/pages/page_00037
begin
--   Manifest
--     PAGE: 00037
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
 p_id=>37
,p_name=>'Configuration - Statistics'
,p_alias=>'CONFIGURATION-STATISTICS'
,p_step_title=>'Configuration - Statistics'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.t-Form-inlineHelp ul li {',
'    font-size: 1.1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4859659349240114)
,p_plug_name=>'Automation - Purge Statistics'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>70
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
 p_id=>wwv_flow_imp.id(8608203121575437)
,p_plug_name=>'Statistics'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14374214007956774)
,p_plug_name=>'Automation - Gather Daily Statistics'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>60
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27538437580351975)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4860681240240124)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_button_name=>'ENABLE_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Enable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P37_STATIC_ID_1.'
,p_button_condition=>'P37_POLLING_STATUS_CODE_1'
,p_button_condition2=>'DISABLED'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4860737620240125)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_button_name=>'DISABLE_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Disable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P37_STATIC_ID_1.'
,p_button_condition=>'P37_POLLING_STATUS_CODE_1'
,p_button_condition2=>'ACTIVE'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4860832913240126)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_button_name=>'SEE_LOGS_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'See Logs'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:41:P41_STATIC_ID:&P37_STATIC_ID.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4895385806115110)
,p_button_sequence=>150
,p_button_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_button_name=>'ENABLE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Enable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P37_STATIC_ID.'
,p_button_condition=>'P37_POLLING_STATUS_CODE'
,p_button_condition2=>'DISABLED'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4895788183115110)
,p_button_sequence=>170
,p_button_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_button_name=>'DISABLE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Disable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P37_STATIC_ID.'
,p_button_condition=>'P37_POLLING_STATUS_CODE'
,p_button_condition2=>'ACTIVE'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4894936412115110)
,p_button_sequence=>190
,p_button_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_button_name=>'SEE_LOGS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'See Logs'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:41:P41_STATIC_ID:&P37_STATIC_ID.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3337626931771697)
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
 p_id=>wwv_flow_imp.id(3336931358771696)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27538437580351975)
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
 p_id=>wwv_flow_imp.id(3287364553239514)
,p_name=>'P37_STATS_RETAIN_MONTH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(8608203121575437)
,p_prompt=>'Retain Monthly Summaries (Months)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'1 Year'
,p_quick_pick_value_01=>'12'
,p_quick_pick_label_02=>'9 Months'
,p_quick_pick_value_02=>'9'
,p_quick_pick_label_03=>'6 Months'
,p_quick_pick_value_03=>'6'
,p_quick_pick_label_04=>'3 Months'
,p_quick_pick_value_04=>'3'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3287449524239515)
,p_name=>'P37_STATS_RETAIN_QTR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(8608203121575437)
,p_prompt=>'Retain Quarterly Summaries (Months)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'5 Years'
,p_quick_pick_value_01=>'60'
,p_quick_pick_label_02=>'4 Years'
,p_quick_pick_value_02=>'48'
,p_quick_pick_label_03=>'3 Years'
,p_quick_pick_value_03=>'36'
,p_quick_pick_label_04=>'2 Years'
,p_quick_pick_value_04=>'24'
,p_quick_pick_label_05=>'1 Year'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3341734890779729)
,p_name=>'P37_STATS_RETAIN_DAILY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(8608203121575437)
,p_prompt=>'Retain Daily Summaries (Days)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
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
 p_id=>wwv_flow_imp.id(4859720703240115)
,p_name=>'P37_NAME_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_item_source_plug_id=>wwv_flow_imp.id(4859659349240114)
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
 p_id=>wwv_flow_imp.id(4859803239240116)
,p_name=>'P37_STATIC_ID_1'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_item_source_plug_id=>wwv_flow_imp.id(4859659349240114)
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
 p_id=>wwv_flow_imp.id(4859947218240117)
,p_name=>'P37_POLLING_STATUS_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_item_source_plug_id=>wwv_flow_imp.id(4859659349240114)
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
 p_id=>wwv_flow_imp.id(4860022218240118)
,p_name=>'P37_POLLING_INTERVAL_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_item_source_plug_id=>wwv_flow_imp.id(4859659349240114)
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
 p_id=>wwv_flow_imp.id(4860169479240119)
,p_name=>'P37_POLLING_LAST_RUN_TIMESTAMP_1'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_item_source_plug_id=>wwv_flow_imp.id(4859659349240114)
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
 p_id=>wwv_flow_imp.id(4860208998240120)
,p_name=>'P37_POLLING_NEXT_RUN_TIMESTAMP_1'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_item_source_plug_id=>wwv_flow_imp.id(4859659349240114)
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4860303242240121)
,p_name=>'P37_POLLING_STATUS_CODE_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_item_source_plug_id=>wwv_flow_imp.id(4859659349240114)
,p_source=>'POLLING_STATUS_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14377573837956770)
,p_name=>'P37_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_item_source_plug_id=>wwv_flow_imp.id(14374214007956774)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14377636673956771)
,p_name=>'P37_STATIC_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_item_source_plug_id=>wwv_flow_imp.id(14374214007956774)
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
 p_id=>wwv_flow_imp.id(14377735556956772)
,p_name=>'P37_POLLING_INTERVAL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_item_source_plug_id=>wwv_flow_imp.id(14374214007956774)
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
 p_id=>wwv_flow_imp.id(14636483847502423)
,p_name=>'P37_POLLING_STATUS_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_item_source_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_source=>'POLLING_STATUS_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14636566639502424)
,p_name=>'P37_POLLING_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_item_source_plug_id=>wwv_flow_imp.id(14374214007956774)
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
 p_id=>wwv_flow_imp.id(14636685133502425)
,p_name=>'P37_POLLING_LAST_RUN_TIMESTAMP'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_item_source_plug_id=>wwv_flow_imp.id(14374214007956774)
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
 p_id=>wwv_flow_imp.id(14636716808502426)
,p_name=>'P37_POLLING_NEXT_RUN_TIMESTAMP'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(14374214007956774)
,p_item_source_plug_id=>wwv_flow_imp.id(14374214007956774)
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
 p_id=>wwv_flow_imp.id(3287570384239516)
,p_computation_sequence=>10
,p_computation_item=>'P37_STATS_RETAIN_DAILY'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_stats_retain_summary_daily',
'         , p_default_value => flow_constants_pkg.gc_config_default_stats_retain_summary_daily',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3287640183239517)
,p_computation_sequence=>20
,p_computation_item=>'P37_STATS_RETAIN_MONTH'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_stats_retain_summary_month',
'         , p_default_value => flow_constants_pkg.gc_config_default_stats_retain_summary_month',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3287793538239518)
,p_computation_sequence=>30
,p_computation_item=>'P37_STATS_RETAIN_QTR'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_stats_retain_summary_qtr',
'         , p_default_value => flow_constants_pkg.gc_config_default_stats_retain_summary_qtr',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(4860412063240122)
,p_computation_sequence=>40
,p_computation_item=>'P37_STATIC_ID_1'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'flows-for-apex-purge-statistics'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(4900885174110851)
,p_computation_sequence=>130
,p_computation_item=>'P37_STATIC_ID'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'flows-for-apex-gather-daily-statistics'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(4901082893108850)
,p_name=>'Close Dialog - Automation'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(14374214007956774)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(4901439462108850)
,p_event_id=>wwv_flow_imp.id(4901082893108850)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'window.location.reload();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(4860962453240127)
,p_name=>'Close Dialog - Automation_1'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(4859659349240114)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(4861058913240128)
,p_event_id=>wwv_flow_imp.id(4860962453240127)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'window.location.reload();'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(3339267970771698)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_timers_settings(',
'  pi_timer_max_cycles      => :P37_TIMER_MAX_CYCLES',
', pi_timer_status          => :P37_TIMER_STATUS',
', pi_timer_repeat_interval => :P37_TIMER_REPEAT_INTERVAL',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(3337626931771697)
,p_process_success_message=>'Changes saved.'
,p_internal_uid=>3339267970771698
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4900451808112931)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(14374214007956774)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Configuration - Statistics'
,p_internal_uid=>4900451808112931
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4860593046240123)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(4859659349240114)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Configuration - Statistics_1'
,p_internal_uid=>4860593046240123
);
wwv_flow_imp.component_end;
end;
/
