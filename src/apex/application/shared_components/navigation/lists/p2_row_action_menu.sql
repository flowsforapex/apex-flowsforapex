prompt --application/shared_components/navigation/lists/p2_row_action_menu
begin
--   Manifest
--     LIST: P2_ROW_ACTION_MENU
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
 p_id=>wwv_flow_api.id(39902352324857428)
,p_name=>'P2_ROW_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39902501487857435)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Edit'
,p_list_item_icon=>'fa-pencil'
,p_list_text_01=>'edit-flow-diagram'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39902920078857437)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'New Version'
,p_list_item_icon=>'fa-arrow-circle-o-up'
,p_list_text_01=>'new-flow-version'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(39903360633857437)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Copy'
,p_list_item_icon=>'fa-plus'
,p_list_text_01=>'copy-flow'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
