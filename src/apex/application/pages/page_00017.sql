prompt --application/pages/page_00017
begin
--   Manifest
--     PAGE: 00017
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
 p_id=>17
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Task Statistics'
,p_alias=>'TASK-STATISTICS'
,p_step_title=>'Task Statistics'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'C##RALLEN'
,p_last_upd_yyyymmddhh24miss=>'20230406111726'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2146022401493944)
,p_plug_name=>'Historic Step Waiting Times for &P17_OBJT_NAME. ( &P17_OBJT_BPMN_ID. )'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with summary_dates as',
'(',
'    select trunc(sysdate) - 7 + level dt, ''DAY'' as period, 8-level sort_order',
'    from dual',
'    connect by level <= ( sysdate - sysdate +7)',
'    union',
'    select trunc(sysdate,''MM'') dt, ''MTD'' as period, 9 sort_order',
'    from dual',
'    union',
'    select add_months( trunc(sysdate,''MM'')',
'                     , - floor (months_between ( trunc ( sysdate)',
'                                               , trunc ( add_months(sysdate,-6) , ''Q'')',
'                                               ) - 3',
'                                ) + level-1',
'                     )',
'                     ,''MONTH''',
'                     , 10*(7-level)',
'    from dual',
'    connect by level <= ( sysdate - sysdate + floor (months_between ( trunc (sysdate)',
'                                                                    , trunc (add_months ( sysdate ,-6) , ''Q'')',
'                                                                    ) - 2',
'                                                    )',
'                        )',
'    union ',
'    select add_months(trunc(sysdate,''Q''), -3 - (3*level)),''QUARTER'', 100*level',
'    from dual',
'    connect by level <= (sysdate -sysdate +4)',
')',
'select sd.dt, ',
'       sd.period, ',
'       case sd.period',
'          when ''DAY''     then to_char(dt,''YYYY-MM-DD'')|| '' DAY''',
'          when ''MTD''     then to_char(dt,''YYYY-MM "MTD"'')|| '' MTD''',
'          when ''MONTH''   then to_char(dt,''YYYY-MM'')|| '' MONTH''',
'          when ''QUARTER'' then to_char(dt,''YYYY-"0"Q'')|| '' QUARTER''',
'       end PeriodLabel,',
'       sd.sort_order,',
'       ist.stsf_completed,',
'       ist.stsf_duration_10pc_sec,',
'       ist.stsf_duration_50pc_sec,',
'       ist.stsf_duration_90pc_sec,',
'       ist.stsf_duration_max_sec,',
'       ist.stsf_waiting_10pc_sec,',
'       ist.stsf_waiting_50pc_sec,',
'       ist.stsf_waiting_90pc_sec,',
'       ist.stsf_waiting_max_sec',
'  from summary_dates sd',
'  left join flow_step_stats ist',
'    on sd.dt     = ist.stsf_period_start',
'   and sd.period = ist.stsf_period',
' where ist.stsf_dgrm_id = :P17_DGRM_ID',
'   and ist.stsf_objt_bpmn_id = :P17_OBJT_BPMN_ID',
'union all',
'   select trunc(sysdate)',
'        , ''DAY''',
'        , to_char (sysdate,''YYYY-MM-DD'')',
'        , 0',
'        , count(lgsf_prcs_id) num_completed',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )',
'               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_10pc_sec',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )',
'               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_50pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )',
'               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_90pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( max (lgsf_completed - lgsf_was_current)) duration_max_sec                                  ',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )',
'               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_10pc_sec',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )',
'               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_50pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )',
'               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_90pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( max (lgsf_started - lgsf_was_current)) waiting_max_sec           ',
'        from flow_step_event_log lgsf',
'        where trunc (sys_extract_utc(lgsf_completed)) = trunc(sysdate)',
'        and  lgsf_sbfl_dgrm_id = :P17_DGRM_ID',
'        and  lgsf_objt_id = :P17_OBJT_BPMN_ID',
'        group by lgsf_sbfl_dgrm_id, lgsf_objt_id',
''))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P17_DGRM_ID,P17_OBJT_BPMN_ID'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(2146135245493945)
,p_region_id=>wwv_flow_api.id(2146022401493944)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2146229575493946)
,p_chart_id=>wwv_flow_api.id(2146135245493945)
,p_seq=>10
,p_name=>'Waiting-Max'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_MAX_SEC'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#FF2D55'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2146557171493949)
,p_chart_id=>wwv_flow_api.id(2146135245493945)
,p_seq=>20
,p_name=>'Waiting-90pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_90PC_SEC'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#FF9500'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2146692991493950)
,p_chart_id=>wwv_flow_api.id(2146135245493945)
,p_seq=>30
,p_name=>'Waiting-50pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_50PC_SEC'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#000000'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2570196315060501)
,p_chart_id=>wwv_flow_api.id(2146135245493945)
,p_seq=>40
,p_name=>'Waiting-10pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_10PC_SEC'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#C7C7CC'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(2146340173493947)
,p_chart_id=>wwv_flow_api.id(2146135245493945)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(2146498314493948)
,p_chart_id=>wwv_flow_api.id(2146135245493945)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2561368308878606)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495573047450880221)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12495520300515880126)
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2561999301878606)
,p_plug_name=>'Historic Step Performance for &P17_OBJT_NAME. ( &P17_OBJT_BPMN_ID. )'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with summary_dates as',
'(',
'    select trunc(sysdate) - 7 + level dt, ''DAY'' as period, 8-level sort_order',
'    from dual',
'    connect by level <= ( sysdate - sysdate +7)',
'    union',
'    select trunc(sysdate,''MM'') dt, ''MTD'' as period, 9 sort_order',
'    from dual',
'    union',
'    select add_months( trunc(sysdate,''MM'')',
'                     , - floor (months_between ( trunc ( sysdate)',
'                                               , trunc ( add_months(sysdate,-6) , ''Q'')',
'                                               ) - 3',
'                                ) + level-1',
'                     )',
'                     ,''MONTH''',
'                     , 10*(7-level)',
'    from dual',
'    connect by level <= ( sysdate - sysdate + floor (months_between ( trunc (sysdate)',
'                                                                    , trunc (add_months ( sysdate ,-6) , ''Q'')',
'                                                                    ) - 2',
'                                                    )',
'                        )',
'    union ',
'    select add_months(trunc(sysdate,''Q''), -3 - (3*level)),''QUARTER'', 100*level',
'    from dual',
'    connect by level <= (sysdate -sysdate +4)',
')',
'select sd.dt, ',
'       sd.period, ',
'       case sd.period',
'          when ''DAY''     then to_char(dt,''YYYY-MM-DD'')  || '' DAY''',
'          when ''MTD''     then to_char(dt,''YYYY-MM'')||'' MTD''',
'          when ''MONTH''   then to_char(dt,''YYYY-MM'')||'' MONTH''',
'          when ''QUARTER'' then to_char(dt,''YYYY-"0"Q'')||'' QUARTER''',
'       end PeriodLabel,',
'       sd.sort_order,',
'       ist.stsf_completed,',
'       ist.stsf_duration_10pc_sec,',
'       ist.stsf_duration_50pc_sec,',
'       ist.stsf_duration_90pc_sec,',
'       ist.stsf_duration_max_sec,',
'       ist.stsf_waiting_10pc_sec,',
'       ist.stsf_waiting_50pc_sec,',
'       ist.stsf_waiting_90pc_sec,',
'       ist.stsf_waiting_max_sec',
'  from summary_dates sd',
'  left join flow_step_stats ist',
'    on sd.dt     = ist.stsf_period_start',
'   and sd.period = ist.stsf_period',
' where ist.stsf_dgrm_id = :P17_DGRM_ID',
'   and ist.stsf_objt_bpmn_id = :P17_OBJT_BPMN_ID',
'union all',
'   select trunc(sysdate)',
'        , ''DAY''',
'        , to_char (sysdate,''YYYY-MM-DD'')',
'        , 0',
'        , count(lgsf_prcs_id) num_completed',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )',
'               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_10pc_sec',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )',
'               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_50pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )',
'               within group (order by (lgsf_completed - lgsf_was_current) ASC))   duration_90pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( max (lgsf_completed - lgsf_was_current)) duration_max_sec                                  ',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )',
'               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_10pc_sec',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )',
'               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_50pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )',
'               within group (order by (lgsf_started - lgsf_was_current) ASC))   waiting_90pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( max (lgsf_started - lgsf_was_current)) waiting_max_sec           ',
'        from flow_step_event_log lgsf',
'        where trunc (sys_extract_utc(lgsf_completed)) = trunc(sysdate)',
'        and  lgsf_sbfl_dgrm_id = :P17_DGRM_ID',
'        and  lgsf_objt_id = :P17_OBJT_BPMN_ID',
'        group by lgsf_sbfl_dgrm_id, lgsf_objt_id',
''))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P17_DGRM_ID,P17_OBJT_BPMN_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(2562347006878607)
,p_region_id=>wwv_flow_api.id(2561999301878606)
,p_chart_type=>'lineWithArea'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2564030625878607)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>10
,p_name=>'Duration-Max'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_DURATION_MAX_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#FF2D55'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2145050239493934)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>20
,p_name=>'Duration-90pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_DURATION_90PC_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#FF9500'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2145180896493935)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>30
,p_name=>'Duration-10pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_DURATION_10PC_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#C7C7CC'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2145203533493936)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>40
,p_name=>'Duration-50pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_DURATION_50PC_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#000000'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2145388121493937)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>50
,p_name=>'Waiting-Max'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_MAX_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#FF2D55'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2145474164493938)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>60
,p_name=>'Waiting-90pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_90PC_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#FF9500'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2145521870493939)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>70
,p_name=>'Waiting-50pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_50PC_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#000000'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(2145684188493940)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_seq=>80
,p_name=>'Waiting-10pc'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'STSF_WAITING_10PC_SEC'
,p_group_short_desc_column_name=>'PERIOD'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#C7C7CC'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(2562894890878607)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>true
,p_zoom_order_weeks=>true
,p_zoom_order_months=>true
,p_zoom_order_quarters=>true
,p_zoom_order_years=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(2563491063878607)
,p_chart_id=>wwv_flow_api.id(2562347006878607)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>true
,p_zoom_order_weeks=>true
,p_zoom_order_months=>true
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2145742635493941)
,p_name=>'P17_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2561999301878606)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2145861612493942)
,p_name=>'P17_OBJT_BPMN_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(2561999301878606)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2145950517493943)
,p_name=>'P17_OBJT_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2561999301878606)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.component_end;
end;
/
