prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>984337
,p_default_id_offset => 0
,p_default_owner=>'MT_NDBRUIJN'
);
wwv_flow_api.create_page(
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(12661400121045546580)
,p_name=>'Open Flow'
,p_alias=>'OPEN_FLOW'
,p_page_mode=>'MODAL'
,p_step_title=>'Open Flow'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'MOKLEIN'
,p_last_upd_yyyymmddhh24miss=>'20200701111602'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12660171646147794773)
,p_plug_name=>'Form'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12661483304580546762)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12660170076569794758)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12660171646147794773)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--danger:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12661422548915546654)
,p_button_image_alt=>'Delete'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'javascript:apex.confirm("Delete diagram?", "DELETE");'
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12660171323079794770)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(12660171646147794773)
,p_button_name=>'OPEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12661422548915546654)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Open'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_icon_css_classes=>'fa-folder-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(12659445061602152633)
,p_branch_name=>'Redirect'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP,:P1_NAME:&P3_NAME.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12660171519344794772)
,p_name=>'P3_NAME'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12660171646147794773)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DIAGRAMS'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- select -'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12661423406524546660)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12659448699287152669)
,p_name=>'Reload List'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12659448614229152668)
,p_event_id=>wwv_flow_api.id(12659448699287152669)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_NAME'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12659449386902152676)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Diagram'
,p_process_sql_clob=>'flow_p0003_api.delete_diagram( pi_dgrm_name => :p3_name );'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(12660170076569794758)
,p_process_success_message=>'Diagram deleted.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(331396632111413615)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Cache'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(12660170076569794758)
);
wwv_flow_api.component_end;
end;
/
