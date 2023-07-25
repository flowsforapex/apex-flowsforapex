prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Management'
,p_alias=>'FLOW-MANAGEMENT'
,p_step_title=>'Flow Management - &APP_NAME_TITLE.'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'initPage2();'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'C##LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20230725093110'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5522803511864949)
,p_plug_name=>'Action Menu'
,p_region_name=>'actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_list_id=>wwv_flow_api.id(7927640106409064)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7938769092499710)
,p_plug_name=>'Copy Model'
,p_region_name=>'copy_flow_reg'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24213241311956116)
,p_plug_name=>'Flow Management'
,p_region_name=>'parsed_drgm'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0002_DIAGRAMS_VW'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Flow Management'
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
 p_id=>wwv_flow_api.id(24214476360956128)
,p_max_row_count=>'1000000'
,p_max_rows_per_page=>'1000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLSX:PDF:RTF'
,p_owner=>'FLOWS4APEX'
,p_internal_uid=>24214476360956128
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214554954956129)
,p_db_column_name=>'DGRM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214647255956130)
,p_db_column_name=>'DGRM_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214759985956131)
,p_db_column_name=>'DGRM_VERSION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Version'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214844713956132)
,p_db_column_name=>'DGRM_STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ffa-dgrm-badge">',
'    <i class="#DGRM_STATUS_ICON#"></i>',
'    <span class="ffa-dgrm-badge-text">#DGRM_STATUS#</span>',
'</div>'))
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2496678063177011)
,p_db_column_name=>'DGRM_STATUS_ICON'
,p_display_order=>50
,p_column_identifier=>'Z'
,p_column_label=>'Dgrm Status Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214982358956133)
,p_db_column_name=>'DGRM_CATEGORY'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Category'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215092633956134)
,p_db_column_name=>'DGRM_LAST_UPDATE'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Last Update'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215123061956135)
,p_db_column_name=>'BTN'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'<button type="button" title="&APP_TEXT$APP_P2_HEADER_BUTTON_TITLE." aria-label="&APP_TEXT$APP_P2_HEADER_BUTTON_TITLE." class="t-Button t-Button--noLabel t-Button--icon js-menuButton" id="header-action" data-menu="header_actions_menu"><span aria-hidde'
||'n="true" class="t-Icon fa fa-bars"></span></button>'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" title="&APP_TEXT$APP_P2_ROW_BUTTON_TITLE." aria-label="&APP_TEXT$APP_P2_ROW_BUTTON_TITLE." class="t-Button t-Button--noLabel t-Button--icon js-menuButton" ',
'        data-menu="row_actions_menu"',
'        data-dgrm="#DGRM_ID#">',
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
,p_static_id=>'action_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215292671956136)
,p_db_column_name=>'INSTANCES'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Instances'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RIR,RP:IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION:#DGRM_NAME#,#DGRM_VERSION#'
,p_column_linktext=>'#INSTANCES#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26092727630304614)
,p_db_column_name=>'DIAGRAM_PARSED'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Flow Parsed'
,p_column_html_expression=>'<span aria-hidden="true" class="fa #DIAGRAM_PARSED_ICON#"></span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26093269879304619)
,p_db_column_name=>'DIAGRAM_PARSED_ICON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Diagram Parsed Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34401608353171402)
,p_db_column_name=>'INSTANCE_CREATED'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'<i class="status_icon fa fa-plus-circle-o" data-status="created"></i>&APP_TEXT$APP_STATUS_CREATED.'
,p_column_html_expression=>'<a href=#INSTANCE_CREATED_LINK#>#INSTANCE_CREATED#</a>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34401735853171403)
,p_db_column_name=>'INSTANCE_RUNNING'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'<i class="status_icon fa fa-play-circle-o" data-status="running"></i>&APP_TEXT$APP_STATUS_RUNNING.'
,p_column_html_expression=>'<a href=#INSTANCE_RUNNING_LINK#>#INSTANCE_RUNNING#</a>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34401808911171404)
,p_db_column_name=>'INSTANCE_COMPLETED'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'<i class="status_icon fa fa-check-circle-o" data-status="completed"></i>&APP_TEXT$APP_STATUS_COMPLETED.'
,p_column_html_expression=>'<a href=#INSTANCE_COMPLETED_LINK#>#INSTANCE_COMPLETED#</a>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34403520844171421)
,p_db_column_name=>'INSTANCE_TERMINATED'
,p_display_order=>150
,p_column_identifier=>'T'
,p_column_label=>'<i class="status_icon fa fa-stop-circle-o" data-status="terminated"></i>&APP_TEXT$APP_STATUS_TERMINATED.'
,p_column_html_expression=>'<a href=#INSTANCE_TERMINATED_LINK#>#INSTANCE_TERMINATED#</a>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34401973271171405)
,p_db_column_name=>'INSTANCE_ERROR'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'<i class="status_icon fa fa-exclamation-circle-o" data-status="error"></i>&APP_TEXT$APP_STATUS_ERROR.'
,p_column_html_expression=>'<a href=#INSTANCE_ERROR_LINK#>#INSTANCE_ERROR#</a>'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34402061088171406)
,p_db_column_name=>'INSTANCE_CREATED_LINK'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Instance Created Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34403349213171419)
,p_db_column_name=>'INSTANCE_RUNNING_LINK'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Instance Running Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34403481804171420)
,p_db_column_name=>'INSTANCE_COMPLETED_LINK'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Instance Completed Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34403626861171422)
,p_db_column_name=>'INSTANCE_TERMINATED_LINK'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Instance Terminated Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34403765313171423)
,p_db_column_name=>'INSTANCE_ERROR_LINK'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Instance Error Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34631762547575819)
,p_db_column_name=>'EDIT_LINK'
,p_display_order=>220
,p_column_identifier=>'W'
,p_column_label=>'Edit Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34631865848575820)
,p_db_column_name=>'CREATE_INSTANCE_LINK'
,p_display_order=>230
,p_column_identifier=>'X'
,p_column_label=>'Create Instance Link'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(34632066723575822)
,p_db_column_name=>'CHECKBOX'
,p_display_order=>240
,p_column_identifier=>'Y'
,p_column_label=>'<input type="checkbox" id="check-all">'
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
,p_static_id=>'checkbox_col'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(26034946443441850)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'260350'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECKBOX:BTN:DGRM_NAME:DGRM_VERSION:DGRM_STATUS:DGRM_CATEGORY:DGRM_LAST_UPDATE:INSTANCE_CREATED:INSTANCE_RUNNING:INSTANCE_COMPLETED:INSTANCE_TERMINATED:INSTANCE_ERROR:'
,p_sort_column_1=>'DGRM_CATEGORY'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'DGRM_NAME'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'DGRM_VERSION'
,p_sort_direction_3=>'DESC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
,p_break_on=>'DGRM_CATEGORY:0:0:0:0:0'
,p_break_enabled_on=>'0:0:0:0:0:DGRM_CATEGORY'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(11245398850667810)
,p_report_id=>wwv_flow_api.id(26034946443441850)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'DIAGRAM_PARSED'
,p_operator=>'='
,p_expr=>'Yes'
,p_condition_sql=>'"DIAGRAM_PARSED" = #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# = ''Yes''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34402625223171412)
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
 p_id=>wwv_flow_api.id(34634863225575850)
