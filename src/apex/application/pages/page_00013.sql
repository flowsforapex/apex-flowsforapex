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
,p_step_title=>'Object Details'
,p_autocomplete_on_off=>'OFF'
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
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210813075948'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(11504924392020455)
,p_name=>'Variables'
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
'where',
'    objt_bpmn_id = :P13_OBJT_ID',
'order by',
'    expr_set desc, expr_order'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_OBJT_ID'
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
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
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
'    end as obat_value',
'from',
'    flow_object_attributes',
'join',
'    flow_objects',
'on',
'    obat_objt_id = objt_id',
'where',
'    objt_bpmn_id = :P13_OBJT_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_OBJT_ID'
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
,p_plug_name=>'Event Log'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11506057978020466)
,p_plug_name=>'Completed Objects'
,p_parent_plug_id=>wwv_flow_api.id(16275635604249762)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select *',
'from flow_subflows',
'where sbfl_prcs_id = :P13_PRCS_ID and sbfl_current = :P13_OBJT_ID'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(23845375832515291)
,p_name=>'Event Log'
,p_parent_plug_id=>wwv_flow_api.id(11506057978020466)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    USER_AVATAR,',
'    USER_NAME,',
'    EVENT_LINK,',
'    EVENT_DESC,',
'    EVENT_DATE,',
'    case event_date_type',
'        when ''SBFL_LAST_UPDATE'' then ''Updated''',
'        when ''SBFL_WORK_STARTED'' then ''Started''',
'        when ''SBFL_BECAME_CURRENT'' then ''Current''',
'    end as EVENT_TYPE,',
'    case event_date_type',
'        when ''SBFL_LAST_UPDATE'' then :P13_OBJT_ID || '' updated''',
'        when ''SBFL_WORK_STARTED'' then :P13_OBJT_ID || '' started''',
'        when ''SBFL_BECAME_CURRENT'' then :P13_OBJT_ID || '' is current''',
'    end as EVENT_TITLE,',
'    case event_date_type',
'        when ''SBFL_LAST_UPDATE'' then ''updated''',
'        when ''SBFL_WORK_STARTED'' then ''started''',
'        when ''SBFL_BECAME_CURRENT'' then ''current''',
'    end  as EVENT_STATUS,',
'    case event_date_type',
'        when ''SBFL_LAST_UPDATE'' then ''fa fa-check''',
'        when ''SBFL_WORK_STARTED'' then ''fa fa-gear''',
'        when ''SBFL_BECAME_CURRENT'' then ''fa fa-play''',
'    end as EVENT_ICON',
'from (',
'    select SBFL_ID,',
'           null as USER_AVATAR,',
'           null as USER_NAME,',
'           null as EVENT_LINK,',
'           null as EVENT_DESC,',
'           SBFL_LAST_UPDATE,',
'           SBFL_WORK_STARTED,',
'           SBFL_BECAME_CURRENT',
'    from FLOW_SUBFLOWS',
'    where SBFL_PRCS_ID = :P13_PRCS_ID and SBFL_CURRENT = :P13_OBJT_ID',
') ',
'unpivot include nulls (event_date for event_date_type in (SBFL_LAST_UPDATE, SBFL_WORK_STARTED, SBFL_BECAME_CURRENT))',
'order by event_date desc nulls last'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_PRCS_ID,P13_OBJT_ID'
,p_query_row_template=>wwv_flow_api.id(12495551963420880184)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7108232064320979)
,p_query_column_id=>1
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>1
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7108652918320980)
,p_query_column_id=>2
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>2
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7107428735320979)
,p_query_column_id=>3
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>9
,p_column_heading=>'Event Link'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7110269679320980)
,p_query_column_id=>4
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>6
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7109020373320980)
,p_query_column_id=>5
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>3
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7109869435320980)
,p_query_column_id=>6
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>5
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7109424715320980)
,p_query_column_id=>7
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>4
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7107004519320978)
,p_query_column_id=>8
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>7
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7107837424320979)
,p_query_column_id=>9
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>8
,p_column_heading=>'Event Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(11506173740020467)
,p_plug_name=>'Current Objects'
,p_parent_plug_id=>wwv_flow_api.id(16275635604249762)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'SQL_EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'exists(',
'    select *',
'    from flow_subflow_event_log',
'    where lgsf_prcs_id = :P13_PRCS_ID and lgsf_objt_id = :P13_OBJT_ID',
')',
'and not exists(',
'    select *',
'    from flow_subflows',
'    where sbfl_prcs_id = :P13_PRCS_ID and sbfl_current = :P13_OBJT_ID',
')'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(16212173591416073)
,p_name=>'Event Log'
,p_parent_plug_id=>wwv_flow_api.id(11506173740020467)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    USER_AVATAR,',
'    USER_NAME,',
'    EVENT_LINK,',
'    EVENT_DESC,',
'    EVENT_DATE,',
'    case event_date_type',
'        when ''LGSF_COMPLETED'' then ''Completed''',
'        when ''LGSF_STARTED'' then ''Started''',
'        when ''LGSF_WAS_CURRENT'' then ''Current''',
'    end as EVENT_TYPE,',
'    case event_date_type',
'        when ''LGSF_COMPLETED'' then :P13_OBJT_ID || '' completed''',
'        when ''LGSF_STARTED'' then :P13_OBJT_ID || '' started''',
'        when ''LGSF_WAS_CURRENT'' then :P13_OBJT_ID || '' is current''',
'    end as EVENT_TITLE,',
'    case event_date_type',
'        when ''LGSF_COMPLETED'' then ''completed''',
'        when ''LGSF_STARTED'' then ''started''',
'        when ''LGSF_WAS_CURRENT'' then ''current''',
'    end  as EVENT_STATUS,',
'    case event_date_type',
'        when ''LGSF_COMPLETED'' then ''fa fa-check''',
'        when ''LGSF_STARTED'' then ''fa fa-gear''',
'        when ''LGSF_WAS_CURRENT'' then ''fa fa-play''',
'    end as EVENT_ICON',
'from (',
'    select LGSF_SBFL_ID,',
'            substr(LGSF_USER,0,2) as USER_AVATAR,',
'            LGSF_USER as USER_NAME,',
'            null as EVENT_LINK,',
'            null as EVENT_DESC,',
'            LGSF_COMPLETED,',
'            LGSF_STARTED,',
'            LGSF_WAS_CURRENT',
'    from FLOW_SUBFLOW_EVENT_LOG',
'    where LGSF_PRCS_ID = :P13_PRCS_ID and LGSF_OBJT_ID = :P13_OBJT_ID',
') ',
'unpivot include nulls (event_date for event_date_type in (LGSF_COMPLETED, LGSF_STARTED, LGSF_WAS_CURRENT))',
'where LGSF_SBFL_ID = (',
'    select MAX(LGSF_SBFL_ID)',
'    from FLOW_SUBFLOW_EVENT_LOG',
'    where LGSF_PRCS_ID = :P13_PRCS_ID and LGSF_OBJT_ID = :P13_OBJT_ID',
')',
'order by event_date desc nulls last'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P13_PRCS_ID,P13_OBJT_ID'
,p_query_row_template=>wwv_flow_api.id(12495551963420880184)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7113279534320984)
,p_query_column_id=>1
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>4
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7113600242320985)
,p_query_column_id=>2
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>5
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7112423301320983)
,p_query_column_id=>3
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>2
,p_column_heading=>'Event Link'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7115204212320986)
,p_query_column_id=>4
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>9
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7114008839320985)
,p_query_column_id=>5
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>6
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7114876169320985)
,p_query_column_id=>6
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>8
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7114424569320985)
,p_query_column_id=>7
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>7
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7112099932320983)
,p_query_column_id=>8
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>1
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7112853138320984)
,p_query_column_id=>9
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>3
,p_column_heading=>'Event Icon'
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
,p_display_as=>'NATIVE_HIDDEN'
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
,p_name=>'P13_OBJT_TAG_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(16277096138249777)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select objt_tag_name',
'from flow_objects',
'where objt_bpmn_id = :P13_OBJT_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7105969039320977)
,p_name=>'P13_BECAME_CURRENT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11506057978020466)
,p_prompt=>'Current Time'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CURRENT_TIME from (',
'    select SBFL_ID,',
'           REGEXP_SUBSTR((current_timestamp - SBFL_BECAME_CURRENT), ''\d{2}:\d{2}:\d{2}'') as CURRENT_TIME',
'    from FLOW_SUBFLOWS',
'    where SBFL_PRCS_ID = :P13_PRCS_ID and SBFL_CURRENT = :P13_OBJT_ID',
'    order by SBFL_ID desc',
')',
'where ROWNUM <= 1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_css_classes=>'task_stats'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_icon_css_classes=>'fa-clock-o'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7106310971320978)
,p_name=>'P13_WORK_STARTED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11506057978020466)
,p_prompt=>'Working Time'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select WORKING_TIME from (',
'    select SBFL_ID,',
'           REGEXP_SUBSTR((current_timestamp - SBFL_WORK_STARTED), ''\d{2}:\d{2}:\d{2}'') as WORKING_TIME',
'    from FLOW_SUBFLOWS',
'    where SBFL_PRCS_ID = :P13_PRCS_ID and SBFL_CURRENT = :P13_OBJT_ID',
'    order by SBFL_ID desc',
')',
'where ROWNUM <= 1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_css_classes=>'task_stats'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_icon_css_classes=>'fa-clock-o'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7110922336320982)
,p_name=>'P13_WAS_CURRENT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(11506173740020467)
,p_prompt=>'Current Time'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CURRENT_TIME from (',
'    select LGSF_SBFL_ID,',
'           REGEXP_SUBSTR((LGSF_COMPLETED - LGSF_WAS_CURRENT), ''\d{2}:\d{2}:\d{2}'') as CURRENT_TIME',
'    from FLOW_SUBFLOW_EVENT_LOG',
'    where LGSF_PRCS_ID = :P13_PRCS_ID and LGSF_OBJT_ID = :P13_OBJT_ID',
'    order by LGSF_SBFL_ID desc',
')',
'where ROWNUM <= 1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_css_classes=>'task_stats'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_icon_css_classes=>'fa-clock-o'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7111317916320982)
,p_name=>'P13_STARTED'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(11506173740020467)
,p_prompt=>'Working Time'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select WORKING_TIME from (',
'    select LGSF_SBFL_ID,',
'           REGEXP_SUBSTR((LGSF_COMPLETED - LGSF_STARTED), ''\d{2}:\d{2}:\d{2}'') as WORKING_TIME',
'    from FLOW_SUBFLOW_EVENT_LOG',
'    where LGSF_PRCS_ID = :P13_PRCS_ID and LGSF_OBJT_ID = :P13_OBJT_ID',
'    order by LGSF_SBFL_ID desc',
')',
'where ROWNUM <= 1'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_tag_css_classes=>'task_stats'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_icon_css_classes=>'fa-clock-o'
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.component_end;
end;
/
