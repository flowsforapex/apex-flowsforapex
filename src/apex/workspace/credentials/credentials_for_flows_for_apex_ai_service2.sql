prompt --workspace/credentials/credentials_for_flows_for_apex_ai_service2
begin
--   Manifest
--     CREDENTIAL: Credentials for flows for apex ai service2
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(4444843643055631)
,p_name=>'Credentials for flows for apex ai service2'
,p_static_id=>'credentials_for_flows_for_apex_ai_service2'
,p_authentication_type=>'HTTP_HEADER'
,p_valid_for_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'https://api.openai.com/v1',
''))
,p_prompt_on_install=>true
);
wwv_flow_imp.component_end;
end;
/
