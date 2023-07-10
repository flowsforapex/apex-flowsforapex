prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
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
 p_id=>8
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Instance Details'
,p_alias=>'FLOW-INSTANCE-DETAILS'
,p_step_title=>'Flow Instance Details  - &APP_NAME_TITLE.'
,p_reload_on_submit=>'A'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_IMAGES#lib/prismjs/js/prism.js'
,p_javascript_code=>'initPage8();'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Remove border around Instance Details alert region */',
'.t-Alert.remove-alert-border { border: none;}',
'',
'/* Make active tab in Instance Events bold */',
'.is-active .t-Tabs-link {',
'    font-weight: 700;',
'}'))
,p_step_template=>wwv_flow_api.id(12495618547053880299)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'C##LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20230706154628'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3510821361851721)
,p_plug_name=>'Receive Message'
,p_region_name=>'receive_message_dialog'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size600x400'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>100
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
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
,p_region_name=>'flow-instances'
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
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-expanded:t-Region--stacked:t-Region--scrollBody:margin-bottom-none'
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
,p_region_css_classes=>'js-react-on-prcs remove-alert-border'
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
,p_column_display_sequence=>1
,p_column_heading=>'ID'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(8023758985825606)
,p_query_column_id=>2
,p_column_alias=>'PRCS_NAME'
,p_column_display_sequence=>2
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(15355984569942507)
,p_query_column_id=>3
,p_column_alias=>'DGRM_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'Model'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'#DGRM_NAME# - Version #DGRM_VERSION#'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(15356093907942508)
,p_query_column_id=>4
,p_column_alias=>'DGRM_VERSION'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5683966799037039)
,p_query_column_id=>5
,p_column_alias=>'STATUS'
,p_column_display_sequence=>5
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2142146265493905)
,p_query_column_id=>6
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>46
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5684069475037040)
,p_query_column_id=>7
,p_column_alias=>'INITIALIZED_ON'
,p_column_display_sequence=>6
,p_column_heading=>'Initialized On'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5684163968037041)
,p_query_column_id=>8
,p_column_alias=>'LAST_UPDATE_ON'
,p_column_display_sequence=>26
,p_column_heading=>'Last Update On'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2142255235493906)
,p_query_column_id=>9
,p_column_alias=>'DUE_ON'
,p_column_display_sequence=>16
,p_column_heading=>'Due On'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(5684296657037042)
,p_query_column_id=>10
,p_column_alias=>'BUSINESS_REFERENCE'
,p_column_display_sequence=>36
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
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:is-collapsed:t-Region--stacked:t-Region--scrollBody'
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
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
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
,p_download_formats=>'CSV:HTML:EMAIL:XLSX:PDF:RTF'
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
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8318997702792318)
,p_db_column_name=>'LGPR_BUSINESS_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Business Reference'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
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
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8320162530792319)
,p_db_column_name=>'LGPR_USER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'User'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8320570260792319)
,p_db_column_name=>'LGPR_COMMENT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Comment'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8321340756792320)
,p_db_column_name=>'LGPR_ERROR_INFO'
,p_display_order=>80
,p_column_identifier=>'J'
,p_column_label=>'Error Stack'
,p_column_html_expression=>'#PRETAG##LGPR_ERROR_INFO##POSTTAG#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
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
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(12632064663220606)
,p_db_column_name=>'LGPR_OBJT_ID'
,p_display_order=>120
,p_column_identifier=>'M'
,p_column_label=>'Object'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(13861584261230054)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'83217'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>20
,p_report_columns=>'LGPR_USER:LGPR_TIMESTAMP:LGPR_PRCS_EVENT:LGPR_COMMENT::LGPR_PRCS_EVENT_ICON:LGPR_ERROR_INFO:PRETAG:POSTTAG:LGPR_OBJT_ID'
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
 p_id=>wwv_flow_api.id(2570542357060505)
