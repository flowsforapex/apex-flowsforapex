prompt --application/shared_components/automations/flows_for_apex_daily_instance_archive
begin
--   Manifest
--     AUTOMATION: Flows for APEX - Daily Instance Archive
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.8'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_imp_shared.create_automation(
 p_id=>wwv_flow_imp.id(2130974654065929)
,p_name=>'Flows for APEX - Daily Instance Archive'
,p_static_id=>'flows-for-apex-daily-instance-archive'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=DAILY;INTERVAL=1;BYHOUR=0;BYMINUTE=0'
,p_polling_status=>'DISABLED'
,p_result_type=>'ALWAYS'
,p_use_local_sync_table=>false
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'IGNORE'
,p_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Flows for APEX Daily Instance Archive.',
'For each process instance that has reached ''completed'' or ''terminated'' status, this daily job creates a JSON summary of the instance execution, diagrams used, sub flows run, variables set, process events.',
'Archives are stored based on the F4A Configuration Parameter  ''logging_archive_location'', and can be set to a database table or to OCI Object Storage.'))
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(2131266656065931)
,p_automation_id=>wwv_flow_imp.id(2130974654065929)
,p_name=>'Run Daily Instance Archive'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_admin_api.archive_completed_instances;',
'end;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Daily Instance Summary Archive process error'
,p_stop_execution_on_error=>true
);
wwv_flow_imp.component_end;
end;
/
