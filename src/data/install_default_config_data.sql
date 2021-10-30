insert into flow_configuration (cfig_key, cfig_value) values ('logging_level', 'standard');
insert into flow_configuration (cfig_key, cfig_value) values ('logging_hide_userid', 'false');
insert into flow_configuration (cfig_key, cfig_value) values ('logging_language','en');
insert into flow_configuration (cfig_key, cfig_value) values ('engine_app_mode','production');
-- put new systems into strict mode for step keys (migrated systems are in legacy mode)
insert into flow_configuration (cfig_key, cfig_value) values ('duplicate_step_prevention','strict');

