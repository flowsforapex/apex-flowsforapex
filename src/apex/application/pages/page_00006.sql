prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Import Flow'
,p_alias=>'IMPORT-FLOW'
,p_page_mode=>'MODAL'
,p_step_title=>'Import Flow'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'MOKLEIN'
,p_last_upd_yyyymmddhh24miss=>'20210224143445'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19000369704190884)
,p_plug_name=>'Import Flow'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24211779219956101)
,p_plug_name=>'Import Warning'
,p_region_template_options=>'#DEFAULT#:t-Alert--colorBG:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info:t-Alert--accessibleHeading'
,p_plug_template=>wwv_flow_api.id(12495613507239880288)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_source=>'We encourage you to import flow that were built using Flows for APEX to make sure that they can be run by the engine.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(19019657971332914)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(19000369704190884)
,p_button_name=>'IMPORT_AND_IMPORT_ANOTHER'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Import and import another'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(19019773259332915)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(19000369704190884)
,p_button_name=>'IMPORT_AND_EDIT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_image_alt=>'Import and edit'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-edit'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(19018929080332907)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(19000369704190884)
,p_button_name=>'IMPORT'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Import'
,p_button_position=>'BELOW_BOX'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(19019818946332916)
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_DGRM_ID:&P6_DGRM_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'IMPORT_AND_EDIT'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(10431588640468049)
,p_name=>'P6_IMPORT_FROM'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_item_default=>'file'
,p_prompt=>'Import From'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:File;file,Text;text'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19000655987190889)
,p_name=>'P6_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19001062236190895)
,p_name=>'P6_DGRM_NAME'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>600
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19001433995190900)
,p_name=>'P6_DGRM_CONTENT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_prompt=>'Paste  BPMN file content (30 000 characters max.)'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>30000
,p_cHeight=>10
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19001891912190900)
,p_name=>'P6_DGRM_VERSION'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_item_default=>'0'
,p_prompt=>'Version'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>40
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19002654728190900)
,p_name=>'P6_DGRM_CATEGORY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'DIAGRAM_CATEGORIES_LOV'
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>120
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'Y'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19018652597332904)
,p_name=>'P6_BPMN_FILE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_prompt=>'BPMN File'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'APEX_APPLICATION_TEMP_FILES'
,p_attribute_09=>'REQUEST'
,p_attribute_10=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24211819068956102)
,p_name=>'P6_FORCE_OVERWRITE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_item_default=>'N'
,p_prompt=>'Force Overwrite'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APPLICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(19023151364332949)
,p_validation_name=>'DGRM_CONTENT is not null'
,p_validation_sequence=>10
,p_validation=>'P6_DGRM_CONTENT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please paste BPMN file content'
,p_validation_condition=>'P6_IMPORT_FROM'
,p_validation_condition2=>'text'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_associated_item=>wwv_flow_api.id(19001433995190900)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(19023037485332948)
,p_validation_name=>'File is not null'
,p_validation_sequence=>20
,p_validation=>'return flow_p0006_api.is_file_uploaded(pi_file_name => :P6_BPMN_FILE);'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please select a #LABEL#.'
,p_validation_condition=>'P6_IMPORT_FROM'
,p_validation_condition2=>'file'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_associated_item=>wwv_flow_api.id(19018652597332904)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(19019544229332913)
,p_validation_name=>'Validate XML'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_p0006_api.is_valid_xml(',
'        pi_import_from => :P6_IMPORT_FROM,',
'        pi_dgrm_content => :P6_DGRM_CONTENT,',
'        pi_file_name => :P6_BPMN_FILE',
'    );'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please check the flow provided.'
,p_validation_condition_type=>'NOT_DISPLAYING_INLINE_VALIDATION_ERRORS'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(10431642957468050)
,p_name=>'Show/Hide Import Options'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_IMPORT_FROM'
,p_condition_element=>'P6_IMPORT_FROM'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'text'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19018371683332901)
,p_event_id=>wwv_flow_api.id(10431642957468050)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_DGRM_CONTENT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19018703760332905)
,p_event_id=>wwv_flow_api.id(10431642957468050)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_BPMN_FILE'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19018463856332902)
,p_event_id=>wwv_flow_api.id(10431642957468050)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_DGRM_CONTENT'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(19018502280332903)
,p_event_id=>wwv_flow_api.id(10431642957468050)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_BPMN_FILE'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(24211903521956103)
,p_name=>'Ask for confirmation'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_FORCE_OVERWRITE'
,p_condition_element=>'P6_FORCE_OVERWRITE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(24212041561956104)
,p_event_id=>wwv_flow_api.id(24211903521956103)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.confirm( apex.lang.getMessage("FLOW_OVERWRITE_WARN"), function( okPressed ) {',
'    if( !okPressed ) {',
'        apex.item("P6_FORCE_OVERWRITE").setValue("N");',
'    }',
'});',
''))
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(19018865821332906)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Upload & Parse'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_dgrm_id flow_diagrams.dgrm_id%type;',
'begin',
'    l_dgrm_id := flow_p0006_api.upload_and_parse(',
'        pi_import_from => :P6_IMPORT_FROM,',
'        pi_dgrm_name => :P6_DGRM_NAME,',
'        pi_dgrm_category => :P6_DGRM_CATEGORY,',
'        pi_dgrm_version => :P6_DGRM_VERSION,',
'        pi_dgrm_content => :P6_DGRM_CONTENT,',
'        pi_file_name => :P6_BPMN_FILE,',
'        pi_force_overwrite => :P6_FORCE_OVERWRITE',
'    );',
'    :P6_DGRM_ID := l_dgrm_id;',
'end;',
''))
,p_process_error_message=>'Flow already exists. Use force orverwrite.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Flow imported.'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(19019994508332917)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Page'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'IMPORT_AND_IMPORT_ANOTHER'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(19008825550190910)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P6_DGRM_ID'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'IMPORT'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.component_end;
end;
/
