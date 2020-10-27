CREATE OR REPLACE PACKAGE BODY flow_notif_pkg AS
   PROCEDURE send_notification (
      p_process_id       IN   flow_processes.prcs_id%TYPE,
      p_subflow_id       IN   flow_subflows.sbfl_id%TYPE,
      p_template_ident   IN   apex_appl_email_templates.static_id%TYPE,
      p_modeller_values  IN   CLOB,
      p_return_code      OUT  NUMBER
   ) IS
      l_templ_content_all  CLOB;
      l_templ_tags_all     apex_t_varchar2;
      l_templ_tags_temp    apex_t_varchar2;
      --l_modeller_tag_values  apex_t_varchar2; -- TBD...
      TYPE l_values_tab IS
         TABLE OF VARCHAR2(32767) INDEX BY VARCHAR2(4000);
      l_tab_values         l_values_tab := l_values_tab();
      l_temp_str           VARCHAR2(4000);
      l_temp_val           VARCHAR2(32767);
      l_process_values     apex_t_varchar2;
      CURSOR c1 IS
         WITH clobs AS (
            SELECT html_header,
                   html_body,
                   html_footer
              FROM APEX_APPL_EMAIL_TEMPLATES
             WHERE static_id = p_template_ident
         )
         SELECT *
           FROM clobs UNPIVOT ( colvalue
            FOR col
         IN ( html_header,
              html_body,
              html_footer ) );
   BEGIN
      -- Get template fields
      FOR c1_row IN c1 LOOP
         DBMS_LOB.APPEND(l_templ_content_all, c1_row.colvalue);
      END LOOP;
      -- Extract tags
      l_templ_tags_all   := apex_string.grep(
         p_str            => l_templ_content_all,
         p_pattern        => '\#(.*?)\#',
         p_modifier       => 'i',
         p_subexpression  => '1'
      );

      -- Deduplicate
      l_templ_tags_temp  := l_templ_tags_all;
      l_templ_tags_all   := l_templ_tags_all MULTISET UNION DISTINCT l_templ_tags_temp;
      -- Get process values
      FOR i IN 1..l_templ_tags_all.COUNT
      LOOP
         SELECT prov_var_name,
                CASE prov_var_type
                   WHEN 'VC2'   THEN
                      prov_var_vc2
                   WHEN 'NUM'   THEN
                      to_char(prov_var_num)
                   WHEN 'DATE'  THEN
                      to_char(prov_var_date, 'yyyy-mm-dd hh24:mi:ss')
                   WHEN 'CLOB'  THEN
                      dbms_lob.substr(prov_Var_clob, 32767)
                END val
           INTO l_temp_str,
                l_temp_val
           FROM flow_process_variables
          WHERE prov_var_name = l_templ_tags_all(i);
          -- Fill the collection
         l_tab_values(l_temp_str) := l_temp_val;
      END LOOP;
      -- Prepare p_placeholders
      NULL; -- TBD...
      -- ?OPTIONAL? Get substitutions for modeller values -- TBD...
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
   END;
END flow_notif_pkg;