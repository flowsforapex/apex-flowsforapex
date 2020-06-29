prompt --application/shared_components/plugins/region_type/com_mtag_as_wfp_region
begin
--   Manifest
--     PLUGIN: COM.MTAG.AS.WFP.REGION
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>984337
,p_default_id_offset=>329200360457307309
,p_default_owner=>'MT_NDBRUIJN'
);
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(3607004603740545433)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COM.MTAG.AS.WFP.REGION'
,p_display_name=>'Display BPMN.IO workflow'
,p_supported_ui_types=>'DESKTOP'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('REGION TYPE','COM.MTAG.AS.WFP.REGION'),'')
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function f_render',
'( P_REGION              IN  APEX_PLUGIN.T_REGION',
', P_PLUGIN              IN  APEX_PLUGIN.T_PLUGIN',
', P_IS_PRINTER_FRIENDLY IN  BOOLEAN',
') return apex_plugin.t_region_render_result',
'as',
'		',
'	l_current_text        varchar2(4000 char):= p_region.attribute_01;',
'	l_branch              varchar2(4000 char):= p_region.attribute_02;',
'	l_abzweigung_waehlen  varchar2(4000 char):= p_region.attribute_03;',
'	l_naechster_schritt   varchar2(4000 char):= p_region.attribute_04;',
'	l_return              apex_plugin.t_region_render_result;',
'',
'begin',
'  htp.p(''<div id="canvas"></div>'');',
'  return l_return;',
'end;'))
,p_api_version=>1
,p_render_function=>'f_render'
,p_standard_attributes=>'VALUE_ATTRIBUTE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>2
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2022556433842281655)
,p_plugin_id=>wwv_flow_api.id(3607004603740545433)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'CURRENT_TEXT'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2014390210997016780)
,p_plugin_id=>wwv_flow_api.id(3607004603740545433)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'P10_BRANCH'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2014194030811015150)
,p_plugin_id=>wwv_flow_api.id(3607004603740545433)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'NAECHSTER_SCHRITT'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2014187803815013752)
,p_plugin_id=>wwv_flow_api.id(3607004603740545433)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'ABZWEIGUNG_WAEHLEN'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.component_end;
end;
/
