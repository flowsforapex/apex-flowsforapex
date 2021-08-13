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
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.a-Tabs-panel {',
'    display: none;',
'}',
'',
'.t-Timeline-type.started {',
'    background-color: #d9b13b;',
'    color: white;',
'}',
'',
'.t-Timeline-type.error {',
'    background-color: #d2423b;',
'    color: white;',
'}',
'',
'.t-Timeline-type.terminated {',
'    background-color: #d76a27;',
'    color: white;',
'}',
'',
'.t-Timeline-type.created, .t-Timeline-type.current {',
'    background-color: #8c9eb0;',
'    color: white;',
'}',
'',
'.t-Timeline-type.completed {',
'    background-color: #6aad42;',
'    color: white;',
'}',
'',
'.t-Timeline-type.reset {',
'    background-color: #0076df;',
'    color: white;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210813080015'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(16453181626752830)
,p_name=>'Tasks'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    substr(USER_NAME, 0, 2) as USER_AVATAR,',
'    USER_NAME,',
'    EVENT_DATE,',
'    EVENT_TITLE,',
'    EVENT_DESC,',
'    EVENT_STATUS,',
'    EVENT_TYPE,',
'    EVENT_ICON,',
'    null as EVENT_LINK',
'from (',
'    /***** current log *****/',
'    select',
'        null as USER_NAME,            ',
'        EVENT_DATE,',
'        case event_date_type',
'           -- when ''SBFL_LAST_UPDATE'' then SBFL_CURRENT || '' updated''',
'            when ''SBFL_WORK_STARTED'' then nvl(SBFL_CURRENT, SBFL_STARTING_OBJECT) || '' started''',
'            when ''SBFL_BECAME_CURRENT'' then nvl(SBFL_CURRENT, SBFL_STARTING_OBJECT) || '' is current''',
'        end as EVENT_TITLE,',
'        null as EVENT_DESC,',
'        case event_date_type',
'            -- when ''SBFL_LAST_UPDATE'' then ''updated''',
'            when ''SBFL_WORK_STARTED'' then ''started''',
'            when ''SBFL_BECAME_CURRENT'' then ''current''',
'        end as EVENT_STATUS,',
'        case event_date_type',
'            -- when ''SBFL_LAST_UPDATE'' then ''updated''',
'            when ''SBFL_WORK_STARTED'' then ''started''',
'            when ''SBFL_BECAME_CURRENT'' then ''current''',
'        end as EVENT_TYPE,',
'        case event_date_type',
'            -- when ''SBFL_LAST_UPDATE'' then ''fa fa-check''',
'            when ''SBFL_WORK_STARTED'' then ''fa fa-gear''',
'            when ''SBFL_BECAME_CURRENT'' then ''fa fa-play''',
'        end as EVENT_ICON',
'    from (',
'        select',
'            SBFL_CURRENT,',
'            SBFL_STARTING_OBJECT,',
'            --SBFL_LAST_UPDATE,',
'            SBFL_WORK_STARTED,',
'            SBFL_BECAME_CURRENT',
'        from FLOW_SUBFLOWS',
'        where SBFL_PRCS_ID = :P14_PRCS_ID',
'    ) ',
'    unpivot include nulls (event_date for event_date_type in (SBFL_WORK_STARTED, SBFL_BECAME_CURRENT))',
'    union',
'    /***** completed log *****/',
'    select',
'        USER_NAME,',
'        EVENT_DATE,',
'        case event_date_type',
'            when ''LGSF_COMPLETED'' then LGSF_OBJT_ID || ''  completed''',
'            when ''LGSF_STARTED'' then LGSF_OBJT_ID || ''  started''',
'            when ''LGSF_WAS_CURRENT'' then LGSF_OBJT_ID || ''  is current''',
'        end as EVENT_TITLE,',
'        null as EVENT_DESC,',
'        case event_date_type',
'            when ''LGSF_COMPLETED'' then ''completed''',
'            when ''LGSF_STARTED'' then ''started''',
'            when ''LGSF_WAS_CURRENT'' then ''current''',
'        end as EVENT_STATUS,',
'        case event_date_type',
'            when ''LGSF_COMPLETED'' then ''completed''',
'            when ''LGSF_STARTED'' then ''started''',
'            when ''LGSF_WAS_CURRENT'' then ''current''',
'        end as EVENT_TYPE,',
'        case event_date_type',
'            when ''LGSF_COMPLETED'' then ''fa fa-check''',
'            when ''LGSF_STARTED'' then ''fa fa-gear''',
'            when ''LGSF_WAS_CURRENT'' then ''fa fa-play''',
'        end as EVENT_ICON',
'    from (',
'        select',
'            LGSF_OBJT_ID,',
'            LGSF_USER as USER_NAME,',
'            LGSF_COMPLETED,',
'            LGSF_STARTED,',
'            LGSF_WAS_CURRENT',
'        from FLOW_SUBFLOW_EVENT_LOG',
'        where LGSF_PRCS_ID = :P14_PRCS_ID',
'        -- and LGSF_SBFL_ID = (select MAX(LGSF_SBFL_ID) from FLOW_SUBFLOW_EVENT_LOG where LGSF_PRCS_ID = :P14_PRCS_ID)',
'    )',
'    unpivot include nulls (event_date for event_date_type in (LGSF_COMPLETED, LGSF_STARTED, LGSF_WAS_CURRENT))',
')',
'order by event_date desc nulls last'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P14_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495551963420880184)
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
 p_id=>wwv_flow_api.id(7122182850323660)
