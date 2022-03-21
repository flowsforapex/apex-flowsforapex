PROMPT >> Inital System Configuration for new systems
begin
  insert into flow_configuration (cfig_key, cfig_value) values ('logging_level', 'standard');
  insert into flow_configuration (cfig_key, cfig_value) values ('logging_hide_userid', 'false');
  insert into flow_configuration (cfig_key, cfig_value) values ('logging_language','en');
  insert into flow_configuration (cfig_key, cfig_value) values ('engine_app_mode','production');
  -- put new systems into strict mode for step keys (migrated systems are in legacy mode)
  insert into flow_configuration (cfig_key, cfig_value) values ('duplicate_step_prevention','strict');
  insert into flow_configuration (cfig_key, cfig_value) values ('version_initial_installed','22.2');
  insert into flow_configuration (cfig_key, cfig_value) values ('version_now_installed','22.2');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_workspace', 'FLOWS4APEX');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_application', '100');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_pageid', '1');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_email_sender', '');
  insert into flow_configuration (cfig_key, cfig_value) values ('timer_max_cycles','1000');
  commit;
end;
/
