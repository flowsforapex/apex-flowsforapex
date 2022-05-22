PROMPT >>  Update Current Version Configuration Parameter to 22.2

begin
  update flow_configuration
     set cfig_value = '22.2'
   where cfig_key = 'version_now_installed';
end;
/
