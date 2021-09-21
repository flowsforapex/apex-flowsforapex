prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow'
,p_alias=>'FLOW'
,p_step_title=>'Flow - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'initPage7();'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20210916120936'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7937843762499701)
,p_plug_name=>'Action Menu'
,p_region_name=>'actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:js-addActions'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_list_id=>wwv_flow_api.id(7935522414465879)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(26003019626877931)
,p_plug_name=>'Attributes'
,p_region_name=>'attributes'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>9
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_DIAGRAMS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(28425138174759832)
,p_plug_name=>'Flow Viewer'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_DIAGRAMS_VW'
,p_query_where=>'dgrm_id = :p7_dgrm_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION'
,p_ajax_items_to_submit=>'P7_DGRM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P7_DGRM_ID'
,p_attribute_01=>'DGRM_CONTENT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_attribute_10=>'Y'
,p_attribute_11=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34402779943171413)
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
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(36450747308745933)
,p_name=>'Process instances per status'
,p_region_name=>'instances_counter'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-BadgeList--large:t-BadgeList--circular:t-BadgeList--cols t-BadgeList--3cols:t-Report--hideNoPagination'
,p_new_grid_row=>false
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0007_INSTANCES_COUNTER_VW'
,p_query_where=>'dgrm_id = :P7_DGRM_ID'
,p_include_rowid_column=>false
,p_display_when_condition=>'P7_DGRM_ID'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P7_DGRM_ID'
,p_query_row_template=>wwv_flow_api.id(12495570578125880206)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(26021369466277917)
,p_query_column_id=>1
,p_column_alias=>'DGRM_ID'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(26021760516277918)
,p_query_column_id=>2
,p_column_alias=>'CREATED_INSTANCES'
,p_column_display_sequence=>1
,p_column_heading=>'Created'
,p_use_as_row_header=>'N'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span data-status="created">#CREATED_INSTANCES#</a>',
''))
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(26022166035277918)
,p_query_column_id=>3
,p_column_alias=>'RUNNING_INSTANCES'
,p_column_display_sequence=>2
,p_column_heading=>'Running'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span data-status="running">#RUNNING_INSTANCES#</a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(26022532889277920)
,p_query_column_id=>4
,p_column_alias=>'COMPLETED_INSTANCES'
,p_column_display_sequence=>3
,p_column_heading=>'Completed'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span data-status="completed">#COMPLETED_INSTANCES#</a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34402829743171414)
,p_query_column_id=>5
,p_column_alias=>'TERMINATED_INSTANCES'
,p_column_display_sequence=>5
,p_column_heading=>'Terminated'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span data-status="terminated">#TERMINATED_INSTANCES#</a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(34402963356171415)
,p_query_column_id=>6
,p_column_alias=>'ERROR_INSTANCES'
,p_column_display_sequence=>6
,p_column_heading=>'Error'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span data-status="error">#ERROR_INSTANCES#</a>'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(45087523137560136)
,p_plug_name=>'New Version'
,p_region_name=>'new_version_reg'
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
 p_id=>wwv_flow_api.id(45089270532561391)