,p_plug_name=>'Row Action Menu'
,p_region_name=>'row_actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609667684880263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(39902352324857428)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(40001574962317105)
,p_plug_name=>'Header Action Menu'
,p_region_name=>'header_actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609667684880263)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(40402255178815218)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(71488161436297107)
,p_plug_name=>'New Version'
,p_region_name=>'new_version_reg'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7938939101499712)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(7938769092499710)
,p_button_name=>'COPY_MODEL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Copy Model'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26400953036736995)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(71488161436297107)
,p_button_name=>'ADD_VERSION'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Version'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-chevron-circle-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24212654778956110)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(34402625223171412)
,p_button_name=>'CREATE_MODEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--padRight'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create Model'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5522753745864948)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(34402625223171412)
,p_button_name=>'ACTION_MENU'
,p_button_static_id=>'action-menu-btn'
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
 p_id=>wwv_flow_api.id(34403897960171424)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(24213241311956116)
,p_button_name=>'RESET'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:RP,2,RIR::'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(34632313238575825)
,p_branch_name=>'Go To Page 5'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_MULTI:Y&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'EXPORT_FLOW'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(40001200556317102)
,p_branch_action=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7:P7_DGRM_ID:&P2_DGRM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'EDIT_FLOW'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7938841081499711)
,p_name=>'P2_NEW_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7938769092499710)
,p_prompt=>'New Name/Suffix'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_inline_help_text=>'In case of single model copy, the new model will have the entered name but if you have selected more than one row then the value entered will be used as a suffix.'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(15356359428942511)
,p_name=>'P2_BULK_ACTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(24213241311956116)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26093937239304626)
,p_name=>'P2_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(24213241311956116)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26401222533737000)
,p_name=>'P2_NEW_VERSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(71488161436297107)
,p_prompt=>'New Version'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(26401796293739221)
,p_validation_name=>'Flow exists (bulk new version)'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_app_api.validate_flow_exists_bulk(',
'  pi_dgrm_id_list => :P2_DGRM_ID',
', pi_new_version => :P2_NEW_VERSION',
');'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>':request = ''ADD_VERSION'' and :P2_BULK_ACTION = ''Y'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_api.id(26401222533737000)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(15356574500942513)
,p_validation_name=>'Flow exists (new version)'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_app_api.validate_flow_exists(',
'  pi_dgrm_id => :P2_DGRM_ID',
', pi_new_version => :P2_NEW_VERSION',
');'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>':request = ''ADD_VERSION'' and :P2_BULK_ACTION = ''N'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_api.id(26401222533737000)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(40001878906317108)
,p_validation_name=>'Flow exists (bulk copy)'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_app_api.validate_flow_copy_bulk(',
'  pi_dgrm_id_list => :P2_DGRM_ID',
', pi_new_name => :P2_NEW_NAME',
');'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>':request = ''COPY_MODEL'' and :P2_BULK_ACTION = ''Y'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_api.id(7938841081499711)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(15356425922942512)
,p_validation_name=>'Flow exists (copy)'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_app_api.validate_flow_copy(',
'  pi_new_name => :P2_NEW_NAME',
');'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>':request = ''COPY_MODEL'' and :P2_BULK_ACTION = ''N'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_associated_item=>wwv_flow_api.id(7938841081499711)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(15356651838942514)
,p_validation_name=>'New name is not null'
,p_validation_sequence=>50
,p_validation=>'P2_NEW_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'#LABEL# must have a value.'
,p_validation_condition=>'COPY_MODEL'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_api.id(7938841081499711)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(15356707920942515)
,p_validation_name=>'New version is not null'
,p_validation_sequence=>60
,p_validation=>'P2_NEW_VERSION'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'#LABEL# must have a value.'
,p_validation_condition=>'ADD_VERSION'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_api.id(26401222533737000)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(19019347638332911)
,p_name=>'Imported - Refresh Report'
,p_event_sequence=>30
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#actions_menu'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.data.dialogPageId == "6"'
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19023277699332950)
,p_event_id=>wwv_flow_api.id(19019347638332911)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess(apex.lang.getMessage("APP_MODEL_IMPORTED"));'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26091408686304601)
,p_event_id=>wwv_flow_api.id(19019347638332911)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(24213241311956116)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(26093728782304624)
,p_name=>'Clickable Action clicked - Forward to Process or Selection'
,p_event_sequence=>80
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.clickable-action'
,p_bind_type=>'live'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26093894432304625)
,p_event_id=>wwv_flow_api.id(26093728782304624)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myElement = apex.jQuery( this.triggeringElement );',
'var myAction  = myElement.data( "action" );',
'var myDiagram = myElement.data( "dgrm" );',
'',
'apex.item( "P2_DGRM_ID" ).setValue( myDiagram );',
'',
'switch (myAction) {',
'    case ''new_version'': {',
'        apex.item( "P2_NEW_VERSION" ).setValue( "" );',
'        apex.theme.openRegion( "new_version_reg" );    ',
'        break;',
'    }',
'    case ''copy_flow'': {',
'        apex.item( "P2_NEW_NAME" ).setValue( "" );',
'        apex.theme.openRegion( "copy_flow_reg" );    ',
'        break;',
'    }',
'}',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34718198447581242)
,p_name=>'Dialog closed - Refresh Report & Show Success'
,p_event_sequence=>90
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(24213241311956116)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34718524685581254)
,p_event_id=>wwv_flow_api.id(34718198447581242)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(24213241311956116)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34719055685581256)
,p_event_id=>wwv_flow_api.id(34718198447581242)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if (this.data.successMessage !== undefined) {',
'    apex.message.showPageSuccess(this.data.successMessage.text);',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5521840396864939)
,p_name=>'Flow Management Report refreshed'
,p_event_sequence=>100
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(24213241311956116)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5521906942864940)
,p_event_id=>wwv_flow_api.id(5521840396864939)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$("#parsed_drgm table th.a-IRR-header--group").attr("colspan", "6").after(''<th colspan="5" class="a-IRR-header a-IRR-header--group" id="instances_column_group_heading" style="text-align: center;">Instances</th>'');',
'',
'$( ".a-IRR-headerLabel, .a-IRR-headerLink" ).each( function () {',
'      var status = $( this ).children("i").data("status");',
'      if ( status == "created" ) {',
'        $( this ).parent().addClass( "ffa-color--created" );',
'      } else if ( status == "completed" ) {',
'        $( this ).parent().addClass( "ffa-color--completed" );',
'      } else if ( status == "running" ) {',
'        $( this ).parent().addClass( "ffa-color--running" );',
'      } else if ( status == "terminated" ) {',
'        $( this ).parent().addClass( "ffa-color--terminated" );',
'      } else if ( status == "error" ) {',
'        $( this ).parent().addClass( "ffa-color--error" );',
'      }',
'    } );',
'',
'//if ($("li.a-IRR-controls-item--controlBreak").length > 0) {',
'if ($("th.a-IRR-header--group").length > 0) {',
'    $("th").each(function(i){',
'        if ( apex.jQuery(this).attr("id") === undefined) {',
'            apex.jQuery(this).find(''input[type="checkbox"]'').hide();',
'            apex.jQuery(this).find(''button#header-action'').hide();',
'        } else {',
'            apex.jQuery(this).addClass("u-alignMiddle");',
'        }',
'    });',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(40001392180317103)
,p_name=>'Change checkAll'
,p_event_sequence=>110
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#check-all'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(40001401094317104)
,p_event_id=>wwv_flow_api.id(40001392180317103)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($(''#parsed_drgm #check-all'' ).is('':checked'') ) {',
'      $(''#parsed_drgm input[type=checkbox][name=f01]'').prop(''checked'',true);',
'     } else {',
'     $(''#parsed_drgm input[type=checkbox][name=f01]'').prop(''checked'',false);',
' } '))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26094153642304628)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add new version'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.add_new_version(',
'  pi_dgrm_id_list => :P2_DGRM_ID',
', pi_new_version => :P2_NEW_VERSION',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'ADD_VERSION'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'&APP_TEXT$APP_NEW_VERSION_ADDED.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(7939199045499714)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Copy Model'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.copy_model(',
'  pi_dgrm_id_list => :P2_DGRM_ID',
', pi_new_name => :P2_NEW_NAME',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'COPY_MODEL'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'&APP_TEXT$APP_MODEL_COPIED.'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(34632414579575826)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Selection in Collection'
,p_process_sql_clob=>'flow_engine_app_api.copy_selection_to_collection;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'EXPORT_FLOW,ADD_VERSION,COPY_FLOW'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
null;
wwv_flow_api.component_end;
end;
/
