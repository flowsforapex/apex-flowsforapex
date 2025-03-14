prompt --application/shared_components/files/css_21_1_flows4apex_light_min_css
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
wwv_flow_imp.g_varchar2_table(1) := '2E6666612D636F6C6F722D2D6572726F72202E742D42616467654C6973742D6C6162656C2C2E6666612D636F6C6F722D2D72756E6E696E67202E742D42616467654C6973742D6C6162656C2C2E6666612D636F6C6F722D2D7465726D696E61746564202E';
wwv_flow_imp.g_varchar2_table(2) := '742D42616467654C6973742D6C6162656C7B636F6C6F723A2366666621696D706F7274616E747D0A2F2A2320736F757263654D617070696E6755524C3D666C6F777334617065782E6C696768742E6373732E6D61702A2F';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(18107437347376260)
,p_file_name=>'css/21.1/flows4apex.light.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
