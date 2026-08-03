prompt --application/pages/page_00023
begin
--   Manifest
--     PAGE: 00023
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
 p_id=>23
,p_name=>'Adhoc Activity Launcher'
,p_alias=>'ADHOC-ACTIVITY-LAUNCHER'
,p_page_mode=>'MODAL'
,p_step_title=>'Adhoc Activity Launcher'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>'apex.util.getTopApex().jQuery(".f4a-dynamic-title .ui-dialog-content").dialog("option", "title", "Input Parameters for " + apex.items.P23_ACTIVITY_NAME.value);'
,p_step_template=>wwv_flow_imp.id(12495624331342880306)
,p_page_template_options=>'#DEFAULT#'
,p_dialog_css_classes=>'f4a-dynamic-title'
,p_dialog_chained=>'N'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(16803637065123704)
,p_plug_name=>'Button Bar'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495606500823880260)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43702852780283160)
,p_plug_name=>'Parameters'
,p_title=>'Input Parameters for &P23_ACTIVITY_NAME.'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495609856182880263)
,p_plug_display_sequence=>10
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(43703399822283165)
,p_plug_name=>'Task Parameters'
,p_parent_plug_id=>wwv_flow_imp.id(43702852780283160)
,p_region_template_options=>'#DEFAULT#:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source_type=>'PLUGIN_JSON_REGION.UWESIMON.SELFHOST.E'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'attribute_01', '250',
  'attribute_02', 'SQL-Query',
  'attribute_04', wwv_flow_string.join(wwv_flow_t_varchar2(
    'select input_parameters_schema',
    '  from   flow_object_input_schema_vw',
    ' where  objt_bpmn_id = :P23_ACTIVITY_BPMN_ID',
    '   and  objt_dgrm_id = :P23_DGRM_ID')),
  'attribute_05', '3',
  'attribute_06', 'N',
  'attribute_07', 'Y',
  'attribute_08', 'Y',
  'attribute_09', 'Y',
  'attribute_10', 'P23_DATA',
  'attribute_11', 'floating',
  'attribute_13', 'N',
  'attribute_16', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(21944177366360635)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(16803637065123704)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(21944539683360635)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(16803637065123704)
,p_button_name=>'Start'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Start'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(21784837320192731)
,p_name=>'P23_PRCS_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(43702852780283160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(21785086135192733)
,p_name=>'P23_SBFL_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(43702852780283160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43704394675283169)
,p_name=>'P23_DATA'
,p_data_type=>'CLOB'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(43702852780283160)
,p_prompt=>'Data'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43704491910283170)
,p_name=>'P23_ACTIVITY_BPMN_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(43702852780283160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43704639469283171)
,p_name=>'P23_DGRM_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(43702852780283160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43704759478283172)
,p_name=>'P23_ACTIVITY_NAME'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(43702852780283160)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(21947422972360653)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(21944177366360635)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(21947935698360654)
,p_event_id=>wwv_flow_imp.id(21947422972360653)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(21946754213360652)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Start Adhoc Activity'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_api_pkg.flow_start_adhoc_activity',
'( p_process_id             => :P23_PRCS_ID',
', p_subflow_id             => :P23_SBFL_ID',
', p_activity_bpmn_id       => :P23_ACTIVITY_BPMN_ID',
', p_user_input_parameters  => :P23_DATA',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(21944539683360635)
,p_internal_uid=>21946754213360652
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(21947032415360653)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'CloseDialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Activity Started'
,p_internal_uid=>21947032415360653
);
wwv_flow_imp.component_end;
end;
/