,p_plug_name=>'Task List Entries'
,p_region_name=>'task-list'
,p_parent_plug_id=>wwv_flow_api.id(30368937979343097)
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(1792064716043263)
,p_plug_display_sequence=>100
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'  from table (',
'      flow_api_pkg.get_current_tasks',
'            ( p_context => ''SINGLE_PROCESS''',
'            , p_prcs_id => :P8_PRCS_ID ))'))
,p_optimizer_hint=>'APEX$USE_NO_GROUPING_SETS'
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_ajax_items_to_submit=>'P8_PRCS_ID'
,p_plug_query_num_rows_type=>'SCROLL'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_query_no_data_found=>'No Tasks'
,p_show_total_row_count=>false
);
wwv_flow_api.create_card(
 p_id=>wwv_flow_api.id(2570671262060506)
,p_region_id=>wwv_flow_api.id(2570542357060505)
,p_layout_type=>'ROW'
,p_title_adv_formatting=>false
,p_title_column_name=>'SUBJECT'
,p_sub_title_adv_formatting=>true
,p_sub_title_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<small role="group" aria-label="Task Details">',
'    <strong>&TASK_DEF_NAME!HTML.</strong>',
'{if INITIATOR/}',
'    <span role="separator" aria-label="&middot;"> &middot; </span> Initiated by &INITIATOR_LOWER!HTML. ',
'{endif/}',
'{if !IS_COMPLETED/}',
'    {case DUE_CODE/}',
'        {when OVERDUE/}',
'            <span role="separator" aria-label="&middot;"> &middot; </span><strong class="u-danger-text">Due &DUE_IN.</strong>',
'        {when NEXT_HOUR/}',
'            <span role="separator" aria-label="&middot;"> &middot; </span> <strong class="u-danger-text">Due &DUE_IN.</strong>',
'        {when NEXT_24_HOURS/}',
'            <span role="separator" aria-label="&middot;"> &middot; </span> <span class="u-danger-text">Due &DUE_IN.</span>',
'        {otherwise/}',
'            {if DUE_IN/}<span role="separator" aria-label="&middot;"> &middot; </span> <span>Due &DUE_IN.</span>{endif/}',
'    {endcase/}',
'{endif/}',
'{if !IS_COMPLETED/}',
'    {case PRIORITY/}',
'        {when 1/}',
'            <span role="separator" aria-label="&middot;"> &middot; </span> <strong class="u-danger-text">Urgent</strong>',
'        {when 2/}',
'            <span role="separator" aria-label="&middot;"> &middot; </span> <span class="u-danger-text">High priority</span>',
'    {endcase/}',
'{endif/}',
'</small>'))
,p_body_adv_formatting=>false
,p_second_body_adv_formatting=>false
,p_badge_column_name=>'BADGE_TEXT'
,p_badge_css_classes=>'&BADGE_CSS_CLASSES.'
,p_media_adv_formatting=>false
,p_pk1_column_name=>'TASK_ID'
);
wwv_flow_api.create_card_action(
 p_id=>wwv_flow_api.id(2570792162060507)
,p_card_id=>wwv_flow_api.id(2570671262060506)
,p_action_type=>'TITLE'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'&DETAILS_LINK_TARGET.'
);
wwv_flow_api.create_card_action(
 p_id=>wwv_flow_api.id(2570853105060508)
,p_card_id=>wwv_flow_api.id(2570671262060506)
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_display_sequence=>20
,p_label=>'Approve'
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'#'
,p_link_attributes=>'data-id="&TASK_ID."'
,p_button_display_type=>'TEXT_WITH_ICON'
,p_icon_css_classes=>'fa-check-square u-success-text'
,p_action_css_classes=>'approve'
,p_is_hot=>false
,p_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_condition_expr1=>'TASK_TYPE'
,p_condition_expr2=>'APPROVAL'
,p_exec_cond_for_each_row=>true
);
wwv_flow_api.create_card_action(
 p_id=>wwv_flow_api.id(2570994574060509)
,p_card_id=>wwv_flow_api.id(2570671262060506)
,p_action_type=>'BUTTON'
,p_position=>'SECONDARY'
,p_display_sequence=>30
,p_label=>'Reject'
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'#'
,p_link_attributes=>'data-id="&TASK_ID."'
,p_button_display_type=>'TEXT_WITH_ICON'
,p_icon_css_classes=>'fa-times u-danger-text'
,p_action_css_classes=>'reject'
,p_is_hot=>false
,p_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_condition_expr1=>'TASK_TYPE'
,p_condition_expr2=>'APPROVAL'
,p_exec_cond_for_each_row=>true
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3509332876851706)
,p_plug_name=>'Message Subscriptions'
,p_region_name=>'message-subscriptions'
,p_parent_plug_id=>wwv_flow_api.id(30368937979343097)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>60
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select mes.msub_id,',
'       mes.msub_message_name,',
'       mes.msub_key_name,',
'       mes.msub_key_value,',
'       mes.msub_payload_var,',
'       mes.msub_created,',
'       action',
'  from flow_p0008_message_subscriptions_vw mes',
' where mes.msub_prcs_id = :P8_PRCS_ID'))
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
,p_prn_page_header=>'Message Subscriptions'
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
 p_id=>wwv_flow_api.id(3509425289851707)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF:RTF:EMAIL'
