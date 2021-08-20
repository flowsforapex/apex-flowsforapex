prompt --application/shared_components/navigation/lists/p2_action_menu
begin
--   Manifest
--     LIST: P2_ACTION_MENU
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
 p_id=>wwv_flow_api.id(7927640106409064)
,p_name=>'P2_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7928205045409069)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Import Flow'
,p_list_item_link_target=>'f?p=&APP_ID.:6:&SESSION.:IMPORT_FLOW:&DEBUG.:6:P6_FORCE_OVERWRITE:N:'
,p_list_item_icon=>'fa-upload'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7928603491409069)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Refresh'
,p_list_item_link_target=>'javascript:window.location.reload();'
,p_list_item_icon=>'fa-refresh'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
