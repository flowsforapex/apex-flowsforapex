prompt --application/user_interfaces
begin
--   Manifest
--     USER INTERFACES: 100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_user_interface(
 p_id=>wwv_flow_imp.id(12495499263265880052)
,p_ui_type_name=>'DESKTOP'
,p_display_name=>'Desktop'
,p_display_seq=>10
,p_use_auto_detect=>false
,p_is_default=>true
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:3:&SESSION.'
,p_login_url=>'f?p=&APP_ID.:LOGIN:&SESSION.'
,p_theme_style_by_user_pref=>false
,p_navigation_list_id=>wwv_flow_imp.id(12495635966008880385)
,p_navigation_list_position=>'SIDE'
,p_navigation_list_template_id=>wwv_flow_imp.id(12495533999726880152)
,p_nav_list_template_options=>'#DEFAULT#:js-defaultCollapsed:js-navCollapsed--hidden:t-TreeNav--styleA'
,p_css_file_urls=>'#APP_IMAGES#css/flows4apex#MIN#.css'
,p_javascript_file_urls=>'#APP_IMAGES#js/flows4apex#MIN#.js'
,p_nav_bar_type=>'LIST'
,p_nav_bar_list_id=>wwv_flow_imp.id(12495499558192880054)
,p_nav_bar_list_template_id=>wwv_flow_imp.id(12495534382344880154)
,p_nav_bar_template_options=>'#DEFAULT#'
);
wwv_flow_imp.component_end;
end;
/
