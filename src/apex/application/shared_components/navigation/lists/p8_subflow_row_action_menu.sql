prompt --application/shared_components/navigation/lists/p8_subflow_row_action_menu
begin
--   Manifest
--     LIST: P8_SUBFLOW_ROW_ACTION_MENU
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(2407587958394790)
,p_name=>'P8_SUBFLOW_ROW_ACTION_MENU'
,p_list_status=>'PUBLIC'
,p_version_scn=>1842640680
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2407770381394791)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Complete'
,p_list_item_icon=>'fa-sign-out'
,p_list_text_01=>'complete-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(6516742938690)
,p_list_item_display_sequence=>15
,p_list_item_link_text=>'-'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2408186437394796)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Re-start'
,p_list_item_icon=>'fa-redo-arrow'
,p_list_text_01=>'restart-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(6837593932517)
,p_list_item_display_sequence=>25
,p_list_item_link_text=>'Force Next Step'
,p_list_item_icon=>'fa-circle-arrow-out-east fam-pause fam-is-danger'
,p_list_text_01=>'force-next-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2408507152394796)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'-'
,p_list_item_link_target=>'separator'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2408929523394796)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Reserve'
,p_list_item_icon=>'fa-lock'
,p_list_text_01=>'reserve-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(2409356015394796)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Release'
,p_list_item_icon=>'fa-unlock'
,p_list_text_01=>'release-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(73474529421861842)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'-'
,p_list_item_link_target=>'separator'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(73474805704863264)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Reschedule'
,p_list_item_icon=>'fa-clock-o'
,p_list_text_01=>'reschedule-timer'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7153715926375)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'-'
,p_list_item_link_target=>'separator'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7668582916460)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Delete Subflow'
,p_list_item_icon=>'fa-trash fam-pause fam-is-danger'
,p_list_text_01=>'delete-on-resume'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(7955792911684)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Rewind to Previous Gateway'
,p_list_item_icon=>'fa-fast-backward fam-pause fam-is-danger'
,p_list_text_01=>'return-prev-gw-resume'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(8210725906916)
,p_list_item_display_sequence=>110
,p_list_item_link_text=>'Rewind to Last Step'
,p_list_item_icon=>'fa-step-backward fam-pause fam-is-danger'
,p_list_text_01=>'rewind-last-step'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(8558461902787)
,p_list_item_display_sequence=>120
,p_list_item_link_text=>'Rewind to Earlier Step'
,p_list_item_icon=>'fa-backward fam-pause fam-is-danger'
,p_list_text_01=>'reposition-subflow'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(8866680897439)
,p_list_item_display_sequence=>130
,p_list_item_link_text=>'Rewind from Sub Process'
,p_list_item_icon=>'fa-fast-backward fam-pause fam-is-danger'
,p_list_text_01=>'rewind-subprocess-on-resume'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(9154014893229)
,p_list_item_display_sequence=>140
,p_list_item_link_text=>'Rewind from Call Activity'
,p_list_item_icon=>'fa-fast-backward fam-pause fam-is-danger'
,p_list_text_01=>'rewind-call-activity-on-resume'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
