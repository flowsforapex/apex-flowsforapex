create or replace package body flow_notif_pkg as

  PROCEDURE send_notification( p_process_id          in  flow_processes.prcs_id%type
                             , p_subflow_id          in  flow_subflows.sbfl_id%type
                             , p_template_ident      in  VARCHAR2
                             , p_substitution_values in  CLOB
                             , p_return_code         out NUMBER
                             ) is
    -- l_substitution_arr apex_t_varchar2
    l_header        clob;
    l_body          clob;
    l_footer        clob;
    l_templ_tags_h  apex_t_varchar2;
    l_templ_tags_b  apex_t_varchar2;
    l_templ_tags_f  apex_t_varchar2;
    begin
      -- Get template values
      select html_header,
             html_body,
             html_footer
      into l_header,
           l_body,
           l_footer
      from APEX_APPL_EMAIL_TEMPLATES
      where static_id = p_template_ident;
      
     l_templ_tags_h := apex_string.grep (
                           p_str => l_header,
                           p_pattern => '\#(.*?)\#',									 
                           p_modifier => 'i',
                           p_subexpression => '1'
                           );
      
      
      -- ?OPTIONAL? --
      -- Get substitutions for items...
      -- l_substitution_arr := APEX_STRING.split(.....).LAST
      -- if l_substitution_arr.COUNT > 0 THEN
      --   LOOP
      --     get_item_value(l_substitution_ar....);
      -- end loop;
      -- END ?OPTIONAL? --
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