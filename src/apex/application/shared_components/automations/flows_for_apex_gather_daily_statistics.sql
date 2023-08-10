prompt --application/shared_components/automations/flows_for_apex_gather_daily_statistics
begin
--   Manifest
--     AUTOMATION: Flows for APEX - Gather Daily Statistics
--   Manifest End
wwv_flow_api.component_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>2400405578329584
,p_default_application_id=>100
,p_default_id_offset=>0
,p_default_owner=>'FLOWS4APEX'
);
wwv_flow_api.create_automation(
 p_id=>wwv_flow_api.id(2133342671110884)
,p_name=>'Flows for APEX - Gather Daily Statistics'
,p_static_id=>'flows-for-apex-gather-daily-statistics'
,p_trigger_type=>'POLLING'
,p_polling_interval=>'FREQ=DAILY;INTERVAL=1;BYHOUR=0;BYMINUTE=12'
,p_polling_status=>'ACTIVE'
,p_result_type=>'ALWAYS'
,p_use_local_sync_table=>false
,p_include_rowid_column=>false
,p_commit_each_row=>false
,p_error_handling_type=>'IGNORE'
);
wwv_flow_api.create_automation_action(
 p_id=>wwv_flow_api.id(2133626467110885)
,p_automation_id=>wwv_flow_api.id(2133342671110884)
,p_name=>'Gather Daily Stats'
,p_execution_sequence=>10
,p_action_type=>'NATIVE_PLSQL'
,p_action_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    flow_admin_api.run_daily_stats;',
'end;'))
,p_action_clob_language=>'PLSQL'
,p_location=>'LOCAL'
,p_error_message=>'Error gathering daily Flows for APEX Stats'
,p_stop_execution_on_error=>true
);
wwv_flow_api.component_end;
end;
/
