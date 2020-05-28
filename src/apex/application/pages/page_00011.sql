prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>59800345087111703
,p_default_application_id=>480340
,p_default_id_offset=>13603073842510480015
,p_default_owner=>'FLOWSFORAPEX'
);
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(13652442279228366415)
,p_name=>'Create Process Instance'
,p_alias=>'CREATE_PROCESS_INSTANCE'
,p_page_mode=>'MODAL'
,p_step_title=>'Create Process Instance'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_last_updated_by=>'NDBRUIJN'
,p_last_upd_yyyymmddhh24miss=>'20200525093538'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(13656075500152983625)
,p_plug_name=>'Create Process Instance'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--textContent:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(13652359095693366233)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(13656075683739983627)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_api.id(13656075500152983625)
,p_button_name=>'ERSTELLEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--mobileHideLabel:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_api.id(13652419851358366341)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'LEFT'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_api.create_page_branch(
 p_id=>wwv_flow_api.id(13656076438129983634)
,p_branch_name=>'Redirect'
,p_branch_action=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:RP::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13656075632868983626)
,p_name=>'P11_DGM_NAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(13656075500152983625)
,p_prompt=>'Diagram'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DIAGRAMS'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(13652418993749366335)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(13656076050064983631)
,p_name=>'P11_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(13656075500152983625)
,p_prompt=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_api.id(13652418695048366335)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(13656076324990983633)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'CREATE_INSTANCE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  dummy number;',
'begin',
'  dummy:= flows_pkg.flow_create',
'  ( p_diagram_name => :P11_DGM_NAME',
'  , p_process_name => :P11_NAME',
'  );',
'end;'))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_api.component_end;
end;
/
