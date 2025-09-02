prompt --application/shared_components/user_interface/lovs/logging_levels
begin
--   Manifest
--     LOGGING_LEVELS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(11503678828527)
,p_lov_name=>'LOGGING_LEVELS'
,p_lov_query=>'.'||wwv_flow_imp.id(11503678828527)||'.'
,p_location=>'STATIC'
,p_version_scn=>3588742803
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(11844748828527)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'None'
,p_lov_return_value=>'0'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12266247828526)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Abnormal Events'
,p_lov_return_value=>'1'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12660029828526)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Major Events'
,p_lov_return_value=>'2'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12991310828526)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Routine'
,p_lov_return_value=>'4'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(13844636828526)
,p_lov_disp_sequence=>8
,p_lov_disp_value=>'Full / Debug'
,p_lov_return_value=>'8'
);
wwv_flow_imp.component_end;
end;
/
