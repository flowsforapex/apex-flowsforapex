prompt --application/shared_components/logic/application_computations/p0_license_edition
begin
--   Manifest
--     APPLICATION COMPUTATION: P0_LICENSE_EDITION
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_flow_computation(
 p_id=>wwv_flow_imp.id(14845215945423867)
,p_computation_sequence=>10
,p_computation_item=>'P0_LICENSE_EDITION'
,p_computation_point=>'AFTER_LOGIN'
,p_computation_type=>'FUNCTION_BODY'
,p_computation_language=>'PLSQL'
,p_computation_processed=>'REPLACE_EXISTING'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return flow_admin_api.get_config_value(',
'   p_config_key => ''license_edition'',',
'   p_default_value => ''community''',
')'))
,p_version_scn=>3787892091
);
wwv_flow_imp.component_end;
end;
/
