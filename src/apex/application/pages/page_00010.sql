prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>984337
,p_default_id_offset=>0
,p_default_owner=>'MT_NDBRUIJN'
);
wwv_flow_api.create_page(
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Instances'
,p_alias=>'FLOW_INSTANCES'
,p_step_title=>'Flow Instances'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.clickable-action {',
'  cursor: pointer;',
'}'))
,p_step_template=>wwv_flow_api.id(12495618547053880299)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'NDBRUIJN'
,p_last_upd_yyyymmddhh24miss=>'20200701212745'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(160796420876501967)
,p_plug_name=>'Choose Branch'
,p_region_name=>'multi_step_chooser'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(173008747142503554)
,p_plug_name=>'Flow Control'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495604368136880259)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(160799453422501997)
,p_name=>'Subflows'
,p_parent_plug_id=>wwv_flow_api.id(173008747142503554)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>30
,p_region_css_classes=>'js-react-on-prcs js-hide-no-prcs'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_SUBFLOWS_VW'
,p_query_where=>'sbfl_prcs_id = :p10_prcs_id'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P10_PRCS_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No current subflows found.'
,p_query_num_rows_type=>'ROW_RANGES_WITH_LINKS'
,p_pagination_display_position=>'BOTTOM_LEFT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160799330531501996)
,p_query_column_id=>1
,p_column_alias=>'SBFL_ID'
,p_column_display_sequence=>2
,p_column_heading=>'ID'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160799230943501995)
,p_query_column_id=>2
,p_column_alias=>'SBFL_SBFL_ID'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160799129243501994)
,p_query_column_id=>3
,p_column_alias=>'SBFL_STARTING_OBJECT'
,p_column_display_sequence=>5
,p_column_heading=>'Starting Object'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160799018324501993)
,p_query_column_id=>4
,p_column_alias=>'SBFL_ROUTE'
,p_column_display_sequence=>6
,p_column_heading=>'Route'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798879972501992)
,p_query_column_id=>5
,p_column_alias=>'SBFL_LAST_COMPLETED'
,p_column_display_sequence=>7
,p_column_heading=>'Last Completed'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798785838501991)
,p_query_column_id=>6
,p_column_alias=>'SBFL_CURRENT'
,p_column_display_sequence=>8
,p_column_heading=>'Current'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798717697501990)
,p_query_column_id=>7
,p_column_alias=>'SBFL_LAST_UPDATE'
,p_column_display_sequence=>9
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798666092501989)
,p_query_column_id=>8
,p_column_alias=>'SBFL_STATUS'
,p_column_display_sequence=>3
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798494661501988)
,p_query_column_id=>9
,p_column_alias=>'NEXT_STEP_LINK'
,p_column_display_sequence=>1
,p_column_heading=>'<span class="fa fa-arrows-alt"></span>'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="#CLASS_STRING#" data-prcs="#SBFL_PRCS_ID#" data-sbfl="#SBFL_ID#" data-action="#DATA_ACTION#" title="#TITLE#"></span>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160796580484501969)
,p_query_column_id=>10
,p_column_alias=>'IS_MULTISTEP'
,p_column_display_sequence=>12
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798297119501986)
,p_query_column_id=>11
,p_column_alias=>'SBFL_PRCS_ID'
,p_column_display_sequence=>11
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160798410431501987)
,p_query_column_id=>12
,p_column_alias=>'CLASS_STRING'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160796483223501968)
,p_query_column_id=>13
,p_column_alias=>'DATA_ACTION'
,p_column_display_sequence=>13
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160795987225501963)
,p_query_column_id=>14
,p_column_alias=>'TITLE'
,p_column_display_sequence=>14
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(12493545854579486121)
,p_name=>'Flow Instances'
,p_parent_plug_id=>wwv_flow_api.id(173008747142503554)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--staticRowColors:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   select prcs.prcs_id',
'        , prcs.prcs_name',
'        , prcs.prcs_status',
'        , prcs.prcs_dgrm_name',
'        , prcs.prcs_init_date',
'        , prcs.prcs_last_update',
'        , prcs.start_link',
'        , prcs.reset_link',
'        , prcs.delete_link',
'     from flow_p0010_instances_vw prcs'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No current flow instances found.'
,p_query_num_rows_type=>'ROW_RANGES_WITH_LINKS'
,p_pagination_display_position=>'BOTTOM_LEFT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75701329407828129)
,p_query_column_id=>1
,p_column_alias=>'PRCS_ID'
,p_column_display_sequence=>1
,p_default_sort_column_sequence=>1
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75701396396828130)
,p_query_column_id=>2
,p_column_alias=>'PRCS_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(6600215407290123)
,p_query_column_id=>3
,p_column_alias=>'PRCS_STATUS'
,p_column_display_sequence=>8
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75701490799828131)
,p_query_column_id=>4
,p_column_alias=>'PRCS_DGRM_NAME'
,p_column_display_sequence=>7
,p_column_heading=>'Flow'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75701686225828133)
,p_query_column_id=>5
,p_column_alias=>'PRCS_INIT_DATE'
,p_column_display_sequence=>9
,p_column_heading=>'Creation Date'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(75701815255828134)
,p_query_column_id=>6
,p_column_alias=>'PRCS_LAST_UPDATE'
,p_column_display_sequence=>10
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12491782668638762844)
,p_query_column_id=>7
,p_column_alias=>'START_LINK'
,p_column_display_sequence=>3
,p_column_heading=>'<span class="fa fa-play" title="Start Process Instance"></span>'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="clickable-action fa fa-play" data-prcs="#PRCS_ID#" data-action="start" title="Start Process Instance"></span>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12491782525484762843)
,p_query_column_id=>8
,p_column_alias=>'RESET_LINK'
,p_column_display_sequence=>4
,p_column_heading=>'<span class="fa fa-undo" title="Reset Process Instance"></span>'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="clickable-action fa fa-undo" data-prcs="#PRCS_ID#" data-action="reset" title="Reset Process Instance"></span>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(12491782481671762842)
,p_query_column_id=>9
,p_column_alias=>'DELETE_LINK'
,p_column_display_sequence=>5
,p_column_heading=>'<span class="fa fa-trash" title="Delete Process Instance"></span>'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="clickable-action fa fa-trash" data-prcs="#PRCS_ID#" data-action="delete" title="Delete Process Instance"></span>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(160797404213501977)
,p_query_column_id=>10
,p_column_alias=>'DERIVED$01'
,p_column_display_sequence=>2
,p_column_heading=>'<span class="fa fa-eye" title="View Process Instance"></span>'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span class="clickable-action fa fa-eye" data-prcs="#PRCS_ID#" data-action="view" title="View Process Instance"></span>'
,p_derived_column=>'Y'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6127698437330102702)
,p_plug_name=>'Flow Monitor'
,p_region_css_classes=>'js-react-on-prcs js-hide-no-prcs'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0010_VW'
,p_query_where=>'prcs_id = :p10_prcs_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.MTAG.AS.WFP.REGION'
,p_ajax_items_to_submit=>'P10_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'DGRM_CONTENT'
,p_attribute_02=>'ALL_CURRENT'
,p_attribute_03=>':'
,p_attribute_04=>'ALL_COMPLETED'
,p_attribute_05=>':'
,p_attribute_06=>'LAST_COMPLETED'
,p_attribute_07=>':'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12491866708043262849)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--slimPadding:margin-bottom-none'
,p_plug_template=>wwv_flow_api.id(12495606500823880260)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(160796295436501966)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(160796420876501967)
,p_button_name=>'SELECT_BRANCH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Select Branch'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-sign-out'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12491866636991262848)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12491866708043262849)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Create'
,p_button_position=>'TOP'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:RP::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6600306983290124)
,p_name=>'P10_SBFL_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12491864731021262829)
,p_name=>'P10_PRCS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12493545854579486121)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12519723272096181854)
,p_name=>'P10_BRANCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(160796420876501967)
,p_prompt=>'Option'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select conn.d',
'     , conn.r',
'  from flow_p0010_branches_vw conn',
' where conn.prcs_id = :p10_prcs_id',
'   and conn.sbfl_id = :p10_sbfl_id',
';'))
,p_lov_cascade_parent_items=>'P10_PRCS_ID,P10_SBFL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160797771746501981)
,p_name=>'Create Process Dialog closed - refresh Instances'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12491866636991262848)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797694678501980)
,p_event_id=>wwv_flow_api.id(160797771746501981)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(12493545854579486121)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160797616307501979)
,p_name=>'Process Instance changed - Refresh BPMN Diagram'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_PRCS_ID'
,p_condition_element=>'P10_PRCS_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797119562501974)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'.js-hide-no-prcs'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(165495673080747086)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(12493545854579486121)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160796977285501973)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'.js-hide-no-prcs'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797554131501978)
,p_event_id=>wwv_flow_api.id(160797616307501979)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'JQUERY_SELECTOR'
,p_affected_elements=>'.js-react-on-prcs'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160797345580501976)
,p_name=>'React on Action requested'
,p_event_sequence=>120
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'document'
,p_bind_type=>'live'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'wfp-action-request'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160797238690501975)
,p_event_id=>wwv_flow_api.id(160797345580501976)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'//var myElement = apex.jQuery( this.triggeringElement );',
'',
'var myAction  = this.data.action;',
'var myProcess = this.data.prcs;',
'var mySubflow = this.data.sbfl;',
'var myBranch  = this.data.branch;',
'',
'if ( myAction !== "view" ) {',
'  var result = apex.server.process( "PROCESS_ACTION", {',
'    x01: myAction,',
'    x02: myProcess,',
'    x03: mySubflow,',
'    x04: myBranch',
'  });',
'  result.done( function( data ) {',
'    if (!data.success) {',
'      apex.debug.error( "Something went wrong..." );',
'    } else {',
'      if ( myAction === "delete" ) {',
'        apex.item( "P10_PRCS_ID" ).setValue();',
'      } else {',
'        apex.item( "P10_PRCS_ID" ).setValue( myProcess );',
'      }',
'    }',
'  }). fail( function( jqXHR, textStatus, errorThrown ) {',
'    apex.debug.error( "Total fail...", jqXHR, textStatus, errorThrown );',
'  });  ',
'} else {',
'  apex.item( "P10_PRCS_ID" ).setValue( myProcess );',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160796862675501971)
,p_name=>'Clickable Action clicked - Forward to Process or Selection'
,p_event_sequence=>130
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.clickable-action'
,p_bind_type=>'live'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160796714573501970)
,p_event_id=>wwv_flow_api.id(160796862675501971)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myElement = apex.jQuery( this.triggeringElement );',
'',
'if ( myElement.data("action") !== "choose_branch" ) {',
'  apex.event.trigger( document, "wfp-action-request", {',
'    action: myElement.data( "action" ),',
'    prcs:   myElement.data( "prcs" ),',
'    sbfl:   myElement.data( "sbfl" ),',
'    branch: null',
'  });',
'} else {',
'  apex.theme.openRegion( "multi_step_chooser" );',
'  apex.item( "P10_PRCS_ID" ).setValue( myElement.data( "prcs" ), null, true );',
'  apex.item( "P10_SBFL_ID" ).setValue( myElement.data( "sbfl" ), null, true );',
'  apex.item( "P10_BRANCH" ).refresh();',
'}'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(160796264856501965)
,p_name=>'MultiStep Decision taken - trigger process'
,p_event_sequence=>140
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(160796295436501966)
,p_condition_element=>'P10_BRANCH'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(160796072229501964)
,p_event_id=>wwv_flow_api.id(160796264856501965)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myBranch = apex.item( "P10_BRANCH" ).getValue();',
'apex.event.trigger( document, "wfp-action-request", {',
'    action: "choose_branch",',
'    prcs:   apex.item( "P10_PRCS_ID" ).getValue(),',
'    sbfl:   apex.item( "P10_SBFL_ID" ).getValue(),',
'    branch: myBranch',
'  });',
'apex.theme.closeRegion("multi_step_chooser");'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(160796959681501972)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PROCESS_ACTION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_p0010_api.process_action',
'(',
'  pi_action  => apex_application.g_x01',
', pi_prcs_id => apex_application.g_x02',
', pi_sbfl_id => apex_application.g_x03',
', pi_branch  => apex_application.g_x04',
');'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
