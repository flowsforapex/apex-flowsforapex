prompt --application/shared_components/navigation/lists/p8_variable_header_action_menu
begin
--   Manifest
--     LIST: P8_VARIABLE_HEADER_ACTION_MENU
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
 p_id=>wwv_flow_imp.id(7390393853616382)
,p_name=>'P8_VARIABLE_HEADER_ACTION_MENU'
,p_list_status=>'PUBLIC'
,p_version_scn=>1760504778
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7390805893616409)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Delete'
,p_list_item_icon=>'fa-trash-o'
,p_list_text_01=>'bulk-delete-process-variable'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
