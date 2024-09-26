prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_page.create_page(
 p_id=>16
,p_user_interface_id=>wwv_flow_imp.id(12495499263265880052)
,p_name=>'Process Statistics'
,p_alias=>'PROCESS-STATISTICS'
,p_step_title=>'Process Statistics'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'04'
,p_last_updated_by=>'DENNIS.AMTHOR@HYAND.COM'
,p_last_upd_yyyymmddhh24miss=>'20240926144145'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2143958569493923)
,p_plug_name=>'Process Performance (Period Summaries)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
' with summary_dates as',
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
'          when ''MTD''     then to_char(dt,''YYYY-MM'')|| '' MTD''',
'          when ''MONTH''   then to_char(dt,''YYYY-MM'')|| '' MONTH''',
'          when ''QUARTER'' then to_char(dt,''YYYY-"0"Q'')|| '' QUARTER''',
'       end PeriodLabel,',
'       sd.sort_order,',
'       ist.stpr_created,',
'       ist.stpr_started,',
'       ist.stpr_completed,',
'       ist.stpr_error,',
'       ist.stpr_terminated,',
'       ist.stpr_reset,',
'       ist.stpr_duration_10pc_sec,',
'       ist.stpr_duration_50pc_sec,',
'       ist.stpr_duration_90pc_sec,',
'       ist.stpr_duration_max_sec',
'  from summary_dates sd',
'  left join flow_instance_stats ist',
'    on sd.dt     = ist.stpr_period_start',
'   and sd.period = ist.stpr_period',
' where ist.stpr_dgrm_id = :P16_DGRM_ID',
'union all',
'   select trunc(sysdate)',
'        , ''DAY''',
'        , to_char (sysdate,''YYYY-MM-DD'')',
'        , 0',
'        , sum ( case lgpr_prcs_event when ''created''    then 1 else 0 end) num_created',
'        , sum ( case lgpr_prcs_event when ''started''    then 1 else 0 end) num_started',
'        , sum ( case lgpr_prcs_event when ''completed''  then 1 else 0 end) num_completed',
'        , sum ( case lgpr_prcs_event when ''error    ''  then 1 else 0 end) num_error',
'        , sum ( case lgpr_prcs_event when ''terminated'' then 1 else 0 end) num_terminated',
'        , sum ( case lgpr_prcs_event when ''reset''      then 1 else 0 end) num_reset',
'--        , approx_percentile (0.10 )',
'--               within group (order by (lgpr_duration) ASC) duration_10pc_ivl',
'--        , approx_percentile (0.50 )',
'--               within group (order by (lgpr_duration) ASC) duration_50pc_ivl',
'--        , approx_percentile (0.90 )',
'--               within group (order by (lgpr_duration) ASC) duration_90pc_ivl',
'--        , max (lgpr_duration) duration_Max_ivl',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.10 )',
'               within group (order by (lgpr_duration) ASC)) duration_10pc_sec',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.50 )',
'               within group (order by (lgpr_duration) ASC)) duration_50pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( approx_percentile (0.90 )',
'               within group (order by (lgpr_duration) ASC)) duration_90pc_sec             ',
'        , flow_api_pkg.intervaldstosec ( max (lgpr_duration)) duration_max_sec                                  ',
'         from flow_instance_event_log lgpr',
'        where lgpr.lgpr_prcs_event in (''created'',''started'', ''error'', ''completed'', ''terminated'', ''reset'')',
'        and   trunc (sys_extract_utc(lgpr_timestamp)) = trunc(sysdate)',
'        and  lgpr_dgrm_id = :P16_DGRM_ID',
'        group by lgpr_dgrm_id',
''))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P16_DGRM_ID'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(2144034250493924)
,p_region_id=>wwv_flow_imp.id(2143958569493923)
,p_chart_type=>'combo'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'on'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'on'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2144120727493925)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_seq=>10
,p_name=>'Instances Started'
,p_location=>'REGION_SOURCE'
,p_series_type=>'bar'
,p_items_value_column_name=>'STPR_STARTED'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#D9B13B'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2144430910493928)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_seq=>20
,p_name=>'Instances Completed'
,p_location=>'REGION_SOURCE'
,p_series_type=>'bar'
,p_items_value_column_name=>'STPR_COMPLETED'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#8C9EB0'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_stack_category=>'completions'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2144581361493929)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_seq=>30
,p_name=>'Instances Terminated'
,p_location=>'REGION_SOURCE'
,p_series_type=>'bar'
,p_items_value_column_name=>'STPR_TERMINATED'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#D76A27'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_stack_category=>'completions'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2144612523493930)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_seq=>40
,p_name=>'Instances Errors'
,p_location=>'REGION_SOURCE'
,p_series_type=>'bar'
,p_items_value_column_name=>'STPR_ERROR'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#D2433B'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_stack_category=>'completions'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2144795267493931)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_seq=>50
,p_name=>'Median Duration'
,p_location=>'REGION_SOURCE'
,p_series_type=>'line'
,p_items_value_column_name=>'STPR_DURATION_50PC_SEC'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#000000'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'on'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2144947294493933)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_seq=>60
,p_name=>'90pc Duration'
,p_location=>'REGION_SOURCE'
,p_series_type=>'line'
,p_items_value_column_name=>'STPR_DURATION_90PC_SEC'
,p_items_label_column_name=>'PERIODLABEL'
,p_color=>'#FF3B30'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'on'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(2144270836493926)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
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
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(2144335477493927)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Instances'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(2144842592493932)
,p_chart_id=>wwv_flow_imp.id(2144034250493924)
,p_axis=>'y2'
,p_is_rendered=>'on'
,p_title=>'sec'
,p_format_scaling=>'auto'
,p_scaling=>'log'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_split_dual_y=>'auto'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2549667804373355)
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
 p_id=>wwv_flow_imp.id(2550204271373356)