,p_owner=>'C##LMOREAUX'
,p_internal_uid=>3509425289851707
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509591891851708)
,p_db_column_name=>'MSUB_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Msub Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509620456851709)
,p_db_column_name=>'MSUB_MESSAGE_NAME'
,p_display_order=>60
,p_column_identifier=>'B'
,p_column_label=>'Message Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509701785851710)
,p_db_column_name=>'MSUB_KEY_NAME'
,p_display_order=>70
,p_column_identifier=>'C'
,p_column_label=>'Key Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3509835519851711)
,p_db_column_name=>'MSUB_KEY_VALUE'
,p_display_order=>80
,p_column_identifier=>'D'
,p_column_label=>'Key Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3510437164851717)
,p_db_column_name=>'MSUB_PAYLOAD_VAR'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Payload Variable'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3510565399851718)
,p_db_column_name=>'MSUB_CREATED'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Created'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(3510601685851719)
,p_db_column_name=>'ACTION'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Quick Action'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" class="t-Button t-Button--icon t-Button--link t-Button--iconLeft js-actionButton" data-action="receive-message" data-message="#MSUB_MESSAGE_NAME#" data-key="#MSUB_KEY_NAME#" data-value="#MSUB_KEY_VALUE#"><span aria-hidden="true"'
||' class="t-Icon t-Icon--left fa fa-box-arrow-in-east"></span>Receive Message</button>',
''))
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(3587249378535438)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'35873'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ACTION:MSUB_MESSAGE_NAME:MSUB_KEY_NAME:MSUB_KEY_VALUE:MSUB_PAYLOAD_VAR:MSUB_CREATED:'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(8392311025345610)
,p_plug_name=>'Variables'
,p_region_name=>'process-variables'
,p_parent_plug_id=>wwv_flow_api.id(30368937979343097)
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CHECKBOX,',
'       ACTION,',
'       PROV_PRCS_ID,',
'       PROV_VAR_NAME,',
'       PROV_VAR_TYPE,',
'       PROV_SCOPE,',
'       CALLING_OBJECT,',
'       PROV_VAR_VALUE,',
'       IS_GATEWAY_ROUTE,',
'       case when :P8_DIAGRAM_LEVEL = prov_scope then ''t-Button--success''',
'       end as current_class,',
'       case when :P8_DIAGRAM_LEVEL = prov_scope then 1 else 0',
'       end as current_scope',
'  from FLOW_P0008_VARIABLES_VW',
'where prov_prcs_id = :P8_PRCS_iD'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_PRCS_ID,P8_DIAGRAM_LEVEL'
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
,p_download_formats=>'CSV:HTML:EMAIL:XLSX:PDF:RTF'
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
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
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
'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon #CURRENT_CLASS# variable-actions-btn js-menuButton" ',
'data-menu="variable_row_action_menu"',
'data-name="#PROV_VAR_NAME#"',
'data-type="#PROV_VAR_TYPE#"',
'data-prcs="#PROV_PRCS_ID#"',
'data-scope="#PROV_SCOPE#"',
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
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55103738997434701)
,p_db_column_name=>'PROV_SCOPE'
,p_display_order=>80
,p_column_identifier=>'L'
,p_column_label=>'Scope'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55103850324434702)
,p_db_column_name=>'CALLING_OBJECT'
,p_display_order=>90
,p_column_identifier=>'M'
,p_column_label=>'Calling Object'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55108405946434748)
,p_db_column_name=>'CURRENT_CLASS'
,p_display_order=>100
,p_column_identifier=>'O'
,p_column_label=>'Current Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55108556668434749)
,p_db_column_name=>'CURRENT_SCOPE'
,p_display_order=>110
,p_column_identifier=>'P'
,p_column_label=>'Current Scope'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(10983804979667357)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'59765'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECKBOX:ACTION:PROV_VAR_NAME:PROV_VAR_TYPE:PROV_VAR_VALUE:PROV_SCOPE:'
,p_sort_column_1=>'CURRENT_SCOPE'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(166753193485966384)
,p_plug_name=>'Subflows'
,p_region_name=>'subflows'
,p_parent_plug_id=>wwv_flow_api.id(30368937979343097)
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>wwv_flow_api.id(12495584334308880235)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select SBFL_ID,',
'       SBFL_PRCS_ID,',
'       SBFL_CURRENT,',
'       SBFL_STEP_KEY,',
'       SBFL_SBFL_DGRM_ID,',
'       SBFL_DIAGRAM_LEVEL,',
'       CALLING_OBJECT,',
'       SBFL_STARTING_OBJECT,',
'       SBFL_LAST_UPDATE,',
'       SBFL_STATUS,',
'       SBFL_STATUS_ICON,',
'       SBFL_PRIORITY,',
'       SBFL_DUE_ON,',
'       SBFL_TIMR_START_ON,',
'       SBFL_CURRENT_LANE,',
'       SBFL_RESERVATION,',
'       SBFL_POTENTIAL_USERS,',
'       SBFL_POTENTIAL_GROUPS,',
'       SBFL_EXCLUDED_USERS,',
'       ACTIONS,',
'       CHECKBOX,',
'       QUICK_ACTION_ICON,',
'       QUICK_ACTION_LABEL,',
'       QUICK_ACTION,',
'       TIMER_STATUS_INFO,',
'       case when :P8_DIAGRAM_LEVEL = SBFL_DIAGRAM_LEVEL then ''t-Button--success''',
'       end as current_class,',
'       case when :P8_DIAGRAM_LEVEL = SBFL_DIAGRAM_LEVEL then 1 else 0',
'       end as current_level',
'  from FLOW_P0008_SUBFLOWS_VW',
'where sbfl_prcs_id = :P8_PRCS_ID'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P8_PRCS_ID,P8_DIAGRAM_LEVEL'
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
,p_download_formats=>'CSV:HTML:EMAIL:XLSX:PDF:RTF'
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
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5958314416464441)
,p_db_column_name=>'SBFL_PRCS_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Process ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
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
 p_id=>wwv_flow_api.id(2142712189493911)
