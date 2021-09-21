prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
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
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Instance Details'
,p_alias=>'FLOW-INSTANCE-DETAILS'
,p_step_title=>'Flow Instance Details  - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_IMAGES#lib/prismjs/js/prism.js'
,p_javascript_code=>'initPage8();'
,p_step_template=>wwv_flow_api.id(12495618547053880299)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20210915150346'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5681179787037011)
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
 p_id=>wwv_flow_api.id(5681250057037012)
,p_plug_name=>'Flow Instance'
,p_region_name=>'instance-data'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_PROCESSES'
,p_include_rowid_column=>false
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(5684323221037043)
,p_plug_name=>'Instance Details'
,p_region_name=>'flow-reports'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6433334615417643)
,p_plug_name=>'Instance Details'
,p_parent_plug_id=>wwv_flow_api.id(5684323221037043)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--scrollBody:margin-bottom-none'
,p_plug_template=>wwv_flow_api.id(12495604368136880259)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(5682136171037021)
,p_name=>'Instance Details'
,p_region_name=>'flow-instance-detail'
,p_parent_plug_id=>wwv_flow_api.id(6433334615417643)
,p_template=>wwv_flow_api.id(12495613507239880288)
,p_display_sequence=>10
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--customIcons:t-Alert--info:t-Alert--accessibleHeading:margin-bottom-none'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0008_INSTANCE_DETAILS_VW'
,p_query_where=>'prcs_id = :P8_PRCS_ID'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P8_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495548550946880181)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8023653162825605)
,p_query_column_id=>1
,p_column_alias=>'PRCS_ID'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8023758985825606)
,p_query_column_id=>2
,p_column_alias=>'PRCS_NAME'
,p_column_display_sequence=>1
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5683820665037038)
,p_query_column_id=>3
,p_column_alias=>'FLOW_DIAGRAM'
,p_column_display_sequence=>2
,p_column_heading=>'Flow Diagram'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5683966799037039)
,p_query_column_id=>4
,p_column_alias=>'STATUS'
,p_column_display_sequence=>3
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5684069475037040)
,p_query_column_id=>5
,p_column_alias=>'INITIALIZED_ON'
,p_column_display_sequence=>4
,p_column_heading=>'Initialized On'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5684163968037041)
,p_query_column_id=>6
,p_column_alias=>'LAST_UPDATE_ON'
,p_column_display_sequence=>5
,p_column_heading=>'Last Update On'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5684296657037042)
,p_query_column_id=>7
,p_column_alias=>'BUSINESS_REFERENCE'
,p_column_display_sequence=>8
,p_column_heading=>'Business Reference'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8024125104825610)
,p_plug_name=>'Instance Events'
,p_parent_plug_id=>wwv_flow_api.id(5684323221037043)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495604368136880259)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(29001516138505995)
,p_plug_name=>'Instance Events'
,p_region_name=>'flow-instance-events'
,p_parent_plug_id=>wwv_flow_api.id(8024125104825610)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0008_INSTANCE_LOG_VW'
,p_query_where=>'lgpr_prcs_id = :P8_PRCS_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Instance Events'
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
 p_id=>wwv_flow_api.id(13471539909181525)
,p_max_row_count=>'1000000'
,p_max_rows_per_page=>'20'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'DAMTHOR'
,p_internal_uid=>13471539909181525
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8318159619792316)
,p_db_column_name=>'LGPR_PRCS_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Lgpr Prcs Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8318543391792317)
,p_db_column_name=>'LGPR_PRCS_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Name'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8318997702792318)
,p_db_column_name=>'LGPR_BUSINESS_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Business Reference'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8319379673792319)
,p_db_column_name=>'LGPR_PRCS_EVENT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Event'
,p_column_html_expression=>'<span class="prcs_event_badge"><i class="status_icon fa #LGPR_PRCS_EVENT_ICON#"></i>#LGPR_PRCS_EVENT#</span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'instance_event_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8319757479792319)
,p_db_column_name=>'LGPR_TIMESTAMP'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Timestamp'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8320162530792319)
,p_db_column_name=>'LGPR_USER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'User'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8320570260792319)
,p_db_column_name=>'LGPR_COMMENT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8321340756792320)
,p_db_column_name=>'LGPR_ERROR_INFO'
,p_display_order=>80
,p_column_identifier=>'J'
,p_column_label=>'Error Stack'
,p_column_html_expression=>'#PRETAG##LGPR_ERROR_INFO##POSTTAG#'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8320935355792320)
,p_db_column_name=>'LGPR_PRCS_EVENT_ICON'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Lgpr Prcs Event Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8028177005825650)
,p_db_column_name=>'PRETAG'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Pretag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12631588555220601)
,p_db_column_name=>'POSTTAG'
,p_display_order=>110
,p_column_identifier=>'L'
,p_column_label=>'Posttag'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(13861584261230054)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'83217'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>20
,p_report_columns=>'LGPR_USER:LGPR_TIMESTAMP:LGPR_PRCS_EVENT:LGPR_COMMENT::LGPR_PRCS_EVENT_ICON:LGPR_ERROR_INFO:PRETAG:POSTTAG'
,p_sort_column_1=>'LGPR_TIMESTAMP'
,p_sort_direction_1=>'DESC'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(30368937979343097)
,p_plug_name=>'Tab Holder'
,p_parent_plug_id=>wwv_flow_api.id(5684323221037043)
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_api.id(12495575615770880223)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8392311025345610)
,p_plug_name=>'Variables'
,p_region_name=>'process-variables'
,p_parent_plug_id=>wwv_flow_api.id(30368937979343097)
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0008_VARIABLES_VW'
,p_query_where=>'prov_prcs_id = :P8_PRCS_iD'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Variables'
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
 p_id=>wwv_flow_api.id(8393401240345621)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'LMOREAUX'
