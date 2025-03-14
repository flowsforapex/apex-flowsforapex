prompt --application/pages/page_00036
begin
--   Manifest
--     PAGE: 00036
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
 p_id=>36
,p_name=>'Configuration - Timers'
,p_alias=>'CONFIGURATION-TIMERS'
,p_step_title=>'Configuration - Timers'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'span.t-Form-inlineHelp ul li {',
'    font-size: 1.1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4548240290043011)
,p_plug_name=>'Additonal Installation Step Not Complete'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>wwv_flow_imp.id(12495613507239880288)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_source=>'To use the Timers feature of Flows for APEX, you must complete additional installation step that can be found <a href="https://flowsforapex.org/latest/installation/#post-installation-task-1-additional-step-to-use-timers" target="_blank">here</a>.'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>'not flow_timers_pkg.timer_job_exists'
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(5273399411803742)
,p_plug_name=>'Timers'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>'flow_timers_pkg.timer_job_exists'
,p_plug_display_when_cond2=>'PLSQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(24203633870580280)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3311591865325268)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(24203633870580280)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'flow_timers_pkg.timer_job_exists'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3249682912234740)
,p_name=>'P36_TIMER_STATUS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(5273399411803742)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Timers Enabled'
,p_source=>'flow_timers_pkg.get_timer_status'
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'TRUE'
,p_attribute_03=>'enabled'
,p_attribute_04=>'FALSE'
,p_attribute_05=>'disabled'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3250052219234740)
,p_name=>'P36_TIMER_REPEAT_INTERVAL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(5273399411803742)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Timer Repeat Interval'
,p_source=>'flow_timers_pkg.get_timer_repeat_interval'
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'Hourly'
,p_quick_pick_value_01=>'FREQ=HOURLY;INTERVAL=1'
,p_quick_pick_label_02=>'10 Min'
,p_quick_pick_value_02=>'FREQ=MINUTELY;INTERVAL=10'
,p_quick_pick_label_03=>'5 Min'
,p_quick_pick_value_03=>'FREQ=MINUTELY;INTERVAL=10'
,p_quick_pick_label_04=>'1 Min'
,p_quick_pick_value_04=>'FREQ=MINUTELY;INTERVAL=10'
,p_quick_pick_label_05=>'10 Sec (Production Use - not for apex.oracle.com)'
,p_quick_pick_value_05=>'FREQ=SECONDLY;INTERVAL=10'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3317563907227906)
,p_name=>'P36_TIMER_MAX_CYCLES'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(5273399411803742)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Timer Max Cycles'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_util.get_config_value(',
'           p_config_key =>flow_constants_pkg.gc_config_timer_max_cycles',
'         , p_default_value => flow_constants_pkg.gc_config_default_timer_max_cycles',
'       )'))
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_inline_help_text=>'For cycle timers, this will defined the maximum number of execution.'
,p_encrypt_session_state_yn=>'N'
,p_attribute_03=>'left'
,p_attribute_04=>'text'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(3257766356234742)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Set Settings'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'flow_engine_app_api.set_timers_settings(',
'  pi_timer_max_cycles      => :P36_TIMER_MAX_CYCLES',
', pi_timer_status          => :P36_TIMER_STATUS',
', pi_timer_repeat_interval => :P36_TIMER_REPEAT_INTERVAL',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Changes saved.'
,p_internal_uid=>3257766356234742
);
wwv_flow_imp.component_end;
end;
/
