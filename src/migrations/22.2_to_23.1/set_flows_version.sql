PROMPT >>  Update Current Version Configuration Parameter to 23.1

begin
  update flow_configuration
     set cfig_value = '23.1'
   where cfig_key = 'version_now_installed';
  commit;
end;
/
