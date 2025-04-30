PROMPT >>  Update Current Version Configuration Parameter to 25.1

begin
  update flow_configuration
     set cfig_value = '25.1'
   where cfig_key = 'version_now_installed';
  commit;
end;
/
