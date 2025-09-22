prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
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
 p_id=>33
,p_name=>'Configuration - Instance Archiving and Purging'
,p_alias=>'CONFIGURATION-ARCHIVING'
,p_step_title=>'Configuration - Instance Archiving and Purging'
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
 p_id=>wwv_flow_imp.id(9479602182841663)
,p_plug_name=>'Automation - Daily Instance Summary Archive'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>30
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
 p_id=>wwv_flow_imp.id(11186537419048718)
,p_plug_name=>'Instance Summary Archiving'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(3746146895530325)
,p_name=>'JSON Configuration'
,p_parent_plug_id=>wwv_flow_imp.id(11186537419048718)
,p_template=>wwv_flow_imp.id(12495609856182880263)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select json_query( (select flow_engine_util.get_config_value(',
'           p_config_key => ''logging_archive_location''',
'         , p_default_value => null',
'       ) from dual), ''$'' returning varchar2(4000) pretty) as d',
'from dual'))
,p_header=>'Archive Location'
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
 p_id=>wwv_flow_imp.id(3746305351530327)
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
 p_id=>wwv_flow_imp.id(13980151483687947)
,p_plug_name=>'Completed Process Instance Purging'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14768878313669603)
,p_plug_name=>'Automation - Purge Completed Instances'
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
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24201499202577457)
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
 p_id=>wwv_flow_imp.id(3512936201851742)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(3746146895530325)
,p_button_name=>'EDIT_CONFIGURATION'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--link'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Edit Configuration'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:38:&SESSION.::&DEBUG.:38:P38_CFIG_KEY:logging_archive_location'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14769779291669612)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_button_name=>'ENABLE_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Enable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P33_STATIC_ID.'
,p_button_condition=>'P33_POLLING_STATUS_CODE_1'
,p_button_condition2=>'DISABLED'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14769876647669613)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_button_name=>'DISABLE_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Disable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P33_STATIC_ID.'
,p_button_condition=>'P33_POLLING_STATUS_CODE_1'
,p_button_condition2=>'ACTIVE'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14769968479669614)
,p_button_sequence=>100
,p_button_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_button_name=>'SEE_LOGS_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'See Logs'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:41:P41_STATIC_ID:&P33_STATIC_ID_1.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4881119153147212)
,p_button_sequence=>150
,p_button_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_button_name=>'ENABLE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Enable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P33_STATIC_ID.'
,p_button_condition=>'P33_POLLING_STATUS_CODE'
,p_button_condition2=>'DISABLED'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4881512778147212)
,p_button_sequence=>170
,p_button_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_button_name=>'DISABLE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Disable'
,p_button_redirect_url=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:&P33_STATIC_ID.'
,p_button_condition=>'P33_POLLING_STATUS_CODE'
,p_button_condition2=>'ACTIVE'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4880796912147213)
,p_button_sequence=>190
,p_button_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_button_name=>'SEE_LOGS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'See Logs'
,p_button_redirect_url=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:41:P41_STATIC_ID:&P33_STATIC_ID.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3164119045223081)
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
 p_id=>wwv_flow_imp.id(3309455839322446)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24201499202577457)
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
 p_id=>wwv_flow_imp.id(3161511927223080)
,p_name=>'P33_LOGGING_ARCHIVE_ENABLED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(11186537419048718)
,p_prompt=>'Enable Instance Summary Archiving'
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
 p_id=>wwv_flow_imp.id(3161978411223080)
,p_name=>'P33_LOGGING_ARCHIVE_LOCATION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(11186537419048718)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9481460141841660)
,p_name=>'P33_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_item_source_plug_id=>wwv_flow_imp.id(9479602182841663)
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
 p_id=>wwv_flow_imp.id(9481522977841661)
,p_name=>'P33_STATIC_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_item_source_plug_id=>wwv_flow_imp.id(9479602182841663)
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
 p_id=>wwv_flow_imp.id(9481621860841662)
,p_name=>'P33_POLLING_INTERVAL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_item_source_plug_id=>wwv_flow_imp.id(9479602182841663)
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
 p_id=>wwv_flow_imp.id(9740370151387313)
,p_name=>'P33_POLLING_STATUS_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_item_source_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_source=>'POLLING_STATUS_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9740452943387314)
,p_name=>'P33_POLLING_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_item_source_plug_id=>wwv_flow_imp.id(9479602182841663)
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
 p_id=>wwv_flow_imp.id(9740571437387315)
,p_name=>'P33_POLLING_LAST_RUN_TIMESTAMP'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_item_source_plug_id=>wwv_flow_imp.id(9479602182841663)
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
 p_id=>wwv_flow_imp.id(9740603112387316)
