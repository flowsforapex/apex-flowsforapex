prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Flow Modeler'
,p_alias=>'MODELER'
,p_step_title=>'Flow Modeler - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'FLOWS4APEX'
,p_last_upd_yyyymmddhh24miss=>'20210816050719'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(7938399981499706)
,p_plug_name=>'Action Menu'
,p_region_name=>'actions'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495609856182880263)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_list_id=>wwv_flow_api.id(7959288629726086)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_api.id(12495525309455880143)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(22800510543488044)
,p_plug_name=>'&P4_REGION_TITLE.'
,p_region_name=>'modeler'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_DIAGRAMS'
,p_query_where=>'dgrm_id = :p4_dgrm_id'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.MODELER.REGION'
,p_ajax_items_to_submit=>'P4_DGRM_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(24418438259878743)
,p_plug_name=>'Flow XML'
,p_region_name=>'diagram_xml_region'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size600x400'
,p_plug_template=>wwv_flow_api.id(12495608896288880263)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_04'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(34403031827171416)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_api.id(12495573047450880221)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_api.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_api.id(12495520300515880126)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(15683484308738625)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(34403031827171416)
,p_button_name=>'SAVE_FLOW'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_api.id(12495521691135880126)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save Flow'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-save'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(7938283749499705)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_api.id(34403031827171416)
,p_button_name=>'ACTION_MENU'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(12495522463331880131)
,p_button_image_alt=>'Action Menu'
,p_button_position=>'REGION_TEMPLATE_NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'js-menuButton'
,p_icon_css_classes=>'fa-bars'
,p_button_cattributes=>'data-menu="actions_menu"'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(15681777930738608)
,p_name=>'P4_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(22800510543488044)
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(22800638443488045)
,p_name=>'P4_REGION_TITLE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(22800510543488044)
,p_source=>'No valid Flow selected.'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(24418616934878745)
,p_name=>'P4_DIAGRAM_XML'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(24418438259878743)
,p_prompt=>'Diagram Xml'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>50
,p_cHeight=>20
,p_grid_label_column_span=>0
,p_field_template=>wwv_flow_api.id(12495523145758880138)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_warn_on_unsaved_changes=>'I'
,p_attribute_01=>'Y'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(22800733881488046)
,p_computation_sequence=>10
,p_computation_item=>'P4_REGION_TITLE'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dgrm_name || '' (Version: '' || dgrm_version || '', Status: '' || dgrm_status || '')'' as d',
'  from flow_diagrams',
' where dgrm_id = :p4_dgrm_id'))
,p_compute_when=>'P4_DGRM_ID'
,p_compute_when_type=>'ITEM_IS_NOT_NULL'
);
wwv_flow_api.create_page_da_event(
 p_id=>wwv_flow_api.id(15683695432738627)
,p_name=>'Save Flow Clicked'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_api.id(15683484308738625)
,p_bind_type=>'bind'
,p_bind_event_type=>'click'
);
wwv_flow_api.create_page_da_action(
 p_id=>wwv_flow_api.id(22801024059488049)
,p_event_id=>wwv_flow_api.id(15683695432738627)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.region(''modeler'').save();'
);
wwv_flow_api.component_end;
end;
/
