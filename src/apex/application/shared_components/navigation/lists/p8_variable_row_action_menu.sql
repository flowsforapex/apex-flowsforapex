prompt --application/shared_components/navigation/lists/p8_variable_row_action_menu
begin
--   Manifest
--     LIST: P8_VARIABLE_ROW_ACTION_MENU
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(7074608790273038)
,p_name=>'P8_VARIABLE_ROW_ACTION_MENU'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7074803452273042)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Edit'
,p_list_item_icon=>'fa-pencil'
,p_list_text_01=>'update-process-variable'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(7075252422273053)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Delete'
,p_list_item_icon=>'fa-trash-o'
,p_list_text_01=>'delete-process-variable'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.component_end;
end;
/
