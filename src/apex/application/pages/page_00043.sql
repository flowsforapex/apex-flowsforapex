prompt --application/pages/page_00043
begin
--   Manifest
--     PAGE: 00043
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
 p_id=>43
,p_name=>'Configuration - Automations'
,p_alias=>'CONFIGURATION-AUTOMATIONS'
,p_step_title=>'Configuration - Automations'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(85187802327140)
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
 p_id=>wwv_flow_imp.id(9166221988802596)
,p_plug_name=>'Automations'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495584334308880235)
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with automation_log as (',
'    select ',
'        a.automation_id, ',
'        a.application_id,',
'        l.status_code,',
'        row_number() over(partition by a.automation_id, a.application_id order by start_timestamp desc) as rn',
'    from apex_appl_automations	a',
'    join apex_automation_log l  ',
'      on l.automation_id = a.automation_id ',
'      and l.application_id = a.application_id',
'    where a.application_id = :app_id',
'    and a.static_id like ''flows-for-apex-%''',
'    and a.trigger_type_code = ''POLLING''',
')',
'select ',
'    a.name, ',
'    a.static_id, ',
'    a.trigger_type_code, ',
'    a.trigger_type, ',
'    a.polling_interval, ',
'    a.polling_status_code, ',
'    a.polling_status, ',
'    a.component_comment,',
'    coalesce(l.status_code, ''N/A'') as status_code',
'from apex_appl_automations a',
'left join automation_log l',
'  on l.automation_id = a.automation_id ',
' and l.application_id = a.application_id',
' and l.rn = 1',
'where a.application_id = :app_id',
'and a.static_id like ''flows-for-apex-%''',
';'))
,p_plug_source_type=>'NATIVE_IR'
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(38707861676195)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'MOREAUX.LOUIS@GMAIL.COM'
,p_internal_uid=>4497812545832008
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(38854468676196)
,p_db_column_name=>'NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Name'
,p_column_link=>'f?p=&APP_ID.:41:&SESSION.::&DEBUG.:41:P41_STATIC_ID:#STATIC_ID#'
,p_column_linktext=>'#NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(38914720676197)
,p_db_column_name=>'STATIC_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Static Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39076176676198)
,p_db_column_name=>'TRIGGER_TYPE_CODE'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Trigger Type Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39111120676199)
,p_db_column_name=>'TRIGGER_TYPE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Trigger Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39256251676200)
,p_db_column_name=>'POLLING_INTERVAL'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Polling Interval'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39366039676201)
,p_db_column_name=>'POLLING_STATUS_CODE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Polling Status Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39405629676202)
,p_db_column_name=>'POLLING_STATUS'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Polling Status'
,p_column_link=>'f?p=&APP_ID.:40:&SESSION.::&DEBUG.:40:P40_STATIC_ID:#STATIC_ID#'
,p_column_linktext=>'#POLLING_STATUS#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(39520645676203)
,p_db_column_name=>'COMPONENT_COMMENT'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Component Comment'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(4861842052240136)
,p_db_column_name=>'STATUS_CODE'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Status'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span aria-hidden="true" class="fa fa-lg {case STATUS_CODE/}',
'    {when FAILURE/}',
'        fa-exclamation-circle-o u-danger-text',
'    {when SUCCESS/}',
'        fa-check-circle-o u-success-text',
'    {otherwise/}',
'        fa-question-circle-o u-warning-text',
'{endcase/}"></span> ',
'',
''))
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(100260199291065)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'45594'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'NAME:POLLING_STATUS:STATUS_CODE:POLLING_INTERVAL:COMPONENT_COMMENT:'
);
wwv_flow_imp.component_end;
end;
/
