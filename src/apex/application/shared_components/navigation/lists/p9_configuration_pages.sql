prompt --application/shared_components/navigation/lists/p9_configuration_pages
begin
--   Manifest
--     LIST: P9_CONFIGURATION_PAGES
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
 p_id=>wwv_flow_imp.id(3291351989268379)
,p_name=>'P9_CONFIGURATION_PAGES'
,p_list_status=>'PUBLIC'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(3291576005268381)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Logging'
,p_list_item_link_target=>'f?p=&APP_ID.:32:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-indent'
,p_list_text_01=>'Language, level, user information, retention time, bpmn location, message flows'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(3291958597268382)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Archiving'
,p_list_item_link_target=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-archive'
,p_list_text_01=>'Enable archiving, instance archive location'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(3343699244810836)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Statistics'
,p_list_item_link_target=>'f?p=&APP_ID.:37:&SESSION.::&DEBUG.:37:::'
,p_list_item_icon=>'fa-bar-chart'
,p_list_text_01=>'Summaries retention time'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(3292372844268382)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Engine App'
,p_list_item_link_target=>'f?p=&APP_ID.:34:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-window'
,p_list_text_01=>'App Mode'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(3292700268268382)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Engine'
,p_list_item_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-hardware'
,p_list_text_01=>'Step key usage, default values'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(3293122238268383)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Timers'
,p_list_item_link_target=>'f?p=&APP_ID.:36:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-clock-o'
,p_list_text_01=>'Enable timers, scheduler, max cycles'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(3293918632269809)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'REST'
,p_list_item_link_target=>'f?p=&APP_ID.:30:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-gear'
,p_list_text_01=>'REST clients'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
