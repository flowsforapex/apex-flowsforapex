prompt --application/shared_components/automations/flows_for_apex_purge_logs
begin
--   Manifest
--     AUTOMATION: Flows for APEX - Purge Logs
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
 p_id=>wwv_flow_imp.id(2134304189122562)
,p_name=>'Flows for APEX - Purge Logs'
,p_static_id=>'flows-for-apex-purge-logs'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=DAILY;INTERVAL=1;BYHOUR=0;BYMINUTE=5'
,p_polling_status=>'DISABLED'
,p_result_type=>'ALWAYS'
,p_use_local_sync_table=>false
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'IGNORE'
,p_comment=>'Flows for APEX Purge Instance Log Tables.   This purges records in the flow_instance_events, flow_step_events, and flow_variable_events tables to keep log table size under control.  If instance summary archiving is enabled, a json document containing'
||' a full summary / audit trail for each process instance should have been created and stored in archive storage (database table or OCI Object Storage) before the relevant records are purged.   See documentation.'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(2134675479122562)
,p_automation_id=>wwv_flow_imp.id(2134304189122562)
,p_name=>'Purge Log Tables'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_admin_api.purge_instance_logs;',
'end;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Flows for APEX - Error purging log tables.'
,p_stop_execution_on_error=>true
);
wwv_flow_imp.component_end;
end;
/