,p_db_column_name=>'SBFL_DUE_ON'
,p_display_order=>50
,p_column_identifier=>'AF'
,p_column_label=>'Due On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5959540044464442)
,p_db_column_name=>'SBFL_LAST_UPDATE'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Last Update'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2142388218493907)
,p_db_column_name=>'SBFL_PRIORITY'
,p_display_order=>70
,p_column_identifier=>'AB'
,p_column_label=>'Priority'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5959935453464442)
,p_db_column_name=>'SBFL_STATUS'
,p_display_order=>80
,p_column_identifier=>'F'
,p_column_label=>'Status'
,p_column_html_expression=>'<span class="sbfl_status_badge"><i class="status_icon fa #SBFL_STATUS_ICON#"></i>#SBFL_STATUS#</span><span class="sbfl_timer_start">#TIMER_STATUS_INFO#</span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'subflow_status_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5960359099464442)
,p_db_column_name=>'SBFL_CURRENT_LANE'
,p_display_order=>90
,p_column_identifier=>'G'
,p_column_label=>'Lane'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5960748117464443)
,p_db_column_name=>'SBFL_RESERVATION'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>'Reserved For'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2142460053493908)
,p_db_column_name=>'SBFL_POTENTIAL_USERS'
,p_display_order=>120
,p_column_identifier=>'AC'
,p_column_label=>'Potential Users'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2142511739493909)
,p_db_column_name=>'SBFL_POTENTIAL_GROUPS'
,p_display_order=>130
,p_column_identifier=>'AD'
,p_column_label=>'Potential Groups'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(2142648848493910)
,p_db_column_name=>'SBFL_EXCLUDED_USERS'
,p_display_order=>140
,p_column_identifier=>'AE'
,p_column_label=>'Excluded Users'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(5961953081464444)
,p_db_column_name=>'ACTIONS'
,p_display_order=>150
,p_column_identifier=>'K'
,p_column_label=>'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon js-menuButton" data-menu="subflow_header_action_menu"><span aria-hidden="true" class="t-Icon fa fa-bars"></span></button>'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" title="Actions" aria-label="Actions" class="t-Button t-Button--noLabel t-Button--icon #CURRENT_CLASS# subflow-actions-btn js-menuButton" ',
'data-menu="subflow_row_action_menu"',
'data-prcs="#SBFL_PRCS_ID#"',
'data-sbfl="#SBFL_ID#"',
'data-key = "#SBFL_STEP_KEY#"',
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
,p_display_order=>160
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
,p_display_order=>170
,p_column_identifier=>'N'
,p_column_label=>'Quick Action Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8025569156825624)
,p_db_column_name=>'QUICK_ACTION'
,p_display_order=>180
,p_column_identifier=>'O'
,p_column_label=>'Quick Action'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button type="button" class="t-Button t-Button--icon t-Button--link t-Button--iconLeft js-actionButton" ',
'data-prcs="#SBFL_PRCS_ID#" data-sbfl="#SBFL_ID#" data-key = "#SBFL_STEP_KEY#" data-action="#QUICK_ACTION#">',
'    <span aria-hidden="true" class="t-Icon t-Icon--left fa #QUICK_ACTION_ICON#"></span>#QUICK_ACTION_LABEL#',
'</button>'))
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_static_id=>'quick_action_col'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(8025669951825625)
,p_db_column_name=>'QUICK_ACTION_LABEL'
,p_display_order=>190
,p_column_identifier=>'P'
,p_column_label=>'Quick Action Label'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(7335900830307041)
,p_db_column_name=>'SBFL_STATUS_ICON'
,p_display_order=>200
,p_column_identifier=>'Q'
,p_column_label=>'Sbfl Status Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62703712227232507)
,p_db_column_name=>'SBFL_STEP_KEY'
,p_display_order=>210
,p_column_identifier=>'R'
,p_column_label=>'Step Key'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62707325166232543)
,p_db_column_name=>'SBFL_TIMR_START_ON'
,p_display_order=>220
,p_column_identifier=>'S'
,p_column_label=>'Timer Start On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(62707438405232544)
,p_db_column_name=>'TIMER_STATUS_INFO'
,p_display_order=>230
,p_column_identifier=>'T'
,p_column_label=>'Timer Status Info'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55104508785434709)
,p_db_column_name=>'SBFL_SBFL_DGRM_ID'
,p_display_order=>240
,p_column_identifier=>'U'
,p_column_label=>'Calling Diagram ID'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55104683966434710)
,p_db_column_name=>'SBFL_DIAGRAM_LEVEL'
,p_display_order=>250
,p_column_identifier=>'V'
,p_column_label=>'Level'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55104753757434711)
,p_db_column_name=>'CALLING_OBJECT'
,p_display_order=>260
,p_column_identifier=>'W'
,p_column_label=>'Calling Object'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55108288395434746)
,p_db_column_name=>'CURRENT_CLASS'
,p_display_order=>270
,p_column_identifier=>'Z'
,p_column_label=>'Current Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(55108363460434747)
,p_db_column_name=>'CURRENT_LEVEL'
,p_display_order=>280
,p_column_identifier=>'AA'
,p_column_label=>'Current Level'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(8498061205860315)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'59631'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHECKBOX:ACTIONS:QUICK_ACTION:SBFL_CURRENT:SBFL_LAST_UPDATE:SBFL_STATUS:SBFL_CURRENT_LANE:SBFL_RESERVATION:SBFL_DIAGRAM_LEVEL::SBFL_PRIORITY:SBFL_POTENTIAL_USERS:SBFL_POTENTIAL_GROUPS:SBFL_EXCLUDED_USERS:SBFL_DUE_ON'
,p_sort_column_1=>'CURRENT_LEVEL'
,p_sort_direction_1=>'DESC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(60914663811851899)
,p_report_id=>wwv_flow_api.id(8498061205860315)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'SBFL_STATUS'
,p_operator=>'in'
,p_expr=>'running,error,waiting for timer'
,p_condition_sql=>'"SBFL_STATUS" in (#APXWS_EXPR_VAL1#, #APXWS_EXPR_VAL2#, #APXWS_EXPR_VAL3#)'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''running, error, waiting for timer''  '
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
 p_id=>wwv_flow_api.id(62707563129232545)