,p_plug_name=>'Task Step Performance (current month) - &P16_DGRM_NAME_VERSION. (dgrm_id : &P16_DGRM_ID. )'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select stsf_objt_bpmn_id||'' (''||stsf_tag_name || '')'' label',
'     , objt.objt_name name',
'     , stsf_objt_bpmn_id',
'     , sum(stsf_completed)',
'     , avg(stsf_duration_10pc_sec)',
'     , avg(stsf_duration_50pc_sec)',
'     , avg(stsf_duration_90pc_sec)',
'     , max(stsf_duration_max_sec)',
'from  flow_step_stats stsf',
'left join flow_objects objt',
'  on objt.objt_dgrm_id = stsf.stsf_dgrm_id',
' and objt.objt_bpmn_id = stsf.stsf_objt_bpmn_id',
'where stsf_period_start >= sysdate - :P16_period',
'and stsf_period = ''DAY''',
'and stsf_dgrm_id = :P16_DGRM_ID',
'group by stsf_objt_bpmn_id||'' (''||stsf_tag_name || '')'', objt.objt_name, stsf_objt_bpmn_id',
'order by max(stsf_duration_max_sec) desc'))
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_ajax_items_to_submit=>'P16_DGRM_ID,P16_PERIOD'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(2550693860373356)
,p_region_id=>wwv_flow_imp.id(2550204271373356)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_indicator_size=>1
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2552379943373356)
,p_chart_id=>wwv_flow_imp.id(2550693860373356)
,p_seq=>10
,p_name=>'10 Percentile'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'AVG(STSF_DURATION_10PC_SEC)'
,p_group_short_desc_column_name=>'LABEL'
,p_items_label_column_name=>'NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:17:P17_DGRM_ID,P17_OBJT_BPMN_ID,P17_OBJT_NAME:&P16_DGRM_ID.,&STSF_OBJT_BPMN_ID.,&NAME.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2143658369493920)
,p_chart_id=>wwv_flow_imp.id(2550693860373356)
,p_seq=>20
,p_name=>'50 Percentile'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'AVG(STSF_DURATION_50PC_SEC)'
,p_group_short_desc_column_name=>'LABEL'
,p_items_label_column_name=>'NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:17:P17_DGRM_ID,P17_OBJT_BPMN_ID,P17_OBJT_NAME:&P16_DGRM_ID.,&STSF_OBJT_BPMN_ID.,&NAME.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2143732834493921)
,p_chart_id=>wwv_flow_imp.id(2550693860373356)
,p_seq=>30
,p_name=>'90 Percentile'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'AVG(STSF_DURATION_90PC_SEC)'
,p_group_short_desc_column_name=>'LABEL'
,p_items_label_column_name=>'NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:17:P17_DGRM_ID,P17_OBJT_BPMN_ID,P17_OBJT_NAME:&P16_DGRM_ID.,&STSF_OBJT_BPMN_ID.,&NAME.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2143869603493922)
,p_chart_id=>wwv_flow_imp.id(2550693860373356)
,p_seq=>40
,p_name=>'Max'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'MAX(STSF_DURATION_MAX_SEC)'
,p_group_short_desc_column_name=>'LABEL'
,p_items_label_column_name=>'NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:17:P17_DGRM_ID,P17_OBJT_BPMN_ID,P17_OBJT_NAME:&P16_DGRM_ID.,&STSF_OBJT_BPMN_ID.,&NAME.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(2551102899373356)
,p_chart_id=>wwv_flow_imp.id(2550693860373356)
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
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(2551732940373356)
,p_chart_id=>wwv_flow_imp.id(2550693860373356)
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(2143450803493918)
,p_name=>'P16_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(2550204271373356)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(2143539142493919)
,p_name=>'P16_DGRM_NAME_VERSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(2550204271373356)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp.component_end;
end;
/