,p_internal_uid=>8393401240345621
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5974128075464466)
,p_db_column_name=>'PROV_PRCS_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Process ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5974553661464467)
,p_db_column_name=>'PROV_VAR_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5974908646464467)
,p_db_column_name=>'PROV_VAR_TYPE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5975357132464467)
,p_db_column_name=>'PROV_VAR_VALUE'
,p_display_order=>40
,p_column_identifier=>'H'
,p_column_label=>'Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_static_id=>'prov_var_value'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5975755489464467)
,p_db_column_name=>'CHECKBOX'
,p_display_order=>50
,p_column_identifier=>'I'
,p_column_label=>'<input type="checkbox" id="check-all-variables">'
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
,p_static_id=>'variable_checkbox_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5976199322464468)
,p_db_column_name=>'ACTION'
,p_display_order=>60
,p_column_identifier=>'J'
,p_column_label=>'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon js-menuButton" data-menu="variable_header_action_menu"><span aria-hidden="true" class="t-Icon fa fa-bars"></span></button>'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon variable-actions-btn js-menuButton" ',
'data-menu="variable_row_action_menu"',
'data-name="#PROV_VAR_NAME#"',
'data-type="#PROV_VAR_TYPE#"',
'data-prcs="#PROV_PRCS_ID#"',
'data-gateway-route="#IS_GATEWAY_ROUTE#"',
'>',
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
,p_column_alignment=>'CENTER'
,p_static_id=>'variable_action_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(6432711704417637)
,p_db_column_name=>'IS_GATEWAY_ROUTE'
,p_display_order=>70
,p_column_identifier=>'K'
,p_column_label=>'Is Gateway Route'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(10983804979667357)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'59765'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECKBOX:ACTION:PROV_VAR_NAME:PROV_VAR_TYPE:PROV_VAR_VALUE::IS_GATEWAY_ROUTE'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6432353612417633)
,p_plug_name=>'Variables - Row Actions'
,p_region_name=>'variable_row_action'
,p_parent_plug_id=>wwv_flow_api.id(8392311025345610)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(7074608790273038)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6433033616417640)
,p_plug_name=>'Variables - Header Actions'
,p_region_name=>'variable_header_action'
,p_parent_plug_id=>wwv_flow_api.id(8392311025345610)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(7390393853616382)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(166753193485966384)
,p_plug_name=>'Subflows'
,p_region_name=>'subflows'
,p_parent_plug_id=>wwv_flow_api.id(30368937979343097)
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0008_SUBFLOWS_VW'
,p_query_where=>'sbfl_prcs_id = :P8_PRCS_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_document_header=>'APEX'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Subflows'
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
 p_id=>wwv_flow_api.id(8390422207345591)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'LMOREAUX'
