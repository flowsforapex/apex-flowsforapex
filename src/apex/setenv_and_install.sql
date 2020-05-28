begin
  apex_application_install.set_workspace('TEST2');
  apex_application_install.generate_application_id;
  apex_application_install.generate_offset;
  apex_application_install.set_schema('TEST2');
  apex_application_install.set_application_alias('FLOWSFORAPEXTEST2');
end;
/

@install.sql