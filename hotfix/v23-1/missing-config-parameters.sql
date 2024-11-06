PROMPT >> Add missing configuration parameters for migration
begin
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_retain_logs_after_prcs_completion_days',p_value => '60');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_archive_instance_summaries'            ,p_value => 'false');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_received_message_flow'                 ,p_value => 'true');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_retain_message_flow_days'              ,p_value => '5');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'stats_retain_daily_summaries_days'             ,p_value => '185');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'stats_retain_monthly_summaries_months'         ,p_value => '9');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'stats_retain_quarterly_summaries_months'       ,p_value => '60');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_archive_location'                      ,p_value => null );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_bpmn_location'                         ,p_value => null );
  commit;
end;
/
