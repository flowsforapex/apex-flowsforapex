prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
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
 p_id=>24
,p_name=>'Message Start Listeners'
,p_alias=>'MESSAGE-START-LISTENERS'
,p_step_title=>'Message Start Listeners'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22334755989326195)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22335425829326197)
,p_plug_name=>'Message Start Listeners'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495584334308880235)
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0024_MESSAGE_START_LISTENERS_VW'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Message Start Listeners'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(22335596245326197)
,p_name=>'Message Start Listeners'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'RALLEN2010@GMAIL.COM'
,p_internal_uid=>22335596245326197
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22336152348326258)
,p_db_column_name=>'MSUB_ID'
,p_display_order=>1
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22336535579326259)
,p_db_column_name=>'MSUB_MESSAGE_NAME'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22336978992326259)
,p_db_column_name=>'MSUB_KEY_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Key'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22337373749326259)
,p_db_column_name=>'MSUB_START_EVENT_BPMN_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Start Event'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22337730258326259)
,p_db_column_name=>'MSUB_PAYLOAD_VAR'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Payload Variable'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22338520078326259)
,p_db_column_name=>'DGRM_ID'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Diagram ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22339724489326260)
,p_db_column_name=>'DGRM_CATEGORY'
,p_display_order=>17
,p_column_identifier=>'J'
,p_column_label=>'Category'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22338911210326260)
,p_db_column_name=>'DGRM_NAME'
,p_display_order=>27
,p_column_identifier=>'H'
,p_column_label=>'Diagram'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22339384899326260)
,p_db_column_name=>'DGRM_VERSION'
,p_display_order=>37
,p_column_identifier=>'I'
,p_column_label=>'Diagram Version'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22340128804326260)
,p_db_column_name=>'DGRM_ICON'
,p_display_order=>57
,p_column_identifier=>'K'
,p_column_label=>'<span class="fa fa-workflow"></span>'
,p_column_html_expression=>'<span class="fa #DGRM_ICON#"></span>'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(22338103180326259)
,p_db_column_name=>'MSUB_CREATED'
,p_display_order=>67
,p_column_identifier=>'F'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(22343659920346775)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'223437'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'MSUB_ID:MSUB_MESSAGE_NAME:MSUB_START_EVENT_BPMN_ID:MSUB_PAYLOAD_VAR:DGRM_ICON:DGRM_NAME:DGRM_VERSION:DGRM_CATEGORY:MSUB_CREATED:'
);
wwv_flow_imp.component_end;
end;
/
