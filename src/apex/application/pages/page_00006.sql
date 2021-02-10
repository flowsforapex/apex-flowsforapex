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
,p_name=>'Import Diagram'
,p_alias=>'IMPORT-DIAGRAM'
,p_page_mode=>'MODAL'
,p_step_title=>'Import Diagram'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210210004634'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(19000369704190884)
,p_plug_name=>'Import Diagram'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
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
,p_button_image_alt=>'Import And Import Another'
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
,p_button_image_alt=>'Import And Edit'
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
,p_field_template=>wwv_flow_api.id(12495522847445880132)
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
 p_id=>wwv_flow_api.id(19002242138190900)
,p_name=>'P6_DGRM_STATUS'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_item_default=>'draft'
,p_prompt=>'Status'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:draft;draft,released;released,deprecated;deprecated,archived;archived'
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'4'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(19002654728190900)
,p_name=>'P6_DGRM_CATEGORY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(19000369704190884)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct dgrm_category d, dgrm_category r',
'from flow_diagrams_lov'))
,p_lov_display_null=>'YES'
,p_cSize=>60
,p_cMaxlength=>120
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
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
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attribute_01=>'APEX_APPLICATION_TEMP_FILES'
,p_attribute_09=>'REQUEST'
,p_attribute_10=>'N'
);
wwv_flow_api.create_page_validation(
 p_id=>wwv_flow_api.id(19019544229332913)
,p_validation_name=>'Validate XML'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare ',
'    l_dgrm_content flow_diagrams.dgrm_content%type;',
'    l_import_from varchar2(5) := :P6_IMPORT_FROM;',
'    l_xmltype xmltype;',
'    l_err boolean := true;',
'begin',
'    if (l_import_from = ''text'') then',
'        l_dgrm_content := :P6_DGRM_CONTENT;',
'    else',
'        select to_clob(blob_content)',
'        into l_dgrm_content',
'        from apex_application_temp_files',
'        where name = :P6_BPMN_FILE;',
'    end if;',
'    begin',
'        l_xmltype := xmltype.createXML(l_dgrm_content);',
'    exception when others then',
'        l_err := false;',
'    end;',
'    return l_err;',
'end;'))
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please check the diagram provided.'
,p_when_button_pressed=>wwv_flow_api.id(19018929080332907)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
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
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(19018865821332906)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Upload & Parse'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_dgrm_id flow_diagrams.dgrm_id%type;',
'    l_dgrm_name flow_diagrams.dgrm_name%type;',
'    l_dgrm_category flow_diagrams.dgrm_category%type;',
'    l_dgrm_version flow_diagrams.dgrm_version%type;',
'    l_dgrm_status flow_diagrams.dgrm_status%type;',
'    l_dgrm_content flow_diagrams.dgrm_content%type;',
'    l_import_from varchar2(5) := :P6_IMPORT_FROM;',
'begin    ',
'    l_dgrm_name := :P6_DGRM_NAME;',
'    l_dgrm_category := :P6_DGRM_CATEGORY;',
'    l_dgrm_version := :P6_DGRM_VERSION;',
'    l_dgrm_status := :P6_DGRM_STATUS;',
'    if (l_import_from = ''text'') then',
'        l_dgrm_content := :P6_DGRM_CONTENT;',
'    else',
'        select to_clob(blob_content)',
'        into l_dgrm_content',
'        from apex_application_temp_files',
'        where name = :P6_BPMN_FILE;',
'    end if;',
'    ',
'    if (:request in (''IMPORT'', ''IMPORT_AND_IMPORT_ANOTHER'')) then',
'        flow_bpmn_parser_pkg.upload_and_parse(',
'            pi_dgrm_name => l_dgrm_name',
'            , pi_dgrm_version => l_dgrm_version',
'            , pi_dgrm_category => l_dgrm_category',
'            , pi_dgrm_content => l_dgrm_content',
'            , pi_dgrm_status => l_dgrm_status',
'        );',
'    end if;',
'    ',
'    if (:request = ''IMPORT_AND_EDIT'') then',
'        l_dgrm_id := flow_bpmn_parser_pkg.upload_diagram(',
'            pi_dgrm_name => l_dgrm_name',
'            , pi_dgrm_version => l_dgrm_version',
'            , pi_dgrm_category => l_dgrm_category',
'            , pi_dgrm_content => l_dgrm_content',
'            , pi_dgrm_status => l_dgrm_status',
'        );',
'        flow_bpmn_parser_pkg.parse(pi_dgrm_id => l_dgrm_id);',
'        :P6_DGRM_ID := l_dgrm_id;',
'    end if;',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
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
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'IMPORT'
,p_process_when_type=>'REQUEST_IN_CONDITION'
);
wwv_flow_api.component_end;
end;
/