,p_plug_name=>'Reschedule Timer'
,p_region_name=>'reschedule_timer_dialog'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>90
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6133652177393567089)
,p_plug_name=>'Flow Viewer'
,p_region_name=>'flow-monitor'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:js-showMaximizeButton:t-Region--scrollBody'
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
,p_attribute_03=>'PRDG_ID'
,p_attribute_04=>'ALL_COMPLETED'
,p_attribute_05=>'PRDG_PRDG_ID'
,p_attribute_06=>'ALL_ERRORS'
,p_attribute_07=>'CALLING_OBJT'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_attribute_11=>'Y'
,p_attribute_12=>'BREADCRUMB'
,p_attribute_13=>'DRILLDOWN_ALLOWED'
,p_attribute_14=>'Y'
,p_attribute_15=>'N'
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
 p_id=>wwv_flow_api.id(62707677337232546)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(62707563129232545)
,p_button_name=>'RESCHEDULE_TIMER'
,p_button_static_id=>'reschedule-timer-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Reschedule Timer'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_button_cattributes=>'data-action="" data-prcs="" data-sbfl="" data-key=""'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3511050226851723)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(3510821361851721)
,p_button_name=>'RECEIVE_MESSAGE'
,p_button_static_id=>'receive-message-btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Receive Message'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-actionButton'
,p_button_cattributes=>'data-action="receive-message" data-message="" data-key="" data-value=""'
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
,p_button_cattributes=>'data-action="" data-prcs="" data-sbfl="" data-key="" data-no-update="true"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3511139234851724)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3510821361851721)
,p_button_name=>'CANCEL_RECEIVE_MESSAGE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_warn_on_unsaved_changes=>null
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
,p_button_image_alt=>'Set Gateway Route'
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
,p_button_image_alt=>'Set Process Variable'
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
 p_id=>wwv_flow_api.id(3510991975851722)
