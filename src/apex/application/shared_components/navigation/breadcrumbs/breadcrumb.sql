prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_menu(
 p_id=>wwv_flow_api.id(12495636486941880396)
,p_name=>'Breadcrumb'
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(6043758234733358)
,p_parent_id=>wwv_flow_api.id(34554383018964598)
,p_short_name=>'&P8_PRCS_NAME.'
,p_page_id=>8
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(11904723133918726)
,p_parent_id=>0
,p_short_name=>'Configuration'
,p_page_id=>9
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34530380979770009)
,p_parent_id=>0
,p_short_name=>'Flow Management'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2::'
,p_page_id=>2
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34530584751775010)
,p_parent_id=>wwv_flow_api.id(34530380979770009)
,p_short_name=>'&FLOW_PAGE_TITLE.'
,p_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34550076822906956)
,p_parent_id=>wwv_flow_api.id(34530584751775010)
,p_short_name=>'Flow Modeler'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34554383018964598)
,p_parent_id=>0
,p_short_name=>'Flow Monitor'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_api.create_menu_option(
 p_id=>wwv_flow_api.id(34709672555312450)
,p_parent_id=>0
,p_short_name=>'Dashboard'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_api.component_end;
end;
/
