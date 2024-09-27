prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
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
 p_id=>wwv_flow_imp.id(12495635966008880385)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(34586567175532090)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-pie-chart'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'3'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(9900462312126995)
,p_list_item_display_sequence=>15
,p_list_item_link_text=>'Flow Management'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-sitemap-horizontal'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2,4,7'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(12493524976121117621)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Flow Monitor'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RP,RIR:::'
,p_list_item_icon=>'fa-sequence'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'10,8'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(5597875143964021)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Simple Form Templates'
,p_list_item_link_target=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-forms'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'50,51'
);
wwv_flow_imp.component_end;
end;
/
