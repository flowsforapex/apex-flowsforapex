prompt --application/shared_components/files/css_flows4apex_dark_min_css
begin
--   Manifest
--     APP STATIC FILES: 100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E63757272656E742D70726F636573733A6E6F74285B686561646572732A3D696E7374616E63655F7374617475735F636F6C5D297B6261636B67726F756E642D636F6C6F723A72676261283235352C3235352C3235352C2E31342921696D706F7274616E';
wwv_flow_imp.g_varchar2_table(2) := '747D0A2F2A2320736F757263654D617070696E6755524C3D666C6F777334617065782E6461726B2E6373732E6D61702A2F';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(17905049977092217)
,p_file_name=>'css/flows4apex.dark.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
