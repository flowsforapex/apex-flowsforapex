prompt --application/shared_components/user_interface/lovs/p6_import_from
begin
--   Manifest
--     P6_IMPORT_FROM
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(11250367144948655)
,p_lov_name=>'P6_IMPORT_FROM'
,p_lov_query=>'.'||wwv_flow_imp.id(11250367144948655)||'.'
,p_location=>'STATIC'
,p_version_scn=>1760504935
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(11250625753948668)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'File'
,p_lov_return_value=>'file'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(11251072818948672)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Text'
,p_lov_return_value=>'text'
);
wwv_flow_imp.component_end;
end;
/