,p_plug_name=>'Delete Model'
,p_region_name=>'delete_reg'
,p_region_template_options=>'#DEFAULT#:js-dialog-size600x400'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(45089418627561392)
,p_name=>'Associated process instances'
,p_parent_plug_id=>wwv_flow_api.id(45089270532561391)
,p_template=>wwv_flow_api.id(12495613507239880288)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlightOff:t-Report--noBorders:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select apex_lang.message(p_name => ''APP_DIAGRAM_INSTANCES_NB'', p0 => nb_instances) as nb_instances',
'from (',
'select count(*) as nb_instances',
'from flow_processes',
'where prcs_dgrm_id = :P7_DGRM_ID',
')'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P7_DGRM_ID'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_headings_type=>'NO_HEADINGS'
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(26069606115228470)
,p_query_column_id=>1
,p_column_alias=>'NB_INSTANCES'
,p_column_display_sequence=>1
,p_column_heading=>'Nb Instances'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(45090112965561399)
,p_plug_name=>'Form'
,p_parent_plug_id=>wwv_flow_api.id(45089270532561391)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26067817325227237)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(45087523137560136)
,p_button_name=>'ADD_VERSION'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Version'
,p_button_position=>'BELOW_BOX'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-chevron-circle-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24215404585956138)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(26003019626877931)
,p_button_name=>'NEW_VERSION'
,p_button_static_id=>'new_version_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--simple:t-Button--iconLeft:t-Button--stretch:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'New Version'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P7_DGRM_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-arrow-circle-o-up'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24215607769956140)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_api.id(26003019626877931)
,p_button_name=>'DEPRECATE'
,p_button_static_id=>'deprecate_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--simple:t-Button--iconLeft:t-Button--stretch:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Deprecate'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P7_DGRM_STATUS = flow_constants_pkg.gc_dgrm_status_released'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-ban'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24215581832956139)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_api.id(26003019626877931)
,p_button_name=>'RELEASE'
,p_button_static_id=>'release_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--simple:t-Button--iconLeft:t-Button--stretch:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Release'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P7_DGRM_ID is not null and :P7_DGRM_STATUS = flow_constants_pkg.gc_dgrm_status_draft'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-check'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(24215790121956141)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_api.id(26003019626877931)
,p_button_name=>'ARCHIVE'
,p_button_static_id=>'archive_btn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--simple:t-Button--iconLeft:t-Button--stretch:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Archive'
,p_button_position=>'BODY'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P7_DGRM_STATUS = flow_constants_pkg.gc_dgrm_status_deprecated'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-archive'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(34404258251171428)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(45089270532561391)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26068946058228467)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(45089270532561391)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_CREATE'
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26091600150304603)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(28425138174759832)
,p_button_name=>'MODIFY_DIAGRAM'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Modify Diagram'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P7_DGRM_STATUS = flow_constants_pkg.gc_dgrm_status_draft ',
'or (',
'    :P7_DGRM_STATUS = flow_constants_pkg.gc_dgrm_status_released ',
'    and flow_engine_util.get_config_value(',
'           p_config_key => ''engine_app_mode''',
'         , p_default_value => flow_constants_pkg.gc_config_default_engine_app_mode',
'       ) = ''development''',
')'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-apex'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26009257493877978)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(34402779943171413)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_DGRM_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'UPDATE'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(5522981517864950)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(34402779943171413)
,p_button_name=>'ACTION_MENU'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_button_image_alt=>'Action Menu'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P7_DGRM_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_button_css_classes=>'js-menuButton'
,p_icon_css_classes=>'fa-bars'
,p_button_cattributes=>'data-menu="actions_menu"'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(26009611434877978)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_api.id(34402779943171413)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_button_condition=>'P7_DGRM_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-plus'
,p_database_action=>'INSERT'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(24216692251956150)
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'DELETE'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(34402504419171411)
,p_branch_name=>'Go To Page 4'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_DGRM_ID:&P7_DGRM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'MODIFY_DIAGRAM'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(8026927386825638)
,p_name=>'P7_ENGINE_APP_MODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7937843762499701)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24212748636956111)
,p_name=>'P7_DGRM_LAST_UPDATE'
,p_source_data_type=>'TIMESTAMP_TZ'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_source_plug_id=>wwv_flow_api.id(26003019626877931)
,p_source=>'DGRM_LAST_UPDATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26003369119877940)
,p_name=>'P7_DGRM_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_source_plug_id=>wwv_flow_api.id(26003019626877931)
,p_source=>'DGRM_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26003724086877950)
,p_name=>'P7_DGRM_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_source_plug_id=>wwv_flow_api.id(26003019626877931)
,p_prompt=>'Name'
,p_source=>'DGRM_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>600
,p_read_only_when=>'P7_DGRM_STATUS'
,p_read_only_when2=>'draft'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26004107468877957)
,p_name=>'P7_DGRM_VERSION'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_source_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_default=>'0'
,p_prompt=>'Version'
,p_source=>'DGRM_VERSION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>40
,p_read_only_when=>'P7_DGRM_STATUS'
,p_read_only_when2=>'draft'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26004547057877957)
,p_name=>'P7_DGRM_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_source_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_default=>'flow_constants_pkg.gc_dgrm_status_draft'
,p_item_default_type=>'PLSQL_EXPRESSION'
,p_prompt=>'Status'
,p_source=>'DGRM_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_colspan=>10
,p_display_when=>'P7_DGRM_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26004901378877959)
,p_name=>'P7_DGRM_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(26003019626877931)
,p_item_source_plug_id=>wwv_flow_api.id(26003019626877931)
,p_prompt=>'Category'
,p_source=>'DGRM_CATEGORY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'DIAGRAM_CATEGORIES_LOV'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'No Category'
,p_cSize=>60
,p_cMaxlength=>120
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'Y'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26068279548227242)
,p_name=>'P7_NEW_VERSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(45087523137560136)
,p_prompt=>'New Version'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(26070342430228478)
,p_name=>'P7_CASCADE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(45090112965561399)
,p_prompt=>'Cascade'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Delete associated process instances'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(34403109564171417)
,p_computation_sequence=>10
,p_computation_item=>'FLOW_PAGE_TITLE'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'PLSQL_EXPRESSION'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'case ',
'    when :P7_DGRM_ID is null ',
'    then ',
'        apex_lang.message(',
'            p_name => ''APP_TITLE_NEW_MODEL''',
'        )',
'    else ',
'        apex_lang.message(',
'              p_name => ''APP_TITLE_MODEL''',
'            , p0 => :P7_DGRM_NAME',
'            , p1 => :P7_DGRM_VERSION',
'        )',
'end'))
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(8027046376825639)
,p_computation_sequence=>10
,p_computation_item=>'P7_ENGINE_APP_MODE'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'FUNCTION_BODY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_util.get_config_value(',
'           p_config_key => ''engine_app_mode''',
'         , p_default_value => flow_constants_pkg.gc_config_default_engine_app_mode',
'       );'))
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(26093582071304622)
,p_validation_name=>'Version'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_err varchar2(4000);',
'    l_version_exists number;',
'begin',
'    if (:P7_NEW_VERSION is null) then',
'        l_err := apex_lang.message(p_name => ''APEX.PAGE_ITEM_IS_REQUIRED''); --''#LABEL# must have a value'';',
'    else',
'        select count(*)',
'        into l_version_exists',
'        from flow_diagrams',
'        where dgrm_name = :P7_DGRM_NAME',
'        and dgrm_version = :P7_NEW_VERSION;',
'        ',
'        if (l_version_exists > 0) then',
'            l_err := apex_lang.message(p_name => ''APP_ERR_MODEL_VERSION_EXIST'');',
'        end if;',
'    end if;',
'    return l_err;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_ERR_TEXT'
,p_validation_condition=>'ADD_VERSION'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_api.id(26068279548227242)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24216185870956145)
,p_name=>'Open new version'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(24215404585956138)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26093383508304620)
,p_event_id=>wwv_flow_api.id(24216185870956145)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_NEW_VERSION'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24216276371956146)
,p_event_id=>wwv_flow_api.id(24216185870956145)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(45087523137560136)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(26096043786304647)
,p_name=>'Click on instances counter'
,p_event_sequence=>40
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.instance-counter-link'
,p_bind_type=>'live'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(26096178250304648)
,p_event_id=>wwv_flow_api.id(26096043786304647)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myElement = $( this.triggeringElement ).children().first();',
'var prcsStatus  = myElement.data( "status" );',
'var dgrmName = apex.item("P7_DGRM_NAME").getValue();',
'var dgrmVersion = apex.item("P7_DGRM_VERSION").getValue();',
'',
'apex.navigation.redirect( "f?p=" + $v( "pFlowId" ) + ":10:" + $v( "pInstance" ) + "::" + (apex.debug.getLevel() >= 4 ? "LEVEL" + apex.debug.getLevel() : "") + ":RIR,RP:IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS:" + dgrmName + "," + dgrmVer'
||'sion + "," + prcsStatus);'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34402165369171407)
,p_name=>'Click on Modify Diagram'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(26091600150304603)
,p_condition_element=>'P7_DGRM_STATUS'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'draft'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34402245490171408)
,p_event_id=>wwv_flow_api.id(34402165369171407)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'MODIFY_DIAGRAM'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34402409828171410)
,p_event_id=>wwv_flow_api.id(34402165369171407)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'&APP_TEXT$APP_CONFIRM_EDIT_RELEASE_DIAGRAM.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34402353637171409)
,p_event_id=>wwv_flow_api.id(34402165369171407)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'MODIFY_DIAGRAM'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34404369417171429)
,p_name=>'Click on Cancel'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(34404258251171428)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34404485254171430)
,p_event_id=>wwv_flow_api.id(34404369417171429)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(45089270532561391)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34630409664575806)
,p_name=>'Click On Release'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(24215581832956139)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34630565554575807)
,p_event_id=>wwv_flow_api.id(34630409664575806)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'&APP_TEXT$APP_CONFIRM_RELEASE_MODEL.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34630686363575808)
,p_event_id=>wwv_flow_api.id(34630409664575806)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'RELEASE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(34630711735575809)
,p_name=>'Click on Deprecate'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(24215607769956140)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34630828651575810)
,p_event_id=>wwv_flow_api.id(34630711735575809)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'&APP_TEXT$APP_CONFIRM_DEPRECATE_MODEL.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(34630931054575811)
,p_event_id=>wwv_flow_api.id(34630711735575809)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'DEPRECATE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(8024957923825618)
,p_name=>'Click on Archive'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(24215790121956141)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8025177637825620)
,p_event_id=>wwv_flow_api.id(8024957923825618)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'&APP_TEXT$APP_CONFIRM_ARCHIVE_MODEL.'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(8025291955825621)
,p_event_id=>wwv_flow_api.id(8024957923825618)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'ARCHIVE'
,p_attribute_02=>'Y'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(22799930478488038)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PROCESS_PAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_p0007_api.process_page',
'(',
'  pio_dgrm_id      => :p7_dgrm_id',
', pi_dgrm_name     => :p7_dgrm_name',
', pi_dgrm_version  => :p7_dgrm_version',
', pi_dgrm_category => :p7_dgrm_category',
', pi_new_version   => :p7_new_version',
', pi_cascade       => :p7_cascade',
', pi_request       => :request',
');'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':request not in (''FLOWS'', ''FLOWS-DARK'', ''DARK_MODE'', ''LIGHT_MODE'')'
,p_process_when_type=>'PLSQL_EXPRESSION'
,p_process_success_message=>'Action processed.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(22800039236488039)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Session State on Delete'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.component_end;
end;
/
begin
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(26010056924877981)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(26003019626877931)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Edit Diagram'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
null;
wwv_flow_api.component_end;
end;
/
