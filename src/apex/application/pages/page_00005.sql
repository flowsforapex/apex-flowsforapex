prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_page.create_page(
 p_id=>5
,p_name=>'Export'
,p_alias=>'EXPORT'
,p_page_mode=>'MODAL'
,p_step_title=>'Export - &APP_NAME_TITLE.'
,p_reload_on_submit=>'A'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17600327473220601)
,p_plug_name=>'Options'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(17601866805220616)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_button_name=>'EXPORT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Export'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-download'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17600676567220604)
,p_name=>'P5_DGRM_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17601343709220611)
,p_name=>'P5_FILENAME'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_prompt=>'File Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>300
,p_display_when=>'P5_MULTI'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17601485306220612)
,p_name=>'P5_INCLUDE_VERSION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_prompt=>'Include Version'
,p_display_as=>'NATIVE_YES_NO'
,p_tag_css_classes=>'filename-changer'
,p_display_when=>'P5_MULTI'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17601505679220613)
,p_name=>'P5_INCLUDE_CATEGORY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_prompt=>'Include Category'
,p_display_as=>'NATIVE_YES_NO'
,p_tag_css_classes=>'filename-changer'
,p_display_when=>'P5_MULTI'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17601607926220614)
,p_name=>'P5_INCLUDE_LAST_CHANGE_DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_prompt=>'Include Last Change Date'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_display_when=>'P5_MULTI'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_css_classes=>'filename-changer'
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17601740723220615)
,p_name=>'P5_DOWNLOAD_AS'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_item_default=>'BPMN'
,p_prompt=>'Download As'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'P5_DOWNLOAD_AS'
,p_lov=>'.'||wwv_flow_imp.id(11258952541008552)||'.'
,p_tag_css_classes=>'filename-changer'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17602168797220619)
,p_name=>'P5_INCLUDE_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_prompt=>'Include Status'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_display_when=>'P5_MULTI'
,p_display_when2=>'N'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_css_classes=>'filename-changer'
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(34632201368575824)
,p_name=>'P5_MULTI'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(17600327473220601)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(17601968120220617)
,p_name=>'Set File Name On Change'
,p_event_sequence=>10
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.filename-changer'
,p_bind_type=>'live'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_when_cond=>'P5_MULTI'
,p_display_when_cond2=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17602048410220618)
,p_event_id=>wwv_flow_imp.id(17601968120220617)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P5_FILENAME'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_engine_app_api.get_file_name(',
'    p_dgrm_id => :P5_DGRM_ID,',
'    p_include_version => :P5_INCLUDE_VERSION,',
'    p_include_status => :P5_INCLUDE_STATUS,',
'    p_include_category => :P5_INCLUDE_CATEGORY,',
'    p_include_last_change_date => :P5_INCLUDE_LAST_CHANGE_DATE,',
'    p_download_as => :P5_DOWNLOAD_AS',
');',
''))
,p_attribute_07=>'P5_INCLUDE_VERSION,P5_INCLUDE_CATEGORY,P5_INCLUDE_LAST_CHANGE_DATE,P5_DOWNLOAD_AS,P5_DGRM_ID,P5_INCLUDE_STATUS'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17602291110220620)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Download File'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_engine_app_api.download_file(',
'        p_dgrm_id => :P5_DGRM_ID,',
'        p_file_name => :P5_FILENAME,',
'        p_download_as => :P5_DOWNLOAD_AS,',
'        p_multi_file => case :P5_MULTI when ''Y'' then true else false end',
'    );',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(17601866805220616)
,p_internal_uid=>17602291110220620
);
wwv_flow_imp.component_end;
end;
/
