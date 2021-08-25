prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
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
 p_id=>12
,p_user_interface_id=>wwv_flow_api.id(12495499263265880052)
,p_name=>'Viewer'
,p_alias=>'VIEWER'
,p_page_mode=>'NON_MODAL'
,p_step_title=>'Flow Monitor - &APP_NAME_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch:t-Dialog--noPadding'
,p_last_updated_by=>'LMOREAUX'
,p_last_upd_yyyymmddhh24miss=>'20210824173035'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(6161598858353963900)
,p_plug_name=>'Flow Monitor (&P12_FLOW_NAME.)'
,p_region_name=>'flow-monitor'
,p_region_css_classes=>'js-react-on-prcs'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_INSTANCE_DETAILS_VW'
,p_query_where=>'prcs_id = :P12_PRCS_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION'
,p_ajax_items_to_submit=>'P12_PRCS_ID'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'DGRM_CONTENT'
,p_attribute_02=>'ALL_CURRENT'
,p_attribute_04=>'ALL_COMPLETED'
,p_attribute_06=>'ALL_ERRORS'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_attribute_10=>'Y'
,p_attribute_11=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(33735715098406128)
,p_name=>'P12_PRCS_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(6161598858353963900)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(33737496021406145)
,p_name=>'P12_FLOW_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(6161598858353963900)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_api.create_page_computation(
 p_id=>wwv_flow_api.id(33737563010406146)
,p_computation_sequence=>10
,p_computation_item=>'P12_FLOW_NAME'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>'select prcs_name from flow_instances_vw where prcs_id = :P12_PRCS_ID'
);
wwv_flow_api.component_end;
end;
/
