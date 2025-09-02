prompt --application/pages/page_00040
begin
--   Manifest
--     PAGE: 00040
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
 p_id=>40
,p_name=>'Enable/Disable Automation'
,p_alias=>'ENABLE-DISABLE-AUTOMATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Enable/Disable Automation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:t-DeferredRendering'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4618800202349218)
,p_plug_name=>'Enable Automation'
,p_region_css_classes=>'u-textCenter'
,p_icon_css_classes=>'fa-question-circle-o'
,p_region_template_options=>'#DEFAULT#:t-Alert--wizard:t-Alert--customIcons:t-Alert--warning'
,p_plug_template=>wwv_flow_imp.id(12495613507239880288)
,p_plug_display_sequence=>10
,p_location=>null
,p_plug_source=>'The automation is currently disabled, do you want to enable it?'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from apex_appl_automations	',
'where application_id = :app_id',
'and static_id = :P40_STATIC_ID',
'and polling_status_code = ''DISABLED'''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4619086969349220)
,p_plug_name=>'Disable Automation'
,p_region_css_classes=>'u-textCenter'
,p_icon_css_classes=>'fa-question-circle-o'
,p_region_template_options=>'#DEFAULT#:t-Alert--wizard:t-Alert--customIcons:t-Alert--warning'
,p_plug_template=>wwv_flow_imp.id(12495613507239880288)
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source=>'The automation is currently enabled, do you want to disable it?'
,p_plug_display_condition_type=>'EXISTS'
,p_plug_display_when_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select 1',
'from apex_appl_automations	',
'where application_id = :app_id',
'and static_id = :P40_STATIC_ID',
'and polling_status_code = ''ACTIVE'''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4618906099349219)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(4618800202349218)
,p_button_name=>'ENABLE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Enable'
,p_button_position=>'CLOSE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(4619141310349221)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(4619086969349220)
,p_button_name=>'DISABLE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(12495521767510880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Disable'
,p_button_position=>'CLOSE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4619363268349223)
,p_name=>'P40_STATIC_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4619204702349222)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Enable Automation'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    apex_automation.enable(',
'        p_application_id  => :app_id,',
'        p_static_id       => :P40_STATIC_ID',
'    );',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(4618906099349219)
,p_internal_uid=>9078309386505035
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4619457602349224)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Disable Automation'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    apex_automation.disable(',
'        p_application_id  => :app_id,',
'        p_static_id       => :P40_STATIC_ID',
'    );',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(4619141310349221)
,p_internal_uid=>9078562286505037
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(4619525839349225)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>9078630523505038
);
wwv_flow_imp.component_end;
end;
/
