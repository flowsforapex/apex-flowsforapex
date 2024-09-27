prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(12495636486941880396)
,p_name=>'Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(2116968797571265)
,p_parent_id=>wwv_flow_imp.id(6043758234733358)
,p_short_name=>'Instance Timeline - &P20_PRCS_NAME.'
,p_link=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:::'
,p_page_id=>20
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(2407759203411191)
,p_parent_id=>wwv_flow_imp.id(11904723133918726)
,p_short_name=>'REST Service'
,p_link=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.:RP,30::'
,p_page_id=>30
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(2541995976137178)
,p_short_name=>'Daily Statistics'
,p_link=>'f?p=&APP_ID.:15:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(2550001583373355)
,p_short_name=>'Process Statistics'
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(2561724817878606)
,p_short_name=>'Task Statistics'
,p_link=>'f?p=&APP_ID.:17:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3308151438310190)
,p_parent_id=>wwv_flow_imp.id(11904723133918726)
,p_short_name=>'Logging'
,p_link=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.:32::'
,p_page_id=>32
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3308475687313586)
,p_parent_id=>wwv_flow_imp.id(11904723133918726)
,p_short_name=>'Archiving'
,p_link=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.:33::'
,p_page_id=>33
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3308685056315428)
,p_parent_id=>wwv_flow_imp.id(11904723133918726)
,p_short_name=>'Engine App'
,p_link=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.:34::'
,p_page_id=>34
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3308819433316729)
,p_parent_id=>wwv_flow_imp.id(11904723133918726)
,p_short_name=>'Engine'
,p_link=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.:35::'
,p_page_id=>35
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3309054147318793)
,p_parent_id=>wwv_flow_imp.id(11904723133918726)
,p_short_name=>'Timers'
,p_link=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.:36::'
,p_page_id=>36
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(3337454003771697)
,p_parent_id=>wwv_flow_imp.id(11904723133918726)
,p_short_name=>'Statistics'
,p_link=>'f?p=&APP_ID.:37:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>37
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(5601978818964023)
,p_short_name=>'Simple Form Templates'
,p_link=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:::'
,p_page_id=>50
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(6043758234733358)
,p_parent_id=>wwv_flow_imp.id(34554383018964598)
,p_short_name=>'&P8_PRCS_NAME.'
,p_link=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::P8_PRCS_ID:&P20_PRCS_ID.'
,p_page_id=>8
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(11904723133918726)
,p_parent_id=>0
,p_short_name=>'Configuration'
,p_link=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:9::'
,p_page_id=>9
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(34530380979770009)
,p_parent_id=>0
,p_short_name=>'Flow Management'
,p_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2::'
,p_page_id=>2
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(34530584751775010)
,p_parent_id=>wwv_flow_imp.id(34530380979770009)
,p_short_name=>'&FLOW_PAGE_TITLE.'
,p_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:::'
,p_page_id=>7
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(34550076822906956)
,p_parent_id=>wwv_flow_imp.id(34530584751775010)
,p_short_name=>'Flow Modeler'
,p_link=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(34554383018964598)
,p_parent_id=>0
,p_short_name=>'Flow Monitor'
,p_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:::'
,p_page_id=>10
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(34709672555312450)
,p_parent_id=>0
,p_short_name=>'Dashboard'
,p_link=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_page_id=>3
);
wwv_flow_imp.component_end;
end;
/
