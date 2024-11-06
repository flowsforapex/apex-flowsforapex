prompt --application/shared_components/navigation/lists/desktop_navigation_bar
begin
--   Manifest
--     LIST: Desktop Navigation Bar
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
 p_id=>wwv_flow_imp.id(12495499558192880054)
,p_name=>'Desktop Navigation Bar'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(34597614443542059)
,p_list_item_display_sequence=>5
,p_list_item_link_text=>'Getting started'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-info-square-o'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(11904067894914484)
,p_list_item_display_sequence=>6
,p_list_item_link_text=>'Configuration'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9:::'
,p_list_item_icon=>'fa-gear'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(5589254850825963)
,p_list_item_display_sequence=>7
,p_list_item_link_text=>'Theme'
,p_list_item_icon=>'fa-paint-brush'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(6211519620415215)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Automatic'
,p_list_item_link_target=>'javascript:apex.submit((window.matchMedia && window.matchMedia(''(prefers-color-scheme: dark)'').matches) ? ''RESET_DARK'' : ''RESET_LIGHT'');'
,p_list_item_icon=>'fa-adjust'
,p_parent_list_item_id=>wwv_flow_imp.id(5589254850825963)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(5591024903839479)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Light Mode'
,p_list_item_link_target=>'javascript:apex.submit(''LIGHT_MODE'');'
,p_list_item_icon=>'fa-sun-o'
,p_parent_list_item_id=>wwv_flow_imp.id(5589254850825963)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(5591767688841799)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Dark Mode'
,p_list_item_link_target=>'javascript:apex.submit(''DARK_MODE'');'
,p_list_item_icon=>'fa-moon-o'
,p_parent_list_item_id=>wwv_flow_imp.id(5589254850825963)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(12495487956468879842)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'&APP_USER.'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(12495487403732879842)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'---'
,p_list_item_link_target=>'separator'
,p_parent_list_item_id=>wwv_flow_imp.id(12495487956468879842)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(12495487001695879840)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Sign Out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_list_item_icon=>'fa-sign-out'
,p_parent_list_item_id=>wwv_flow_imp.id(12495487956468879842)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
