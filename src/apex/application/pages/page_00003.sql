prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_user_interface_id=>wwv_flow_imp.id(12495499263265880052)
,p_name=>'Dashboard'
,p_alias=>'DASHBOARD'
,p_step_title=>'Dashboard - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'initPage3();'
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'13'
,p_last_updated_by=>'DENNIS.AMTHOR@HYAND.COM'
,p_last_upd_yyyymmddhh24miss=>'20240926144145'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(2036577010569044)
,p_plug_name=>'Instance Errors in the last 14 days'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(2036635440569045)
,p_region_id=>wwv_flow_imp.id(2036577010569044)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
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
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2036784998569046)
,p_chart_id=>wwv_flow_imp.id(2036635440569045)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with period as (',
'    select sysdate - 13 + level - 1 dt',
'    from   dual',
'    connect by level <= (',
'      sysdate - sysdate  + 14',
'    )',
'  ), ',
'  error_counts as (',
'    select trunc(cast(lgpr.lgpr_timestamp as date)) as day, count(lgpr.lgpr_prcs_id) as error_count',
'    from flow_instance_event_log lgpr',
'    where lgpr.lgpr_prcs_event = ''error''',
'    and   lgpr.lgpr_timestamp > systimestamp - to_dsinterval (''P14D'')',
'    group by trunc(cast(lgpr.lgpr_timestamp as date))',
'  )',
'  select    to_char(trunc(p.dt), ''YYYY-MM-DD'') label, e.error_count as value',
'  from      period p',
'  left join error_counts e',
'  on        e.day = trunc(p.dt)',
'  order by  to_char(trunc(p.dt), ''YYYY-MM-DD'')'))
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D2433B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(2036882857569047)
,p_chart_id=>wwv_flow_imp.id(2036635440569045)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
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
 p_id=>wwv_flow_imp.id(2036981184569048)
,p_chart_id=>wwv_flow_imp.id(2036635440569045)
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
 p_id=>wwv_flow_imp.id(2037037389569049)
,p_plug_name=>'Current Overdue Flow Instances'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(2037143803569050)
,p_region_id=>wwv_flow_imp.id(2037037389569049)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
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
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2141783765493901)
,p_chart_id=>wwv_flow_imp.id(2037143803569050)
,p_seq=>10
,p_name=>'Running'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   select prcs.prcs_dgrm_id Diagram, dgrm.dgrm_name Process_Name, count(prcs_id)',
'     from flow_processes prcs',
'left join flow_diagrams dgrm',
'       on dgrm.dgrm_id = prcs.prcs_dgrm_id',
'    where prcs.prcs_due_on < systimestamp',
'      and prcs.prcs_status = ''running''',
' group by prcs_dgrm_id, dgrm.dgrm_name',
' order by count(prcs_id) desc',
'fetch first 10 rows only'))
,p_items_value_column_name=>'COUNT(PRCS_ID)'
,p_items_label_column_name=>'PROCESS_NAME'
,p_color=>'#6AAD42'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(2142032851493904)
,p_chart_id=>wwv_flow_imp.id(2037143803569050)
,p_seq=>20
,p_name=>'Error'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   select prcs.prcs_dgrm_id Diagram, dgrm.dgrm_name Process_Name, count(prcs_id)',
'     from flow_processes prcs',
'left join flow_diagrams dgrm',
'       on dgrm.dgrm_id = prcs.prcs_dgrm_id',
'    where prcs.prcs_due_on < systimestamp',
'      and prcs.prcs_status = ''error''',
' group by prcs_dgrm_id, dgrm.dgrm_name',
' order by count(prcs_id) desc',
'fetch first 10 rows only'))
,p_items_value_column_name=>'COUNT(PRCS_ID)'
,p_items_label_column_name=>'PROCESS_NAME'
,p_color=>'#D2433B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(2141803901493902)
,p_chart_id=>wwv_flow_imp.id(2037143803569050)
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
 p_id=>wwv_flow_imp.id(2141997113493903)
,p_chart_id=>wwv_flow_imp.id(2037143803569050)
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
 p_id=>wwv_flow_imp.id(3511439830851727)
