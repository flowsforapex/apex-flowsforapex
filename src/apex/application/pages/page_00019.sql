prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
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
 p_id=>19
,p_name=>'Running Task Status'
,p_alias=>'RUNNING-TASK-STATUS'
,p_step_title=>'Running Task Status'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(139713252817873)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(12495573047450880221)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(12495636486941880396)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(12495520300515880126)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(140369606817870)
,p_plug_name=>'Running Task Status'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(12495582446800880234)
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'FLOW_P0019_VW'
,p_query_where=>'dgrm_id = :P19_DGRM_ID'
,p_include_rowid_column=>false
,p_plug_source_type=>'PLUGIN_COM.FLOWS4APEX.VIEWER.REGION.251'
,p_ajax_items_to_submit=>'P19_DGRM_ID'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'badges_data', 'BADGES_DATA',
  'diagram_identifier', 'DGRM_ID',
  'diagram_xml', 'DGRM_CONTENT',
  'enable_mousewheel_zoom', 'N',
  'refresh_on_load', 'Y',
  'show_toolbar', 'N',
  'use_bpmn_colors', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(699571956607074)
,p_name=>'P19_DGRM_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(140369606817870)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp.component_end;
end;
/
