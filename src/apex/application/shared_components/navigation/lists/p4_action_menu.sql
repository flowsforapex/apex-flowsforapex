prompt --application/shared_components/navigation/lists/p4_action_menu
begin
--   Manifest
--     LIST: P4_ACTION_MENU
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(7959288629726086)
,p_name=>'P4_ACTION_MENU'
,p_list_status=>'PUBLIC'
,p_version_scn=>1760504785
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7959427446726087)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'View Source'
,p_list_item_link_target=>'javascript:apex.region( ''modeler'' ).getDiagram().then( ( xml ) => { apex.item( ''P4_DIAGRAM_XML'' ).setValue( xml );apex.theme.openRegion(''diagram_xml_region''); } );'
,p_list_item_icon=>'fa-cloud-download'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7959824792726090)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Download (SVG)'
,p_list_item_link_target=>'javascript:apex.region( ''modeler'' ).getSVG().then( ( svg ) => {'||wwv_flow.LF||
'     var svgBlob = new Blob([svg], {'||wwv_flow.LF||
'        type: ''image/svg+xml'''||wwv_flow.LF||
'    });'||wwv_flow.LF||
'    var fileName = $v(''P4_REGION_TITLE'');'||wwv_flow.LF||
''||wwv_flow.LF||
'    var downloadLink = document.createElement(''a'');'||wwv_flow.LF||
'    downloadLink.download = fileName;'||wwv_flow.LF||
'    downloadLink.href = window.URL.createObjectURL(svgBlob);'||wwv_flow.LF||
'    downloadLink.click();'||wwv_flow.LF||
'} );'
,p_list_item_icon=>'fa-image'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
