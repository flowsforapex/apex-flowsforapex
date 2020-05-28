prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>59800345087111703
,p_default_application_id=>480340
,p_default_id_offset=>13603073842510480015
,p_default_owner=>'FLOWSFORAPEX'
);
wwv_flow_api.create_page(
 p_id=>10
,p_user_interface_id=>wwv_flow_api.id(13652442279228366415)
,p_name=>'Process Instances'
,p_alias=>'PROCESS_INSTANCES'
,p_step_title=>'Process Instances'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'https://unpkg.com/bpmn-js@6.2.1/dist/bpmn-viewer.development.js'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var diagram = $v(''P10_DIAGRAM'');',
'',
'/*if (diagram == '''')',
'    diagram =',
'        "<?xml version=''1.0'' encoding=''UTF-8''?>" +',
'        "<bpmn:definitions xmlns:xsi=''http://www.w3.org/2001/XMLSchema-instance'' xmlns:bpmn=''http://www.omg.org/spec/BPMN/20100524/MODEL'' xmlns:bpmndi=''http://www.omg.org/spec/BPMN/20100524/DI'' id=''Definitions_05abd8f'' targetNamespace=''http://bpmn.io'
||'/schema/bpmn'' exporter=''bpmn-js (https://demo.bpmn.io)'' exporterVersion=''6.2.0''>" +',
'        "<bpmn:process id=''Process_19jajli'' isExecutable=''false''/>" +',
'        "<bpmndi:BPMNDiagram id=''BPMNDiagram_1''>" +',
'        "<bpmndi:BPMNPlane id=''BPMNPlane_1'' bpmnElement=''Process_19jajli''/>" +',
'        "</bpmndi:BPMNDiagram>" +',
'        "</bpmn:definitions>";*/',
'',
'if (diagram != '''') {',
'    ',
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
,p_step_template=>wwv_flow_api.id(13652322995440366168)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'NDBRUIJN'
,p_last_upd_yyyymmddhh24miss=>'20200525094546'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7185904579856816265)
,p_plug_name=>'Process Instance &P10_ID.'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13652359095693366233)
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
wwv_flow_api.create_report_region(
 p_id=>wwv_flow_api.id(13654395687914760346)
,p_name=>'Process Instances'
,p_template=>wwv_flow_api.id(13652359095693366233)
,p_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--staticRowColors:t-Report--rowHighlight'
,p_display_point=>'BODY'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   select prc.prc_id',
'        , prc.prc_name',
'        , prc.prc_dgm_name',
'        , case',
'          when prc.prc_current is not null then obj.obj_name',
'          when prc.prc_current is null then ''n.a.''',
'          end as prc_current',
'        , prc.prc_init_date',
'        , prc.prc_last_update',
'        , null as start_link',
'        , null as reset_link',
'        , null as delete_link',
'     from processes prc',
'left join objects   obj on prc.prc_current = obj.obj_id'))
,p_ajax_enabled=>'Y'
,p_query_row_template=>wwv_flow_api.id(13652381840540366277)
,p_query_num_rows=>30
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'ROW_RANGES_WITH_LINKS'
,p_pagination_display_position=>'BOTTOM_LEFT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656452248984642716)
,p_query_column_id=>1
,p_column_alias=>'PRC_ID'
,p_column_display_sequence=>1
,p_column_heading=>'Process Instance ID'
,p_use_as_row_header=>'N'
,p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RP:P10_ID:#PRC_ID#'
,p_column_linktext=>'#PRC_ID#'
,p_column_alignment=>'CENTER'
,p_default_sort_column_sequence=>1
,p_default_sort_dir=>'desc'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656452669215642720)
,p_query_column_id=>2
,p_column_alias=>'PRC_NAME'
,p_column_display_sequence=>2
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13655715041589349056)
,p_query_column_id=>3
,p_column_alias=>'PRC_DGM_NAME'
,p_column_display_sequence=>3
,p_column_heading=>'Diagram'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656452352112642717)
,p_query_column_id=>4
,p_column_alias=>'PRC_CURRENT'
,p_column_display_sequence=>4
,p_column_heading=>'State'
,p_use_as_row_header=>'N'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656078885665983659)
,p_query_column_id=>5
,p_column_alias=>'PRC_INIT_DATE'
,p_column_display_sequence=>5
,p_column_heading=>'Created On'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH24:MI:SS'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656452462691642718)
,p_query_column_id=>6
,p_column_alias=>'PRC_LAST_UPDATE'
,p_column_display_sequence=>6
,p_column_heading=>'Updated On'
,p_use_as_row_header=>'N'
,p_column_format=>'DD-MON-YYYY HH24:MI:SS'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656158873855483623)
,p_query_column_id=>7
,p_column_alias=>'START_LINK'
,p_column_display_sequence=>7
,p_column_heading=>'Start'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<i class="start_link fa fa-play" data-id="#PRC_ID#"></i>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656159017009483624)
,p_query_column_id=>8
,p_column_alias=>'RESET_LINK'
,p_column_display_sequence=>8
,p_column_heading=>'Stop'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<i class="reset_link fa fa-stop-circle-o" data-id="#PRC_ID#"></i>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_report_columns(
 p_id=>wwv_flow_api.id(13656159060822483625)
,p_query_column_id=>9
,p_column_alias=>'DELETE_LINK'
,p_column_display_sequence=>9
,p_column_heading=>'Delete'
,p_use_as_row_header=>'N'
,p_column_html_expression=>'<i class="delete_link fa fa-trash" data-id="#PRC_ID#"></i>'
,p_column_alignment=>'CENTER'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13656074834450983618)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--slimPadding:margin-bottom-none'
,p_plug_template=>wwv_flow_api.id(13652335041670366207)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13656074905502983619)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(13656074834450983618)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(13652419851358366341)
,p_button_image_alt=>'Create'
,p_button_position=>'TOP'
,p_button_alignment=>'LEFT'
,p_button_redirect_url=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:RP::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13577929501532895418)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(7185904579856816265)
,p_button_name=>'NEXT_STEP'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13652419851358366341)
,p_button_image_alt=>'Next Process Step'
,p_button_position=>'TOP'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'  v_current    varchar2(50);',
'  v_next_count number;',
'',
'begin',
'  if :P10_ID is not null',
'  then',
'    select PRC_CURRENT',
'      into v_current',
'      from PROCESSES',
'     where PRC_ID = :P10_ID',
'         ;',
'',
'    if v_current is not null',
'    then',
'      select count(CON_ID)',
'        into v_next_count',
'        from CONNECTIONS',
'       where CON_SOURCE_REF = v_current',
'           ;',
'',
'      if v_next_count = 1',
'      then',
'        return true;',
'      end if;',
'    end if;',
'  end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-arrow-right-alt'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13577929890963895422)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(7185904579856816265)
,p_button_name=>'CHOOSE_DIRECTION'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_api.id(13652419851358366341)
,p_button_image_alt=>'Next direction?'
,p_button_position=>'TOP'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'',
'  v_current    varchar2(50);',
'  v_next_count number;',
'',
'begin',
'  if :P10_ID is not null',
'  then',
'    select PRC_CURRENT',
'      into v_current',
'      from PROCESSES',
'     where PRC_ID = :P10_ID',
'         ;',
'',
'    if v_current is not null',
'    then',
'      select count(CON_ID)',
'        into v_next_count',
'        from CONNECTIONS',
'       where CON_SOURCE_REF = v_current',
'           ;',
'',
'      if v_next_count > 1 ',
'      then',
'        return true;',
'      end if;',
'    end if;',
'  end if;',
'end;'))
,p_button_condition_type=>'FUNCTION_BODY'
,p_icon_css_classes=>'fa-code-fork'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(13656160025530483634)
,p_branch_name=>'Redirect'
,p_branch_action=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RP:P10_ID:&P10_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'START'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13577929414622895417)
,p_name=>'P10_BRANCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(7185904579856816265)
,p_prompt=>'Option'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select',
'CON_NAME as d,',
'CON_NAME as r',
'from',
'CONNECTIONS',
'join',
'PROCESSES',
'on',
'CON_SOURCE_REF = PRC_CURRENT',
'where',
'PRC_ID = :P10_ID',
'order by',
'CON_NAME asc;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'v_current varchar2(50);',
'v_next_count number;',
'begin',
'',
'if :P10_ID is not null then',
'',
'select PRC_CURRENT',
'into v_current',
'from PROCESSES',
'where PRC_ID = :P10_ID;',
'',
'if v_current is not null then',
'',
'select count(CON_ID)',
'into v_next_count',
'from CONNECTIONS',
'where CON_SOURCE_REF = v_current;',
'',
'if v_next_count > 1 then',
'return true;',
'end if;',
'',
'end if;',
'',
'end if;',
'end;'))
,p_display_when_type=>'FUNCTION_BODY'
,p_field_template=>wwv_flow_api.id(13652418695048366335)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13654396196062760351)
,p_name=>'P10_DIAGRAM'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(13654395687914760346)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13656076684362983637)
,p_name=>'P10_CURRENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(13654395687914760346)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13656076811472983638)
,p_name=>'P10_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13654395687914760346)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13656159415059483628)
,p_name=>'start_process'
,p_event_sequence=>40
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.start_link'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13656159522019483629)
,p_event_id=>wwv_flow_api.id(13656159415059483628)
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
 p_id=>wwv_flow_api.id(13656159626487483630)
