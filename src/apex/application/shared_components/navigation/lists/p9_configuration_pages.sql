prompt --application/shared_components/navigation/lists/p9_configuration_pages
begin
--   Manifest
--     LIST: P9_CONFIGURATION_PAGES
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(3291351989268379)
,p_name=>'P9_CONFIGURATION_PAGES'
,p_list_status=>'PUBLIC'
,p_version_scn=>3770182256
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
,p_list_item_link_text=>'Completed Instance Archiving and Purging'
,p_list_item_link_target=>'f?p=&APP_ID.:33:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-archive'
,p_list_text_01=>'Configure process instance archiving and purging'
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
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(11497553424163179)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'License'
,p_list_item_link_target=>'f?p=&APP_ID.:39:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-signature'
,p_list_text_01=>'Edition, license information'
,p_translate_list_text_y_n=>'Y'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(4807112393506933)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Automations'
,p_list_item_link_target=>'f?p=&APP_ID.:43:&SESSION.::&DEBUG.:43,CIR,RIR:::'
,p_list_item_icon=>'fa-calendar-clock'
,p_list_text_01=>'Manage and monitor automations'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(12583258855978108)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'AI Prompts'
,p_list_item_link_target=>'f?p=&APP_ID.:44:&SESSION.::&DEBUG.:RP:::'
,p_list_item_icon=>'fa-ai'
,p_list_text_01=>'AI Prompts and Quick Actions'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
