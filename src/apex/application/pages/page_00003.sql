prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Dashboard'
,p_alias=>'DASHBOARD'
,p_step_title=>'Dashboard - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'initPage3();'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20210902110542'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(34404686490171432)
,p_name=>'Flow Instances per status'
,p_region_name=>'flow-instances-per-status'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-BadgeList--large:t-BadgeList--dash:t-BadgeList--cols t-BadgeList--5cols:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ',
'    sum(case when i.prcs_status = ''created'' then 1 else 0 end)  as created_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''created'', p_clear_cache => ''RP,RIR'') as instance_created_link,',
'    sum(case when i.prcs_status = ''running'' then 1 else 0 end)  as running_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''running'', p_clear_cache => ''RP,RIR'') as instance_running_link,',
'    sum(case when i.prcs_status = ''completed'' then 1 else 0 end) as completed_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''completed'', p_clear_cache => ''RP,RIR'') as instance_completed_link,',
'    sum(case when i.prcs_status = ''terminated'' then 1 else 0 end)  as terminated_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''terminated'', p_clear_cache => ''RP,RIR'') as instance_terminated_link,',
'    sum(case when i.prcs_status = ''error'' then 1 else 0 end) as error_instances,',
'    apex_page.get_url(p_page => 10, p_items => ''IR_PRCS_STATUS'', p_values => ''error'', p_clear_cache => ''RP,RIR'') as instance_error_link',
'from flow_instances_vw i'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(12495570578125880206)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34404729118171433)
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
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34405276469171438)
,p_query_column_id=>2
,p_column_alias=>'INSTANCE_CREATED_LINK'
,p_column_display_sequence=>6
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34404808882171434)
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
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34405310659171439)
,p_query_column_id=>4
,p_column_alias=>'INSTANCE_RUNNING_LINK'
,p_column_display_sequence=>7
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34404982371171435)
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
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34405470286171440)
,p_query_column_id=>6
,p_column_alias=>'INSTANCE_COMPLETED_LINK'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34405020184171436)
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
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34405533448171441)
,p_query_column_id=>8
,p_column_alias=>'INSTANCE_TERMINATED_LINK'
,p_column_display_sequence=>9
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34405145511171437)
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
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34405630954171442)
,p_query_column_id=>10
,p_column_alias=>'INSTANCE_ERROR_LINK'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34405803831171444)
,p_plug_name=>'Flow Instances per Diagram - Top 10'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_num_rows=>15
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(34405931132171445)
,p_region_id=>wwv_flow_api.id(34405803831171444)
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
,p_sorting=>'value-desc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(34406094116171446)
,p_chart_id=>wwv_flow_api.id(34405931132171445)
,p_seq=>10
,p_name=>'Created'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d.dgrm_name label, count(i.prcs_id) value',
'from flow_diagrams_vw d',
'left join flow_instances_vw i on i.dgrm_id = d.dgrm_id and i.prcs_status = ''created''',
'group by d.dgrm_name',
'order by 2 desc, 1 asc',
'fetch first 10 rows only'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D9B13B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(34406322852171449)
,p_chart_id=>wwv_flow_api.id(34405931132171445)
,p_seq=>20
,p_name=>'Running'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d.dgrm_name label, count(i.prcs_id) value',
'from flow_diagrams_vw d',
'left join flow_instances_vw i on i.dgrm_id = d.dgrm_id and i.prcs_status = ''running''',
'group by d.dgrm_name',
'order by 2 desc, 1 asc',
'fetch first 10 rows only'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#6AAD42'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(34406421411171450)
,p_chart_id=>wwv_flow_api.id(34405931132171445)
,p_seq=>30
,p_name=>'Completed'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d.dgrm_name label, count(i.prcs_id) value',
'from flow_diagrams_vw d',
'left join flow_instances_vw i on i.dgrm_id = d.dgrm_id and i.prcs_status = ''completed''',
'group by d.dgrm_name',
'order by 2 desc, 1 asc',
'fetch first 10 rows only'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#8C9EB0 '
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(34629958268575801)
,p_chart_id=>wwv_flow_api.id(34405931132171445)
,p_seq=>40
,p_name=>'Terminated'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d.dgrm_name label, count(i.prcs_id) value',
'from flow_diagrams_vw d',
'left join flow_instances_vw i on i.dgrm_id = d.dgrm_id and i.prcs_status = ''terminated''',
'group by d.dgrm_name',
'order by 2 desc, 1 asc',
'fetch first 10 rows only'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D76A27'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(34630038161575802)
,p_chart_id=>wwv_flow_api.id(34405931132171445)
,p_seq=>50
,p_name=>'Error'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d.dgrm_name label, count(i.prcs_id) value',
'from flow_diagrams_vw d',
'left join flow_instances_vw i on i.dgrm_id = d.dgrm_id and i.prcs_status = ''error''',
'group by d.dgrm_name',
'order by 2 desc, 1 asc',
'fetch first 10 rows only'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D2433B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(34406178037171447)
,p_chart_id=>wwv_flow_api.id(34405931132171445)
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
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(34406265588171448)
,p_chart_id=>wwv_flow_api.id(34405931132171445)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34586934772532100)
,p_plug_name=>'Flow Instances created in the last 7 days'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_jet_chart(
 p_id=>wwv_flow_api.id(34587344445532101)
,p_region_id=>wwv_flow_api.id(34586934772532100)
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
wwv_flow_api.create_jet_chart_series(
 p_id=>wwv_flow_api.id(34589026072532104)
,p_chart_id=>wwv_flow_api.id(34587344445532101)
,p_seq=>10
,p_name=>'Series 1'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with period as (',
'    select sysdate - 7 + level - 1 dt',
'    from   dual',
'    connect by level <= (',
'      sysdate - sysdate  + 8',
'    )',
'  )',
'  select  to_char(trunc(p.dt), ''YYYY-MM-DD'') label, count(ins.prcs_id) as value',
'  from period p',
'  left join flow_instances_vw ins on trunc(cast(ins.prcs_init_ts as date)) = trunc(p.dt)',
'  group by to_char(trunc(p.dt), ''YYYY-MM-DD'')',
'  order by  to_char(trunc(p.dt), ''YYYY-MM-DD'')'))
,p_max_row_count=>20
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_color=>'#D9B13B'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(34587853181532103)
,p_chart_id=>wwv_flow_api.id(34587344445532101)
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
wwv_flow_api.create_jet_chart_axis(
 p_id=>wwv_flow_api.id(34588414131532104)
,p_chart_id=>wwv_flow_api.id(34587344445532101)
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
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34631684166575818)
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
wwv_flow_api.component_end;
end;
/
