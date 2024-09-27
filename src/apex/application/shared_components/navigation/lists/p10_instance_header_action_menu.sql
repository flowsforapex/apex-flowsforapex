prompt --application/shared_components/navigation/lists/p10_instance_header_action_menu
begin
--   Manifest
--     LIST: P10_INSTANCE_HEADER_ACTION_MENU
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
 p_id=>wwv_flow_imp.id(2431522092873048)
,p_name=>'P10_INSTANCE_HEADER_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2432103661873123)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Start'
,p_list_item_icon=>'fa-play'
,p_list_text_01=>'bulk-start-flow-instance'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2432511726873124)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Reset'
,p_list_item_icon=>'fa-undo'
,p_list_text_01=>'bulk-reset-flow-instance'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2432979512873125)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Terminate'
,p_list_item_icon=>'fa-stop'
,p_list_text_01=>'bulk-terminate-flow-instance'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2433306262873126)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Delete'
,p_list_item_icon=>'fa-trash-o'
,p_list_text_01=>'bulk-delete-flow-instance'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
