prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
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
 p_id=>22
,p_name=>'Ad Hoc Activities'
,p_alias=>'AD-HOC-ACTIVITIES'
,p_page_mode=>'MODAL'
,p_step_title=>'Ad Hoc Activities'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_IMAGES#lib/prismjs/js/prism.js'
,p_javascript_code_onload=>'initPage22();'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.col-no-wrap {',
'    text-wrap: nowrap;',
'}'))
,p_step_template=>wwv_flow_imp.id(9977787507536054)
,p_page_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd:js-dialog-class-t-Drawer--xl'
,p_protection_level=>'C'
,p_page_component_map=>'23'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(16803482167123702)
,p_plug_name=>'Startable Activities'
,p_region_template_options=>'#DEFAULT#:t-ContentBlock--h3'
,p_plug_template=>wwv_flow_imp.id(12495598315850880248)
,p_plug_display_sequence=>70
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20034979759645870)
,p_plug_name=>'Ad Hoc Activities - Cards'
,p_region_name=>'adhoc-activities'
,p_parent_plug_id=>wwv_flow_imp.id(16803482167123702)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(1792064716043263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0022_STARTABLE_ADHOC_ACTIVITIES_VW'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'subproc_bpmn_id = :P22_SUBPROCESS_BPMN_ID and',
'subproc_step_key = :P22_SUBPROC_STEP_KEY and',
'dgrm_id = :P22_DGRM_ID'))
,p_query_order_by_type=>'STATIC'
,p_query_order_by=>'ACTIVITY_DISPLAY_ORDER'
,p_include_rowid_column=>false
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_ajax_items_to_submit=>'P22_SUBPROCESS_BPMN_ID,P22_SUBPROC_STEP_KEY,P22_DGRM_ID'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_no_data_found=>'No Startable Activities Now'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(21785465464192737)
,p_region_id=>wwv_flow_imp.id(20034979759645870)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'ACTIVITY_NAME'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>false
,p_body_column_name=>'ACTIVITY_DESCRIPTION'
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ACTIVITY_ICON'
,p_icon_position=>'START'
,p_icon_description=>'&ACTIVITY_TAG_NAME.'
,p_badge_column_name=>'BADGE_LABEL'
,p_badge_css_classes=>'&BADGE_CSS_CLASS.'
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(21785533403192738)
,p_card_id=>wwv_flow_imp.id(21785465464192737)
,p_action_type=>'BUTTON'
,p_position=>'SECONDARY'
,p_display_sequence=>10
,p_label=>'Start'
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:23:&SESSION.::&DEBUG.:23:P23_ACTIVITY_BPMN_ID,P23_ACTIVITY_NAME,P23_DGRM_ID,P23_PRCS_ID,P23_SBFL_ID:&ACTIVITY_BPMN_ID.,&ACTIVITY_NAME.,&DGRM_ID.,&PRCS_ID.,&SUBPROC_SBFL_ID.'
,p_button_display_type=>'TEXT'
,p_is_hot=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(16803577815123703)
,p_plug_name=>'Started Activities'
,p_region_template_options=>'#DEFAULT#:t-ContentBlock--h3'
,p_plug_template=>wwv_flow_imp.id(12495598315850880248)
,p_plug_display_sequence=>80
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20042766778654206)
,p_plug_name=>'Started Ad Hoc Activities '
,p_region_name=>'started-adhoc-activities'
,p_parent_plug_id=>wwv_flow_imp.id(16803577815123703)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495584334308880235)
,p_plug_display_sequence=>90
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0022_STARTED_ADHOC_ACTIVITIES_VW'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    prcs_id           = :P22_PRCS_ID',
'and subproc_bpmn_id   = :P22_SUBPROCESS_BPMN_ID',
'and subproc_step_key  = :P22_SUBPROC_STEP_KEY'))
,p_query_order_by_type=>'STATIC'
,p_query_order_by=>'status desc, start_time'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P22_PRCS_ID,P22_SUBPROCESS_BPMN_ID,P22_SUBPROC_STEP_KEY'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
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
 p_id=>wwv_flow_imp.id(20042829107654207)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'No started activities'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'RALLEN2010@GMAIL.COM'
