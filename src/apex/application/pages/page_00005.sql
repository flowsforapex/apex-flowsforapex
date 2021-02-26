prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page(
 p_id=>5
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Export Flow'
,p_alias=>'EXPORT-FLOW'
,p_page_mode=>'MODAL'
,p_step_title=>'Export Flow'
,p_reload_on_submit=>'A'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'MOKLEIN'
,p_last_upd_yyyymmddhh24miss=>'20210224143615'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(17600327473220601)
,p_plug_name=>'Options'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(17601866805220616)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(17600327473220601)
,p_button_name=>'EXPORT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Export'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-download'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17600676567220604)
,p_name=>'P5_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(17600327473220601)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17601343709220611)
,p_name=>'P5_FILENAME'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(17600327473220601)
,p_prompt=>'File Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17601485306220612)
,p_name=>'P5_INCLUDE_VERSION'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(17600327473220601)
,p_prompt=>'Include Version'
,p_display_as=>'NATIVE_YES_NO'
,p_tag_css_classes=>'filename-changer'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17601505679220613)
,p_name=>'P5_INCLUDE_CATEGORY'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(17600327473220601)
,p_prompt=>'Include Category'
,p_display_as=>'NATIVE_YES_NO'
,p_tag_css_classes=>'filename-changer'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17601607926220614)
,p_name=>'P5_INCLUDE_LAST_CHANGE_DATE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(17600327473220601)
,p_prompt=>'Include Last Change Date'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_css_classes=>'filename-changer'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17601740723220615)
,p_name=>'P5_DOWNLOAD_AS'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_api.id(17600327473220601)
,p_item_default=>'BPMN'
,p_prompt=>'Download As'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:BPMN File;BPMN,SQL Script;SQL'
,p_tag_css_classes=>'filename-changer'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(17602168797220619)
,p_name=>'P5_INCLUDE_STATUS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(17600327473220601)
,p_prompt=>'Include Status'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_css_classes=>'filename-changer'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(17601968120220617)
,p_name=>'Set File Name On Change'
,p_event_sequence=>10
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.filename-changer'
,p_bind_type=>'live'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(17602048410220618)
,p_event_id=>wwv_flow_api.id(17601968120220617)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P5_FILENAME'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_p0005_api.get_file_name(',
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
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(17602291110220620)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Download File'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_p0005_api.download_file(',
'        p_dgrm_id => :P5_DGRM_ID,',
'        p_file_name => :P5_FILENAME,',
'        p_download_as => :P5_DOWNLOAD_AS',
'    );',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(17601866805220616)
);
wwv_flow_api.component_end;
end;
/
