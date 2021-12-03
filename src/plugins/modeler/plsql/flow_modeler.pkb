create or replace package body flow_modeler
as
  function render
  (
    p_region              in  apex_plugin.t_region
  , p_plugin              in  apex_plugin.t_plugin
  , p_is_printer_friendly in  boolean
  )
    return apex_plugin.t_region_render_result
  as
    l_return apex_plugin.t_region_render_result;
  begin
    apex_plugin_util.debug_region
    (
      p_plugin => p_plugin
    , p_region => p_region
    );
    sys.htp.p( '<div id="' || p_region.static_id || '_modeler" class="flows4apex-modeler ' || v('THEME_PLUGIN_CLASS') || '">' );
    sys.htp.p( '<div id="' || p_region.static_id || '_canvas" class="canvas"></div>' );
    sys.htp.p( '<div id="' || p_region.static_id || '_properties" class="properties-panel-parent"></div>' );
    sys.htp.p( '<div id="' || p_region.static_id || '_dialogContainer" class="dialog-container"></div>' );
    sys.htp.p( '</div>' );
    apex_javascript.add_onload_code
    (
      p_code =>
        'apex.jQuery("#' || p_region.static_id || '").modeler({' ||
        apex_javascript.add_attribute
        (
          p_name      => 'ajaxIdentifier'
        , p_value     => apex_plugin.get_ajax_identifier
        , p_add_comma => true
        ) ||
        apex_javascript.add_attribute
        (
          p_name      => 'itemsToSubmit'
        , p_value     => apex_plugin_util.page_item_names_to_jquery( p_page_item_names => p_region.ajax_items_to_submit )
        , p_add_comma => true
        ) ||
        '})'
    );
    return l_return;
    
  end render;
  procedure load
  (
    p_region in apex_plugin.t_region
  , p_plugin in apex_plugin.t_plugin
  )
  as
    type t_col_position_tab is table of pls_integer index by varchar2(128);
    
    l_col_positions t_col_position_tab;
    l_context       apex_exec.t_context;
    l_id      number;
    l_content clob;
    l_found   boolean := false;
  begin
    apex_plugin_util.debug_region
    (
      p_plugin => p_plugin
    , p_region => p_region
    );
    l_context :=
      apex_exec.open_query_context
      (
        p_first_row => 1
      , p_max_rows  => 1
      );
    l_col_positions('id') :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => 'DGRM_ID'
      , p_is_required => true
      , p_data_type   => apex_exec.c_data_type_number
      );
    
    l_col_positions('content') :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => 'DGRM_CONTENT'
      , p_is_required => true
      , p_data_type   => apex_exec.c_data_type_clob
      );
    apex_json.open_object;
    apex_json.write
    (
      p_name  => 'success'
    , p_value => true
    );
    if apex_exec.next_row( p_context => l_context ) then
      l_found   := true;
      l_id      := apex_exec.get_number( p_context => l_context, p_column_idx => l_col_positions('id') );
      l_content := apex_exec.get_clob( p_context => l_context, p_column_idx => l_col_positions('content') );
    else
      l_found   := false;
    end if;
    apex_exec.close( p_context => l_context );
    apex_json.write
    (
      p_name  => 'found'
    , p_value => l_found
    );
    apex_json.open_object
    (
      p_name => 'data'
    );
    if l_found then
      apex_json.write
      (
        p_name  => 'id'
      , p_value => l_id
      );
      apex_json.write
      (
        p_name  => 'content'
      , p_value => l_content
      );
    else
      apex_json.write
      (
        p_name  => 'message'
      , p_value => flow_api_pkg.message( p_message_key => 'plugin-modeler-id-not-found', p_lang => apex_util.get_session_lang() )
      );
    end if;
    apex_json.close_all;
  exception
    when others then
      apex_exec.close( p_context => l_context );
      apex_json.open_object;
      apex_json.write
      (
        p_name  => 'success'
      , p_value => false
      );
      apex_json.write
      (
        p_name  => 'message'
      , p_value => flow_api_pkg.message( p_message_key => 'plugin-unexpected-error', p_lang => apex_util.get_session_lang() )
      );
      apex_json.close_all;
  end load;
  procedure save
  (
    p_region in apex_plugin.t_region
  , p_plugin in apex_plugin.t_plugin
  )
  as
    l_str_tab apex_t_varchar2 := apex_t_varchar2();
    l_clob    clob;
    l_values  apex_json.t_values;
    l_id      number;
    l_content clob;
  begin
    for i in 1..apex_application.g_json.count loop
      l_str_tab.extend();
      l_str_tab(i) := apex_application.g_json(i);
    end loop;
    l_clob := apex_string.join_clob( p_table => l_str_tab, p_sep => null );
    apex_json.parse
    (
      p_values => l_values
    , p_source => l_clob
    );
    l_id      := apex_json.get_number( p_values => l_values, p_path => 'regions[1].data.id' );
    l_content := apex_json.get_clob( p_values => l_values, p_path => 'regions[1].data.content');
    flow_bpmn_parser_pkg.update_diagram
    (
      pi_dgrm_id      => l_id
    , pi_dgrm_content => l_content
    );
    apex_json.open_object;
    apex_json.write( p_name => 'success', p_value => true );
    apex_json.write
      (
        p_name  => 'message'
      , p_value => flow_api_pkg.message( p_message_key => 'plugin-diagram-saved', p_lang => apex_util.get_session_lang() )
      );
    apex_json.close_all;
  exception
    when others then
      apex_json.open_object;
      apex_json.write( p_name => 'success', p_value => false );
      apex_json.write
      (
        p_name  => 'message'
      , p_value => flow_api_pkg.message( p_message_key => 'plugin-diagram-not-parsable', p_lang => apex_util.get_session_lang() )
      );
      apex_json.close_all;
  end save;
  procedure get_applications
  as
    l_result clob;
    cursor c_applications is select * from apex_applications order by application_name;
    l_application apex_applications%rowtype;
  begin
    l_result := '[';
    open c_applications;
    loop
        fetch c_applications into l_application;
        exit when c_applications%NOTFOUND;
        l_result := l_result || '{"name":"' || l_application.application_name || '","value":"' || l_application.application_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_applications;
  procedure get_pages
  as
    l_result clob;
    cursor c_pages is select * from apex_application_pages where application_id = apex_application.g_x02 order by page_name;
    l_page apex_application_pages%rowtype;
  begin
    l_result := '[';
    open c_pages;
    loop
        fetch c_pages into l_page;
        exit when c_pages%NOTFOUND;
        l_result := l_result || '{"name":"' || l_page.page_name || '","value":"' || l_page.page_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_pages;
  procedure get_items
  as
    l_result clob;
    cursor c_items is select * from apex_application_page_items where application_id = apex_application.g_x02 and page_id = apex_application.g_x03 order by item_name;
    l_item apex_application_page_items%rowtype;
  begin
    l_result := '[';
    open c_items;
    loop
        fetch c_items into l_item;
        exit when c_items%NOTFOUND;
        l_result := l_result || '{"name":"' || l_item.item_name || '","value":"' || l_item.item_name || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_items;
  procedure get_applications_mail
  as
    l_result clob;
    cursor c_applications is select * from apex_applications where application_id in (select application_id from apex_appl_email_templates) order by application_name;
    l_application apex_applications%rowtype;
  begin
    l_result := '[{"name":"","value":""},';
    open c_applications;
    loop
        fetch c_applications into l_application;
        exit when c_applications%NOTFOUND;
        l_result := l_result || '{"name":"' || l_application.application_name || '","value":"' || l_application.application_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_applications_mail;
  procedure get_templates
  as
    l_result clob;
    cursor c_templates is select * from apex_appl_email_templates where application_id = apex_application.g_x02 order by name;
    l_template apex_appl_email_templates%rowtype;
  begin
    l_result := '[{"name":"","value":""},';
    open c_templates;
    loop
        fetch c_templates into l_template;
        exit when c_templates%NOTFOUND;
        l_result := l_result || '{"name":"' || l_template.name || '","value":"' || l_template.static_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_templates;
  procedure get_json_placeholders
  as
    l_placeholders apex_t_varchar2;
  begin
    with email_content as (
      select subject||text_template||html_body||html_footer||html_header||html_template as d
      from apex_appl_email_templates
      where application_id = apex_application.g_x02 
      and static_id = apex_application.g_x03
   ),
   placeholders as (
      select distinct to_char(regexp_substr(ec.d, '\#(.*?)\#', 1, level, NULL, 1)) AS placeholder
      from email_content ec
      connect by level <= length(regexp_replace(ec.d, '\#(.*?)\#')) + 1
   ) 
   select p.placeholder
   bulk collect into l_placeholders
   from placeholders p
   where p.placeholder is not null
   order by p.placeholder;

   apex_json.open_object;
   for i in 1..l_placeholders.count()
   loop
      apex_json.write(p_name => l_placeholders(i), p_value => '', p_write_null => true);
   end loop;
   apex_json.close_object;
  end get_json_placeholders;
  procedure parse_code
  as
    v_cur int;
    v_command varchar2(100);
    v_input varchar2(4000);
    l_result clob := '{"message":""}';
  begin
    if (apex_application.g_x02 is not null) then
        case apex_application.g_x03
        when 'sql' then
            v_command := upper(substr(apex_application.g_x02, 1,instr(apex_application.g_x02,' ') - 1));
            if v_command in ( 'ALTER', 'COMPUTE', 'CREATE', 'DROP', 'GRANT', 'REVOKE') then
                l_result := '{"message":"Forbidden DDL statement"}';
            elsif v_command in ( 'SELECT', 'INSERT', 'UPDATE', 'DELETE' ) then
                v_input := rtrim(apex_application.g_x02, ';');
                begin
                    v_cur := dbms_sql.open_cursor();
                    dbms_sql.parse(v_cur, v_input, dbms_sql.native);
                    dbms_sql.close_cursor(v_cur);
                    l_result := '{"message":"Validation successful"}';
                exception
                    when others then l_result := '{"message":"' || apex_escape.json(sqlerrm) || '"}';
                end;
            else
                l_result := '{"message":"Unparsable SQL"}';
            end if;
        when 'plsql' then
            v_input := 'begin' || apex_application.lf || apex_application.g_x02 || apex_application.lf || 'end;';
            begin
                    v_cur := dbms_sql.open_cursor();
                    dbms_sql.parse(v_cur, v_input, dbms_sql.native);
                    dbms_sql.close_cursor(v_cur);
                    l_result := '{"message":"Validation successful"}';
                exception
                    when others then l_result := '{"message":"' || apex_escape.json(sqlerrm) || '"}';
                end;
        end case;
    end if;
    htp.p(l_result);
  end parse_code;
  function ajax
  (
    p_region              in  apex_plugin.t_region
  , p_plugin              in  apex_plugin.t_plugin
  )
    return apex_plugin.t_region_ajax_result
  as
    l_return apex_plugin.t_region_ajax_result;
  begin
    case upper(apex_application.g_x01)
      when 'LOAD' then load( p_region => p_region, p_plugin => p_plugin );
      when 'SAVE' then save( p_region => p_region, p_plugin => p_plugin );
      when 'GET_APPLICATIONS' then get_applications;
      when 'GET_PAGES' then get_pages;
      when 'GET_ITEMS' then get_items;
      when 'GET_APPLICATIONS_MAIL' then get_applications_mail;
      when 'GET_TEMPLATES' then get_templates;
      when 'PARSE_CODE' then parse_code;
      else null;
    end case;
    return l_return;
  end ajax;
end flow_modeler;
/
