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
,p_user_interface_id=>wwv_flow_api.id(13533038870183269920)
,p_name=>'Flows Editor'
,p_alias=>'EDITOR'
,p_step_title=>'Flows Editor'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APP_IMAGES#js/bpmn-modeler.development.js',
'#IMAGE_PREFIX#libraries/apex/legacy_18.js'))
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var bpmnModeler = new BpmnJS({',
'    container: ''#canvas''',
'});',
'',
'',
'function parseXML(xmlDoc) {',
'',
'    /***** connections *****/',
'    ',
'    // get messageFlows',
'    let messageFlows = Array.from(xmlDoc.getElementsByTagName("bpmn:messageFlow"));',
'    // get sequenceFlows',
'    let sequenceFlows = Array.from(xmlDoc.getElementsByTagName("bpmn:sequenceFlow"));',
'',
'    // get needed data',
'    let flowData = [];',
'',
'    for (let i of messageFlows) {',
'        flowData.push([i.getAttribute("id"), i.getAttribute("name"), i.getAttribute("sourceRef"), i.getAttribute("targetRef")]);',
'    }',
'',
'    for (let i of sequenceFlows) {',
'        flowData.push([i.getAttribute("id"), i.getAttribute("name"), i.getAttribute("sourceRef"), i.getAttribute("targetRef")]);',
'    }',
'',
'    // concat string',
'    let flowString = "";',
'',
'    for (let i of flowData) {',
'        flowString += i;',
'        flowString += ''|'';',
'    }',
'',
'    flowString = flowString.substring(0, flowString.length-1);',
'',
'    /***** objects *****/',
'',
'    // get processes',
'    let processes = Array.from(xmlDoc.getElementsByTagName("bpmn:process"));',
'',
'    // get processes childs',
'    let objects = [];',
'',
'    for (let i of processes) {',
'        for (let j of Array.from(i.childNodes)) {',
'            objects.push(j);    ',
'        }',
'    }',
'',
'    // filter flows + text nodes (spaces between tags)',
'    objects = objects.filter(object => object.nodeName != ''bpmn:sequenceFlow'');',
'    objects = objects.filter(object => object.nodeName != ''#text'');',
'',
'    // get needed data',
'    let objectData = [];',
'',
'    for (let i of objects) {',
'        objectData.push([i.getAttribute("id"), i.getAttribute("name"), i.getAttribute("sourceRef"), i.getAttribute("targetRef")]);',
'    }',
'',
'    // concat string',
'    let objectString = "";',
'',
'    for (let i of objectData) {',
'        objectString += i;',
'        objectString += ''|'';',
'    }',
'',
'    objectString = objectString.substring(0, objectString.length-1);',
'',
'    //console.log(flowString);',
'    //console.log(objectString);',
'',
'    // set page items',
'    $s("P1_FLOWSTRING", flowString);',
'    $s("P1_OBJECTSTRING", objectString);',
'',
'    // save session state',
'    apex.server.process(''DUMMY'', {pageItems: ''#P1_FLOWSTRING, #P1_OBJECTSTRING''}, {success: function(pData) {}, dataType: ''text''});',
'}'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var diagram = $v(''P1_DIAGRAM'');',
'',
'if (diagram == '''')',
'    diagram =',
'        "<?xml version=''1.0'' encoding=''UTF-8''?>" +',
'        "<bpmn:definitions xmlns:xsi=''http://www.w3.org/2001/XMLSchema-instance'' xmlns:bpmn=''http://www.omg.org/spec/BPMN/20100524/MODEL'' xmlns:bpmndi=''http://www.omg.org/spec/BPMN/20100524/DI'' id=''Definitions_05abd8f'' targetNamespace=''http://bpmn.io'
||'/schema/bpmn'' exporter=''bpmn-js (https://demo.bpmn.io)'' exporterVersion=''6.2.0''>" +',
'        "<bpmn:process id=''Process_19jajli'' isExecutable=''false''/>" +',
'        "<bpmndi:BPMNDiagram id=''BPMNDiagram_1''>" +',
'        "<bpmndi:BPMNPlane id=''BPMNPlane_1'' bpmnElement=''Process_19jajli''/>" +',
'        "</bpmndi:BPMNDiagram>" +',
'        "</bpmn:definitions>";',
'',
'bpmnModeler.importXML(diagram, function(err) {',
'',
'    if (!err) {',
'        console.log("success!");',
'        bpmnModeler.get("canvas").zoom("fit-viewport");',
'        ',
'        /*',
'        var elementRegistry = bpmnModeler.get(''elementRegistry'');',
'        var modeling = bpmnModeler.get(''modeling'');',
'',
'        var elementToColor = elementRegistry.get(''ExclusiveGateway_1rthyfx'');',
'',
'        modeling.setColor([elementToColor], {',
'            stroke: ''green'',',
'            fill: ''rgba(0, 80, 0, 0.4)''',
'        });',
'        */',
'      ',
'    } else {',
'        console.log("something went wrong:", err);',
'    }',
'});'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'https://unpkg.com/bpmn-js@6.2.1/dist/assets/bpmn-font/css/bpmn.css',
'https://unpkg.com/bpmn-js@6.2.1/dist/assets/diagram-js.css'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#canvas {',
'    height: 100vw;',
'    background-color: #f0f0f0;',
'}'))
,p_step_template=>wwv_flow_api.id(13532919586395269673)
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'NDBRUIJN'
,p_last_upd_yyyymmddhh24miss=>'20200526080748'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13534177308358147621)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--slimPadding:margin-bottom-none'
,p_plug_template=>wwv_flow_api.id(13532931632625269712)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13537476000417116122)
,p_plug_name=>'Edit Flow &P1_NAME.'
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13532955686648269738)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_source=>'<div id="canvas"></div>'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13534610722082267221)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_button_name=>'NEW'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(13533016442313269846)
,p_button_image_alt=>'New'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13534180360812147652)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_button_name=>'OPEN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(13533016442313269846)
,p_button_image_alt=>'Open'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-folder-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13534177414647147622)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_button_name=>'SAVE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(13533016442313269846)
,p_button_image_alt=>'Save'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13534177634747147625)
,p_name=>'P1_DIAGRAM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13534991027496663838)
,p_name=>'P1_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13535044712850391338)
,p_name=>'P1_SAVE_URL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_source=>'APEX_UTIL.PREPARE_URL(p_url => ''f?p=&APP_ID.:2:&SESSION.::NO:RP::'', p_checksum_type => ''SESSION'')'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13536309049739252536)
,p_name=>'P1_FLOWSTRING'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13536309174253252537)
,p_name=>'P1_OBJECTSTRING'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13537476384260116126)
,p_name=>'P1_CHANGE_FLAG'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13537476890052116131)
,p_name=>'P1_OPEN_URL'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(13534177308358147621)
,p_source=>'APEX_UTIL.PREPARE_URL(p_url => ''f?p=&APP_ID.:3:&SESSION.::NO:RP::'', p_checksum_type => ''SESSION'')'
,p_source_type=>'FUNCTION'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13534610808462267222)
,p_name=>'New Diagram'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(13534610722082267221)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13534610879389267223)
,p_event_id=>wwv_flow_api.id(13534610808462267222)
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
 p_id=>wwv_flow_api.id(13534990604620663834)
