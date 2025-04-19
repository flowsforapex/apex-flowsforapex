prompt --application/shared_components/security/authentications/application_express_authentication
begin
--   Manifest
--     AUTHENTICATION: Application Express Authentication
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(12495636783173880401)
,p_name=>'Application Express Authentication'
,p_scheme_type=>'NATIVE_APEX_ACCOUNTS'
,p_invalid_session_type=>'LOGIN'
,p_cookie_name=>'&WORKSPACE_COOKIE.'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_version_scn=>1760506621
);
wwv_flow_imp.component_end;
end;
/
