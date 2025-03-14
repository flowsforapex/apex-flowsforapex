prompt --application/shared_components/files/css_21_2_flows4apex_light_css
begin
--   Manifest
--     APP STATIC FILES: 100
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E6666612D636F6C6F722D2D72756E6E696E67202E742D42616467654C6973742D6C6162656C207B0A2020636F6C6F723A20776869746521696D706F7274616E743B0A7D0A0A2E6666612D636F6C6F722D2D7465726D696E61746564202E742D42616467';
wwv_flow_imp.g_varchar2_table(2) := '654C6973742D6C6162656C207B0A2020636F6C6F723A20776869746521696D706F7274616E743B0A7D0A0A2E6666612D636F6C6F722D2D6572726F72202E742D42616467654C6973742D6C6162656C207B0A2020636F6C6F723A20776869746521696D70';
wwv_flow_imp.g_varchar2_table(3) := '6F7274616E743B0A7D';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(32200948477850895)
,p_file_name=>'css/21.2/flows4apex.light.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
