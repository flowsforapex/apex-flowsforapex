PROMPT >> Add new configuration Keys for creating an APEX Session (Issue #444)

begin
  insert into flow_configuration (cfig_key, cfig_value) values ('default_application', '100');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_pageid', '1');
  insert into flow_configuration (cfig_key, cfig_value) values ('default_username', 'FLOWS4APEX');
end;
/
