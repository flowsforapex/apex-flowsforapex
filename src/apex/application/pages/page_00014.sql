prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
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
 p_id=>14
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Logs'
,p_alias=>'LOGS'
,p_page_mode=>'MODAL'
,p_step_title=>'Logs'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'DAMTHOR'
,p_last_upd_yyyymmddhh24miss=>'20210823132750'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(2447308339538228)
,p_name=>'Completed Objects'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    coalesce(OBJT_NAME, LGSF_OBJT_ID) as COMPLETED_OBJECT,',
'    LGSF_WAS_CURRENT,',
'    LGSF_STARTED,',
'    LGSF_COMPLETED,',
'    LGSF_USER',
'from',
'    FLOW_SUBFLOW_EVENT_LOG',
'join',
'    FLOW_OBJECTS',
'on',
'    LGSF_OBJT_ID = OBJT_BPMN_ID',
'join',
'    FLOW_PROCESSES',
'on',
'    OBJT_DGRM_ID = PRCS_DGRM_ID',
'where',
'    PRCS_ID = :P14_PRCS_ID',
'order by',
'    LGSF_COMPLETED desc nulls last'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P14_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2496590124177010)
,p_query_column_id=>1
,p_column_alias=>'COMPLETED_OBJECT'
,p_column_display_sequence=>1
,p_column_heading=>'Object'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2447905253538234)
,p_query_column_id=>2
,p_column_alias=>'LGSF_WAS_CURRENT'
,p_column_display_sequence=>2
,p_column_heading=>'Became Current'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2448038177538235)
,p_query_column_id=>3
,p_column_alias=>'LGSF_STARTED'
,p_column_display_sequence=>3
,p_column_heading=>'Work Started'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2448100273538236)
,p_query_column_id=>4
,p_column_alias=>'LGSF_COMPLETED'
,p_column_display_sequence=>4
,p_column_heading=>'Completed'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2496096444177005)
,p_query_column_id=>5
,p_column_alias=>'LGSF_USER'
,p_column_display_sequence=>5
,p_column_heading=>'User'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(16453181626752830)
,p_name=>'Current Objects'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    coalesce(OBJT_NAME, SBFL_CURRENT) as CURRENT_OBJECT,',
'    SBFL_BECAME_CURRENT,',
'    SBFL_WORK_STARTED,',
'    SBFL_LAST_UPDATE',
'from',
'    FLOW_SUBFLOWS',
'join',
'    FLOW_OBJECTS',
'on',
'    SBFL_CURRENT = OBJT_BPMN_ID',
'join',
'    FLOW_PROCESSES',
'on',
'    OBJT_DGRM_ID = PRCS_DGRM_ID',
'where',
'    PRCS_ID = :P14_PRCS_ID',
'order by',
'    SBFL_LAST_UPDATE desc nulls last'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P14_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2496432706177009)
,p_query_column_id=>1
,p_column_alias=>'CURRENT_OBJECT'
,p_column_display_sequence=>1
,p_column_heading=>'Object'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2447071242538225)
,p_query_column_id=>2
,p_column_alias=>'SBFL_BECAME_CURRENT'
,p_column_display_sequence=>2
,p_column_heading=>'Became Current'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2447127208538226)
,p_query_column_id=>3
,p_column_alias=>'SBFL_WORK_STARTED'
,p_column_display_sequence=>3
,p_column_heading=>'Work Started'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2447208382538227)
,p_query_column_id=>4
,p_column_alias=>'SBFL_LAST_UPDATE'
,p_column_display_sequence=>4
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(16454301111752841)
,p_plug_name=>'Region Display Selector'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>wwv_flow_api.id(12495575615770880223)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_DISPLAY_SELECTOR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'STANDARD'
,p_attribute_02=>'N'
,p_attribute_03=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(20683667255713697)
,p_name=>'Instances'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    LGPR_USER,',
'    LGPR_TIMESTAMP,',
'    LGPR_PRCS_EVENT,',
'    LGPR_COMMENT',
'from',
'    FLOW_INSTANCE_EVENT_LOG',
'where',
'    LGPR_PRCS_ID = :P14_PRCS_ID',
'order by',
'    LGPR_TIMESTAMP desc nulls last'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P14_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2448244035538237)
,p_query_column_id=>1
,p_column_alias=>'LGPR_USER'
,p_column_display_sequence=>1
,p_column_heading=>'User'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2448355180538238)
,p_query_column_id=>2
,p_column_alias=>'LGPR_TIMESTAMP'
,p_column_display_sequence=>6
,p_column_heading=>'Timestamp'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2448421547538239)
,p_query_column_id=>3
,p_column_alias=>'LGPR_PRCS_EVENT'
,p_column_display_sequence=>5
,p_column_heading=>'Event'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="ffa-badge #LGPR_PRCS_EVENT#">#LGPR_PRCS_EVENT#</span>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2448522671538240)
,p_query_column_id=>4
,p_column_alias=>'LGPR_COMMENT'
,p_column_display_sequence=>7
,p_column_heading=>'Comment'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7129192978323670)
,p_name=>'P14_PRCS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(20683667255713697)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