,p_internal_uid=>8390422207345591
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5958060753464437)
,p_db_column_name=>'SBFL_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Subflow ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5958314416464441)
,p_db_column_name=>'SBFL_PRCS_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Process ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5958746107464441)
,p_db_column_name=>'SBFL_CURRENT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Current'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5959198304464442)
,p_db_column_name=>'SBFL_STARTING_OBJECT'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Starting Object'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5959540044464442)
,p_db_column_name=>'SBFL_LAST_UPDATE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Last Update'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5959935453464442)
,p_db_column_name=>'SBFL_STATUS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="sbfl_status_badge"><i class="status_icon fa #SBFL_STATUS_ICON#"></i>#SBFL_STATUS#</span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'subflow_status_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5960359099464442)
,p_db_column_name=>'SBFL_CURRENT_LANE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Lane'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5960748117464443)
,p_db_column_name=>'SBFL_RESERVATION'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Reserved For'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5961953081464444)
,p_db_column_name=>'ACTIONS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon js-menuButton" data-menu="subflow_header_action_menu"><span aria-hidden="true" class="t-Icon fa fa-bars"></span></button>'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon subflow-actions-btn js-menuButton" ',
'data-menu="subflow_row_action_menu"',
'data-prcs="#SBFL_PRCS_ID#"',
'data-sbfl="#SBFL_ID#"',
'data-status="#SBFL_STATUS#"',
'data-reservation="#SBFL_RESERVATION#">',
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
,p_column_alignment=>'CENTER'
,p_static_id=>'subflow_action_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5962397543464444)
,p_db_column_name=>'CHECKBOX'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'<input type="checkbox" id="check-all-subflows">'
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
,p_static_id=>'subflow_checkbox_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8025464938825623)
,p_db_column_name=>'QUICK_ACTION_ICON'
,p_display_order=>130
,p_column_identifier=>'N'
,p_column_label=>'Quick Action Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8025569156825624)
,p_db_column_name=>'QUICK_ACTION'
,p_display_order=>140
,p_column_identifier=>'O'
,p_column_label=>'Quick Action'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" class="t-Button t-Button--icon t-Button--link t-Button--iconLeft js-actionButton" ',
'data-prcs="#SBFL_PRCS_ID#" data-sbfl="#SBFL_ID#" data-action="#QUICK_ACTION#">',
'    <span aria-hidden="true" class="t-Icon t-Icon--left fa #QUICK_ACTION_ICON#"></span>#QUICK_ACTION_LABEL#',
'</button>'))
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'quick_action_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8025669951825625)
,p_db_column_name=>'QUICK_ACTION_LABEL'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Quick Action Label'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7335900830307041)
,p_db_column_name=>'SBFL_STATUS_ICON'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Sbfl Status Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(8498061205860315)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'59631'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECKBOX:ACTIONS:QUICK_ACTION:SBFL_CURRENT:SBFL_LAST_UPDATE:SBFL_STATUS:SBFL_CURRENT_LANE:SBFL_RESERVATION::QUICK_ACTION_LABEL:SBFL_STATUS_ICON'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(11261908176020193)
,p_report_id=>wwv_flow_api.id(8498061205860315)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'SBFL_STATUS'
,p_operator=>'in'
,p_expr=>'running,error'
,p_condition_sql=>'"SBFL_STATUS" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''running, error''  '
,p_enabled=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8367243423910488)
,p_plug_name=>'Subflows - Row Actions'
,p_region_name=>'subflow_row_action'
,p_parent_plug_id=>wwv_flow_api.id(166753193485966384)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(2407587958394790)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8392021138345607)
,p_plug_name=>'Subflows - Header Actions'
,p_region_name=>'subflow_header_action'
,p_parent_plug_id=>wwv_flow_api.id(166753193485966384)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions:js-menu-callout'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_list_id=>wwv_flow_api.id(4409050172512221)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8354985158946288)
,p_plug_name=>'Add Gateway Route'
,p_region_name=>'gateway_selector'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size600x400'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8391710661345604)
,p_plug_name=>'Reserve Step'
,p_region_name=>'reservation_dialog'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8394514514345632)
,p_plug_name=>'Add/Edit Process Variable'
,p_region_name=>'variable_dialog'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size600x400'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13245209048329626)
,p_plug_name=>'Instance Action'
,p_region_name=>'instance_action_dialog'
,p_region_css_classes=>'f4a-dynamic-title'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>80
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13891898475964091)
,p_plug_name=>'Action Menu'
,p_region_name=>'actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_list_id=>wwv_flow_api.id(6338940478461643)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6133652177393567089)
,p_plug_name=>'Flow Viewer'
,p_region_name=>'flow-monitor'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0008_VW'
,p_query_where=>'prcs_id = :P8_PRCS_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION'
,p_ajax_items_to_submit=>'P8_PRCS_ID'
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5981427830464471)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8391710661345604)
,p_button_name=>'RESERVE_STEP'
,p_button_static_id=>'reserve-step-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Reserve'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_button_cattributes=>'data-action="" data-prcs="" data-sbfl="" data-no-update="true"'
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
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5954728604464411)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(8354985158946288)
,p_button_name=>'UNSELECT'
,p_button_static_id=>'unselect_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Unselect all'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5955186680464411)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(8354985158946288)
,p_button_name=>'SELECT'
,p_button_static_id=>'select_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Select all'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5955586107464411)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8354985158946288)
,p_button_name=>'ADD_PROV_VAR_ROUTE'
,p_button_static_id=>'add-prov-var-route-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_icon_css_classes=>'fa-plus'
,p_button_cattributes=>'data-action="add-process-variable" data-gateway-route="true"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5982997862464473)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8394514514345632)
,p_button_name=>'ADD_PROV_VAR'
,p_button_static_id=>'add-prov-var-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_icon_css_classes=>'fa-plus'
,p_button_cattributes=>'data-action="add-process-variable" data-gateway-route="false"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5954353112464407)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(8354985158946288)
,p_button_name=>'SAVE_PROV_VAR_ROUTE'
,p_button_static_id=>'save-prov-var-route-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_icon_css_classes=>'fa-save'
,p_button_cattributes=>'data-action="update-process-variable" data-gateway-route="true"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5982517441464472)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(8394514514345632)
,p_button_name=>'SAVE_PROV_VAR'
,p_button_static_id=>'save-prov-var-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_icon_css_classes=>'fa-save'
,p_button_cattributes=>'data-action="update-process-variable" data-gateway-route="false"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(6431406612417624)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(5681179787037011)
,p_button_name=>'SHOW_HISTORY'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Show History'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_icon_css_classes=>'fa-info-circle-o'
,p_button_cattributes=>'data-action="flow-instance-audit" data-prcs="&P8_PRCS_ID." data-name="&P8_PRCS_NAME."'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5978892614464469)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(5681179787037011)
,p_button_name=>'ACTION_MENU'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_button_image_alt=>'Action Menu'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-menuButton'
,p_icon_css_classes=>'fa-bars'
,p_button_cattributes=>'data-menu="actions_menu" data-prcs="&P8_PRCS_ID." data-dgrm="&P8_PRCS_DGRM_ID." data-name="&P8_PRCS_NAME."'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7068041536119722)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(13245209048329626)
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
 p_id=>wwv_flow_api.id(7067605023119721)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(13245209048329626)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5963945833464455)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(166753193485966384)
