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
,p_default_id_offset=>329200360457307309
,p_default_owner=>'MT_NDBRUIJN'
);
wwv_flow_api.create_page(
 p_id=>3
,p_user_interface_id=>wwv_flow_api.id(12990600481502853889)
,p_name=>'Open Flow'
,p_alias=>'OPEN_FLOW'
,p_page_mode=>'MODAL'
,p_step_title=>'Open Flow'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'NDBRUIJN'
,p_last_upd_yyyymmddhh24miss=>'20200616121442'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12989372006605102082)
,p_plug_name=>'Form'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12990683665037854071)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12989370437027102067)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(12989372006605102082)
,p_button_name=>'DELETE'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--danger:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12990622909372853963)
,p_button_image_alt=>'Delete'
,p_button_position=>'BELOW_BOX'
,p_button_redirect_url=>'javascript:apex.confirm("Delete diagram?", "DELETE");'
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12989371683537102079)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(12989372006605102082)
,p_button_name=>'OPEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12990622909372853963)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Open'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_icon_css_classes=>'fa-folder-o'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(12988645422059459942)
,p_branch_name=>'Redirect'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RP:P1_NAME:&P3_NAME.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12989371879802102081)
,p_name=>'P3_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12989372006605102082)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DIAGRAMS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  select drgm.r',
'       , drgm.d',
'    from flow_r_drgm_vw drgm',
'       ;'))
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12990624065682853969)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(12988649059744459978)
,p_name=>'Reload List'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(12988648974686459977)
,p_event_id=>wwv_flow_api.id(12988649059744459978)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_NAME'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12988649747359459985)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Diagram'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete ',
'  from flow_p0003_vw dgrm',
' where dgrm.dgrm_name = :P3_NAME',
'     ;',
'',
':P3_NAME:= '''';'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'DELETE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.component_end;
end;
/