,p_plug_name=>'Errors'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning:t-Alert--accessibleHeading'
,p_plug_template=>wwv_flow_imp.id(12495613507239880288)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P3_APEX_UPGRADE_DETECTED is not null or',
':P3_VERSION_MISMATCH is not null or',
'flow_timers_pkg.get_timer_status = ''FALSE'''))
,p_plug_display_when_cond2=>'PLSQL'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3508800535851701)
,p_plug_name=>'Version mismatch'
,p_parent_plug_id=>wwv_flow_imp.id(3511439830851727)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495604368136880259)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>'&P3_VERSION_MISMATCH!RAW.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P3_VERSION_MISMATCH'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3511545006851728)
,p_plug_name=>'Timers disabled'
,p_parent_plug_id=>wwv_flow_imp.id(3511439830851727)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495604368136880259)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>'Models containing one or more timers could not work properly on this system because they are disabled.<br>You can enable it in the Configuration page.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>'flow_timers_pkg.get_timer_status = ''FALSE'''
,p_plug_display_when_cond2=>'PLSQL'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3511637925851729)
,p_plug_name=>'APEX upgrade detected'
,p_parent_plug_id=>wwv_flow_imp.id(3511439830851727)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495604368136880259)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>'&P3_APEX_UPGRADE_DETECTED!RAW.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P3_APEX_UPGRADE_DETECTED'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(34404686490171432)
,p_name=>'Flow Instances per status'
,p_region_name=>'flow-instances-per-status'
,p_template=>wwv_flow_imp.id(12495582446800880234)
,p_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-BadgeList--large:t-BadgeList--dash:t-BadgeList--cols t-BadgeList--5cols:t-Report--hideNoPagination'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'    nvl(sum(case when i.prcs_status = ''created'' then 1 else 0 end), 0)  as created_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''created'', p_clear_cache => ''RP,RIR'') as instance_created_link,',
'    nvl(sum(case when i.prcs_status = ''running'' then 1 else 0 end), 0)  as running_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''running'', p_clear_cache => ''RP,RIR'') as instance_running_link,',
'    nvl(sum(case when i.prcs_status = ''completed'' then 1 else 0 end), 0) as completed_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''completed'', p_clear_cache => ''RP,RIR'') as instance_completed_link,',
'    nvl(sum(case when i.prcs_status = ''terminated'' then 1 else 0 end), 0)  as terminated_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''terminated'', p_clear_cache => ''RP,RIR'') as instance_terminated_link,',
'    nvl(sum(case when i.prcs_status = ''error'' then 1 else 0 end), 0) as error_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''error'', p_clear_cache => ''RP,RIR'') as instance_error_link',
'from flow_instances_vw i'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(12495570578125880206)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34404729118171433)
,p_query_column_id=>1
,p_column_alias=>'CREATED_INSTANCES'
,p_column_display_sequence=>1
,p_column_heading=>'Created'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<a href="#INSTANCE_CREATED_LINK#"><span class="instance-counter-link" data-status="created">#CREATED_INSTANCES#</span></a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34405276469171438)
,p_query_column_id=>2
,p_column_alias=>'INSTANCE_CREATED_LINK'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34404808882171434)
,p_query_column_id=>3
,p_column_alias=>'RUNNING_INSTANCES'
,p_column_display_sequence=>2
,p_column_heading=>'Running'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<a href="#INSTANCE_RUNNING_LINK#"><span class="instance-counter-link" data-status="running">#RUNNING_INSTANCES#</span></a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34405310659171439)
,p_query_column_id=>4
,p_column_alias=>'INSTANCE_RUNNING_LINK'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34404982371171435)
,p_query_column_id=>5
,p_column_alias=>'COMPLETED_INSTANCES'
,p_column_display_sequence=>3
,p_column_heading=>'Completed'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<a href="#INSTANCE_COMPLETED_LINK#"><span class="instance-counter-link" data-status="completed">#COMPLETED_INSTANCES#</span></a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34405470286171440)
,p_query_column_id=>6
,p_column_alias=>'INSTANCE_COMPLETED_LINK'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34405020184171436)
,p_query_column_id=>7
,p_column_alias=>'TERMINATED_INSTANCES'
,p_column_display_sequence=>4
,p_column_heading=>'Terminated'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<a href="#INSTANCE_TERMINATED_LINK#"><span class="instance-counter-link" data-status="terminated">#TERMINATED_INSTANCES#</span></a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34405533448171441)
,p_query_column_id=>8
,p_column_alias=>'INSTANCE_TERMINATED_LINK'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34405145511171437)
,p_query_column_id=>9
,p_column_alias=>'ERROR_INSTANCES'
,p_column_display_sequence=>5
,p_column_heading=>'Error'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<a href="#INSTANCE_ERROR_LINK#"><span class="instance-counter-link" data-status="error">#ERROR_INSTANCES#</span></a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(34405630954171442)
,p_query_column_id=>10
,p_column_alias=>'INSTANCE_ERROR_LINK'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(34405803831171444)
,p_plug_name=>'Current Flow Instances per Model - Top 10'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(34405931132171445)
,p_region_id=>wwv_flow_imp.id(34405803831171444)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'on'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'value-desc'
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
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(34406094116171446)
,p_chart_id=>wwv_flow_imp.id(34405931132171445)
,p_seq=>10
,p_name=>'Created'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with top_procs as ',
'(',
'select d.dgrm_id, d.dgrm_name, count(i.prcs_id)',
'from  flow_diagrams d',
'join  flow_processes i',
'  on d.dgrm_id = i.prcs_dgrm_id',
'group by d.dgrm_id, d.dgrm_name',
'order by count(i.prcs_id) desc',
'fetch first 15 rows only',
')',
'select p.dgrm_id, p.dgrm_name label, count(i.prcs_id) value',
'from top_procs p',
'left join flow_processes i',
' on p.dgrm_id = i.prcs_dgrm_id',
'where i.prcs_status = ''created''',
'group by p.dgrm_id, p.dgrm_name'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D9B13B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::P16_DGRM_ID,P16_DGRM_NAME_VERSION:&DGRM_ID.,&LABEL.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(34406322852171449)
,p_chart_id=>wwv_flow_imp.id(34405931132171445)
,p_seq=>20
,p_name=>'Running'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with top_procs as ',
'(',
'select d.dgrm_id, d.dgrm_name, count(i.prcs_id)',
'from  flow_diagrams d',
'join  flow_processes i',
'  on d.dgrm_id = i.prcs_dgrm_id',
'group by d.dgrm_id, d.dgrm_name',
'order by count(i.prcs_id) desc',
'fetch first 15 rows only',
')',
'select p.dgrm_id, p.dgrm_name label, count(i.prcs_id) value',
'from top_procs p',
'left join flow_processes i',
' on p.dgrm_id = i.prcs_dgrm_id',
'where i.prcs_status = ''running''',
'group by p.dgrm_id, p.dgrm_name'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#6AAD42'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::P16_DGRM_ID,P16_DGRM_NAME_VERSION:&DGRM_ID.,&LABEL.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(34406421411171450)
,p_chart_id=>wwv_flow_imp.id(34405931132171445)
,p_seq=>30
,p_name=>'Completed'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with top_procs as ',
'(',
'select d.dgrm_id, d.dgrm_name, count(i.prcs_id)',
'from  flow_diagrams d',
'join  flow_processes i',
'  on d.dgrm_id = i.prcs_dgrm_id',
'group by d.dgrm_id, d.dgrm_name',
'order by count(i.prcs_id) desc',
'fetch first 15 rows only',
')',
'select p.dgrm_id, p.dgrm_name label, count(i.prcs_id) value',
'from top_procs p',
'left join flow_processes i',
' on p.dgrm_id = i.prcs_dgrm_id',
'where i.prcs_status = ''completed''',
'group by p.dgrm_id, p.dgrm_name'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#8C9EB0 '
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::P16_DGRM_ID,P16_DGRM_NAME_VERSION:&DGRM_ID.,&LABEL.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(34629958268575801)
,p_chart_id=>wwv_flow_imp.id(34405931132171445)
,p_seq=>40
,p_name=>'Terminated'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with top_procs as ',
'(',
'select d.dgrm_id, d.dgrm_name, count(i.prcs_id)',
'from  flow_diagrams d',
'join  flow_processes i',
'  on d.dgrm_id = i.prcs_dgrm_id',
'group by d.dgrm_id, d.dgrm_name',
'order by count(i.prcs_id) desc',
'fetch first 15 rows only',
')',
'select p.dgrm_id, p.dgrm_name label, count(i.prcs_id) value',
'from top_procs p',
'left join flow_processes i',
' on p.dgrm_id = i.prcs_dgrm_id',
'where i.prcs_status = ''terminated''',
'group by p.dgrm_id, p.dgrm_name'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D76A27'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::P16_DGRM_ID,P16_DGRM_NAME_VERSION:&DGRM_ID.,&LABEL.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(34630038161575802)
,p_chart_id=>wwv_flow_imp.id(34405931132171445)
,p_seq=>50
,p_name=>'Error'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with top_procs as ',
'(',
'select d.dgrm_id, d.dgrm_name, count(i.prcs_id)',
'from  flow_diagrams d',
'join  flow_processes i',
'  on d.dgrm_id = i.prcs_dgrm_id',
'group by d.dgrm_id, d.dgrm_name',
'order by count(i.prcs_id) desc',
'fetch first 15 rows only',
')',
'select p.dgrm_id, p.dgrm_name label, count(i.prcs_id) value',
'from top_procs p',
'left join flow_processes i',
' on p.dgrm_id = i.prcs_dgrm_id',
'where i.prcs_status = ''error''',
'group by p.dgrm_id, p.dgrm_name'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D2433B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:16:&SESSION.::&DEBUG.::P16_DGRM_ID,P16_DGRM_NAME_VERSION:&DGRM_ID.,&LABEL.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(34406178037171447)
,p_chart_id=>wwv_flow_imp.id(34405931132171445)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
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
 p_id=>wwv_flow_imp.id(34406265588171448)
