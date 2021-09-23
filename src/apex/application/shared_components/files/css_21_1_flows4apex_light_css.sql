prompt --application/shared_components/files/css_21_1_flows4apex_light_css
begin
--   Manifest
--     APP STATIC FILES: 100
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E6666612D636F6C6F722D2D72756E6E696E67202E742D42616467654C6973742D6C6162656C207B0D0A2020636F6C6F723A20776869746521696D706F7274616E743B0D0A7D0D0A0D0A2E6666612D636F6C6F722D2D7465726D696E61746564202E742D';
wwv_flow_api.g_varchar2_table(2) := '42616467654C6973742D6C6162656C207B0D0A2020636F6C6F723A20776869746521696D706F7274616E743B0D0A7D0D0A0D0A2E6666612D636F6C6F722D2D6572726F72202E742D42616467654C6973742D6C6162656C207B0D0A2020636F6C6F723A20';
wwv_flow_api.g_varchar2_table(3) := '776869746521696D706F7274616E743B0D0A7D';
wwv_flow_api.create_app_static_file(
 p_id=>wwv_flow_api.id(18106877801374789)
,p_file_name=>'css/21.1/flows4apex.light.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
wwv_flow_api.component_end;
end;
/