,p_internal_uid=>20042829107654207
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20042996027654208)
,p_db_column_name=>'SBFL_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Sbfl Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043049277654209)
,p_db_column_name=>'PRCS_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Prcs Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043161633654210)
,p_db_column_name=>'DGRM_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Dgrm Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043230948654211)
,p_db_column_name=>'SUBPROC_BPMN_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Subproc Bpmn Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043315912654212)
,p_db_column_name=>'SUBPROC_SBFL_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Subproc Sbfl Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043423097654213)
,p_db_column_name=>'SUBPROC_STEP_KEY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Subproc Step Key'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043547723654214)
,p_db_column_name=>'STARTING_OBJECT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Starting Object'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043675718654215)
,p_db_column_name=>'STARTING_OBJECT_NAME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Starting Object Name'
,p_column_html_expression=>'<span class="col-no-wrap">#STARTING_OBJECT_NAME#</span>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043797818654216)
,p_db_column_name=>'STARTING_STEP_KEY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Starting Step Key'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043876303654217)
,p_db_column_name=>'REPEAT_COUNT'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Repeat Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20043980239654218)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="sbfl_status_badge"><i class="status_icon fa #STATUS_ICON#"></i>#STATUS#</span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'started-adhoc-activities-status-col'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(21785624989192739)
,p_db_column_name=>'STATUS_ICON'
,p_display_order=>120
,p_column_identifier=>'P'
,p_column_label=>'Status Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20044003120654219)
,p_db_column_name=>'START_TIME'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Start Time'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20044154072654220)
,p_db_column_name=>'COMPLETE_TIME'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Complete Time'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20044205895654221)
,p_db_column_name=>'INPUTS'
,p_display_order=>150
,p_column_identifier=>'N'
,p_column_label=>'Inputs'
,p_column_html_expression=>'{if INPUTS/}<pre><code class="language-json">#INPUTS#</code></pre>{endif/}'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'CLOB'
,p_heading_alignment=>'LEFT'
,p_rpt_show_filter_lov=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(20044373269654222)
,p_db_column_name=>'OUTPUTS'
,p_display_order=>160
,p_column_identifier=>'O'
,p_column_label=>'Outputs'
,p_column_html_expression=>'{if OUTPUTS/}<pre><code class="language-json">#OUTPUTS#</code></pre>{endif/}'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'CLOB'
,p_heading_alignment=>'LEFT'
,p_rpt_show_filter_lov=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(20090304772210529)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'200904'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STARTING_OBJECT_NAME:STARTING_STEP_KEY:REPEAT_COUNT:STATUS:START_TIME:COMPLETE_TIME:INPUTS:OUTPUTS:'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(20044469144654223)
,p_button_sequence=>100
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Close'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20042266213654201)
,p_name=>'P22_SUBPROCESS_BPMN_ID'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20042353825654202)
,p_name=>'P22_DGRM_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20042485537654203)
,p_name=>'P22_PRCS_ID'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20042535409654204)
,p_name=>'P22_SBFL_ID'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20042659812654205)
,p_name=>'P22_SUBPROC_STEP_KEY'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(20044512769654224)
,p_name=>'Close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(20044469144654223)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(20044627679654225)
,p_event_id=>wwv_flow_imp.id(20044512769654224)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Close'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(22454301098378831)
,p_name=>'Started Activities Report Refreshed'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(16803577815123703)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(22454751270378839)
,p_event_id=>wwv_flow_imp.id(22454301098378831)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(16803577815123703)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$("td[headers*=started-adhoc-activities-status-col]").each(function () {',
'  var statusText = $(this).text().trim().toLowerCase();',
'  var statusSlug = statusText.replace(/\s+/g, "-");',
'  var className = "ffa-color--" + statusSlug;',
'  $(this).addClass(className);',
'});',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(21786099948192743)
,p_event_id=>wwv_flow_imp.id(22454301098378831)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Prism'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(20042766778654206)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Prism.highlightAll();',
'apex.event.trigger("body", "apexwindowresized");'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(21785875255192741)
,p_name=>'Dialog Closed'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(16803482167123702)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(21785920148192742)
,p_event_id=>wwv_flow_imp.id(21785875255192741)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(20042766778654206)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(21786184314192744)
,p_event_id=>wwv_flow_imp.id(21785875255192741)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(20034979759645870)
);
wwv_flow_imp.component_end;
end;
/
