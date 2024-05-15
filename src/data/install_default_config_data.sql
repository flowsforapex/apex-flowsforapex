PROMPT >> Inital System Configuration for new systems
begin
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_level'                                 ,p_value => 'standard');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_hide_userid'                           ,p_value => 'false');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_language'                              ,p_value => 'en');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_retain_logs_after_prcs_completion_days',p_value => '60');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_archive_instance_summaries'            ,p_value => 'false');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_received_message_flow'                 ,p_value => 'true');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_retain_message_flow_days'              ,p_value => '5');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'stats_retain_daily_summaries_days'             ,p_value => '185');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'stats_retain_monthly_summaries_months'         ,p_value => '9');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'stats_retain_quarterly_summaries_months'       ,p_value => '60');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'engine_app_mode'                               ,p_value => 'production');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'duplicate_step_prevention'                     ,p_value => 'strict');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'version_initial_installed'                     ,p_value => '23.1');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'version_now_installed'                         ,p_value => '23.1');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_workspace'                             ,p_value => 'FLOWS4APEX');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_application'                           ,p_value => '100');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_pageid'                                ,p_value => '1');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_username'                              ,p_value => 'FLOWS4APEX');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_email_sender'                          ,p_value => '');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'timer_max_cycles'                              ,p_value => '1000');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'parser_log_enabled'                            ,p_value => 'false' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_rest_incoming_calls'                   ,p_value => 'Y' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_rest_incoming_calls_retain_days'       ,p_value => '60' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'rest_base'                                     ,p_value => null );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_archive_location'                      ,p_value => null );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_bpmn_location'                         ,p_value => null );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'licence_edition'                               ,p_value => 'community' );

  commit;
end;
/
