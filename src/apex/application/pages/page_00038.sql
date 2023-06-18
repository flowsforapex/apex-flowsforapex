prompt --application/pages/page_00038
begin
--   Manifest
--     PAGE: 00038
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_page(
 p_id=>38
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Configuration - Location'
,p_alias=>'CONFIGURATION-LOCATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Configuration - Location'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'C##LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20230513144012'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3512217433851735)
,p_plug_name=>'Location'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_CONFIGURATION'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'u'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3747249703530336)
,p_plug_name=>'Choose the active destination'
,p_parent_plug_id=>wwv_flow_api.id(3512217433851735)
,p_icon_css_classes=>'fa-number-1-o'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--customIcons:t-Alert--info'
,p_plug_template=>wwv_flow_api.id(12495613507239880288)
,p_plug_display_sequence=>10
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3747347338530337)
,p_plug_name=>'Fill in the details'
,p_parent_plug_id=>wwv_flow_api.id(3512217433851735)
,p_icon_css_classes=>'fa-number-2-o'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--customIcons:t-Alert--info:margin-bottom-none'
,p_plug_template=>wwv_flow_api.id(12495613507239880288)
,p_plug_display_sequence=>20
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(3745995977530323)
,p_plug_name=>'Button Bar'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495606500823880260)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3745589259530319)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_api.id(3745995977530323)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(3745670019530320)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(3745995977530323)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495521767510880126)
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_TEMPLATE_PREVIOUS'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3512603514851739)
,p_name=>'P38_CFIG_KEY'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3512217433851735)
,p_item_source_plug_id=>wwv_flow_api.id(3512217433851735)
,p_source=>'CFIG_KEY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3512743931851740)
,p_name=>'P38_CFIG_VALUE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(3512217433851735)
,p_item_source_plug_id=>wwv_flow_api.id(3512217433851735)
,p_source=>'CFIG_VALUE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3513035181851743)
,p_name=>'P38_DESTINATION_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(3747249703530336)
,p_prompt=>'Destination Type'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Table;TABLE,OCI (API);OCI-API,OCI (PreAuth);OCI-PREAUTH'
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'3'
,p_attribute_02=>'NONE'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3513116353851744)
,p_name=>'P38_TABLE_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Table Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select table_name d, table_name r',
'from user_tables'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3513290888851745)
,p_name=>'P38_ID_COLUMN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Id Column'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select column_name d, column_name r',
'from user_tab_columns',
'where table_name = :P38_TABLE_NAME',
'and data_type = ''NUMBER'';'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P38_TABLE_NAME'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3513352883851746)
,p_name=>'P38_TIMESTAMP_COLUMN'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Timestamp Column'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select column_name d, column_name r',
'from user_tab_columns',
'where table_name = :P38_TABLE_NAME',
'and data_type like ''TIMESTAMP%WITH TIME ZONE%'';'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P38_TABLE_NAME'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3513454878851747)
,p_name=>'P38_BLOB_COLUMN'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Blob Column'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select column_name d, column_name r',
'from user_tab_columns',
'where table_name = :P38_TABLE_NAME',
'and data_type = ''BLOB'';'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P38_TABLE_NAME'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3743758890530301)
,p_name=>'P38_BASE_URL'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Base URL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'URL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3743862263530302)
,p_name=>'P38_BUCKET_NAME'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Bucket Name'
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
 p_id=>wwv_flow_api.id(3743975741530303)
,p_name=>'P38_API_DOCUMENT_PREFIX'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Document Prefix'
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
 p_id=>wwv_flow_api.id(3744055656530304)
,p_name=>'P38_API_CREDENTIAL_APEX_STATIC_ID'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'APEX Credential Static Id'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name||'' (''||credential_type||'')'' d, static_id',
'from apex_workspace_credentials;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3744138186530305)
,p_name=>'P38_PRE_AUTH_URL'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Pre Auth URL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'URL'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(3747558988530339)
,p_name=>'P38_PREAUTH_DOCUMENT_PREFIX'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'Document Prefix'
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
 p_id=>wwv_flow_api.id(3747603686530340)
