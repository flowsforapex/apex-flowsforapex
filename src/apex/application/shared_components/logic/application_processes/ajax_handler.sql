prompt --application/shared_components/logic/application_processes/ajax_handler
begin
--   Manifest
--     APPLICATION PROCESS: AJAX_HANDLER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.04.12'
,p_release=>'22.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(7625964662736152)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJAX_HANDLER'
,p_process_sql_clob=>'flow_engine_app_api.handle_ajax;'
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
);
wwv_flow_imp.component_end;
end;
/
