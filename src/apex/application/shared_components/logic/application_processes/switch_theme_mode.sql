prompt --application/shared_components/logic/application_processes/switch_theme_mode
begin
--   Manifest
--     APPLICATION PROCESS: SWITCH_THEME_MODE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(5593447532877397)
,p_process_sequence=>1
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SWITCH_THEME_MODE'
,p_process_sql_clob=>'flow_theme_api.switch_theme_mode(:REQUEST);'
,p_process_clob_language=>'PLSQL'
,p_process_when=>'LIGHT_MODE DARK_MODE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_version_scn=>1760504900
);
wwv_flow_imp.component_end;
end;
/
