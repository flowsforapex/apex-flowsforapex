prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Object Details'
,p_alias=>'OBJECT-DETAILS'
,p_page_mode=>'MODAL'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>'apex.util.getTopApex().jQuery(".ui-dialog-content").dialog("option", "title", $v("P13_TITLE"));'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.a-Tabs-panel {',
'    display: none;',
'}',
'',
'.t-Timeline-type.updated {',
'    background-color: #0076df;',
'    color: white;',
'}',
'',
'.t-Timeline-type.started {',
'    background-color: #d9b13b;',
'    color: white;',
'}',
'',
'.t-Timeline-type.completed {',
'    background-color: #6aad42;',
'    color: white;',
'}',
'',
'.t-Timeline-type.current {',
'    background-color: #8c9eb0;',
'    color: white;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'DAMTHOR'
,p_last_upd_yyyymmddhh24miss=>'20210820151751'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2444672040538201)
,p_plug_name=>'Settings'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(11504924392020455)
,p_name=>'Variables'
,p_parent_plug_id=>wwv_flow_api.id(2444672040538201)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    expr_set,',
'    expr_var_name,',
'    expr_var_type,',
'    expr_type,',
'    expr_expression',
'from',
'    flow_object_expressions',
'join',
'    flow_objects',
'on',
'    expr_objt_id = objt_id',
'join',
'    flow_processes',
'on',
'    objt_dgrm_id = prcs_dgrm_id',
'where',
'    objt_bpmn_id = :P13_OBJT_ID and prcs_id = :P13_PRCS_ID',
'order by',
'    expr_set desc, expr_order'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_OBJT_ID,P13_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No variable expressions found.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7100767336320961)
,p_query_column_id=>1
,p_column_alias=>'EXPR_SET'
,p_column_display_sequence=>1
,p_column_heading=>'Execution'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7101132228320962)
,p_query_column_id=>2
,p_column_alias=>'EXPR_VAR_NAME'
,p_column_display_sequence=>2
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7101559667320963)
,p_query_column_id=>3
,p_column_alias=>'EXPR_VAR_TYPE'
,p_column_display_sequence=>3
,p_column_heading=>'Data Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7101989546320963)
,p_query_column_id=>4
,p_column_alias=>'EXPR_TYPE'
,p_column_display_sequence=>4
,p_column_heading=>'Expression Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7102337978320963)
,p_query_column_id=>5
,p_column_alias=>'EXPR_EXPRESSION'
,p_column_display_sequence=>5
,p_column_heading=>'Expression'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(16213590277416087)
,p_name=>'Attributes'
,p_parent_plug_id=>wwv_flow_api.id(2444672040538201)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    obat_key,',
'    case',
'        when obat_num_value is not null then cast(obat_num_value as varchar2(4000))',
'        when obat_date_value is not null then cast(obat_date_value as varchar2(4000))',
'        when obat_vc_value is not null then obat_vc_value',
'        when obat_clob_value is not null then ''clob''',
'    end as obat_value',
'from',
'    flow_object_attributes',
'join',
'    flow_objects',
'on',
'    obat_objt_id = objt_id',
'join',
'    flow_processes',
'on',
'    objt_dgrm_id = prcs_dgrm_id',
'where',
'    objt_bpmn_id = :P13_OBJT_ID and prcs_id = :P13_PRCS_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_OBJT_ID,P13_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495557168323880188)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No attributes found.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7103062131320969)
,p_query_column_id=>1
,p_column_alias=>'OBAT_KEY'
,p_column_display_sequence=>1
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7103465523320970)
,p_query_column_id=>2
,p_column_alias=>'OBAT_VALUE'
,p_column_display_sequence=>2
,p_column_heading=>'Value'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(16275635604249762)
,p_plug_name=>'Logs'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(2444768214538202)
,p_name=>'Variables'
,p_parent_plug_id=>wwv_flow_api.id(16275635604249762)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    LGVR_EXPR_SET,',
'    LGVR_VAR_NAME,',
'    LGVR_VAR_TYPE,',
'    case',
'        when lgvr_var_vc2 is not null then lgvr_var_vc2',
'        when lgvr_var_num is not null then cast(lgvr_var_num as varchar2(4000))',
'        when lgvr_var_date is not null then cast(lgvr_var_date as varchar2(4000))',
'        when lgvr_var_clob is not null then ''clob''',
'    end as lgvr_value,',
'    LGVR_TIMESTAMP',
'from',
'    FLOW_VARIABLE_EVENT_LOG',
'where',
'    LGVR_PRCS_ID = :P13_PRCS_ID and LGVR_OBJT_ID = :P13_OBJT_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_PRCS_ID,P13_OBJT_ID'
,p_query_row_template=>wwv_flow_api.id(12495551963420880184)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'The variable log for this object is empty.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2445728257538212)
,p_query_column_id=>1
,p_column_alias=>'LGVR_EXPR_SET'
,p_column_display_sequence=>1
,p_column_heading=>'Execution'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2445838300538213)
,p_query_column_id=>2
,p_column_alias=>'LGVR_VAR_NAME'
,p_column_display_sequence=>2
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2445929078538214)
,p_query_column_id=>3
,p_column_alias=>'LGVR_VAR_TYPE'
,p_column_display_sequence=>3
,p_column_heading=>'Data Type'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446045555538215)
,p_query_column_id=>4
,p_column_alias=>'LGVR_VALUE'
,p_column_display_sequence=>4
,p_column_heading=>'Value'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446195496538216)
,p_query_column_id=>5
,p_column_alias=>'LGVR_TIMESTAMP'
,p_column_display_sequence=>5
,p_column_heading=>'Timestamp'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(16212173591416073)
,p_name=>'Events'
,p_parent_plug_id=>wwv_flow_api.id(16275635604249762)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    LGSF_USER,',
'    LGSF_WAS_CURRENT,',
'    LGSF_STARTED,',
'    LGSF_COMPLETED',
'from',
'    FLOW_SUBFLOW_EVENT_LOG',
'where',
'    LGSF_PRCS_ID = :P13_PRCS_ID and LGSF_OBJT_ID = :P13_OBJT_ID',
'order by',
'    LGSF_COMPLETED desc nulls last'))
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from flow_subflows',
'where sbfl_prcs_id = :P13_PRCS_ID and sbfl_current = :P13_OBJT_ID'))
,p_display_condition_type=>'NOT_EXISTS'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_PRCS_ID,P13_OBJT_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'The event log for this object is empty.'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2449529473538250)
,p_query_column_id=>1
,p_column_alias=>'LGSF_USER'
,p_column_display_sequence=>4
,p_column_heading=>'User'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446573885538220)
,p_query_column_id=>2
,p_column_alias=>'LGSF_WAS_CURRENT'
,p_column_display_sequence=>1
,p_column_heading=>'Became Current'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446661888538221)
,p_query_column_id=>3
,p_column_alias=>'LGSF_STARTED'
,p_column_display_sequence=>2
,p_column_heading=>'Work Started'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446757091538222)
,p_query_column_id=>4
,p_column_alias=>'LGSF_COMPLETED'
,p_column_display_sequence=>3
,p_column_heading=>'Completed'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(23845375832515291)
,p_name=>'Events'
,p_parent_plug_id=>wwv_flow_api.id(16275635604249762)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    SBFL_BECAME_CURRENT,',
'    SBFL_WORK_STARTED,',
'    SBFL_LAST_UPDATE',
'from',
'    FLOW_SUBFLOWS',
'where',
'    SBFL_PRCS_ID = :P13_PRCS_ID and SBFL_CURRENT = :P13_OBJT_ID',
'order by',
'    SBFL_LAST_UPDATE desc nulls last'))
,p_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from flow_subflows',
'where sbfl_prcs_id = :P13_PRCS_ID and sbfl_current = :P13_OBJT_ID'))
,p_display_condition_type=>'EXISTS'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_PRCS_ID,P13_OBJT_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446238093538217)
,p_query_column_id=>1
,p_column_alias=>'SBFL_BECAME_CURRENT'
,p_column_display_sequence=>1
,p_column_heading=>'Became Current'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446303556538218)
,p_query_column_id=>2
,p_column_alias=>'SBFL_WORK_STARTED'
,p_column_display_sequence=>2
,p_column_heading=>'Work Started'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2446440955538219)
,p_query_column_id=>3
,p_column_alias=>'SBFL_LAST_UPDATE'
,p_column_display_sequence=>3
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(16277096138249777)
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
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7104199777320970)
,p_name=>'P13_PRCS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(16277096138249777)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7104565818320974)
,p_name=>'P13_OBJT_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(16277096138249777)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7104945910320975)
,p_name=>'P13_TITLE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(16277096138249777)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
