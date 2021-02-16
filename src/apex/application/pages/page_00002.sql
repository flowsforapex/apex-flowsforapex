prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Management'
,p_alias=>'FLOW-MANAGEMENT'
,p_step_title=>'Flow Management'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'td[headers="NB_INSTANCES"]{',
'   padding-left:0px;',
'}'))
,p_step_template=>wwv_flow_api.id(12495635610083880376)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210215180253'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2405357256481942)
,p_plug_name=>'Facets'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_api.id(9900826057126998)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_06=>'Y'
,p_attribute_07=>'Y'
,p_attribute_09=>'N'
,p_attribute_12=>'10000'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(9900826057126998)
,p_name=>'Flow Management'
,p_region_name=>'parsed_drgm'
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0002_DIAGRAMS_VW'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(12495559701953880190)
,p_query_num_rows=>10
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_break_cols=>'1:2'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_break_type_flag=>'DEFAULT_BREAK_FORMATTING'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404091459481929)
,p_query_column_id=>1
,p_column_alias=>'DGRM_ID'
,p_column_display_sequence=>8
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404172622481930)
,p_query_column_id=>2
,p_column_alias=>'DGRM_NAME'
,p_column_display_sequence=>2
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_default_sort_column_sequence=>2
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404228048481931)
,p_query_column_id=>3
,p_column_alias=>'DGRM_VERSION'
,p_column_display_sequence=>3
,p_column_heading=>'Version'
,p_use_as_row_header=>'N'
,p_default_sort_column_sequence=>3
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404360752481932)
,p_query_column_id=>4
,p_column_alias=>'DGRM_STATUS'
,p_column_display_sequence=>4
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404433838481933)
,p_query_column_id=>5
,p_column_alias=>'DGRM_CATEGORY'
,p_column_display_sequence=>1
,p_column_heading=>'Category'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404590761481934)
,p_query_column_id=>6
,p_column_alias=>'DGRM_LAST_UPDATE'
,p_column_display_sequence=>5
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_column_format=>'&APP_DATE_TIME_FORMAT.'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(2404680441481935)
,p_query_column_id=>7
,p_column_alias=>'BTN'
,p_column_display_sequence=>7
,p_column_heading=>'Actions'
,p_use_as_row_header=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(10430299431468036)
,p_query_column_id=>8
,p_column_alias=>'INSTANCES'
,p_column_display_sequence=>6
,p_column_heading=>'Instances'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10431199676468045)
,p_plug_name=>'Diagram'
,p_region_name=>'diagram_reg'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(2404737406481936)
,p_plug_name=>'BPMN'
,p_parent_plug_id=>wwv_flow_api.id(10431199676468045)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_DIAGRAMS_VW'
,p_query_where=>'dgrm_id = :p2_dgrm_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.MTAG.APEX.BPMNVIEWER.REGION'
,p_ajax_items_to_submit=>'P2_DGRM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'DGRM_CONTENT'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_attribute_10=>'Y'
,p_attribute_11=>'N'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(10430346540468037)
,p_name=>'Process instances per status'
,p_region_name=>'instances_counter'
,p_parent_plug_id=>wwv_flow_api.id(10431199676468045)
,p_template=>wwv_flow_api.id(12495582446800880234)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:u-colors:t-BadgeList--xlarge:t-BadgeList--circular:t-BadgeList--cols t-BadgeList--3cols:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0002_INSTANCES_COUNTER_VW'
,p_query_where=>'dgrm_id = :P2_DGRM_ID'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P2_DGRM_ID'
,p_query_row_template=>wwv_flow_api.id(12495570578125880206)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(10431205669468046)
,p_query_column_id=>1
,p_column_alias=>'DGRM_ID'
,p_column_display_sequence=>4
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(10430529633468039)
,p_query_column_id=>2
,p_column_alias=>'CREATED_INSTANCES'
,p_column_display_sequence=>1
,p_column_heading=>'Created Instances'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(10430699410468040)
,p_query_column_id=>3
,p_column_alias=>'RUNNING_INSTANCES'
,p_column_display_sequence=>2
,p_column_heading=>'Running Instances'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(10430716581468041)
,p_query_column_id=>4
,p_column_alias=>'COMPLETED_INSTANCES'
,p_column_display_sequence=>3
,p_column_heading=>'Completed Instances'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19020002791332918)
,p_plug_name=>'New Version'
,p_region_name=>'new_version_reg'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19020645519332924)
,p_plug_name=>'Delete Diagram'
,p_region_name=>'delete_reg'
,p_region_template_options=>'#DEFAULT#:js-dialog-size600x400'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(19020793614332925)
,p_name=>'Associated process instances'
,p_parent_plug_id=>wwv_flow_api.id(19020645519332924)
,p_template=>wwv_flow_api.id(12495613507239880288)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--danger'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlightOff:t-Report--noBorders:t-Report--hideNoPagination'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select count(*) as nb_instances',
'from flow_processes',
'where prcs_dgrm_id = :P2_DGRM_ID'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P2_DGRM_ID'
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
 p_id=>wwv_flow_api.id(19021169014332929)
