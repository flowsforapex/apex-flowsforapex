PROMPT >>  Update Current Version Configuration Parameter to current release

begin
  update flow_configuration
     set cfig_value = '26.1'
   where cfig_key = 'version_now_installed';
  commit;
end;
/
