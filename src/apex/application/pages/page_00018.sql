prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_name=>'APEX Human Task details'
,p_alias=>'APEX-HUMAN-TASK-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'APEX Human Task details'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_imp.id(12495624331342880306)
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'N'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(6766908701665607)
,p_name=>'Participants'
,p_template=>wwv_flow_imp.id(12495582446800880234)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'       PARTICIPANT,',
'       PARTICIPANT_TYPE,',
'       IDENTITY_TYPE',
'  from APEX_TASK_PARTICIPANTS',
' where task_id = :P18_APEX_TASK_ID',
' order by PARTICIPANT_TYPE,  PARTICIPANT'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>':P18_APEX_TASK_ID'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(12495559701953880190)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6767690155665614)
,p_query_column_id=>1
,p_column_alias=>'PARTICIPANT'
,p_column_display_sequence=>30
,p_column_heading=>'Participant'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6767781996665615)
,p_query_column_id=>2
,p_column_alias=>'PARTICIPANT_TYPE'
,p_column_display_sequence=>10
,p_column_heading=>'Participant Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6767897414665616)
,p_query_column_id=>3
,p_column_alias=>'IDENTITY_TYPE'
,p_column_display_sequence=>40
,p_column_heading=>'Identity Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(6767911389665617)
,p_name=>'History'
,p_template=>wwv_flow_imp.id(12495582446800880234)
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select EVENT_CREATOR',
'     , EVENT_TYPE',
'     , EVENT_TIMESTAMP',
'     , coalesce (new_actual_owner, old_actual_owner) as actual_owner',
'     , coalesce (new_state, old_state) as state',
'     , DISPLAY_MSG',
'from  apex_task_history',
'where task_id = :P18_APEX_TASK_ID',
'order by event_timestamp desc'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>':P18_APEX_TASK_ID'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(12495559701953880190)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6768015025665618)
,p_query_column_id=>1
,p_column_alias=>'EVENT_CREATOR'
,p_column_display_sequence=>10
,p_column_heading=>'Event Creator'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6768198425665619)
,p_query_column_id=>2
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>20
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6768244653665620)
,p_query_column_id=>3
,p_column_alias=>'EVENT_TIMESTAMP'
,p_column_display_sequence=>30
,p_column_heading=>'Event Timestamp'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6768342702665621)
,p_query_column_id=>4
,p_column_alias=>'ACTUAL_OWNER'
,p_column_display_sequence=>40
,p_column_heading=>'Actual Owner'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6768471320665622)
,p_query_column_id=>5
,p_column_alias=>'STATE'
,p_column_display_sequence=>50
,p_column_heading=>'State'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(6768552475665623)
,p_query_column_id=>6
,p_column_alias=>'DISPLAY_MSG'
,p_column_display_sequence=>60
,p_column_heading=>'Display Msg'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(11853558310628854)
,p_name=>'APEX Human Task details'
,p_template=>wwv_flow_imp.id(12495582446800880234)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  TASK_ID',
'      , TASK_def_NAME',
'      , subject',
'      , task_type',
'      , due_on',
'      , priority',
'      , detail_pk',
'      , initiator',
'      , initiator_can_complete',
'      , actual_owner',
'      , state',
'      , outcome',
'      , created_by',
'      , created_on',
'      , last_updated_by',
'      , last_updated_on',
'from  apex_tasks',
'where task_id = :P18_APEX_TASK_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>':P18_APEX_TASK_ID'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(12495548550946880181)
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_prn_format=>'PDF'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11853954491628851)
,p_query_column_id=>1
,p_column_alias=>'TASK_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Task Id'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11854396987628851)
,p_query_column_id=>2
,p_column_alias=>'TASK_DEF_NAME'
,p_column_display_sequence=>2
,p_column_heading=>'Task Def Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11854757336628851)
,p_query_column_id=>3
,p_column_alias=>'SUBJECT'
,p_column_display_sequence=>3
,p_column_heading=>'Subject'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11855147939628850)
,p_query_column_id=>4
,p_column_alias=>'TASK_TYPE'
,p_column_display_sequence=>4
,p_column_heading=>'Task Type'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11855533773628850)
,p_query_column_id=>5
,p_column_alias=>'DUE_ON'
,p_column_display_sequence=>5
,p_column_heading=>'Due On'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11855997204628850)
,p_query_column_id=>6
,p_column_alias=>'PRIORITY'
,p_column_display_sequence=>6
,p_column_heading=>'Priority'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11856357459628850)
,p_query_column_id=>7
,p_column_alias=>'DETAIL_PK'
,p_column_display_sequence=>7
,p_column_heading=>'Detail Pk'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11856791232628850)
,p_query_column_id=>8
,p_column_alias=>'INITIATOR'
,p_column_display_sequence=>8
,p_column_heading=>'Initiator'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11857123239628850)
,p_query_column_id=>9
,p_column_alias=>'INITIATOR_CAN_COMPLETE'
,p_column_display_sequence=>9
,p_column_heading=>'Initiator Can Complete'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11857548215628849)
,p_query_column_id=>10
,p_column_alias=>'ACTUAL_OWNER'
,p_column_display_sequence=>10
,p_column_heading=>'Actual Owner'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11857991138628849)
,p_query_column_id=>11
,p_column_alias=>'STATE'
,p_column_display_sequence=>11
,p_column_heading=>'State'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11858390429628849)
,p_query_column_id=>12
,p_column_alias=>'OUTCOME'
,p_column_display_sequence=>12
,p_column_heading=>'Outcome'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11858788146628849)
,p_query_column_id=>13
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>13
,p_column_heading=>'Created By'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11859151981628849)
,p_query_column_id=>14
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>14
,p_column_heading=>'Created On'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11859554934628849)
,p_query_column_id=>15
,p_column_alias=>'LAST_UPDATED_BY'
,p_column_display_sequence=>15
,p_column_heading=>'Last Updated By'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(11859989690628849)
,p_query_column_id=>16
,p_column_alias=>'LAST_UPDATED_ON'
,p_column_display_sequence=>16
,p_column_heading=>'Last Updated On'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(6766567911665603)
,p_name=>'P18_APEX_TASK_ID'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp.component_end;
end;
/
