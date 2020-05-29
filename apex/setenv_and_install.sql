begin
  -- change this accordingly
  apex_application_install.set_workspace('MYWORKSPACE');
  apex_application_install.generate_application_id;
  apex_application_install.generate_offset;
  apex_application_install.set_schema('MYWORKSPACESCHEMA');
  apex_application_install.set_application_alias('MYUNIQUEALIAS');
end;
/

@install.sql