,p_query_column_id=>1
,p_column_alias=>'NB_INSTANCES'
,p_column_display_sequence=>1
,p_column_heading=>'Nb Instances'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<span>There are #NB_INSTANCES# process instances associated to this diagram.</span>'
,p_derived_column=>'N'
,p_include_in_export=>'N'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19021487952332932)
,p_plug_name=>'Form'
,p_parent_plug_id=>wwv_flow_api.id(19020645519332924)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(19020317359332921)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(19020002791332918)
,p_button_name=>'ADD_VERSION'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Version'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-chevron-circle-up'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(19020813372332926)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(19020645519332924)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Delete'
,p_button_position=>'REGION_TEMPLATE_DELETE'
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(10431451245468048)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(9900826057126998)
,p_button_name=>'IMPORT_DIAGRAM'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Import Diagram'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:P6_FORCE_OVERWRITE:N'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(25601193984296773)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(9900826057126998)
,p_button_name=>'REFRESH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--padLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Refresh'
,p_button_position=>'REGION_TEMPLATE_EDIT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(19022220444332940)
,p_branch_name=>'Go To Page 2'
,p_branch_action=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_DGRM_ID:&P2_DGRM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'ADD_VERSION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2404877025481937)
,p_name=>'P2_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(10431199676468045)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2405545162481944)
,p_name=>'P2_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(2405357256481942)
,p_prompt=>'Search'
,p_source=>'DGRM_CATEGORY,DGRM_NAME,DGRM_STATUS,DGRM_LAST_UPDATE'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'ROW'
,p_attribute_02=>'FACET'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(2405686302481945)
,p_name=>'P2_DGRM_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(2405357256481942)
,p_prompt=>'Category'
,p_source=>'DGRM_CATEGORY'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'No Category'
,p_item_template_options=>'#DEFAULT#'
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10426752430468001)
,p_name=>'P2_DGRM_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(2405357256481942)
,p_prompt=>'Status'
,p_source=>'DGRM_STATUS'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_item_template_options=>'#DEFAULT#'
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>5
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19020229312332920)
,p_name=>'P2_VERSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(19020002791332918)
,p_prompt=>'Version'
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
 p_id=>wwv_flow_api.id(19021519028332933)
