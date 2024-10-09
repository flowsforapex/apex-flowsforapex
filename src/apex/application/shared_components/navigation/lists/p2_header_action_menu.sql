prompt --application/shared_components/navigation/lists/p2_header_action_menu
begin
--   Manifest
--     LIST: P2_HEADER_ACTION_MENU
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(40402255178815218)
,p_name=>'P2_HEADER_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(40402870460815221)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Add New Version'
,p_list_item_icon=>'fa-plus'
,p_list_text_01=>'bulk-new-flow-version'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(40403252293815221)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Copy'
,p_list_item_icon=>'fa-clone'
,p_list_text_01=>'bulk-copy-flow'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(40416697084414268)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'-'
,p_list_item_link_target=>'separator'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(40410074688263331)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Export'
,p_list_item_link_target=>'javascript:apex.submit(''EXPORT_FLOW'');'
,p_list_item_icon=>'fa-download'
,p_list_text_01=>'export-flow'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