,p_name=>'reset_process'
,p_event_sequence=>50
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.reset_link'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13656159670155483631)
,p_event_id=>wwv_flow_api.id(13656159626487483630)
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
 p_id=>wwv_flow_api.id(13656159789096483632)
,p_name=>'delete_process'
,p_event_sequence=>60
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.delete_link'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13656159850366483633)
,p_event_id=>wwv_flow_api.id(13656159789096483632)
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
 p_id=>wwv_flow_api.id(13577929619667895419)
,p_name=>'next_step'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(13577929501532895418)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13577929674756895420)
,p_event_id=>wwv_flow_api.id(13577929619667895419)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'flows_pkg.flow_next_step(p_process_id => :P10_ID);'
,p_attribute_02=>'P10_ID'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13577929789037895421)
,p_event_id=>wwv_flow_api.id(13577929619667895419)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.navigation.redirect(''f?p=&APP_ID.:10:&APP_SESSION.::NO:RP:P10_ID:&P10_ID.'');'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13577929962760895423)
,p_name=>'next_branch'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(13577929890963895422)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13577930124501895424)
,p_event_id=>wwv_flow_api.id(13577929962760895423)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flows_pkg.flow_next_branch',
'( p_process_id => :P10_ID',
', p_branch_name => :P10_BRANCH',
');'))
,p_attribute_02=>'P10_ID,P10_BRANCH'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13577930156311895425)
,p_event_id=>wwv_flow_api.id(13577929962760895423)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.navigation.redirect(''f?p=&APP_ID.:10:&APP_SESSION.::NO:RP:P10_ID:&P10_ID.'');'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13654396326591760352)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Diagram'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'  select dgm.dgm_content',
'    into :P10_DIAGRAM',
'    from diagrams  dgm',
'    join processes prc on dgm.dgm_name = prc.prc_dgm_name',
'   where prc.prc_id = :P10_ID',
'  ;',
'    ',
'  select prc.prc_current',
'    into :P10_CURRENT',
'    from processes prc',
'   where prc.prc_id = :P10_ID',
'  ;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P10_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13656158588230483620)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'START_PROCESS'
,p_process_sql_clob=>'flows_pkg.flow_start(p_process_id => :P10_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'START'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13656158737683483621)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'RESET_PROCESS'
,p_process_sql_clob=>'flows_pkg.flow_reset(p_process_id => :P10_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'RESET'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13656158765368483622)
,p_process_sequence=>30
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DELETE_PROCESS'
,p_process_sql_clob=>'flows_pkg.flow_delete(p_process_id => :P10_ID);'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.component_end;
end;
/
