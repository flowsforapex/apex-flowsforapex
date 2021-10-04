create or replace PACKAGE BODY flow_notif_pkg AS


    FUNCTION get_transf_value (
        in_value VARCHAR2
    ) RETURN CLOB IS
    BEGIN
        IF instr(in_value, '&') = 1 THEN
            RETURN to_clob(v(''''
                             || translate(in_value, '&.', '')
                             || ''''));

        ELSE
            RETURN to_clob(in_value);
        END IF;
    END get_transf_value;

    PROCEDURE send_notification (
        p_process_id        IN    flow_processes.prcs_id%TYPE,
      --p_object_id_modif        IN       --- to get mail_to
        p_template_ident    IN    apex_appl_email_templates.static_id%TYPE, -- Do we need this?
        p_modeller_values   IN    CLOB,
        p_return_code       OUT   NUMBER
    ) IS

        l_templ_content_all   CLOB;
        l_templ_tags_all      apex_t_varchar2;
        l_templ_tags_temp     apex_t_varchar2;
        l_temp_str            VARCHAR2(4000);
        l_temp_val            CLOB; -- Dependent by var. table but unlimited in email template, what to do?
        l_process_values      apex_t_varchar2;
        l_p_placeholders      CLOB;
        l_first_record        NUMBER := 1;
        CURSOR c1 IS
        WITH clobs AS (
            SELECT
                to_clob(subject) subject,
                html_header,
                html_body,
                html_footer
            FROM
                apex_appl_email_templates
            WHERE
                static_id = p_template_ident
        )
        SELECT
            colvalue
        FROM
            clobs UNPIVOT ( colvalue
                FOR col
            IN ( subject,
                 html_header,
                 html_body,
                 html_footer ) );

    BEGIN
      -- Optional create session
        IF apex_custom_auth.is_session_valid THEN
            NULL;
        ELSE
            apex_session.create_session(p_app_id => 984337, p_page_id => 1, p_username => 'FFA');
        END IF;
      -- Get template fields

        sys.dbms_lob.createtemporary(l_templ_content_all, true);
        FOR c1_row IN c1 LOOP dbms_lob.append(l_templ_content_all, c1_row.colvalue);
        END LOOP;
      -- Extract tags

        l_templ_tags_all := apex_string.grep(p_str => l_templ_content_all, p_pattern => '\#(.*?)\#', p_modifier => 'i', p_subexpression

        => '1');

      -- Deduplicate

        l_templ_tags_temp := l_templ_tags_all;
        l_templ_tags_all := l_templ_tags_all MULTISET UNION DISTINCT l_templ_tags_temp;
      -- Get process values
        sys.dbms_lob.createtemporary(l_p_placeholders, true);
        FOR i IN 1..l_templ_tags_all.count LOOP BEGIN
            SELECT
                prov_var_name,
                CASE prov_var_type
                    WHEN 'VC2'    THEN
                        get_transf_value(prov_var_vc2)
                    WHEN 'NUM'    THEN
                        to_clob(prov_var_num)
                    WHEN 'DATE'   THEN
                        to_clob(TO_CHAR(prov_var_date, v('APP_NLS_DATE_FORMAT')))
                    WHEN 'CLOB'   THEN
                        prov_var_clob
                END val
            INTO
                l_temp_str,
                l_temp_val
            FROM
                flow_process_variables
            WHERE
                prov_var_name = l_templ_tags_all(i);
         -- Prepare placeholders

            sys.dbms_lob.append(l_p_placeholders,
                CASE i
                    WHEN l_first_record THEN
                        '{'
                    ELSE ', '
                END
                || apex_json.stringify(l_temp_str)
                || ':'
                || apex_json.stringify(l_temp_val));

        EXCEPTION
            WHEN no_data_found THEN
                l_first_record := i + 1;
                l_templ_tags_all.DELETE(i);
        END;
        END LOOP;

        sys.dbms_lob.append(l_p_placeholders, '}');
      
        apex_mail.send(p_to => 'fs@frasit.com'/*Parameter TBD*/, p_template_static_id => p_template_ident, p_placeholders => l_p_placeholders);

        sys.dbms_lob.freetemporary(l_templ_content_all);
        sys.dbms_lob.freetemporary(l_p_placeholders);
        p_return_code := 0;
    EXCEPTION
        WHEN OTHERS THEN
            sys.dbms_lob.freetemporary(l_templ_content_all);
            sys.dbms_lob.freetemporary(l_p_placeholders);
            p_return_code := 1;
            RAISE;
    END send_notification;

END flow_notif_pkg;
/
