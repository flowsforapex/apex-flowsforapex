create or replace package body flow_notif_pkg as

  PROCEDURE send_notification( p_process_id          in  flow_processes.prcs_id%type
                             , p_subflow_id          in  flow_subflows.sbfl_id%type
                             , p_template_ident      in  VARCHAR2
                             , p_substitution_values in  CLOB
                             , p_return_code         out NUMBER
                             ) is
    -- l_substitution_arr apex_t_varchar2
    
    begin
      NULL;
      -- Get substitutions for items...
      -- l_substitution_arr := APEX_STRING.split(.....).LAST
      -- if l_substitution_arr.COUNT > 0 THEN
      --   LOOP
      --     get_item_value(l_substitution_ar....);
      -- end loop;
      
      /*
        apex_mail.send (
                        p_to                 => email_address_of_user,
                        p_template_static_id => 'TEST_EMAIL_1',
                        p_placeholders       => '{' ||
                                '    "SUBFLOW_ID":' || apex_json.stringify( some_value ) ||
                                '   ,"USERNAME":'   || apex_json.stringify( some_value ) ||
                                '}'
                        );
      */
    end;



END flow_notif_pkg;