prompt --application/shared_components/files/css_20_1_flows4apex_light_css_map
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
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22666C6F777334617065782E6C696768742E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C412C7142414171422C2B422C4341436E422C7943222C2266';
wwv_flow_api.g_varchar2_table(2) := '696C65223A22666C6F777334617065782E6C696768742E637373222C22736F7572636573436F6E74656E74223A5B222E63757272656E742D70726F636573733A6E6F74285B686561646572732A3D696E7374616E63655F7374617475735F636F6C5D297B';
wwv_flow_api.g_varchar2_table(3) := '5C725C6E20206261636B67726F756E642D636F6C6F723A207267626128302C302C302C2E312921696D706F7274616E743B5C725C6E7D225D7D';
wwv_flow_api.create_app_static_file(
 p_id=>wwv_flow_api.id(8136557503183087)
,p_file_name=>'css/20.1/flows4apex.light.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
wwv_flow_api.component_end;
end;
/
