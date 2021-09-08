prompt --application/shared_components/navigation/lists/p7_action_menu
begin
--   Manifest
--     LIST: P7_ACTION_MENU
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
 p_id=>wwv_flow_api.id(7935522414465879)
,p_name=>'P7_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7935795315465880)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Export Flow'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_DGRM_ID,P5_MULTI:&P7_DGRM_ID.,N:'
,p_list_item_icon=>'fa-download'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7936149892465882)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Delete'
,p_list_item_icon=>'fa-trash-o'
,p_list_text_01=>'delete-flow-diagram'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