,p_chart_id=>wwv_flow_imp.id(34405931132171445)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(34586934772532100)
,p_plug_name=>'Flow Instances started in the last 14 days'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(34587344445532101)
,p_region_id=>wwv_flow_imp.id(34586934772532100)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
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
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(34589026072532104)
,p_chart_id=>wwv_flow_imp.id(34587344445532101)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with period as (',
'    select sysdate - 13 + level - 1 dt',
'    from   dual',
'    connect by level <= (',
'      sysdate - sysdate  + 14',
'    )',
'  )',
'  select  to_char(trunc(p.dt), ''YYYY-MM-DD'') label, count(ins.prcs_id) as value',
'  from period p',
'  left join flow_instances_vw ins on trunc(cast(ins.prcs_start_ts as date)) = trunc(p.dt)',
'  group by to_char(trunc(p.dt), ''YYYY-MM-DD'')',
'  order by  to_char(trunc(p.dt), ''YYYY-MM-DD'')'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D9B13B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::P15_DATE:&LABEL.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(34587853181532103)
,p_chart_id=>wwv_flow_imp.id(34587344445532101)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
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
 p_id=>wwv_flow_imp.id(34588414131532104)
,p_chart_id=>wwv_flow_imp.id(34587344445532101)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'auto'
,p_minor_tick_rendered=>'auto'
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(34631684166575818)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3508955560851702)
,p_name=>'P3_VERSION_MISMATCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(34631684166575818)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3511819715851731)
,p_name=>'P3_APEX_UPGRADE_DETECTED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(34631684166575818)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3509091092851703)
,p_computation_sequence=>10
,p_computation_item=>'P3_VERSION_MISMATCH'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    return flow_engine_app_api.check_version_mismatch( p_app_id => :app_id);',
'end;'))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(3512045963851733)
,p_computation_sequence=>20
,p_computation_item=>'P3_APEX_UPGRADE_DETECTED'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    return flow_engine_app_api.check_apex_upgrade( p_app_id => :app_id);',
'end;'))
);
wwv_flow_imp.component_end;
end;
/
