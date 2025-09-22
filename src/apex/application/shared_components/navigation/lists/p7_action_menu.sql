prompt --application/shared_components/navigation/lists/p7_action_menu
begin
--   Manifest
--     LIST: P7_ACTION_MENU
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
 p_id=>wwv_flow_imp.id(7935522414465879)
,p_name=>'P7_ACTION_MENU'
,p_list_status=>'PUBLIC'
,p_version_scn=>1760504784
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7935795315465880)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Export'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_DGRM_ID,P5_MULTI:&P7_DGRM_ID.,N:'
,p_list_item_icon=>'fa-download'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7936149892465882)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Delete'
,p_list_item_icon=>'fa-trash-o'
,p_list_text_01=>'delete-flow-diagram'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
