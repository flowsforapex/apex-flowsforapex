prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_page.create_page(
 p_id=>12
,p_name=>'Viewer'
,p_alias=>'VIEWER'
,p_page_mode=>'NON_MODAL'
,p_step_title=>'Flow Monitor - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch:t-Dialog--noPadding'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(6161598858353963900)
,p_plug_name=>'Flow Monitor (&P12_PRCS_NAME.)'
,p_region_name=>'flow-monitor'
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_INSTANCE_DETAILS_VW'
,p_query_where=>'prcs_id = :P12_PRCS_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION'
,p_ajax_items_to_submit=>'P12_PRCS_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'attribute_01', 'DGRM_CONTENT',
  'attribute_02', 'ALL_CURRENT',
  'attribute_03', 'PRDG_ID',
  'attribute_04', 'ALL_COMPLETED',
  'attribute_05', 'PRDG_PRDG_ID',
  'attribute_06', 'ALL_ERRORS',
  'attribute_07', 'CALLING_OBJT',
  'attribute_08', 'Y',
  'attribute_09', 'Y',
  'attribute_11', 'Y',
  'attribute_12', 'BREADCRUMB',
  'attribute_13', 'DRILLDOWN_ALLOWED',
  'attribute_14', 'Y',
  'attribute_15', 'N',
  'attribute_16', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7334819132307030)
,p_name=>'P12_OBJT_LIST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(6161598858353963900)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7335361967307035)
,p_name=>'P12_OBJT_BPMN_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(6161598858353963900)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(7335483836307036)
,p_name=>'P12_OBJT_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(6161598858353963900)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33735715098406128)
,p_name=>'P12_PRCS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(6161598858353963900)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33737496021406145)
,p_name=>'P12_PRCS_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(6161598858353963900)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44803255576176614)
,p_name=>'P12_LOADED_DIAGRAM'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(6161598858353963900)
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(33737563010406146)
,p_computation_sequence=>10
,p_computation_item=>'P12_PRCS_NAME'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.get_prcs_name(',
'  pi_prcs_id => :P12_PRCS_ID',
')'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(8049983261140649)
,p_name=>'Viewer Diagram Loaded'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(6161598858353963900)
,p_condition_element=>'P12_PRCS_NAME'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_diagram_loaded'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(44803326871176615)
,p_event_id=>wwv_flow_imp.id(8049983261140649)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_LOADED_DIAGRAM'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.diagramIdentifier'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8051357622140676)
,p_event_id=>wwv_flow_imp.id(8049983261140649)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_OBJT_LIST'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P12_LOADED_DIAGRAM is not null then',
'return flow_engine_app_api.get_objt_list(p_prdg_id => :P12_LOADED_DIAGRAM);',
'end if;'))
,p_attribute_07=>'P12_LOADED_DIAGRAM'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8051867682140677)
,p_event_id=>wwv_flow_imp.id(8049983261140649)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'changeCursor($v(''P12_OBJT_LIST''));'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(8052795498141983)
,p_name=>'Element clicked'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(6161598858353963900)
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'clickCondition($v(''P12_OBJT_LIST''), this.data);'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION|REGION TYPE|mtbv_element_click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8053641230141984)
,p_event_id=>wwv_flow_imp.id(8052795498141983)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_OBJT_BPMN_ID'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.element.id'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8054174771141984)
,p_event_id=>wwv_flow_imp.id(8052795498141983)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_OBJT_NAME'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P12_LOADED_DIAGRAM is not null then',
'return flow_engine_app_api.get_objt_name(',
'    p_objt_bpmn_id => :P12_OBJT_BPMN_ID',
'  , p_prdg_id => :P12_LOADED_DIAGRAM',
');',
'end if;'))
,p_attribute_07=>'P12_OBJT_BPMN_ID,P12_LOADED_DIAGRAM'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8053186121141984)
,p_event_id=>wwv_flow_imp.id(8052795498141983)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'openObjectDialog($v(''P12_OBJT_BPMN_ID''), $v(''P12_OBJT_NAME''), 12);'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(7335772142307039)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.get_url_p13(',
'  pi_prcs_id => :P12_PRCS_ID',
', pi_prdg_id => :P12_LOADED_DIAGRAM',
', pi_objt_id => apex_application.g_x01',
', pi_title => apex_application.g_x02',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>7335772142307039
);
wwv_flow_imp.component_end;
end;
/
