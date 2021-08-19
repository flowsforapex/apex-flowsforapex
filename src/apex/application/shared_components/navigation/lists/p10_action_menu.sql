prompt --application/shared_components/navigation/lists/p10_action_menu
begin
--   Manifest
--     LIST: P10_ACTION_MENU
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(7946860874526805)
,p_name=>'P10_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7947003406526806)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Refresh'
,p_list_item_link_target=>'javascript:apex.region(''flow_instances'').refresh();apex.region(''subflows'').refresh();apex.region(''variables_ig'').refresh();apex.region(''flow-monitor'').refresh();'
,p_list_item_icon=>'fa-refresh'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7954342541664818)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Download Image'
,p_list_item_link_target=>'javascript:apex.region( ''flow-monitor'' ).getSVG().then( ( svg ) => {'||wwv_flow.LF||
'     var svgBlob = new Blob([svg], {'||wwv_flow.LF||
'        type: ''image/svg+xml'''||wwv_flow.LF||
'    });'||wwv_flow.LF||
'    var fileName = Date.now();'||wwv_flow.LF||
''||wwv_flow.LF||
'    var downloadLink = document.createElement(''a'');'||wwv_flow.LF||
'    downloadLink.download = fileName;'||wwv_flow.LF||
'    downloadLink.href = window.URL.createObjectURL(svgBlob);'||wwv_flow.LF||
'    downloadLink.click();'||wwv_flow.LF||
'} );'
,p_list_item_icon=>'fa-image'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39805200139904551)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'-'
,p_list_item_link_target=>'separator'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39805591040910001)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Display Setting'
,p_list_item_icon=>'fa-gear'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39805873547914084)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'below report|side-by-side|new window'
,p_parent_list_item_id=>wwv_flow_api.id(39805591040910001)
,p_list_text_01=>'choose-setting'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
