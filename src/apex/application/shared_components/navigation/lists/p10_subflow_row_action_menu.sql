prompt --application/shared_components/navigation/lists/p10_subflow_row_action_menu
begin
--   Manifest
--     LIST: P10_SUBFLOW_ROW_ACTION_MENU
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
 p_id=>wwv_flow_api.id(2407587958394790)
,p_name=>'P10_SUBFLOW_ROW_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2407770381394791)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Complete Step'
,p_list_item_icon=>'fa-sign-out'
,p_list_text_01=>'complete-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2408186437394796)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Re-start Step'
,p_list_item_icon=>'fa-redo-arrow'
,p_list_text_01=>'restart-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2408507152394796)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'-'
,p_list_item_link_target=>'separator'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2408929523394796)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Reserve Step'
,p_list_item_icon=>'fa-lock'
,p_list_text_01=>'reserve-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(2409356015394796)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Release Step'
,p_list_item_icon=>'fa-unlock'
,p_list_text_01=>'release-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