,p_name=>'P38_PREAUTH_CREDENTIAL_APEX_STATIC_ID'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_api.id(3747347338530337)
,p_prompt=>'APEX Credential Static Id'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name||'' (''||credential_type||'')'' d, static_id',
'from apex_workspace_credentials;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(3746058063530324)
,p_computation_sequence=>10
,p_computation_item=>'P38_CFIG_VALUE'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_clob clob;',
'begin',
'    apex_json.initialize_clob_output;',
'',
'    apex_json.open_object;',
'    apex_json.write(''destinationType'', :P38_DESTINATION_TYPE);',
'',
'    apex_json.open_object(''tableDetails'');',
'    apex_json.write(''tableName'', :P38_TABLE_NAME);',
'    apex_json.write(''idColumn'', :P38_ID_COLUMN);',
'    apex_json.write(''timestampColumn'', :P38_TIMESTAMP_COLUMN);',
'    apex_json.write(''blobColumn'', :P38_BLOB_COLUMN);',
'    apex_json.close_object;',
'',
'    apex_json.open_object(''ociApiDetails'');',
'    apex_json.write(''baseUrl'', :P38_BASE_URL);',
'    apex_json.write(''bucketName'', :P38_BUCKET_NAME);',
'    apex_json.write(''documentPrefix'', :P38_API_DOCUMENT_PREFIX);',
'    apex_json.write(''credentialApexStaticId'', :P38_API_CREDENTIAL_APEX_STATIC_ID);',
'    apex_json.close_object;',
'',
'    apex_json.open_object(''ociPreAuthDetails'');',
'    apex_json.write(''preAuthUrl'', :P38_PRE_AUTH_URL);',
'    apex_json.write(''documentPrefix'', :P38_PREAUTH_DOCUMENT_PREFIX);',
'    apex_json.write(''credentialApexStaticId'', :P38_PREAUTH_CREDENTIAL_APEX_STATIC_ID);',
'    apex_json.close_object;',
'',
'    apex_json.close_object;',
'',
'    l_clob := apex_json.get_clob_output( p_free => true );',
'',
'    return l_clob;',
'end;'))
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3744327033530307)
,p_name=>'Hide/Show Table Fields'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P38_DESTINATION_TYPE'
,p_condition_element=>'P38_DESTINATION_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'TABLE'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3744474525530308)
,p_event_id=>wwv_flow_api.id(3744327033530307)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_TABLE_NAME,P38_ID_COLUMN,P38_TIMESTAMP_COLUMN,P38_BLOB_COLUMN'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3744597361530309)
,p_event_id=>wwv_flow_api.id(3744327033530307)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_TABLE_NAME,P38_ID_COLUMN,P38_TIMESTAMP_COLUMN,P38_BLOB_COLUMN'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3744633233530310)
,p_name=>'Hide/Show OCI-API Fields'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P38_DESTINATION_TYPE,P38_API_DOCUMENT_PREFIX,P38_API_CREDENTIAL_APEX_STATIC_ID'
,p_condition_element=>'P38_DESTINATION_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'OCI-API'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3744771169530311)
,p_event_id=>wwv_flow_api.id(3744633233530310)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_BASE_URL,P38_BUCKET_NAME,P38_API_DOCUMENT_PREFIX,P38_API_CREDENTIAL_APEX_STATIC_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3747744242530341)
,p_event_id=>wwv_flow_api.id(3744633233530310)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_BASE_URL,P38_BUCKET_NAME,P38_API_DOCUMENT_PREFIX,P38_API_CREDENTIAL_APEX_STATIC_ID'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3744919862530313)
,p_name=>'Hide/Show OCI-PREAUTH Fields'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P38_DESTINATION_TYPE'
,p_condition_element=>'P38_DESTINATION_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'OCI-PREAUTH'
,p_bind_type=>'bind'
,p_bind_event_type=>'change'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3745034758530314)
,p_event_id=>wwv_flow_api.id(3744919862530313)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_PRE_AUTH_URL,P38_PREAUTH_DOCUMENT_PREFIX,P38_PREAUTH_CREDENTIAL_APEX_STATIC_ID'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3747827765530342)
,p_event_id=>wwv_flow_api.id(3744919862530313)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P38_PRE_AUTH_URL,P38_PREAUTH_DOCUMENT_PREFIX,P38_PREAUTH_CREDENTIAL_APEX_STATIC_ID'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(3745700945530321)
,p_name=>'Click on Cancel'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(3745670019530320)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(3745870785530322)
,p_event_id=>wwv_flow_api.id(3745700945530321)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3512846601851741)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_api.id(3512217433851735)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Location'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3746695353530330)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3512551612851738)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_api.id(3512217433851735)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Configuration - Location'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(3744274227530306)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Parse JSON'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'   select destination_type,',
'          table_name,',
'          id_column,',
'          timestamp_column,',
'          blob_column,',
'          base_url,',
'          bucket_name,',
'          oci_api_doc_prefix, ',
'          oci_api_cred,',
'          preauth_url,',
'          oci_preauth_doc_prefix, ',
'          oci_preauth_cred',
'     into :p38_destination_type,',
'          :p38_table_name,',
'          :p38_id_column,',
'          :p38_timestamp_column,',
'          :p38_blob_column,',
'          :p38_base_url,',
'          :p38_bucket_name,',
'          :p38_api_document_prefix,',
'          :p38_api_credential_apex_static_id,',
'          :p38_pre_auth_url,',
'          :p38_preauth_document_prefix,',
'          :p38_preauth_credential_apex_static_id',
'     from json_table(',
'             (',
'                select cfig_value',
'                  from flow_configuration',
'                 where cfig_key = :P38_CFIG_KEY',
'             ),',
'             ''$''',
'             columns (',
'                destination_type       varchar2 path ''$.destinationType'',',
'                table_name             varchar2 path ''$.tableDetails.tableName'',',
'                id_column              varchar2 path ''$.tableDetails.idColumn'',',
'                timestamp_column       varchar2 path ''$.tableDetails.timestampColumn'',',
'                blob_column            varchar2 path ''$.tableDetails.blobColumn'',',
'                base_url               varchar2 path ''$.ociApiDetails.baseUrl'',',
'                bucket_name            varchar2 path ''$.ociApiDetails.bucketName'',',
'                oci_api_doc_prefix     varchar2 path ''$.ociApiDetails.documentPrefix'',',
'                oci_api_cred           varchar2 path ''$.ociApiDetails.credentialApexStaticId'',',
'                preauth_url            varchar2 path ''$.ociPreAuthDetails.preAuthUrl'',',
'                oci_preauth_doc_prefix varchar2 path ''$.ociPreAuthDetails.documentPrefix'',',
'                oci_preauth_cred       varchar2 path ''$.ociPreAuthDetails.credentialApexStaticId''',
'             )',
'          );',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
