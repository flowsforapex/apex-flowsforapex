prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Monitor'
,p_alias=>'FLOW-MONITOR'
,p_step_title=>'Flow Monitor - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'initPage10();'
,p_step_template=>wwv_flow_api.id(12495618547053880299)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20210908122118'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6177850959209923)
,p_plug_name=>'Instance Action'
,p_region_name=>'instance_action_dialog'
,p_region_css_classes=>'f4a-dynamic-title'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7938158412499704)
,p_plug_name=>'Action Menu'
,p_region_name=>'actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_list_id=>wwv_flow_api.id(7946860874526805)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34403200187171418)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495573047450880221)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12495520300515880126)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6127698437330102702)
,p_plug_name=>'Flow Viewer'
,p_region_name=>'flow-monitor'
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_VW'
,p_query_where=>'prcs_id = :p10_prcs_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION'
,p_ajax_items_to_submit=>'P10_PRCS_ID,P10_PRCS_NAME'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_no_data_found=>'No process selected'
,p_attribute_01=>'DGRM_CONTENT'
,p_attribute_02=>'ALL_CURRENT'
,p_attribute_04=>'ALL_COMPLETED'
,p_attribute_06=>'ALL_ERRORS'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_attribute_10=>'Y'
,p_attribute_11=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12493545854579486121)
,p_plug_name=>'Flow Instances'
,p_region_name=>'flow-instances'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_INSTANCES_VW'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P10_PRCS_ID,P10_PRCS_NAME'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Flow Instances'
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
wwv_flow_api.create_worksheet(
 p_id=>wwv_flow_api.id(26094211779304629)
,p_max_row_count=>'1000000'
,p_max_rows_per_page=>'1000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_LEFT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'FLOWS4APEX'
,p_internal_uid=>26094211779304629
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(25020107643509605)
,p_db_column_name=>'VIEW_PROCESS'
,p_display_order=>10
,p_column_identifier=>'K'
,p_column_label=>'Viewer'
,p_column_html_expression=>'<span class="clickable-action id-ref fa fa-eye" data-prcs="#PRCS_ID#" data-action="view-flow-instance" data-name="#PRCS_NAME#" title="View Process Instance"></span>'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'view-process'
,p_rpt_show_filter_lov=>'N'
,p_display_condition_type=>'NEVER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094452210304631)
,p_db_column_name=>'PRCS_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Flow Name'
,p_column_link=>'javascript:void(0);'
,p_column_linktext=>'#PRCS_NAME#'
,p_column_link_attr=>'title="View" class="view-link" data-prcs="#PRCS_ID#" data-name="#PRCS_NAME#"'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_static_id=>'PRCS_NAME'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094567431304632)
,p_db_column_name=>'PRCS_DGRM_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094640100304633)
,p_db_column_name=>'PRCS_DGRM_VERSION'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Version'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094739199304634)
,p_db_column_name=>'PRCS_DGRM_STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Flow Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094816603304635)
,p_db_column_name=>'PRCS_DGRM_CATEGORY'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Flow Category'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094928056304636)
,p_db_column_name=>'PRCS_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="prcs_status_badge"><i class="status_icon fa #PRCS_STATUS_ICON#"></i>#PRCS_STATUS#</span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'instance_status_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26095045075304637)
,p_db_column_name=>'PRCS_INIT_DATE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Creation Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26095177493304638)
,p_db_column_name=>'PRCS_LAST_UPDATE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Last Update'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26095284298304639)
,p_db_column_name=>'BTN'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon js-menuButton" id="instance-header-action" data-menu="instance_header_action_menu"><span aria-hidden="true" class="t-Icon fa fa-bars"></span><'
||'/button>'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon flow-instance-actions-btn js-menuButton" ',
'        data-menu="instance_row_action_menu"',
'        data-prcs="#PRCS_ID#"',
'        data-status="#PRCS_STATUS#"',
'        data-name="#PRCS_NAME#"',
'        data-dgrm="#PRCS_DGRM_ID#"',
'        >',
'    <span aria-hidden="true" class="t-Icon fa fa-bars"></span>',
'</button>'))
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_static_id=>'instance_action_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26094328735304630)
,p_db_column_name=>'PRCS_ID'
,p_display_order=>110
,p_column_identifier=>'A'
,p_column_label=>'Process ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34631054458575812)
,p_db_column_name=>'PRCS_BUSINESS_REF'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Business Reference'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7938514653499708)
,p_db_column_name=>'PRCS_DGRM_ID'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Prcs Dgrm Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(40002069571317110)
,p_db_column_name=>'CHECKBOX'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'<input type="checkbox" id="check-all-instances">'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_static_id=>'instance_checkbox_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6176739527209912)
,p_db_column_name=>'PRCS_STATUS_ICON'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Prcs Status Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8024079343825609)
,p_db_column_name=>'QUICK_ACTION'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Quick Action'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" class="t-Button t-Button--icon t-Button--iconLeft t-Button--link js-actionButton"',
'data-prcs="#PRCS_ID#" data-action="open-flow-instance-details">',
'<span aria-hidden="true" class="t-Icon t-Icon--left fa fa-search"></span>Details</button>'))
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_static_id=>'quick_action_col'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(26608389028834346)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'266084'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>10
,p_report_columns=>'CHECKBOX:BTN:QUICK_ACTION:VIEW_PROCESS:PRCS_NAME:PRCS_BUSINESS_REF:PRCS_DGRM_CATEGORY:PRCS_DGRM_NAME:PRCS_DGRM_VERSION:PRCS_STATUS:PRCS_INIT_DATE:PRCS_LAST_UPDATE:'
,p_sort_column_1=>'PRCS_DGRM_CATEGORY'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'PRCS_NAME'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'PRCS_DGRM_VERSION'
,p_sort_direction_3=>'DESC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_break_on=>'PRCS_DGRM_CATEGORY:0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0:PRCS_DGRM_CATEGORY'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2436340351881201)
,p_plug_name=>'Instances - Header Actions'
,p_region_name=>'instance_header_action'
,p_parent_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(2431522092873048)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40001946826317109)
,p_plug_name=>'Instances - Row Actions'
,p_region_name=>'instance_row_action'
,p_parent_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(40423692118997018)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12491866636991262848)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(34403200187171418)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create new Instance'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:RP,11::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6178284555209927)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(6177850959209923)
,p_button_name=>'CONFIRM'
,p_button_static_id=>'confirm-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Confirm'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_button_cattributes=>'data-action="" data-prcs="" data-sbfl="" data-no-update="true"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7937992279499702)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(34403200187171418)
,p_button_name=>'ACTION_MENU'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_button_image_alt=>'Action Menu'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-menuButton'
,p_icon_css_classes=>'fa-bars'
,p_button_cattributes=>'data-menu="actions_menu"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6179972139209944)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(6177850959209923)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34569800907098125)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_button_name=>'RESET_INSTANCE_IR'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RP,10,RIR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2448762581538242)
,p_name=>'P10_OBJT_BPMN_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(6127698437330102702)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2448870230538243)
,p_name=>'P10_OBJT_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(6127698437330102702)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5522035116864941)
,p_name=>'P10_OBJT_LIST'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6127698437330102702)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6177010376209915)
,p_name=>'P10_OBJT_SBFL_LIST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(6127698437330102702)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6177972762209924)
,p_name=>'P10_COMMENT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6177850959209923)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6179426398209939)
,p_name=>'P10_CONFIRM_TEXT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6177850959209923)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(12495523037429880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7334592520307027)
,p_name=>'P10_PRCS_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34634208559575844)
,p_name=>'P10_DISPLAY_SETTING'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(34403200187171418)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12491864731021262829)
,p_name=>'P10_PRCS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160797771746501981)
,p_name=>'Create Process Dialog closed - refresh Instances'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12491866636991262848)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33737253943406143)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PRCS_ID'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P11_PRCS_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6433779174417647)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PRCS_NAME'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P11_PRCS_NAME'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797694678501980)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(12493545854579486121)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8023336794825602)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6127698437330102702)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(29602959246125302)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'apex.message.showPageSuccess(apex.lang.getMessage("APP_INSTANCE_CREATED"));'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(25020236512509606)
,p_name=>'Create Process Dialog (Report) closed - refresh Instances'
,p_event_sequence=>110
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(12493545854579486121)
,p_bind_type=>'live'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33737390268406144)
,p_event_id=>wwv_flow_api.id(25020236512509606)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_PRCS_ID'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P11_PRCS_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(25020304399509607)
,p_event_id=>wwv_flow_api.id(25020236512509606)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(12493545854579486121)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33737098416406141)
,p_event_id=>wwv_flow_api.id(25020236512509606)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(apex.lang.getMessage("APP_INSTANCE_CREATED"));'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24414763832878706)
,p_name=>'Instances Report Refreshed'
,p_event_sequence=>150
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(12493545854579486121)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24414806355878707)
,p_event_id=>wwv_flow_api.id(24414763832878706)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6127698437330102702)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var prcsId= apex.item( "P10_PRCS_ID" ).getValue();',
'if (prcsId !== "" ) { ',
'  markAsCurrent( prcsId ); ',
'}',
'',
'$("th.a-IRR-header").each(function(i){',
'    if ( apex.jQuery(this).attr("id") === undefined) {',
'      apex.jQuery(this).find(''input[type="checkbox"]'').hide();',
'      apex.jQuery(this).find(''button#instance-header-action'').hide();',
'    } else {',
'      apex.jQuery(this).addClass("u-alignMiddle");',
'    }',
'});',
'',
'$("td[headers*=instance_status_col]").each(function() {',
'  var text = $( this ).text();',
'  if ( text == "created" ) {',
'    $( this ).addClass( "ffa-color--created" );',
'  } else if ( text == "completed" ) {',
'    $( this ).addClass( "ffa-color--completed" );',
'  } else if ( text == "running" ) {',
'    $( this ).addClass( "ffa-color--running" );',
'  } else if ( text == "terminated" ) {',
'    $( this ).addClass( "ffa-color--terminated" );',
'  } else if ( text == "error" ) {',
'    $( this ).addClass( "ffa-color--error" );',
'  }',
'});',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24417684477878735)
,p_name=>'Viewer Refreshed'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6127698437330102702)
,p_condition_element=>'P10_PRCS_NAME'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8023271170825601)
,p_event_id=>wwv_flow_api.id(24417684477878735)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' apex',
'    .jQuery( "#flow-monitor_heading" )',
'    .text( apex.lang.getMessage("APP_VIEWER_TITLE_NO_PROCESS") );'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(33736700260406138)
,p_event_id=>wwv_flow_api.id(24417684477878735)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var prcsId = apex.item("P10_PRCS_ID").getValue();',
'var prcsName = apex.item("P10_PRCS_NAME").getValue();',
'apex',
'    .jQuery( "#flow-monitor_heading" )',
'    .text( apex.lang.formatMessage("APP_VIEWER_TITLE_PROCESS_SELECTED", prcsName) );',
'',
'if ( apex.item("P10_DISPLAY_SETTING").getValue() === "window" ) {',
'    redirectToMonitor("view-flow-instance", prcsId);',
'}'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5522598629864946)
,p_event_id=>wwv_flow_api.id(24417684477878735)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_OBJT_LIST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct listagg(OBJT_BPMN_ID, '':'') within group (order by OBJT_BPMN_ID) "OBJT_ID"',
'from FLOW_OBJECTS',
'where OBJT_DGRM_ID = (select PRCS_DGRM_ID from FLOW_PROCESSES where PRCS_ID = :P10_PRCS_ID)',
'and not OBJT_TAG_NAME in (''bpmn:process'', ''bpmn:subProcess'', ''bpmn:textAnnotation'', ''bpmn:participant'', ''bpmn:laneSet'', ''bpmn:lane'');'))
,p_attribute_07=>'P10_PRCS_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6177386168209918)
,p_event_id=>wwv_flow_api.id(24417684477878735)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_OBJT_SBFL_LIST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct listagg(OBJT_BPMN_ID, '':'') within group (order by OBJT_BPMN_ID) "OBJT_ID"',
'from FLOW_OBJECTS',
'where OBJT_DGRM_ID = (select PRCS_DGRM_ID from FLOW_PROCESSES where PRCS_ID = :P10_PRCS_ID)',
'and OBJT_TAG_NAME = ''bpmn:subProcess'''))
,p_attribute_07=>'P10_PRCS_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5522653812864947)
,p_event_id=>wwv_flow_api.id(24417684477878735)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var objects = $v(''P10_OBJT_LIST'').split('':'');',
'$.each(objects, function( index, value ) {',
'    $( "[data-element-id=''" + value + "'']").css( "cursor", "pointer" );',
'})'))
,p_da_action_comment=>'Apply pointer cursor to clickable elements'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5522150485864942)
,p_name=>'Element clicked'
,p_event_sequence=>240
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6127698437330102702)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(''P10_OBJT_LIST'').split('':'').includes(this.data.element.id);'
,p_bind_type=>'bind'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_element_click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2448959260538244)
,p_event_id=>wwv_flow_api.id(5522150485864942)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_OBJT_BPMN_ID'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.element.id'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2449082180538245)
,p_event_id=>wwv_flow_api.id(5522150485864942)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_OBJT_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct OBJT_NAME',
'from FLOW_OBJECTS',
'where OBJT_BPMN_ID = :P10_OBJT_BPMN_ID'))
,p_attribute_07=>'P10_OBJT_BPMN_ID'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5522263817864943)
,p_event_id=>wwv_flow_api.id(5522150485864942)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var title = $v(''P10_OBJT_BPMN_ID'') + ($v(''P10_OBJT_NAME'').length > 0 ? '' - '' + $v(''P10_OBJT_NAME'') : '''');',
'',
'apex.server.process(',
'    ''PREPARE_URL'',                           ',
'    {',
'        x01: $v(''P10_PRCS_ID''),',
'        x02: this.data.element.id,',
'        x03: title',
'    }, ',
'    {',
'        success: function (pData)',
'        {           ',
'            apex.navigation.redirect(pData);',
'        },',
'        dataType: "text"                     ',
'    }',
');'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34634407162575846)
,p_name=>'On Change Display Setting'
,p_event_sequence=>260
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_DISPLAY_SETTING'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34634644617575848)
,p_event_id=>wwv_flow_api.id(34634407162575846)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Save user preference',
'apex_util.set_preference(''VIEWPORT'',:P10_DISPLAY_SETTING);'))
,p_attribute_02=>'P10_DISPLAY_SETTING'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(4300450048764256)
,p_name=>'Change check-all-instances'
,p_event_sequence=>270
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#check-all-instances'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(4300813188764310)
,p_event_id=>wwv_flow_api.id(4300450048764256)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($(''#flow-instances #check-all-instances'' ).is('':checked'') ) {',
'      $(''#flow-instances input[type=checkbox][name=f01]'').prop(''checked'',true);',
'     } else {',
'     $(''#flow-instances input[type=checkbox][name=f01]'').prop(''checked'',false);',
' } '))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6177414128209919)
,p_name=>'Subflow clicked'
,p_event_sequence=>280
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6127698437330102702)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(''P10_OBJT_SBFL_LIST'').split('':'').includes(this.data.element.id);'
,p_bind_type=>'bind'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_element_click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6177633863209921)
,p_event_id=>wwv_flow_api.id(6177414128209919)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var objects = $v(''P10_OBJT_LIST'').split('':'');',
'$.each(objects, function( index, value ) {',
'    $( "[data-element-id=''" + value + "'']").css( "cursor", "pointer" );',
'})'))
,p_da_action_comment=>'Apply pointer cursor to clickable elements inside opened subflow'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6180087025209945)
,p_name=>'Cancel Dialog'
,p_event_sequence=>290
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(6179972139209944)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6180129920209946)
,p_event_id=>wwv_flow_api.id(6180087025209945)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(6177850959209923)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8023857502825607)
,p_name=>'Click on Flow Name'
,p_event_sequence=>300
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.view-link'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'#flow-instances'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8023966198825608)
,p_event_id=>wwv_flow_api.id(8023857502825607)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.actions.invoke("view-flow-instance", "", this.triggeringElement);'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(33735382808406124)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Viewport for BPMN-Viewer'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Load user preference for the BPMN-Viewer and set it after the page has fully loaded',
'declare',
'    l_script varchar2(4000);',
'begin',
'',
'    -- Set IDs for the the row divs',
'    l_script := q''#apex.jQuery("#flow-instances").parent().attr("id","col1");',
'                   apex.jQuery("#flow-monitor").parent().attr("id","col2");#'';',
'    ',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE (',
'        p_code => l_script,',
'        p_key  => ''init_viewport'');',
'',
'    :P10_DISPLAY_SETTING := nvl(apex_util.get_preference(''VIEWPORT''),''column'');',
'    ',
'    l_script := null;',
'    -- Set view to side-by-side if preference = ''column''',
'    if :P10_DISPLAY_SETTING = ''column'' then',
'    ',
'        l_script := q''#apex.jQuery( "#col1" ).addClass( "col-6" ).removeClass( [ "col-12", "col-end" ] );',
'                       apex.jQuery( "#col2" ).addClass( "col-6" ).removeClass( [ "col-12", "col-start" ] );',
'                       apex.jQuery("#col2").appendTo(apex.jQuery("#col1").parent());',
'                       apex.jQuery("#flow-monitor").show();',
'                       apex.region( "flow-monitor" ).refresh();#'';',
'     elsif :P10_DISPLAY_SETTING = ''window'' then',
'        l_script := q''#apex.jQuery("#flow-monitor").hide();',
'                       apex.jQuery( "#col1" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );',
'                       apex.jQuery( "#col2" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );#'';',
'    end if;',
'    ',
'    if l_script is not null then',
'        APEX_JAVASCRIPT.ADD_ONLOAD_CODE (',
'            p_code => l_script,',
'            p_key  => ''viewport''',
'        );',
'    end if;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5522324613864944)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PREPARE_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_url varchar2(2000);',
'    l_app number := v(''APP_ID'');',
'    l_session number := v(''APP_SESSION'');',
'',
'BEGIN',
'    l_url := APEX_UTIL.PREPARE_URL(',
'        p_url => ''f?p='' || l_app || '':13:'' || l_session ||''::NO:RP:P13_PRCS_ID,P13_OBJT_ID,P13_TITLE:''|| apex_application.g_x01 || '','' || apex_application.g_x02 || '','' || apex_application.g_x03,',
'        p_checksum_type => ''SESSION'');',
'    htp.p(l_url);',
'END;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
