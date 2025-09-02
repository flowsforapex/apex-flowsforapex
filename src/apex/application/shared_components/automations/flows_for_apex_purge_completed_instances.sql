prompt --application/shared_components/automations/flows_for_apex_purge_completed_instances
begin
--   Manifest
--     AUTOMATION: Flows for APEX - Purge Completed Instances
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
 p_id=>wwv_flow_imp.id(14794647413752629)
,p_name=>'Flows for APEX - Purge Completed Instances'
,p_static_id=>'flows-for-apex-purge-completed-instances'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=DAILY;INTERVAL=1;BYMINUTE=0'
,p_polling_status=>'ACTIVE'
,p_result_type=>'ROWS'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_type=>'SQL'
,p_query_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select prcs_id, prcs_complete_ts, prcs_status',
'from flow_processes',
'where prcs_complete_ts <  SYSTIMESTAMP - NUMTODSINTERVAL (TO_NUMBER(flow_admin_api.get_config_value(',
'             p_config_key    => ''completed_prcs_purge_after_completion_days'',',
'             p_default_value => ''365''',
'           )) ',
'           , ''DAY'')',
'  and flow_admin_api.get_config_value(',
'             p_config_key    => ''completed_prcs_purging'',',
'             p_default_value => ''Y''',
'           ) = ''Y''',
'  and prcs_status in (''completed'', ''terminated'')'))
,p_include_rowid_column=>false
,p_pk_column_name=>'PRCS_ID'
,p_commit_each_row=>true
,p_error_handling_type=>'IGNORE'
,p_comment=>'Purges (deletes) process instances from the active Flows for APEX system, n days after the instance completed or was terminated.  Individual process purging is logged in the automation log.'
);
wwv_flow_imp_shared.create_automation_action(
 p_id=>wwv_flow_imp.id(14794958511752617)
,p_automation_id=>wwv_flow_imp.id(14794647413752629)
,p_name=>'Purge Instance'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_api_pkg.flow_delete (p_process_id => :PRCS_ID, p_comment => ''deleted by completed instance purge automation on &SYSDATE.'');',
'    apex_automation.log_info ( ''Process Instance deleted: ''||:PRCS_ID || ''( status : ''|| :PRCS_STATUS || '' - on '' || :PRCS_COMPLETE_TS ||'' )'');',
'end;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Error purging :PRCS_ID'
,p_stop_execution_on_error=>true
);
wwv_flow_imp.component_end;
end;
/
