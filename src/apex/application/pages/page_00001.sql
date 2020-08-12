prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flows for APEX Modeler'
,p_alias=>'EDITOR'
,p_step_title=>'Flows for APEX Modeler'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_IMAGES#js/mtag.bpmnmodeler#MIN#.js'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var bpmnModeler = new bpmnModeler.Modeler({',
'  container: "#canvas",',
'  additionalModules: [',
'    bpmnModeler.modules.propertiesPanelModule,',
'    bpmnModeler.modules.propertiesProviderModule',
'  ],',
'  propertiesPanel: {',
'    parent: "#properties"',
'  }',
'});',
'',
'async function loadDiagram( diagram ) {',
'  const defaultDiagram =',
'    "<?xml version=''1.0'' encoding=''UTF-8''?>" +',
'    "<bpmn:definitions xmlns:xsi=''http://www.w3.org/2001/XMLSchema-instance'' xmlns:bpmn=''http://www.omg.org/spec/BPMN/20100524/MODEL'' xmlns:bpmndi=''http://www.omg.org/spec/BPMN/20100524/DI'' id=''Definitions_1wzb475'' targetNamespace=''http://bpmn.io/sch'
||'ema/bpmn'' exporter=''bpmn-js (https://demo.bpmn.io)'' exporterVersion=''7.2.0''>" +',
'    "<bpmn:process id=''Process_0rxermh'' isExecutable=''false'' />" +',
'    "<bpmndi:BPMNDiagram id=''BPMNDiagram_1''>" +',
'    "<bpmndi:BPMNPlane id=''BPMNPlane_1'' bpmnElement=''Process_0rxermh'' />" +',
'    "</bpmndi:BPMNDiagram>" +',
'    "</bpmn:definitions>";',
'',
'  try {',
'    const result = await bpmnModeler.importXML( diagram || defaultDiagram );',
'    const { warnings } = result;',
'    bpmnModeler.get( "canvas" ).zoom( "fit-viewport" );',
'    if (  warnings.length > 0 ) {',
'      abex.debug.warn( "Warnings during Import.", warnings );',
'    }',
'  } catch( err ) {',
'    apex.debug.error( err.message, err.warnings );',
'  }',
'}',
'',
'async function saveDiagram() {',
'  try {',
'    const result = await bpmnModeler.saveXML( { format: true } );',
'    const { xml } = result;',
'    const clobObj = new apex.ajax.clob( p => {',
'      if ( p.readyState == 4 ) {',
'        apex.navigation.redirect( apex.item( "P1_SAVE_URL" ).getValue() );',
'        //apex.page.submit( "SAVE_DIAGRAM" );',
'      }',
'    });',
'    clobObj._set( xml );',
'  } catch( err ) {',
'    apex.debug.error( err.message, err.warnings );',
'  }',
'}'))
,p_javascript_code_onload=>'loadDiagram( apex.item("P1_DIAGRAM").getValue() );'
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APP_IMAGES#css/mtag.bpmnmodeler.css',
'#APP_IMAGES#css/mtag.bpmnmodeler.font.css',
'#APP_IMAGES#css/mtag.bpmnmodeler.properties-panel.css'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#canvas {',
'    height: 100vw;',
'    background-color: #f0f0f0;',
'}',
'',
'.mtag-bpmn-modeler {',
'  position: relative;',
'}',
'',
'.properties-panel-parent {',
'  position: absolute;',
'  top: 0;',
'  bottom: 0;',
'  right: 0;',
'  width: 260px;',
'  z-index: 10;',
'  border-left: 1px solid #ccc;',
'  overflow: auto;',
'  display: block;',
'  height: 100%;',
'  background-color: #f0f0f0;',
'}',
'.properties-panel-parent:empty {',
'  display: none;',
'}',
'.properties-panel-parent > .djs-properties-panel {',
'  padding-bottom: 70px;',
'  min-height:100%;',
'}'))
,p_step_template=>wwv_flow_api.id(12495618547053880299)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'F4A'
,p_last_upd_yyyymmddhh24miss=>'20200812115829'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12491062133032033850)
,p_plug_name=>'Edit Flow &P1_NAME.'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="mtag-bpmn-modeler">',
'  <div id="canvas"></div>',
'  <div id="properties" class="properties-panel-parent"></div>',
'</div>',
''))
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12494360825091002351)
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
 p_id=>wwv_flow_api.id(12493927411366882751)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_button_name=>'NEW'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'New'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12494357772637002320)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_button_name=>'OPEN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Open'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-folder-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12494360718802002350)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_button_name=>'SAVE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12491061243397033841)
,p_name=>'P1_OPEN_URL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_page.get_url',
'( p_application => :APP_ID',
', p_page        => ''3''',
', p_session     => :SESSION',
', p_clear_cache => ''RP''',
')'))
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12491061749189033846)
,p_name=>'P1_CHANGE_FLAG'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12493493420598758634)
,p_name=>'P1_SAVE_URL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_page.get_url',
'( p_application => :APP_ID',
', p_page        => ''2''',
', p_session     => :SESSION',
', p_clear_cache => ''RP''',
', p_items       => ''P2_NAME''',
', p_values      => :P1_NAME',
')'))
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12493547105952486134)
,p_name=>'P1_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12494360498702002347)
,p_name=>'P1_DIAGRAM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(12494360825091002351)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12493927324986882750)
,p_name=>'New Diagram'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12493927411366882751)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12493927254059882749)
,p_event_id=>wwv_flow_api.id(12493927324986882750)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.confirm(''Create new flow?'',',
'    function(confirm) {',
'        if (confirm)',
'            apex.navigation.redirect(''f?p=&APP_ID.:1:&APP_SESSION.::NO:1::'');',
'});'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12493547528828486138)
,p_name=>'Save Diagram'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12494360718802002350)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12493547218910486135)
,p_event_id=>wwv_flow_api.id(12493547528828486138)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'saveDiagram();'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12491061622134033845)
,p_name=>'Change Listener'
,p_event_sequence=>100
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#canvas'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12491061537438033844)
,p_event_id=>wwv_flow_api.id(12491061622134033845)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>':P1_CHANGE_FLAG := 1;'
,p_attribute_03=>'P1_CHANGE_FLAG'
,p_attribute_04=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12491061413886033843)
,p_name=>'is_changed'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(12494357772637002320)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12491061359002033842)
,p_event_id=>wwv_flow_api.id(12491061413886033843)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v(''P1_CHANGE_FLAG'') == 1) {',
'    apex.message.confirm(''Unsaved changes exist. Are you sure?'', function(okpressed) {',
'        if (okpressed) ',
'            apex.navigation.redirect($v(''P1_OPEN_URL''));',
'    });',
'} else {',
'    console.log("not changed");',
'    apex.navigation.redirect($v(''P1_OPEN_URL''));',
'}'))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12493544059012486103)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Diagram'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dgrm.dgrm_content',
'  into :P1_DIAGRAM',
'  from flow_p0001_vw dgrm',
' where dgrm.dgrm_name = :P1_NAME',
'     ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P1_NAME'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.component_end;
end;
/
