

PROMPT >> Add new configuration Keys

begin
  insert into flow_configuration (cfig_key, cfig_value) values ('default_application', '100');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_pageid', '1');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_username', 'FLOWS4APEX');
end;
/

PROMPT >>  Update Current Version Configuration Parameter to 22.2

begin
  update flow_configuration
     set cfig_value = '22.2'
   where cfig_key = 'version_now_installed';
end;
/