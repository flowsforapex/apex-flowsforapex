prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
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
 p_id=>30
,p_name=>'Configuration - REST'
,p_alias=>'CONFIGURATION-REST'
,p_step_title=>'Configuration - REST'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2362908411158415)
,p_plug_name=>'Content'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>'return flow_rest_install.is_rest_enabled and flow_rest_install.is_module_published;'
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2343931822104541)
,p_plug_name=>'OAUTH Clients'
,p_parent_plug_id=>wwv_flow_imp.id(2362908411158415)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select oc.id',
'     , oc.name',
'     , oc.description',
'     , oc.client_id',
'     , oc.support_uri',
'     , oc.support_email',
'  from user_ords_clients oc'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'ORDS Client Report'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(2344349165104542)
,p_name=>'Report 1'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_actions_menu=>'N'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'C'
,p_enable_mail_download=>'N'
,p_detail_link=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:RP,:P31_ID:#ID#'
,p_detail_link_text=>'<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_owner=>'C##JDOPPELREITER'
,p_internal_uid=>2344349165104542
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2362185830158407)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'L'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2344837977104545)
,p_db_column_name=>'NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2345216929104546)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2346812012104546)
,p_db_column_name=>'CLIENT_ID'
,p_display_order=>40
,p_column_identifier=>'G'
,p_column_label=>'Client Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2348040743104547)
,p_db_column_name=>'SUPPORT_EMAIL'
,p_display_order=>60
,p_column_identifier=>'J'
,p_column_label=>'Support Email'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(2348409591104547)
,p_db_column_name=>'SUPPORT_URI'
,p_display_order=>70
,p_column_identifier=>'K'
,p_column_label=>'Support Uri'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(2358966194119402)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'23590'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NAME:DESCRIPTION:CLIENT_ID:SUPPORT_EMAIL:SUPPORT_URI'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4722613539681901)
,p_plug_name=>'Configuration'
,p_parent_plug_id=>wwv_flow_imp.id(2362908411158415)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2363080166158416)
,p_plug_name=>'Prerequisites missing'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info'
,p_plug_template=>wwv_flow_imp.id(12495613507239880288)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>'return not flow_rest_install.is_rest_enabled or not flow_rest_install.is_module_published;'
,p_plug_display_when_cond2=>'PLSQL'
,p_plug_header=>'<ul>'
,p_plug_footer=>'</ul>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2363132666158417)
,p_plug_name=>'Not REST Enabled'
,p_parent_plug_id=>wwv_flow_imp.id(2363080166158416)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>'<li>Schema is not REST Enabled</li>'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>'return not flow_rest_install.is_rest_enabled;'
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2363247042158418)
,p_plug_name=>'Module missing'
,p_parent_plug_id=>wwv_flow_imp.id(2363080166158416)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>'<li>REST module not installed. Please follow the installation guide at: <a href="https://flowsforapex.org/latest/installation" target="_blank">https://flowsforapex.org/latest/installation</a></li>'
,p_plug_display_condition_type=>'FUNCTION_BODY'
,p_plug_display_when_condition=>'return not flow_rest_install.is_module_published;'
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(19992522503359785)
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
 p_id=>wwv_flow_imp.id(2353415432104550)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(2343931822104541)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'EDIT'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:31:&SESSION.::&DEBUG.:31'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4723087919681905)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(4722613539681901)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'EDIT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'return flow_rest_install.is_rest_enabled and flow_rest_install.is_module_published;'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'FUNCTION_BODY'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4722790490681902)
,p_name=>'P30_LOGGING_REST_INCOMING_CALLS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(4722613539681901)
,p_prompt=>'Log Incoming Rest Calls'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4722861639681903)
,p_name=>'P30_LOGGING_REST_RETAIN_LOGS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(4722613539681901)
,p_prompt=>'Retain Logs (Days)'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>5
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_03=>'right'
,p_attribute_04=>'text'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(5655634694360001)
,p_name=>'P30_BASE_URL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(4722613539681901)
,p_prompt=>'Base-URL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(5655772217360002)
,p_computation_sequence=>10
,p_computation_item=>'P30_BASE_URL'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_rest_constants.c_config_prefix || flow_rest_constants.c_config_key_base',
'         , p_default_value => null',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(4723201073681907)
,p_computation_sequence=>20
,p_computation_item=>'P30_LOGGING_REST_INCOMING_CALLS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_rest_logging.c_log_rest_incoming',
'         , p_default_value => flow_rest_logging.c_log_rest_incoming_default',
'       );'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(4723389675681908)
,p_computation_sequence=>30
,p_computation_item=>'P30_LOGGING_REST_RETAIN_LOGS'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key =>  flow_rest_logging.c_log_rest_incoming_retain_days',
'         , p_default_value => flow_rest_logging.c_log_rest_incoming_retain_days_default',
'       );'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(2352493486104549)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(2343931822104541)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(2352945371104550)
,p_event_id=>wwv_flow_imp.id(2352493486104549)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(2343931822104541)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4723167093681906)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Config'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_rest_install.set_base_url( pi_base_url => :P30_BASE_URL );',
'',
'flow_rest_logging.set_logging_config( pi_log_rest_incoming         => :P30_LOGGING_REST_INCOMING_CALLS',
'                                    , pi_log_rest_incoming_retain  => :P30_LOGGING_REST_RETAIN_LOGS );'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(4723087919681905)
,p_process_when=>'return flow_rest_install.is_rest_enabled and flow_rest_install.is_module_published;'
,p_process_when_type=>'FUNCTION_BODY'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'Rest Configuration saved!'
,p_internal_uid=>4723167093681906
);
wwv_flow_imp.component_end;
end;
/