,p_name=>'P2_CASCADE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(19021487952332932)
,p_prompt=>'Cascade'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'Delete associated process instances'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19022356671332941)
,p_name=>'P2_DGRM_TITLE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(10431199676468045)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(19022882139332946)
,p_validation_name=>'Version is not null'
,p_validation_sequence=>10
,p_validation=>'P2_VERSION'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'#LABEL# must have a value'
,p_validation_condition=>'ADD_VERSION'
,p_validation_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_associated_item=>wwv_flow_api.id(19020229312332920)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(10204710359465896)
,p_name=>'Clickable Action clicked'
,p_event_sequence=>10
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.clickable-action '
,p_bind_type=>'live'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10205117311465914)
,p_event_id=>wwv_flow_api.id(10204710359465896)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var myElement = apex.jQuery( this.triggeringElement );',
'var myAction  = myElement.data( "action" );',
'var myDiagram = myElement.data( "dgrm" );',
'',
'',
'if ( myAction === "dgrm_view" || myAction === "dgrm_new_version" || myAction === "dgrm_delete") {',
'  apex.item( "P2_DGRM_ID" ).setValue( myDiagram );',
'  if (myAction === "dgrm_new_version"){',
'      apex.theme.openRegion( "new_version_reg" );',
'      apex.item("P2_VERSION").setValue(myElement.data( "version" ));',
'  }',
'  if (myAction === "dgrm_delete"){',
'      apex.item("P2_CASCADE").setValue("N");',
'      apex.theme.openRegion( "delete_reg" );',
'  }',
'} else {',
'     apex.server.process(',
'        "PAGE2_AJAX", ',
'        {',
'            x01: myAction,',
'            x02: myDiagram',
'        }, ',
'        {',
'            success: function( pData )  {',
'                console.log(pData);',
'                if (pData.success === true) {',
'                    if (myAction === "dgrm_edit") { ',
'                        apex.navigation.redirect(pData.data.url); ',
'                    } else {',
'                        apex.region("parsed_drgm").refresh();',
'                        apex.message.showPageSuccess( "Successful action!" );',
'                    }',
'                    ',
'                } else {',
'                    apex.message.clearErrors();',
'                    apex.message.showErrors([',
'                        {',
'                            type:       "error",',
'                            location:   "page",',
'                            message:    pData.message,',
'                            unsafe:     false',
'                        }',
'                    ]);',
'                }',
'            },',
'            error: function( jqXHR, textStatus, errorThrown ) {',
'                alert(jqXHR.responseText);',
'            }',
'        } ',
'    );',
'}',
'',
''))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(2404980723481938)
,p_name=>'Refresh diagram'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_DGRM_ID'
,p_condition_element=>'P2_DGRM_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2405950709481948)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(10431199676468045)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19022426605332942)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_DGRM_TITLE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dgrm_name||'' - Version ''||dgrm_version',
'from flow_diagrams',
'where dgrm_id = :P2_DGRM_ID'))
,p_attribute_07=>'P2_DGRM_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2405876514481947)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(10431199676468045)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(2405013624481939)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(2404737406481936)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(10430809928468042)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(10430346540468037)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19021294517332930)
,p_event_id=>wwv_flow_api.id(2404980723481938)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(19020793614332925)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(19019347638332911)
,p_name=>'Imported - Refresh Report'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(10431451245468048)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24212156552956105)
,p_event_id=>wwv_flow_api.id(19019347638332911)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_DGRM_ID'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P6_DGRM_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19019481478332912)
,p_event_id=>wwv_flow_api.id(19019347638332911)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(9900826057126998)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19023277699332950)
,p_event_id=>wwv_flow_api.id(19019347638332911)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.message.showPageSuccess("Diagram imported.");'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(19021914580332937)
,p_name=>'Add Instance'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_api.id(9900826057126998)
,p_bind_type=>'bind'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19022044667332938)
,p_event_id=>wwv_flow_api.id(19021914580332937)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(9900826057126998)
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(19022578329332943)
,p_name=>'Refresh Title'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_DGRM_TITLE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19022673655332944)
,p_event_id=>wwv_flow_api.id(19022578329332943)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$("#diagram_reg_heading").text(apex.item("P2_DGRM_TITLE").getValue());'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24212267235956106)
,p_name=>'Refresh'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(25601193984296773)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24212340713956107)
,p_event_id=>wwv_flow_api.id(24212267235956106)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(9900826057126998)
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24212408123956108)
,p_event_id=>wwv_flow_api.id(24212267235956106)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_api.id(10430346540468037)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(19021866608332936)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Diagram'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_p0002_api.delete_diagram(',
'        pi_dgrm_id => :P2_DGRM_ID,',
'        pi_cascade => :P2_CASCADE',
'    );',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'Diagram deleted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(19022181968332939)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New Version'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_dgrm_id flow_diagrams.dgrm_id%type;',
'begin',
'    l_dgrm_id := flow_p0002_api.add_diagram_version(',
'        pi_dgrm_id => :P2_DGRM_ID,',
'        pi_dgrm_version => :P2_VERSION',
'    );',
'    :P2_DGRM_ID := l_dgrm_id;',
'end;'))
,p_process_error_message=>'Version already exists.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'ADD_VERSION'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'New version added.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(2405147513481940)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PAGE2_AJAX'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_p0002_api.handle_ajax(',
'        pi_dgrm_id => apex_application.g_x02,',
'        pi_action => apex_application.g_x01',
'    );',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
