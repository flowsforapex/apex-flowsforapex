PROMPT >>  Update Current Version Configuration Parameter to 24.1

begin
  update flow_configuration
     set cfig_value = '24.1'
   where cfig_key = 'version_now_installed';
  commit;
end;
/