,p_name=>'Save Diagram'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(13534177414647147622)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13534990914538663837)
,p_event_id=>wwv_flow_api.id(13534990604620663834)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'bpmnModeler.saveXML({format: true}, function(err, xml) {',
'',
'    if (err) {',
'        return console.error(''could not save BPMN 2.0 diagram'', err);',
'    }',
'        ',
'    var clobObj = new apex.ajax.clob(',
'        // Callback function. only process CLOB once it''s finished uploading to APEX',
'        function(p){',
'            if (p.readyState == 4){',
'                //apex.server.process ("SAVE_CLOB", {}, {success: function(data) { apex.message.showPageSuccess(''Diagram saved!''); }, dataType: "text" });',
'                parser = new DOMParser();',
'                parseXML(parser.parseFromString(xml, "text/xml"));',
'                apex.navigation.redirect($v(''P1_SAVE_URL''));',
'            }',
'    });',
'        ',
'    clobObj._set(xml);',
'});'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(13537476511315116127)
,p_name=>'Change Listener'
,p_event_sequence=>100
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#canvas'
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13537476596011116128)
,p_event_id=>wwv_flow_api.id(13537476511315116127)
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
 p_id=>wwv_flow_api.id(13537476719563116129)
,p_name=>'is_changed'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(13534180360812147652)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(13537476774447116130)
,p_event_id=>wwv_flow_api.id(13537476719563116129)
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
 p_id=>wwv_flow_api.id(13534994074436663869)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Diagram'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select DGM_CONTENT',
'  into :P1_DIAGRAM',
'  from DIAGRAMS',
' where DGM_NAME = :P1_NAME',
'     ;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P1_NAME'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.component_end;
end;
/