,p_name=>'P8_PAYLOAD'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3510821361851721)
,p_prompt=>'Payload'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3747988967530343)
,p_name=>'P8_PROV_VAR_TSTZ'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_prompt=>'Value'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_inline_help_text=>'Required format: YYYY-MM-DD HH24:MI:SS TZR'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3748085871530344)
,p_name=>'P8_PROV_VAR_TSTZ_VALID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
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
,p_attribute_01=>'Y'
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
,p_lov_cascade_parent_items=>'P8_PRDG_ID'
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
,p_inline_help_text=>'If left blank, the task will be reserved for the current user (app_user).'
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
,p_lov=>'STATIC2:Varchar2;VARCHAR2,Number;NUMBER,Date;DATE,Clob;CLOB,Timestamp With Time Zone;TIMESTAMP WITH TIME ZONE'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'5'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(5984111734464474)
,p_name=>'P8_PROV_VAR_VC2'
,p_item_sequence=>40
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
,p_item_sequence=>50
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
,p_item_sequence=>70
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
,p_item_sequence=>110
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
 p_id=>wwv_flow_api.id(6429631498417606)
,p_name=>'P8_PROV_VAR_DATE_VALID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6429967240417609)
,p_name=>'P8_PROV_VAR_NUM_VALID'
,p_item_sequence=>60
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(44803138381176613)
,p_name=>'P8_LOADED_DIAGRAM'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(6133652177393567089)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55103924099434703)
,p_name=>'P8_DIAGRAM_LEVEL'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(6133652177393567089)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55107419799434738)
,p_name=>'P8_PROV_SCOPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(8394514514345632)
,p_prompt=>'Scope'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select prdg_diagram_level d, prdg_diagram_level r',
'from flow_instance_diagrams',
'where prdg_prcs_id = :P8_PRCS_ID',
'and prdg_diagram_level is not null',
'order by prdg_diagram_level '))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(55107680657434740)
,p_name=>'P8_PRDG_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(8354985158946288)
,p_prompt=>'Calling Diagram'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'FLOW_INSTANCE_DIAGRAMS_LOV'
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P8_PRCS_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62707796384232547)
,p_name=>'P8_RESCHEDULE_TIMER_NOW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(62707563129232545)
,p_item_default=>'Y'
,p_prompt=>'Reschedule timer now'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(62707843061232548)
,p_name=>'P8_RESCHEDULE_TIMER_AT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(62707563129232545)
,p_prompt=>'Reschedule timer at'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_display_as=>'NATIVE_DATE_PICKER'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_02=>'+0d'
,p_attribute_04=>'both'
,p_attribute_05=>'N'
,p_attribute_07=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(73479633336995802)
,p_name=>'P8_RESCHEDULE_TIMER_COMMENT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(62707563129232545)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>2000
,p_cHeight=>5
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
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
'  apex.jQuery(this).prop("disabled", sbflStatus === "running" || sbflStatus === "error" || sbflStatus === "waiting for timer" ? false : true );',
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
,p_name=>'Viewer Diagram Loaded'
,p_event_sequence=>160
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(6133652177393567089)
,p_bind_type=>'bind'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_diagram_loaded'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6012103981464528)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'initViewer($v(''P8_PRCS_ID''), $v(''P8_PRCS_NAME''), $v(''P8_DISPLAY_SETTING''));'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(44803077743176612)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_LOADED_DIAGRAM'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.diagramIdentifier'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55104290877434706)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_CALLING_DIAGRAM'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.callingDiagramIdentifier'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55104339991434707)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_CALLING_OBJT_ID'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.callingObjectId'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6006917102464525)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_OBJT_LIST'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P8_LOADED_DIAGRAM is not null then',
'return flow_engine_app_api.get_objt_list(p_prdg_id => :P8_LOADED_DIAGRAM);',
'end if;'))
,p_attribute_07=>'P8_LOADED_DIAGRAM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55104408483434708)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_DIAGRAM_LEVEL'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select prdg_diagram_level',
'from FLOW_INSTANCE_DIAGRAMS',
'where prdg_id = :P8_LOADED_DIAGRAM',
'and prdg_diagram_level is not null'))
,p_attribute_07=>'P8_LOADED_DIAGRAM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55104910048434713)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(8392311025345610)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55105202562434716)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(166753193485966384)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6180462025209949)
,p_event_id=>wwv_flow_api.id(6011636562464528)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'changeCursor($v(''P8_OBJT_LIST''));'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(6014453052464529)
,p_name=>'Set Connection Select Option '
,p_event_sequence=>190
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_GATEWAY'
,p_condition_element=>'P8_GATEWAY'
,p_triggering_condition_type=>'NOT_NULL'
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
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.get_connection_select_option(',
'  pi_gateway => :P8_GATEWAY',
', pi_prdg_id => :P8_PRDG_ID',
')'))
,p_attribute_07=>'P8_GATEWAY,P8_PRDG_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(55107869454434742)
,p_event_id=>wwv_flow_api.id(6014453052464529)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_PROV_SCOPE'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.get_scope(',
'  pi_gateway => :P8_GATEWAY',
', pi_prdg_id => :P8_PRDG_ID',
')'))
,p_attribute_07=>'P8_GATEWAY,P8_PRDG_ID'
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
,p_triggering_expression=>'clickCondition($v(''P8_OBJT_LIST''), this.data);'
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
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P8_LOADED_DIAGRAM is not null then',
'return flow_engine_app_api.get_objt_name(',
'    p_objt_bpmn_id => :P8_OBJT_BPMN_ID',
'  , p_prdg_id => :P8_LOADED_DIAGRAM',
');',
'end if;'))
,p_attribute_07=>'P8_OBJT_BPMN_ID,P8_LOADED_DIAGRAM'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(6005023363464524)
,p_event_id=>wwv_flow_api.id(6004548451464524)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'openObjectDialog($v(''P8_OBJT_BPMN_ID''), $v(''P8_OBJT_NAME''),8);'
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
'flow_engine_app_api.set_viewport(:P8_DISPLAY_SETTING);',
''))
,p_attribute_02=>'P8_DISPLAY_SETTING'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
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
'apex.item("P8_PROV_VAR_TSTZ").hide();',
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
'    case "TIMESTAMP WITH TIME ZONE":',
'        apex.item("P8_PROV_VAR_TSTZ").show();',
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
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.check_is_date(',
'  pi_value => :P8_PROV_VAR_DATE',
', pi_format_mask => :APP_DATE_TIME_FORMAT',
')'))
,p_attribute_07=>'P8_PROV_VAR_DATE'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
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
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.check_is_number(',
'  pi_value => :P8_PROV_VAR_NUM',
')'))
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
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(62707920017232549)
,p_name=>'Change Set Now'
,p_event_sequence=>360
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_RESCHEDULE_TIMER_NOW'
,p_condition_element=>'P8_RESCHEDULE_TIMER_NOW'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(62708058684232550)
,p_event_id=>wwv_flow_api.id(62707920017232549)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_RESCHEDULE_TIMER_AT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(73479552347995801)
,p_event_id=>wwv_flow_api.id(62707920017232549)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_RESCHEDULE_TIMER_AT'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3511206012851725)
,p_name=>'Cancel Receive Message'
,p_event_sequence=>370
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3511139234851724)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3511347587851726)
,p_event_id=>wwv_flow_api.id(3511206012851725)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(3510821361851721)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3748125304530345)
,p_name=>'On Change Prob Var Timestamp With Time Zone Value'
,p_event_sequence=>380
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P8_PROV_VAR_TSTZ'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3748214983530346)
,p_event_id=>wwv_flow_api.id(3748125304530345)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982997862464473)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3748394460530347)
,p_event_id=>wwv_flow_api.id(3748125304530345)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982517441464472)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3748406279530348)
,p_event_id=>wwv_flow_api.id(3748125304530345)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P8_PROV_VAR_TSTZ_VALID'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.check_is_tstz(',
'  pi_value => :P8_PROV_VAR_TSTZ',
', pi_format_mask => flow_constants_pkg.gc_prov_default_tstz_format',
')'))
,p_attribute_07=>'P8_PROV_VAR_TSTZ'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3748529700530349)
,p_event_id=>wwv_flow_api.id(3748125304530345)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982997862464473)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3748626209530350)
,p_event_id=>wwv_flow_api.id(3748125304530345)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_api.id(5982517441464472)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3509125998851704)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Donwload Instance Summary'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_engine_app_api.download_instance_summary(',
'        pi_prcs_id => :P8_PRCS_ID',
'    );',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'INSTANCE_SUMMARY'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3510761242851720)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Step Timers'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_api_pkg.step_timers;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'STEP_TIMERS'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5987781654464507)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Viewport for BPMN-Viewer'
,p_process_sql_clob=>'flow_engine_app_api.add_viewport_script(''P8_DISPLAY_SETTING'');'
,p_process_clob_language=>'PLSQL'
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
,p_process_name=>'GET_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.get_url_p13(',
'  pi_prcs_id => :P8_PRCS_ID ',
', pi_prdg_id => :P8_LOADED_DIAGRAM',
', pi_objt_id => apex_application.g_x01',
', pi_title => apex_application.g_x02',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(5986975396464506)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_VARIABLE'
,p_process_sql_clob=>'flow_engine_app_api.pass_variable;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
