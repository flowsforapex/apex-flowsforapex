prompt --application/shared_components/files/css_flows4apex_dark_css
begin
--   Manifest
--     APP STATIC FILES: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E63757272656E742D70726F636573733A6E6F74285B686561646572732A3D22696E7374616E63655F7374617475735F636F6C225D29207B0D0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E';
wwv_flow_api.g_varchar2_table(2) := '3134292021696D706F7274616E743B0D0A7D';
wwv_flow_api.create_app_static_file(
 p_id=>wwv_flow_api.id(17904413161090630)
,p_file_name=>'css/flows4apex.dark.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
wwv_flow_api.component_end;
end;
/
