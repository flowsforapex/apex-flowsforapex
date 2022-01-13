prompt --application/shared_components/files/css_21_2_flows4apex_dark_css
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
wwv_flow_api.g_varchar2_table(1) := '2E6666612D636F6C6F722D2D63726561746564202E742D42616467654C6973742D6C6162656C207B0A2020636F6C6F723A202334363334303021696D706F7274616E743B0A7D0A0A2E6666612D636F6C6F722D2D636F6D706C65746564202E742D426164';
wwv_flow_api.g_varchar2_table(2) := '67654C6973742D6C6162656C207B0A2020636F6C6F723A202332383361346421696D706F7274616E743B0A7D';
wwv_flow_api.create_app_static_file(
 p_id=>wwv_flow_api.id(32200728748850876)
,p_file_name=>'css/21.2/flows4apex.dark.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
wwv_flow_api.component_end;
end;
/
