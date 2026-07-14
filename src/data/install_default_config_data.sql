PROMPT >> Inital System Configuration for new systems
declare
  l_major number;
  l_minor number;
begin
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_default_level'                         ,p_value => '1');
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
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'version_initial_installed'                     ,p_value => '26.1');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'version_now_installed'                         ,p_value => '26.1');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_workspace'                             ,p_value => 'FLOWS4APEX');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_application'                           ,p_value => '100');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_pageid'                                ,p_value => '1');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_username'                              ,p_value => 'FLOWS4APEX');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_apex_business_admin'                   ,p_value => 'FLOWS4APEX');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'default_email_sender'                          ,p_value => '');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'timer_max_cycles'                              ,p_value => '1000');
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'parser_log_enabled'                            ,p_value => 'false' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_rest_incoming_calls'                   ,p_value => 'Y' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_rest_incoming_calls_retain_days'       ,p_value => '60' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'rest_base'                                     ,p_value => null );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_archive_location'                      ,p_value => null );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_bpmn_location'                         ,p_value => null );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_bpmn_enabled'                          ,p_value => 'false' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'logging_bpmn_retain_days'                       ,p_value => '60' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'license_edition'                               ,p_value => 'community' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'license_key'                                   ,p_value => '' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'licensed_to'                                   ,p_value => '' );
  flow_admin_api.set_config_value ( p_update_if_set => false, p_config_key => 'license_expiry_date'                           ,p_value => '' );

  select to_number(substr(version_no, 1, instr(version_no, '.', 1, 1) - 1))
       , to_number(substr(version_no, instr(version_no, '.', 1, 1) + 1, instr(version_no, '.', 1, 1) - 2))
    into l_major
       , l_minor
    from apex_release;

  flow_admin_api.set_config_value (
    p_update_if_set => false
  , p_config_key    => 'monaco_editor_version'
  , p_value         => case when l_major = 24 and l_minor = 1 then '0.47.0'
                            when l_major = 24 and l_minor = 2 then '0.51.0'
                            when l_major = 26 and l_minor = 1 then '0.55.0'
                            else null end
  );

  commit;
end;
/
