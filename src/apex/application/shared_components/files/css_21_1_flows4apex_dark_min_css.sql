prompt --application/shared_components/files/css_21_1_flows4apex_dark_min_css
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
wwv_flow_imp.g_varchar2_table(1) := '2E6666612D636F6C6F722D2D63726561746564202E742D42616467654C6973742D6C6162656C7B636F6C6F723A2334363334303021696D706F7274616E747D2E6666612D636F6C6F722D2D636F6D706C65746564202E742D42616467654C6973742D6C61';
wwv_flow_imp.g_varchar2_table(2) := '62656C7B636F6C6F723A2332383361346421696D706F7274616E747D0A2F2A2320736F757263654D617070696E6755524C3D666C6F777334617065782E6461726B2E6373732E6D61702A2F';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(18106106010373782)
,p_file_name=>'css/21.1/flows4apex.dark.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
