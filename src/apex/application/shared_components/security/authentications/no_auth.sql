prompt --application/shared_components/security/authentications/no_auth
begin
--   Manifest
--     AUTHENTICATION: No Auth
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
 p_id=>wwv_flow_imp.id(36651913839128043)
,p_name=>'No Auth'
,p_scheme_type=>'NATIVE_DAD'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_version_scn=>1760506621
);
wwv_flow_imp.component_end;
end;
/