,p_button_name=>'RESET_SUBFLOW_IR'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:RP,8,RIR:P8_PRCS_ID:&P8_PRCS_ID.'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5977760271464469)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(8392311025345610)
,p_button_name=>'ADD_GATEWAY_ROUTE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Add Gateway Route'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P8_PRCS_STATUS'
,p_button_condition2=>'created:running:error'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_button_css_classes=>'js-hide-no-prcs js-actionButton'
,p_button_cattributes=>'data-action="add-process-variable" data-gateway-route="true"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5976915633464468)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(8392311025345610)
,p_button_name=>'ADD_PROCESS_VARIABLE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Process Variable'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P8_PRCS_STATUS'
,p_button_condition2=>'created:running:error'
,p_button_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_button_css_classes=>'js-hide-no-prcs js-actionButton'
,p_icon_css_classes=>'fa-plus'
,p_button_cattributes=>'data-action="add-process-variable" data-gateway-route="false"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5977391209464468)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(8392311025345610)
,p_button_name=>'RESET_VARIABLE_IR'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Reset'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:RP,8,RIR:P8_PRCS_ID:&P8_PRCS_ID.'
,p_icon_css_classes=>'fa-undo-alt'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5681449489037014)
,p_name=>'P8_PRCS_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(5681250057037012)
,p_item_source_plug_id=>wwv_flow_api.id(5681250057037012)
,p_source=>'PRCS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5681551841037015)
,p_name=>'P8_PRCS_DGRM_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(5681250057037012)
,p_item_source_plug_id=>wwv_flow_api.id(5681250057037012)
,p_source=>'PRCS_DGRM_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5681628052037016)
,p_name=>'P8_PRCS_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(5681250057037012)
,p_item_source_plug_id=>wwv_flow_api.id(5681250057037012)
,p_source=>'PRCS_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5681710279037017)
,p_name=>'P8_PRCS_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(5681250057037012)
,p_item_source_plug_id=>wwv_flow_api.id(5681250057037012)
,p_source=>'PRCS_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5681806442037018)
,p_name=>'P8_PRCS_INIT_TS'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(5681250057037012)
,p_item_source_plug_id=>wwv_flow_api.id(5681250057037012)
,p_source=>'PRCS_INIT_TS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5681957862037019)
,p_name=>'P8_PRCS_LAST_UPDATE'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(5681250057037012)
,p_item_source_plug_id=>wwv_flow_api.id(5681250057037012)
,p_source=>'PRCS_LAST_UPDATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5955943099464415)
,p_name=>'P8_SELECT_OPTION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8354985158946288)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5956326391464421)
,p_name=>'P8_GATEWAY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8354985158946288)
,p_prompt=>'Gateway'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'P8_INSTANCE_GATEWAYS_LOV'
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P8_PRCS_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5956770983464421)
,p_name=>'P8_CONNECTION'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(8354985158946288)
,p_prompt=>'Connection'
,p_display_as=>'NATIVE_CHECKBOX'
,p_named_lov=>'P8_INSTANCE_CONNECTIONS_LOV'
,p_lov_cascade_parent_items=>'P8_PRCS_ID,P8_GATEWAY'
,p_ajax_optimize_refresh=>'Y'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'2'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5972826023464463)
,p_name=>'P8_SBFL_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(166753193485966384)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5979272276464470)
,p_name=>'P8_DISPLAY_SETTING'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6133652177393567089)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5979971726464470)
,p_name=>'P8_OBJT_LIST'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6133652177393567089)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5980365397464471)
,p_name=>'P8_OBJT_BPMN_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(6133652177393567089)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5980714077464471)
,p_name=>'P8_OBJT_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(6133652177393567089)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5981800867464472)
,p_name=>'P8_RESERVATION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8391710661345604)
,p_prompt=>'Reservation'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5983384367464473)
,p_name=>'P8_PROV_VAR_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_prompt=>'Variable Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5983769209464473)
,p_name=>'P8_PROV_VAR_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_item_default=>'VARCHAR2'
,p_prompt=>'Type'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Varchar2;VARCHAR2,Number;NUMBER,Date;DATE,Clob;CLOB'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'4'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5984111734464474)
,p_name=>'P8_PROV_VAR_VC2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_prompt=>'Value'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5984552376464474)
,p_name=>'P8_PROV_VAR_NUM'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_prompt=>'Value'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_03=>'right'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5984956372464474)
,p_name=>'P8_PROV_VAR_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_prompt=>'Value'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_04=>'button'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5985303463464474)
,p_name=>'P8_PROV_VAR_CLOB'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_prompt=>'Value'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6180288422209947)
,p_name=>'P8_OBJT_SBFL_LIST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(6133652177393567089)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6429631498417606)
,p_name=>'P8_PROV_VAR_DATE_VALID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6429967240417609)
,p_name=>'P8_PROV_VAR_NUM_VALID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7068442550119727)
,p_name=>'P8_CONFIRM_TEXT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(13245209048329626)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(12495523037429880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7068819919119733)
,p_name=>'P8_COMMENT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13245209048329626)
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5996686614464519)
,p_name=>'Subflows Report refreshed - Mark currently running'
,p_event_sequence=>140
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(166753193485966384)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5997186082464520)
,p_event_id=>wwv_flow_api.id(5996686614464519)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var runningSelector = "button.clickable-action";',
'var processRows = apex.jQuery( "#subflows tr" );',
'',
'processRows.has( runningSelector ).addClass( "flow-running" );',
'',
'apex.jQuery(".subflow-actions-btn").each(function(){',
'  var sbflStatus = apex.jQuery(this).data("status");',
'  apex.jQuery(this).prop("disabled", sbflStatus === "running" || sbflStatus === "error" ? false : true );',
'});',
'',
'$("td[headers*=subflow_status_col]").each(function() {',
'    var className = ''ffa-color--'' + $(this).text();',
'    $(this).addClass(className);',
'  }',
');',
'',
'$("th.a-IRR-header").each(function(i){',
'    if ( apex.jQuery(this).attr("id") === undefined) {',
'      apex.jQuery(this).find(''input[type="checkbox"]'').hide();',
'      apex.jQuery(this).find(''button#subflow-header-action'').hide();',
'    } else {',
'      apex.jQuery(this).addClass("u-alignMiddle");',
'    }',
'});'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6011636562464528)
,p_name=>'Viewer Refreshed'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6133652177393567089)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6012103981464528)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var prcsId = apex.item("P8_PRCS_ID").getValue();',
'var selectedView  = apex.item("P8_DISPLAY_SETTING").getValue();',
'',
'if ( prcsId !== "" && selectedView === "window") {',
'    redirectToMonitor("view-flow-instance", prcsId);',
'}'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6006917102464525)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_OBJT_LIST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct listagg(OBJT_BPMN_ID, '':'') within group (order by OBJT_BPMN_ID) "OBJT_ID"',
'from FLOW_OBJECTS',
'where OBJT_DGRM_ID = (select PRCS_DGRM_ID from FLOW_PROCESSES where PRCS_ID = :P8_PRCS_ID)',
'and not OBJT_TAG_NAME in (''bpmn:process'', ''bpmn:subProcess'', ''bpmn:textAnnotation'', ''bpmn:participant'', ''bpmn:laneSet'', ''bpmn:lane'');'))
,p_attribute_07=>'P8_PRCS_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6180336771209948)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_OBJT_SBFL_LIST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct listagg(OBJT_BPMN_ID, '':'') within group (order by OBJT_BPMN_ID) "OBJT_ID"',
'from FLOW_OBJECTS',
'where OBJT_DGRM_ID = (select PRCS_DGRM_ID from FLOW_PROCESSES where PRCS_ID = :P8_PRCS_ID)',
'and OBJT_TAG_NAME = ''bpmn:subProcess'''))
,p_attribute_07=>'P8_PRCS_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6180462025209949)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var objects = $v(''P8_OBJT_LIST'').split('':'');',
'$.each(objects, function( index, value ) {',
'    $( "[data-element-id=''" + value + "'']").css( "cursor", "pointer" );',
'})'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6014453052464529)
,p_name=>'Set Connection Select Option '
,p_event_sequence=>190
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_GATEWAY'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6014962408464530)
,p_event_id=>wwv_flow_api.id(6014453052464529)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_SELECT_OPTION'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select select_option',
'from flow_instance_gateways_lov',
'where objt_bpmn_id = :P8_GATEWAY',
'and prcs_id = :P8_PRCS_ID'))
,p_attribute_07=>'P8_GATEWAY,P8_PRCS_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(5998415156464520)
,p_name=>'Select all connection'
,p_event_sequence=>200
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(5955186680464411)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5998953651464521)
,p_event_id=>wwv_flow_api.id(5998415156464520)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery("#P8_CONNECTION").find(''input[type="checkbox"]'').toArray().forEach(function(e) {',
'  e.checked = true;',
'});'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5999457497464521)
,p_event_id=>wwv_flow_api.id(5998415156464520)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5955186680464411)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(5999918515464521)
,p_event_id=>wwv_flow_api.id(5998415156464520)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5954728604464411)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6000312821464522)
,p_name=>'Unselect all connection'
,p_event_sequence=>210
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(5954728604464411)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6000816148464522)
,p_event_id=>wwv_flow_api.id(6000312821464522)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery("#P8_CONNECTION").find(''input[type="checkbox"]'').toArray().forEach(function(e) {',
'  e.checked = false;',
'});'))
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6001349512464522)
,p_event_id=>wwv_flow_api.id(6000312821464522)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5954728604464411)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6001834654464522)
,p_event_id=>wwv_flow_api.id(6000312821464522)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5955186680464411)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6002207343464522)
,p_name=>'Display Button Based on Gateway Type'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_SELECT_OPTION'
,p_condition_element=>'P8_SELECT_OPTION'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'multi'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6002775114464523)
,p_event_id=>wwv_flow_api.id(6002207343464522)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5955186680464411)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6003299003464523)
,p_event_id=>wwv_flow_api.id(6002207343464522)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5955186680464411)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6004548451464524)
,p_name=>'Element clicked'
,p_event_sequence=>240
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6133652177393567089)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(''P8_OBJT_LIST'').split('':'').includes(this.data.element.id);'
,p_bind_type=>'bind'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_element_click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6005591668464524)
,p_event_id=>wwv_flow_api.id(6004548451464524)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_OBJT_BPMN_ID'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.element.id'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6006044910464525)
,p_event_id=>wwv_flow_api.id(6004548451464524)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_OBJT_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct OBJT_NAME',
'from FLOW_OBJECTS',
'where OBJT_BPMN_ID = :P8_OBJT_BPMN_ID'))
,p_attribute_07=>'P8_OBJT_BPMN_ID'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6005023363464524)
,p_event_id=>wwv_flow_api.id(6004548451464524)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var title = $v(''P8_OBJT_BPMN_ID'') + ($v(''P8_OBJT_NAME'').length > 0 ? '' - '' + $v(''P8_OBJT_NAME'') : '''');',
'',
'apex.server.process(',
'    ''PREPARE_URL'',                           ',
'    {',
'        x01: $v(''P8_PRCS_ID''),',
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
 p_id=>wwv_flow_api.id(6006494525464525)
,p_name=>'Subflow clicked'
,p_event_sequence=>250
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6133652177393567089)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'$v(''P8_OBJT_SBFL_LIST'').split('':'').includes(this.data.element.id);'
,p_bind_type=>'bind'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_element_click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6007443076464526)
,p_event_id=>wwv_flow_api.id(6006494525464525)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var objects = $v(''P8_OBJT_LIST'').split('':'');',
'$.each(objects, function( index, value ) {',
'    $( "[data-element-id=''" + value + "'']").css( "cursor", "pointer" );',
'})'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6007809031464526)
,p_name=>'On Change Display Setting'
,p_event_sequence=>260
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_DISPLAY_SETTING'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6008377992464526)
,p_event_id=>wwv_flow_api.id(6007809031464526)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Save user preference',
'apex_util.set_preference(''VIEWPORT'',:P8_DISPLAY_SETTING);',
''))
,p_attribute_02=>'P8_DISPLAY_SETTING'
,p_wait_for_result=>'Y'
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
 p_id=>wwv_flow_api.id(6008810667464526)
,p_event_id=>wwv_flow_api.id(6007809031464526)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(166753193485966384)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6016280779464530)
,p_name=>'Change check-all-subflows'
,p_event_sequence=>280
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#check-all-subflows'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6016777800464530)
,p_event_id=>wwv_flow_api.id(6016280779464530)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($(''#subflows #check-all-subflows'' ).is('':checked'') ) {',
'      $(''#subflows input[type=checkbox][name=f02]'').prop(''checked'',true);',
'     } else {',
'     $(''#subflows input[type=checkbox][name=f02]'').prop(''checked'',false);',
' } '))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6432898825417638)
,p_name=>'Change check-all-variables'
,p_event_sequence=>290
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#check-all-variables'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6432965813417639)
,p_event_id=>wwv_flow_api.id(6432898825417638)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($(''#process-variables #check-all-variables'' ).is('':checked'') ) {',
'      $(''#process-variables input[type=checkbox][name=f03]'').prop(''checked'',true);',
'     } else {',
'     $(''#process-variables input[type=checkbox][name=f03]'').prop(''checked'',false);',
' } '))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6017148201464531)
,p_name=>'On Change Variable Type'
,p_event_sequence=>300
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_PROV_VAR_TYPE'
,p_condition_element=>'P8_PROV_VAR_TYPE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6017642167464531)
,p_event_id=>wwv_flow_api.id(6017148201464531)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var varType = apex.item("P8_PROV_VAR_TYPE").getValue();',
'apex.item("P8_PROV_VAR_VC2").hide();',
'apex.item("P8_PROV_VAR_NUM").hide();',
'apex.item("P8_PROV_VAR_DATE").hide();',
'apex.item("P8_PROV_VAR_CLOB").hide();',
'switch(varType) {',
'    case "VARCHAR2" : ',
'        apex.item("P8_PROV_VAR_VC2").show();',
'        break;',
'    case "NUMBER":',
'        apex.item("P8_PROV_VAR_NUM").show();',
'        break;',
'    case "DATE":',
'        apex.item("P8_PROV_VAR_DATE").show();',
'        break;',
'    case "CLOB":',
'        apex.item("P8_PROV_VAR_CLOB").show();',
'        break;',
'    default:',
'        break;',
'}',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6027025508464536)
,p_name=>'Variables Report Refreshed'
,p_event_sequence=>310
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(8392311025345610)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6027533621464536)
,p_event_id=>wwv_flow_api.id(6027025508464536)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$("th.a-IRR-header").each(function(i){',
'    if ( apex.jQuery(this).attr("id") === undefined) {',
'      apex.jQuery(this).find(''input[type="checkbox"]'').hide();',
'      apex.jQuery(this).find(''button#variables_ir-header-action'').hide();',
'    } else {',
'      apex.jQuery(this).addClass("u-alignMiddle");',
'    }',
'});'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6429724013417607)
,p_name=>'On change Prov Var Date Value'
,p_event_sequence=>320
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_PROV_VAR_DATE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6430356385417613)
,p_event_id=>wwv_flow_api.id(6429724013417607)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982997862464473)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6430410242417614)
,p_event_id=>wwv_flow_api.id(6429724013417607)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982517441464472)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6429852264417608)
,p_event_id=>wwv_flow_api.id(6429724013417607)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_PROV_VAR_DATE_VALID'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_date date;',
'begin',
'    l_date := to_date( :P8_PROV_VAR_DATE, :APP_DATE_TIME_FORMAT);',
'    return ''Y'';',
'exception',
'    when others then',
'        return ''N'';',
'end;'))
,p_attribute_07=>'P8_PROV_VAR_DATE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6430710216417617)
,p_event_id=>wwv_flow_api.id(6429724013417607)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982997862464473)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6430596040417615)
,p_event_id=>wwv_flow_api.id(6429724013417607)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982517441464472)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6430047364417610)
,p_name=>'On Change Prov Var Num Value'
,p_event_sequence=>330
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_PROV_VAR_NUM'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6430812751417618)
,p_event_id=>wwv_flow_api.id(6430047364417610)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982997862464473)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6430913570417619)
,p_event_id=>wwv_flow_api.id(6430047364417610)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982517441464472)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6430261684417612)
,p_event_id=>wwv_flow_api.id(6430047364417610)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_PROV_VAR_NUM_VALID'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_number number;',
'begin',
'    l_number := to_number( :P8_PROV_VAR_NUM );',
'    return ''Y'';',
'exception',
'    when others then',
'        return ''N'';',
'end;'))
,p_attribute_07=>'P8_PROV_VAR_NUM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6431062033417620)
,p_event_id=>wwv_flow_api.id(6430047364417610)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982997862464473)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6431104642417621)
,p_event_id=>wwv_flow_api.id(6430047364417610)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982517441464472)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6433167803417641)
,p_name=>'Click on Cancel Dialog'
,p_event_sequence=>340
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(7067605023119721)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6433270075417642)
,p_event_id=>wwv_flow_api.id(6433167803417641)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(13245209048329626)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8324051646815474)
,p_name=>'Instances Events Report Refreshed'
,p_event_sequence=>350
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(29001516138505995)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8324491461815477)
,p_event_id=>wwv_flow_api.id(8324051646815474)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$("td[headers*=instance_event_col]").each(function() {',
'  var text = $( this ).text();',
'  if ( text == "created" || text == "reset" || text == "restart step") {',
'    $( this ).addClass( "ffa-color--created" );',
'  } else if ( text == "completed" ) {',
'    $( this ).addClass( "ffa-color--completed" );',
'  } else if ( text == "started" || text == "running" ) {',
'    $( this ).addClass( "ffa-color--running" );',
'  } else if ( text == "terminated" ) {',
'    $( this ).addClass( "ffa-color--terminated" );',
'  } else if ( text == "error" ) {',
'    $( this ).addClass( "ffa-color--error" );',
'  }',
'});',
'',
'Prism.highlightAll();'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5987781654464507)
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
'    l_script := q''#apex.jQuery("#flow-reports").parent().attr("id","col1");',
'                   apex.jQuery("#flow-monitor").parent().attr("id","col2");#'';',
'    ',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE (',
'        p_code => l_script,',
'        p_key  => ''init_viewport'');',
'',
'    :P8_DISPLAY_SETTING := nvl(apex_util.get_preference(''VIEWPORT''),''row'');',
'',
'    ',
'    l_script := null;',
'    -- Set view to side-by-side if preference = ''column''',
'    if :P8_DISPLAY_SETTING = ''column'' then',
'    ',
'        l_script := q''#apex.jQuery( "#col1" ).addClass( "col-6" ).removeClass( [ "col-12", "col-end" ] );',
'                       apex.jQuery( "#col2" ).addClass( "col-6" ).removeClass( [ "col-12", "col-start" ] );',
'                       apex.jQuery("#col2").appendTo(apex.jQuery("#col1").parent());',
'                       apex.jQuery("#flow-monitor").show();',
'                       apex.region( "flow-monitor" ).refresh();#'';',
'     elsif :P8_DISPLAY_SETTING = ''window'' then',
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
 p_id=>wwv_flow_api.id(5681318530037013)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(5681250057037012)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Flow Instance Detail'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5987345331464507)
,p_process_sequence=>30
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
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5986975396464506)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_VARIABLE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_prov_prcs_id  flow_process_variables.prov_prcs_id%type := apex_application.g_x01;',
'    l_prov_var_name flow_process_variables.prov_var_name%type := apex_application.g_x02;',
'    l_prov_var_type flow_process_variables.prov_var_type%type := apex_application.g_x03;',
'    l_prov_var_vc2  flow_process_variables.prov_var_vc2%type;',
'    l_prov_var_num  flow_process_variables.prov_var_num%type;',
'    l_prov_var_date flow_process_variables.prov_var_date%type;',
'    l_prov_var_clob flow_process_variables.prov_var_clob%type;',
'begin',
'    case l_prov_var_type',
'        when ''VARCHAR2'' then',
'            l_prov_var_vc2 := flow_process_vars.get_var_vc2(',
'                  pi_prcs_id => l_prov_prcs_id',
'                , pi_var_name =>l_prov_var_name',
'            );',
'        when ''NUMBER'' then',
'            l_prov_var_num := flow_process_vars.get_var_num(',
'                  pi_prcs_id => l_prov_prcs_id',
'                , pi_var_name =>l_prov_var_name',
'            );',
'        when ''DATE'' then',
'            l_prov_var_date := flow_process_vars.get_var_date(',
'                  pi_prcs_id => l_prov_prcs_id',
'                , pi_var_name =>l_prov_var_name',
'            );',
'        when ''CLOB'' then',
'            l_prov_var_clob := flow_process_vars.get_var_clob(',
'                  pi_prcs_id => l_prov_prcs_id',
'                , pi_var_name =>l_prov_var_name',
'            );',
'    end case;',
'    ',
'    apex_json.open_object;',
'    apex_json.write( p_name => ''success'', p_value => not apex_error.have_errors_occurred );',
'    apex_json.write( p_name => ''vc2_value'', p_value => l_prov_var_vc2);',
'    apex_json.write( p_name => ''num_value'', p_value => to_char(l_prov_var_num));',
'    apex_json.write( p_name => ''date_value'', p_value => to_char(l_prov_var_date, :APP_DATE_TIME_FORMAT));',
'    apex_json.write( p_name => ''clob_value'', p_value => l_prov_var_clob);',
'    apex_json.close_all;',
' end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
