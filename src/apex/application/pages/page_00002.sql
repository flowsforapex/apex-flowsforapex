prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Management'
,p_alias=>'FLOW-MANAGEMENT'
,p_step_title=>'Flow Management'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'td[headers="NB_INSTANCES"]{',
'   padding-left:0px;',
'}',
'',
'',
'th#action,',
'td[headers=action]',
'{',
'  width:160px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210226163106'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24213241311956116)
,p_plug_name=>'Flow Management'
,p_region_name=>'parsed_drgm'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
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
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_LEFT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:EMAIL:XLS:PDF:RTF'
,p_owner=>'FLOWS4APEX'
,p_internal_uid=>24214476360956128
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214554954956129)
,p_db_column_name=>'DGRM_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Dgrm Id'
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
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214759985956131)
,p_db_column_name=>'DGRM_VERSION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Version'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214844713956132)
,p_db_column_name=>'DGRM_STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24214982358956133)
,p_db_column_name=>'DGRM_CATEGORY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Category'
,p_column_type=>'STRING'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215092633956134)
,p_db_column_name=>'DGRM_LAST_UPDATE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Last Update'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'&APP_DATE_TIME_FORMAT.'
,p_tz_dependent=>'N'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215123061956135)
,p_db_column_name=>'BTN'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Actions'
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
,p_static_id=>'action'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(24215292671956136)
,p_db_column_name=>'INSTANCES'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Instances'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RIR,RP:IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION:#DGRM_NAME#,#DGRM_VERSION#'
,p_column_linktext=>'#INSTANCES#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26092727630304614)
,p_db_column_name=>'DIAGRAM_PARSED'
,p_display_order=>90
,p_column_identifier=>'J'
,p_column_label=>'Flow Parsed'
,p_column_html_expression=>'<span aria-hidden="true" class="fa #DIAGRAM_PARSED_ICON#"></span>'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
);
wwv_flow_api.create_worksheet_column(
 p_id=>wwv_flow_api.id(26093269879304619)
,p_db_column_name=>'DIAGRAM_PARSED_ICON'
,p_display_order=>100
,p_column_identifier=>'K'
,p_column_label=>'Diagram Parsed Icon'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN'
);
wwv_flow_api.create_worksheet_rpt(
 p_id=>wwv_flow_api.id(26034946443441850)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'260350'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'BTN:DGRM_CATEGORY:DGRM_NAME:DGRM_VERSION:DGRM_STATUS:DGRM_LAST_UPDATE:INSTANCES::DIAGRAM_PARSED:DIAGRAM_PARSED_ICON'
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
,p_break_enabled_on=>'DGRM_CATEGORY:0:0:0:0:0'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26403877354857093)
,p_report_id=>wwv_flow_api.id(26034946443441850)
,p_name=>'Draft'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DGRM_STATUS'
,p_operator=>'='
,p_expr=>'draft'
,p_condition_sql=>' (case when ("DGRM_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''draft''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#FFF5CE'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26404249450857093)
,p_report_id=>wwv_flow_api.id(26034946443441850)
,p_name=>'Released'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DGRM_STATUS'
,p_operator=>'='
,p_expr=>'released'
,p_condition_sql=>' (case when ("DGRM_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''released''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#D0F1CC'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26404654154857093)
,p_report_id=>wwv_flow_api.id(26034946443441850)
,p_name=>'Deprecated'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DGRM_STATUS'
,p_operator=>'='
,p_expr=>'deprecated'
,p_condition_sql=>' (case when ("DGRM_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''deprecated''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#E4F4E3'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26405085580857093)
,p_report_id=>wwv_flow_api.id(26034946443441850)
,p_name=>'Archived'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'DGRM_STATUS'
,p_operator=>'='
,p_expr=>'archived'
,p_condition_sql=>' (case when ("DGRM_STATUS" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''archived''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_column_bg_color=>'#F7F7F7'
);
wwv_flow_api.create_worksheet_condition(
 p_id=>wwv_flow_api.id(26403527797857092)
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
,p_button_plug_id=>wwv_flow_api.id(24213241311956116)
,p_button_name=>'CREATE_FLOW'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--padRight'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Create Flow'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10431451245468048)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(24213241311956116)
,p_button_name=>'IMPORT_FLOW'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Import Flow'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_FORCE_OVERWRITE:N'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25601193984296773)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(24213241311956116)
,p_button_name=>'REFRESH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--padLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Refresh'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
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
,p_validation_name=>'Version'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_err varchar2(4000);',
'    l_version_exists number;',
'begin',
'    if (:P2_NEW_VERSION is null) then',
'        l_err := ''#LABEL# must have a value'';',
'    else',
'        select count(*)',
'        into l_version_exists',
'        from flow_diagrams',
'        where dgrm_name = (select dgrm_name from flow_diagrams where dgrm_id = :P2_DGRM_ID)',
'        and dgrm_version = :P2_NEW_VERSION;',
'        ',
'        if (l_version_exists > 0) then',
'            l_err := ''Version already exists.'';',
'        end if;',
'    end if;',
'    return l_err;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>'ADD_VERSION'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_api.id(26401222533737000)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(19019347638332911)
,p_name=>'Imported - Refresh Report'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(10431451245468048)
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
,p_attribute_01=>'apex.message.showPageSuccess(apex.lang.getMessage("FLOW_IMPORTED"));'
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
 p_id=>wwv_flow_api.id(24212267235956106)
,p_name=>'Click on Refresh Button'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25601193984296773)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26091514612304602)
,p_event_id=>wwv_flow_api.id(24212267235956106)
,p_event_result=>'TRUE'
,p_action_sequence=>10
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
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myElement = apex.jQuery( this.triggeringElement );',
'var myAction  = myElement.data( "action" );',
'var myDiagram = myElement.data( "dgrm" );',
'',
'apex.item( "P2_DGRM_ID" ).setValue( myDiagram );',
'apex.item( "P2_NEW_VERSION" ).setValue( "" );',
'apex.theme.openRegion( "new_version_reg" );',
''))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26094153642304628)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Add new version'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_dgrm_id flow_diagrams.dgrm_id%type := :P2_DGRM_ID;',
'    r_diagrams flow_diagrams%rowtype;',
'begin',
'    select * ',
'    into r_diagrams',
'    from flow_diagrams',
'    where dgrm_id = l_dgrm_id;',
'    ',
'    l_dgrm_id :=',
'      flow_bpmn_parser_pkg.upload_diagram',
'      (',
'        pi_dgrm_name => r_diagrams.dgrm_name',
'      , pi_dgrm_version => :P2_NEW_VERSION',
'      , pi_dgrm_category => r_diagrams.dgrm_category',
'      , pi_dgrm_content => r_diagrams.dgrm_content',
'      , pi_dgrm_status => flow_constants_pkg.gc_dgrm_status_draft',
'      );',
'    ',
'    flow_bpmn_parser_pkg.parse',
'    (',
'      pi_dgrm_id => l_dgrm_id',
'    );',
'    ',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'ADD_VERSION'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'New version added.'
);
wwv_flow_api.component_end;
end;
/
