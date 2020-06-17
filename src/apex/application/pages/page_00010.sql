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
,p_user_interface_id=>wwv_flow_api.id(13154600654189238858)
,p_name=>'Flow Instances'
,p_alias=>'FLOW_INSTANCES'
,p_step_title=>'Flow Instances'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'https://unpkg.com/bpmn-js@7.2.0/dist/bpmn-viewer.production.min.js'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var diagram = $v(''P10_DIAGRAM'');',
'',
'if (diagram != '''') {',
'    var bpmnViewer = new BpmnJS({',
'        container: ''#canvas''',
'    });',
'',
'    bpmnViewer.importXML(diagram, function(err) {',
'',
'        if (!err) {',
'            console.log("success!");',
'            bpmnViewer.get("canvas").zoom("fit-viewport");',
'',
'            var canvas = bpmnViewer.get(''canvas'');',
'            try {',
'                canvas.addMarker($v(''P10_CURRENT''), ''highlight'');',
'            }',
'            catch (e) {',
'                console.log(e);',
'            }',
'',
'        } else {',
'            console.log("something went wrong:", err);',
'        }',
'    });',
'}'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#canvas {',
'    height: 100vw;',
'    background-color: #f0f0f0;',
'}',
'',
'.highlight:not(.djs-connection) .djs-visual > :nth-child(1) {',
'  fill: green !important; /* color elements as green */',
'}',
'',
'.start_link:hover, .reset_link:hover, .delete_link:hover {',
'    cursor: pointer;',
'}'))
,p_step_template=>wwv_flow_api.id(13154719937977239105)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'NDBRUIJN'
,p_last_upd_yyyymmddhh24miss=>'20200616120723'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6786799828253461508)
,p_plug_name=>'Process Instance &P10_ID.'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13154683837724239040)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_plug_display_point=>'BODY'
,p_plug_source_type=>'PLUGIN_COM.MTAG.AS.WFP.REGION'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P10_ID'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13150968098966621655)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--slimPadding:margin-bottom-none'
,p_plug_template=>wwv_flow_api.id(13154707891747239066)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(13152647245502844927)
,p_name=>'Flow Instances'
,p_template=>wwv_flow_api.id(13154683837724239040)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--staticRowColors:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   select prcs.prcs_id',
'        , prcs.prcs_name',
'        , prcs.prcs_dgrm_name',
'        , prcs.prcs_current',
'        , prcs.prcs_init_date',
'        , prcs.prcs_last_update',
'        , prcs.start_link',
'        , prcs.reset_link',
'        , prcs.delete_link',
'     from flow_p0010_2_vw prcs'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(13154661092877238996)
,p_query_num_rows=>100
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'ROW_RANGES_WITH_LINKS'
,p_pagination_display_position=>'BOTTOM_LEFT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76401999416572317)
,p_query_column_id=>1
,p_column_alias=>'PRCS_ID'
,p_column_display_sequence=>4
,p_column_heading=>'ID'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_ID:#PRCS_ID#'
,p_column_linktext=>'#PRCS_ID#'
,p_column_alignment=>'CENTER'
,p_default_sort_column_sequence=>1
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76402066405572318)
,p_query_column_id=>2
,p_column_alias=>'PRCS_NAME'
,p_column_display_sequence=>5
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76402160808572319)
,p_query_column_id=>3
,p_column_alias=>'PRCS_DGRM_NAME'
,p_column_display_sequence=>6
,p_column_heading=>'Flow'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76402254817572320)
,p_query_column_id=>4
,p_column_alias=>'PRCS_CURRENT'
,p_column_display_sequence=>7
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76402356234572321)
,p_query_column_id=>5
,p_column_alias=>'PRCS_INIT_DATE'
,p_column_display_sequence=>8
,p_column_heading=>'Creation Date'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(76402485264572322)
,p_query_column_id=>6
,p_column_alias=>'PRCS_LAST_UPDATE'
,p_column_display_sequence=>9
,p_column_heading=>'Last Update'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13150884059562121650)
,p_query_column_id=>7
,p_column_alias=>'START_LINK'
,p_column_display_sequence=>10
,p_column_heading=>'Start'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<i class="start_link fa fa-play" data-id="#PRCS_ID#"></i>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13150883916408121649)
,p_query_column_id=>8
,p_column_alias=>'RESET_LINK'
,p_column_display_sequence=>11
,p_column_heading=>'Stop'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<i class="reset_link fa fa-stop-circle-o" data-id="#PRCS_ID#"></i>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13150883872595121648)
,p_query_column_id=>9
,p_column_alias=>'DELETE_LINK'
,p_column_display_sequence=>12
,p_column_heading=>'Delete'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<i class="delete_link fa fa-trash" data-id="#PRCS_ID#"></i>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13150968027914621654)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(13150968098966621655)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(13154623082059238932)
,p_button_image_alt=>'Create'
,p_button_position=>'TOP'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:RP::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13178824749929540661)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(6786799828253461508)
,p_button_name=>'NEXT_STEP'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13154623082059238932)
,p_button_image_alt=>'Next Process Step'
,p_button_position=>'TOP'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_api_pkg.next_step_exists(:P10_ID) = TRUE',
'AND flow_api_pkg.next_multistep_exists(:P10_ID) = FALSE'))
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-arrow-right-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13178825139360540665)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(6786799828253461508)
,p_button_name=>'CHOOSE_DIRECTION'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13154623082059238932)
,p_button_image_alt=>'Next direction?'
,p_button_position=>'TOP'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'flow_api_pkg.next_multistep_exists(:P10_ID) = TRUE'
,p_button_condition_type=>'PLSQL_EXPRESSION'
,p_icon_css_classes=>'fa-code-fork'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(13150882907887121639)
,p_branch_name=>'Redirect'
,p_branch_action=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RP:P10_ID:&P10_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'START'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13150966121944621635)
,p_name=>'P10_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13152647245502844927)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13150966249054621636)
,p_name=>'P10_CURRENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(13152647245502844927)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13152646737354844922)
,p_name=>'P10_DIAGRAM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(13152647245502844927)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13178824663019540660)
,p_name=>'P10_BRANCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6786799828253461508)
,p_prompt=>'Option'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select conn.d',
'     , conn.r',
'  from flow_p0010_3_vw conn',
' where conn.prcs_id  = :P10_ID',
'     ;'))
,p_cHeight=>1
,p_display_when=>'flow_api_pkg.next_multistep_exists(:P10_ID) = TRUE'
,p_display_when_type=>'PLSQL_EXPRESSION'
,p_field_template=>wwv_flow_api.id(13154624238369238938)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13150883518358121645)
,p_name=>'start_process'
,p_event_sequence=>40
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.start_link'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13150883411398121644)
,p_event_id=>wwv_flow_api.id(13150883518358121645)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.confirm("Start process?", {',
'    request: "START",',
'    set:{"P10_ID": $(this.triggeringElement).data("id")}',
'});'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13150883306930121643)
,p_name=>'reset_process'
,p_event_sequence=>50
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.reset_link'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13150883263262121642)
,p_event_id=>wwv_flow_api.id(13150883306930121643)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.confirm("Stop process?", {',
'    request: "RESET",',
'    set:{"P10_ID": $(this.triggeringElement).data("id")}',
'});'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13150883144321121641)
,p_name=>'delete_process'
,p_event_sequence=>60
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.delete_link'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13150883083051121640)
,p_event_id=>wwv_flow_api.id(13150883144321121641)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.confirm("Delete process?", {',
'    request: "DELETE",',
'    set:{"P10_ID": $(this.triggeringElement).data("id")}',
'});'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13178824868064540662)
,p_name=>'next_step'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(13178824749929540661)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13178824923153540663)
,p_event_id=>wwv_flow_api.id(13178824868064540662)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'flow_api_pkg.flow_next_step(p_process_id => :P10_ID);'
,p_attribute_02=>'P10_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13178825037434540664)
,p_event_id=>wwv_flow_api.id(13178824868064540662)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.navigation.redirect(''f?p=&APP_ID.:10:&APP_SESSION.::NO:RP:P10_ID:&P10_ID.'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13178825211157540666)
,p_name=>'next_branch'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(13178825139360540665)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13178825372898540667)
,p_event_id=>wwv_flow_api.id(13178825211157540666)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_api_pkg.flow_next_branch',
'( p_process_id => :P10_ID',
', p_branch_name => :P10_BRANCH',
');'))
,p_attribute_02=>'P10_ID,P10_BRANCH'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13178825404708540668)
,p_event_id=>wwv_flow_api.id(13178825211157540666)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.navigation.redirect(''f?p=&APP_ID.:10:&APP_SESSION.::NO:RP:P10_ID:&P10_ID.'');'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13152646606825844921)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Diagram'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  select prcs.dgrm_content',
'       , prcs.prcs_current',
'    into :P10_DIAGRAM',
'       , :P10_CURRENT',
'    from flow_p0010_vw prcs',
'   where prcs.prcs_id = :P10_ID',
'  ;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P10_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13150884345187121653)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'START_PROCESS'
,p_process_sql_clob=>'flow_api_pkg.flow_start(p_process_id => :P10_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'START'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13150884195734121652)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'RESET_PROCESS'
,p_process_sql_clob=>'flow_api_pkg.flow_reset(p_process_id => :P10_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'RESET'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13150884168049121651)
,p_process_sequence=>30
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DELETE_PROCESS'
,p_process_sql_clob=>'flow_api_pkg.flow_delete(p_process_id => :P10_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.component_end;
end;
/
