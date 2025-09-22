prompt --application/shared_components/automations/flows_for_apex_purge_statistics
begin
--   Manifest
--     AUTOMATION: Flows for APEX - Purge Statistics
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.11'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_automation(
 p_id=>wwv_flow_imp.id(2132078093091545)
,p_name=>'Flows for APEX - Purge Statistics'
,p_static_id=>'flows-for-apex-purge-statistics'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=DAILY;INTERVAL=1;BYHOUR=0;BYMINUTE=0'
,p_polling_status=>'ACTIVE'
,p_result_type=>'ALWAYS'
,p_use_local_sync_table=>false
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'IGNORE'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(2132703073101244)
,p_automation_id=>wwv_flow_imp.id(2132078093091545)
,p_name=>'Purge Old Statistics'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_admin_api.purge_statistics;',
'end;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Error purging Flows for APEX Statistics summaries'
,p_stop_execution_on_error=>true
);
wwv_flow_imp.component_end;
end;
/