,p_query_column_id=>1
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>7
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7122978654323661)
,p_query_column_id=>2
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>9
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7121779402323657)
,p_query_column_id=>3
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>6
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7121392166323657)
,p_query_column_id=>4
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>5
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7122500252323660)
,p_query_column_id=>5
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>8
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7123394608323661)
,p_query_column_id=>6
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>1
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7124133892323662)
,p_query_column_id=>7
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>3
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7120990363323655)
,p_query_column_id=>8
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>4
,p_column_heading=>'Event Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7123707667323662)
,p_query_column_id=>9
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>2
,p_column_heading=>'Event Link'
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
,p_component_template_options=>'#DEFAULT#'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'    substr(USER_NAME, 0, 2) as USER_AVATAR,',
'    USER_NAME,',
'    EVENT_DATE,',
'    EVENT_TITLE,',
'    EVENT_DESC,',
'    EVENT_STATUS,',
'    EVENT_TYPE,',
'    EVENT_ICON,',
'    null as EVENT_LINK',
'from (',
'    /***** instance log *****/',
'    select',
'        LGPR_USER as USER_NAME,',
'        LGPR_TIMESTAMP as EVENT_DATE,',
'        case LGPR_PRCS_EVENT',
'            when ''started'' then ''Instance '' || LGPR_PRCS_NAME || '' started.''',
'            when ''created'' then ''Instance '' || LGPR_PRCS_NAME || '' created''',
'            when ''error'' then ''Error on Instance '' || LGPR_PRCS_NAME',
'            when ''reset'' then ''Instance '' || LGPR_PRCS_NAME || '' reseted''',
'        end as EVENT_TITLE,',
'        LGPR_COMMENT as EVENT_DESC,',
'        LGPR_PRCS_EVENT as EVENT_STATUS,',
'        case LGPR_PRCS_EVENT',
'            when ''started'' then ''started''',
'            when ''created'' then ''created''',
'            when ''error'' then ''error''',
'            when ''reset'' then ''reset''',
'        end as EVENT_TYPE,',
'        case LGPR_PRCS_EVENT',
'            when ''started'' then ''fa fa-gear''',
'            when ''created'' then ''fa fa-plus''',
'            when ''error'' then ''fa fa-warning''',
'            when ''reset'' then ''fa fa-undo''',
'        end as EVENT_ICON',
'    from',
'        FLOW_INSTANCE_EVENT_LOG',
'    where',
'        LGPR_PRCS_ID = :P14_PRCS_ID',
')',
'order by event_date desc nulls last'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P14_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495551963420880184)
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
 p_id=>wwv_flow_api.id(7127994262323669)
,p_query_column_id=>1
,p_column_alias=>'USER_AVATAR'
,p_column_display_sequence=>5
,p_column_heading=>'User Avatar'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7128754423323670)
,p_query_column_id=>2
,p_column_alias=>'USER_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'User Name'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7127529129323669)
,p_query_column_id=>3
,p_column_alias=>'EVENT_DATE'
,p_column_display_sequence=>4
,p_column_heading=>'Event Date'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7127152163323669)
,p_query_column_id=>4
,p_column_alias=>'EVENT_TITLE'
,p_column_display_sequence=>3
,p_column_heading=>'Event Title'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7128382663323669)
,p_query_column_id=>5
,p_column_alias=>'EVENT_DESC'
,p_column_display_sequence=>8
,p_column_heading=>'Event Desc'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7125553797323668)
,p_query_column_id=>6
,p_column_alias=>'EVENT_STATUS'
,p_column_display_sequence=>7
,p_column_heading=>'Event Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7126381042323668)
,p_query_column_id=>7
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>1
,p_column_heading=>'Event Type'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7126750751323669)
,p_query_column_id=>8
,p_column_alias=>'EVENT_ICON'
,p_column_display_sequence=>2
,p_column_heading=>'Event Icon'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(7125972473323668)
,p_query_column_id=>9
,p_column_alias=>'EVENT_LINK'
,p_column_display_sequence=>9
,p_column_heading=>'Event Link'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(7124526367323664)
,p_name=>'P14_PRCS_ID_1'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(16453181626752830)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
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
