prompt --application/shared_components/security/authorizations/enterprise_edition
begin
--   Manifest
--     SECURITY SCHEME: Enterprise Edition
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(29951042215468222)
,p_name=>'Enterprise Edition'
,p_scheme_type=>'NATIVE_ITEM_EQUALS_VALUE'
,p_attribute_01=>'P0_LICENSE_EDITION'
,p_attribute_02=>'enterprise'
,p_error_message=>'&APP_TEXT$APP_ENTERPRISE_EDITION_DIALOG!RAW.'
,p_version_scn=>8547405047
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_imp.component_end;
end;
/
