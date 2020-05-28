prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>59800345087111703
,p_default_application_id=>480340
,p_default_id_offset=>13603073842510480015
,p_default_owner=>'FLOWSFORAPEX'
);
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(13652305576485366082)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(13652452142190366604)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Workflow Editor'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-apex'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(13654416566373128846)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Process Instances'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-sequence'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10'
);
wwv_flow_api.component_end;
end;
/
