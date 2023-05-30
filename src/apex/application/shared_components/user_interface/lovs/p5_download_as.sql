prompt --application/shared_components/user_interface/lovs/p5_download_as
begin
--   Manifest
--     P5_DOWNLOAD_AS
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(11258952541008552)
,p_lov_name=>'P5_DOWNLOAD_AS'
,p_lov_query=>'.'||wwv_flow_api.id(11258952541008552)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(11259254401008560)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'BPMN File'
,p_lov_return_value=>'BPMN'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(11259507519008561)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'SQL Script'
,p_lov_return_value=>'SQL'
);
wwv_flow_api.component_end;
end;
/
