prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Create Flow Instance'
,p_alias=>'CREATE_FLOW_INSTANCE'
,p_page_mode=>'MODAL'
,p_step_title=>'Create Flow Instance - &APP_NAME_TITLE.'
,p_first_item=>'AUTO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery("#PopupLov_11_P11_DGRM_ID_dlg").parent(".ui-dialog").on( "dialogopen", function( event, ui ) {',
'    console.log(event);',
'    console.log(ui);',
'} );'))
,p_step_template=>wwv_flow_api.id(12495624331342880306)
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'N'
,p_last_updated_by=>'LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20210921132808'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(10603847781745438)
,p_plug_name=>'Buttons Container'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495606500823880260)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(12491866042341262842)
,p_plug_name=>'Create Flow Instance'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(12491865858754262840)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(10603847781745438)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'TEMPLATE_DEFAULT'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(6433507492417645)
,p_name=>'P11_PRCS_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_api.id(12491866042341262842)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(34631117879575813)
,p_name=>'P11_BUSINESS_REF'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(12491866042341262842)
,p_prompt=>'Business Reference (Process Variable)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12491865492429262836)
,p_name=>'P11_PRCS_NAME'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(12491866042341262842)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522847445880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(12491865909625262841)
,p_name=>'P11_DGRM_ID'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(12491866042341262842)
,p_prompt=>'Parsed Flow'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'DIAGRAMS_PARSED_LOV'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(12495522548744880132)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_plugin_init_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function(options) {',
'    console.log(options);',
'    var col, columns = options.columns;',
'    ',
'    //options.minWidth = 600;',
'',
'    col = columns.DGRM_NAME;',
'    col.noStretch = false;',
'',
'    col = columns.DGRM_STATUS;',
'    col.width = 100;',
'    col.noStretch = true;',
'    ',
'    col = columns.DGRM_VERSION;',
'    col.width = 100;',
'    col.noStretch = true;',
'    ',
'    options.persistState = false;',
'',
'    ',
'    return options;',
'}'))
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(12491865217503262834)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'CREATE_INSTANCE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_prcs_id flow_processes.prcs_id%type;',
'begin',
'    l_prcs_id := flow_api_pkg.flow_create( ',
'          pi_dgrm_id   => :p11_dgrm_id',
'        , pi_prcs_name => :p11_prcs_name',
'    );',
'    ',
'    if :P11_BUSINESS_REF  is not null then',
'        flow_process_vars.set_var( ',
'              pi_prcs_id   => l_prcs_id',
'            , pi_var_name  => ''BUSINESS_REF''',
'            , pi_vc2_value => :P11_BUSINESS_REF',
'        );',
'    end if;',
'    :P11_PRCS_ID := l_prcs_id; ',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(160797930317501982)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P11_PRCS_ID,P11_PRCS_NAME'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'&APP_TEXT$APP_INSTANCE_CREATED.'
);
wwv_flow_api.component_end;
end;
/