,p_name=>'P33_POLLING_NEXT_RUN_TIMESTAMP'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(9479602182841663)
,p_item_source_plug_id=>wwv_flow_imp.id(9479602182841663)
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
 p_id=>wwv_flow_imp.id(13980340513687949)
,p_name=>'P33_COMPLETED_PRCS_PURGING'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13980151483687947)
,p_prompt=>'Enable Completed Process Instance Purging'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14768604768669601)
,p_name=>'P33_COMPLETED_PRCS_PURGE_DAYS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13980151483687947)
,p_prompt=>'Retention period before purging  (Days after instance completed / terminated)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14768998600669604)
,p_name=>'P33_NAME_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_item_source_plug_id=>wwv_flow_imp.id(14768878313669603)
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
 p_id=>wwv_flow_imp.id(14769114762669606)
,p_name=>'P33_STATIC_ID_1'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_item_source_plug_id=>wwv_flow_imp.id(14768878313669603)
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
 p_id=>wwv_flow_imp.id(14769269001669607)
,p_name=>'P33_POLLING_STATUS_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_item_source_plug_id=>wwv_flow_imp.id(14768878313669603)
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
 p_id=>wwv_flow_imp.id(14769302729669608)
,p_name=>'P33_POLLING_INTERVAL_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_item_source_plug_id=>wwv_flow_imp.id(14768878313669603)
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
 p_id=>wwv_flow_imp.id(14769415111669609)
,p_name=>'P33_POLLING_LAST_RUN_TIMESTAMP_1'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_item_source_plug_id=>wwv_flow_imp.id(14768878313669603)
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
 p_id=>wwv_flow_imp.id(14769597769669610)
,p_name=>'P33_POLLING_NEXT_RUN_TIMESTAMP_1'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_item_source_plug_id=>wwv_flow_imp.id(14768878313669603)
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
 p_id=>wwv_flow_imp.id(14769611463669611)
,p_name=>'P33_POLLING_STATUS_CODE_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_item_source_plug_id=>wwv_flow_imp.id(14768878313669603)
,p_source=>'POLLING_STATUS_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3170508084223084)
,p_computation_sequence=>20
,p_computation_item=>'P33_LOGGING_ARCHIVE_ENABLED'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_logging_archive_enabled',
'         , p_default_value => flow_constants_pkg.gc_config_default_logging_archive_enabled',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(13980453602687950)
,p_computation_sequence=>30
,p_computation_item=>'P33_COMPLETED_PRCS_PURGING'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_completed_prcs_purging',
'         , p_default_value => flow_constants_pkg.gc_config_default_completed_prcs_purging',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(14768745596669602)
,p_computation_sequence=>40
,p_computation_item=>'P33_COMPLETED_PRCS_PURGE_DAYS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => flow_constants_pkg.gc_config_completed_prcs_purge_days',
'         , p_default_value => ''365''',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(14770002399669615)
,p_computation_sequence=>10
,p_computation_item=>'P33_STATIC_ID_1'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'flows-for-apex-purge-completed-instances'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(4886405701142240)
,p_computation_sequence=>120
,p_computation_item=>'P33_STATIC_ID'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'STATIC_ASSIGNMENT'
,p_computation=>'flows-for-apex-daily-instance-archive'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(3746400769530328)
,p_name=>'On dialog close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(3512936201851742)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(3746576221530329)
,p_event_id=>wwv_flow_imp.id(3746400769530328)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(3746146895530325)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(3747022152530334)
,p_name=>'On Refresh JSON'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(3746146895530325)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(3747195167530335)
,p_event_id=>wwv_flow_imp.id(3747022152530334)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'Prism.highlightAll();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(4886604122139954)
,p_name=>'Close Dialog - Automation'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(9479602182841663)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(4887009223139953)
,p_event_id=>wwv_flow_imp.id(4886604122139954)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'window.location.reload();'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(3176434129223085)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_archiving_settings(',
'  pi_archiving_enabled           => :P33_LOGGING_ARCHIVE_ENABLED',
', pi_completed_prcs_purging     => :P33_COMPLETED_PRCS_PURGING      ',
', pi_completed_prcs_purge_days  => :P33_COMPLETED_PRCS_PURGE_DAYS',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(3164119045223081)
,p_process_success_message=>'Changes saved.'
,p_internal_uid=>3176434129223085
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4891568334128002)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(9479602182841663)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Configuration - Archiving'
,p_internal_uid=>4891568334128002
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14770181791669616)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(14768878313669603)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Configuration - Archiving - Instance Ourging'
,p_internal_uid=>14770181791669616
);
wwv_flow_imp.component_end;
end;
/
