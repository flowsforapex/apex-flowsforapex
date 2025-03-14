prompt --application/shared_components/navigation/lists/p2_row_action_menu
begin
--   Manifest
--     LIST: P2_ROW_ACTION_MENU
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(39902352324857428)
,p_name=>'P2_ROW_ACTION_MENU'
,p_list_status=>'PUBLIC'
,p_version_scn=>1760504785
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(39902501487857435)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Show Details'
,p_list_item_icon=>'fa-search'
,p_list_text_01=>'edit-flow-diagram'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(39902920078857437)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Add New Version'
,p_list_item_icon=>'fa-plus'
,p_list_text_01=>'new-flow-version'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(39903360633857437)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Copy'
,p_list_item_icon=>'fa-clone'
,p_list_text_01=>'copy-flow'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
