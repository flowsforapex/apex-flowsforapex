prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
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
 p_id=>0
,p_name=>'Global Page'
,p_step_title=>'Global Page'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'14'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4862440282240142)
,p_plug_name=>'Enterprise Edition'
,p_region_name=>'enterprise-edition-dg'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:t-DialogRegion--noPadding:js-dialog-size480x320'
,p_plug_template=>wwv_flow_imp.id(12495587659835880238)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_04'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(4862763016240145)
,p_plug_name=>'Enterprise Edition Feature'
,p_parent_plug_id=>wwv_flow_imp.id(4862440282240142)
,p_region_template_options=>'#DEFAULT#:t-Alert--wizard:t-Alert--defaultIcons:t-Alert--info:t-Alert--accessibleHeading:margin-top-none:margin-bottom-none'
,p_plug_template=>wwv_flow_imp.id(12495613507239880288)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>'&APP_TEXT$APP_ENTERPRISE_EDITION_DIALOG!RAW.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(4862688334240144)
,p_name=>'P0_LICENSE_EDITION'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp.component_end;
end;
/
