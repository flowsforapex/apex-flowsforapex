prompt --application/shared_components/user_interface/lovs/login_remember_username
begin
--   Manifest
--     LOGIN_REMEMBER_USERNAME
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_release=>'20.1.0.00.13'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_list_of_values(
 p_id=>wwv_flow_api.id(12495494129921879909)
,p_lov_name=>'LOGIN_REMEMBER_USERNAME'
,p_lov_query=>'.'||wwv_flow_api.id(12495494129921879909)||'.'
,p_location=>'STATIC'
);
wwv_flow_api.create_static_lov_data(
 p_id=>wwv_flow_api.id(12495493775569879902)
,p_lov_disp_sequence=>10
,p_lov_disp_value=>'Remember username'
,p_lov_return_value=>'Y'
);
wwv_flow_api.component_end;
end;
/
