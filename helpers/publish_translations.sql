PROMPT >> Publish Translated Applications
declare
  c_main_app_id number := apex_application_install.get_application_id;
begin
  -- Next call might fail if we do not set NUMERIC_CHARACTERS
  execute immediate q'[alter session set NLS_NUMERIC_CHARACTERS='.,']';

  for rec in ( select translated_app_language as lang
                 from apex_application_trans_map
                where primary_application_id = c_main_app_id
             )
  loop
    apex_lang.publish_application
    (
      p_application_id => c_main_app_id,
      p_language => rec.lang 
    );
  end loop;
  commit;
end;
/
