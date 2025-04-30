create or replace package body flow_modeler
as
  procedure render
  (
    p_plugin in            apex_plugin.t_plugin
  , p_region in            apex_plugin.t_region
  , p_param  in            apex_plugin.t_region_render_param
  , p_result in out nocopy apex_plugin.t_region_render_result
  )
  as
    l_region_id p_region.static_id%type := p_region.static_id;
    
    l_show_custom_extensions flow_configuration.cfig_value%type;
  begin
    apex_plugin_util.debug_region
    (
      p_plugin => p_plugin
    , p_region => p_region
    );
    
    -- get config value for plugin mode
    begin
        select cfig_value
        into l_show_custom_extensions
        from flow_configuration
        where cfig_key = 'modeler_show_custom_extensions';
    exception
        when no_data_found then
            l_show_custom_extensions := 'false';
    end;

    apex_javascript.add_onload_code
    (
      p_code =>
        'f4a.plugins.modeler.render({' ||
        apex_javascript.add_attribute
        (
          p_name      => 'regionId'
        , p_value     => l_region_id
        , p_add_comma => true
        ) ||
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
        apex_javascript.add_attribute
        (
          p_name      => 'showCustomExtensions'
        , p_value     => ( l_show_custom_extensions = 'true' )
        , p_add_comma => true
        ) ||
        apex_javascript.add_attribute
        (
          p_name      => 'themePluginClass'
        , p_value     => v('THEME_PLUGIN_CLASS')
        , p_add_comma => true
        ) ||
        '})'
    );
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
    
    flow_diagram.update_diagram
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
    l_result := '[{"label":"","value":""},';
    open c_applications;
    loop
      fetch c_applications into l_application;
      exit when c_applications%NOTFOUND;
      l_result :=
        l_result ||
        '{"label":"' || l_application.application_id || ' - ' || l_application.application_name ||
        '","value":"' || l_application.application_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_applications;


  procedure get_pages
  as
    l_result clob;
    l_application_id number := cast(apex_application.g_x02 as number default null on conversion error);
    cursor c_pages is select * from apex_application_pages where application_id = l_application_id order by page_id;
    l_page apex_application_pages%rowtype;
  begin
    l_result := '[{"label":"","value":""},';
    open c_pages;
    loop
      fetch c_pages into l_page;
      exit when c_pages%NOTFOUND;
      l_result :=
        l_result ||
        '{"label":"' || l_page.page_id || ' - ' || l_page.page_name ||
        '","value":"' || l_page.page_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_pages;


  procedure get_items
  as
    l_result clob;
    l_application_id number := cast(apex_application.g_x02 as number default null on conversion error);
    l_page_id number := cast(apex_application.g_x03 as number default null on conversion error);
    cursor c_items is select * from apex_application_page_items where application_id = l_application_id and page_id = l_page_id order by item_name;
    l_item apex_application_page_items%rowtype;
  begin
    l_result := '[{"label":"","value":""},';
    open c_items;
    loop
      fetch c_items into l_item;
      exit when c_items%NOTFOUND;
      l_result := l_result || '{"label":"' || l_item.item_name || '","value":"' || l_item.item_name || '"},';
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
    l_result := '[{"label":"","value":""},';
    open c_applications;
    loop
      fetch c_applications into l_application;
      exit when c_applications%NOTFOUND;
      l_result :=
        l_result ||
        '{"label":"' || l_application.application_id || ' - ' || l_application.application_name ||
        '","value":"' || l_application.application_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_applications_mail;


  procedure get_templates
  as
    l_result clob;
    l_application_id number := cast(apex_application.g_x02 as number default null on conversion error);
    cursor c_templates is select * from apex_appl_email_templates where application_id = l_application_id order by name;
    l_template apex_appl_email_templates%rowtype;
  begin
    l_result := '[{"label":"","value":""},';
    open c_templates;
    loop
      fetch c_templates into l_template;
      exit when c_templates%NOTFOUND;
      l_result := l_result || '{"label":"' || l_template.name || '","value":"' || l_template.static_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_templates;


  procedure get_json_placeholders
  as
    l_placeholders apex_t_varchar2;
    l_application_id number := cast(apex_application.g_x02 as number default null on conversion error);
  begin
    with email_content as (
      select subject || text_template || html_body || html_footer || html_header as d
        from apex_appl_email_templates
       where application_id = l_application_id 
         and static_id = apex_application.g_x03
    ),
    placeholders as (
      select distinct to_char(regexp_substr(ec.d, '\#(.*?)\#', 1, level, NULL, 1)) AS placeholder
        from email_content ec
     connect by level <= length(regexp_replace(ec.d, '\#(.*?)\#')) + 1
    ) 
    select p.placeholder bulk collect
      into l_placeholders
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


  procedure get_diagrams
  as
    l_result clob;
    
    cursor c_diagrams
        is
    select distinct dgrm_name
      from flow_diagrams dgrm
      join flow_objects objt
        on dgrm.dgrm_id = objt.objt_dgrm_id
       and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process
     where objt.objt_attributes."apex"."isCallable" = flow_constants_pkg.gc_vcbool_true
     order by dgrm_name;
    
    l_diagram flow_diagrams.dgrm_name%type;
  begin
    l_result := '[{"label":"","value":""},';
    open c_diagrams;
    loop
      fetch c_diagrams into l_diagram;
      exit when c_diagrams%NOTFOUND;
      l_result := l_result || '{"label":"' || l_diagram || '","value":"' || l_diagram || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_diagrams;


  procedure get_variable_mapping
  as
    l_result clob;

    l_dgrm_id flow_diagrams.dgrm_id%type;

    l_in_variables  clob;
    l_out_variables clob;
  begin
    l_dgrm_id := flow_diagram.get_current_diagram
      ( pi_dgrm_name           => apex_application.g_x02
      , pi_dgrm_calling_method => apex_application.g_x03
      , pi_dgrm_version        => apex_application.g_x04
      );

    select coalesce(objt.objt_attributes."apex"."inVariables", '""')
         , coalesce(objt.objt_attributes."apex"."outVariables", '""')
      into l_in_variables
         , l_out_variables
      from flow_objects objt
     where objt.objt_dgrm_id = l_dgrm_id
       and objt.objt_tag_name = flow_constants_pkg.gc_bpmn_process;

    l_result := '{"InVariables":' || l_in_variables ||',"OutVariables":' || l_out_variables || '}';
    htp.p(l_result);
  end get_variable_mapping;


  procedure get_usernames
  as
    l_result clob;
    cursor c_users is select * from apex_workspace_apex_users order by user_name;
    l_user apex_workspace_apex_users%rowtype;
  begin
    l_result := '[{"label":"","value":""},';
    open c_users;
    loop
      fetch c_users into l_user;
      exit when c_users%NOTFOUND;
      l_result := l_result || '{"label":"' || l_user.user_name || '","value":"' || l_user.user_name || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_usernames;


  procedure get_tasks
  as
    l_result clob;
    l_application_id number := cast(apex_application.g_x02 as number default null on conversion error);
    cursor c_task_defs is select * from apex_appl_taskdefs where application_id = l_application_id order by static_id;
    l_task_def apex_appl_taskdefs%rowtype;
  begin
    l_result := '[{"label":"","value":""},';
    open c_task_defs;
    loop
      fetch c_task_defs into l_task_def;
      exit when c_task_defs%NOTFOUND;
      l_result := l_result || '{"label":"' || l_task_def.name || '","value":"' || l_task_def.static_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_tasks;


  procedure get_json_parameters
  as
    l_placeholders apex_t_varchar2;
    l_application_id number := cast(apex_application.g_x02 as number default null on conversion error);
    
    cursor c_parameters
        is 
    select aatp.*
      from apex_appl_taskdef_params aatp
      join apex_appl_taskdefs aat
        on aatp.task_def_id = aat.task_def_id
     where aat.application_id = l_application_id
       and aat.static_id = apex_application.g_x03;
    
    l_parameter apex_appl_taskdef_params%rowtype;
  begin
    apex_json.open_array;
    open c_parameters;
    loop
      fetch c_parameters into l_parameter;
      exit when c_parameters%NOTFOUND;
      
      apex_json.open_object;
      
      apex_json.write
      (
        p_name  => 'STATIC_ID'
      , p_value => l_parameter.static_id
      , p_write_null => true
      );
      
      apex_json.write
      (
        p_name  => 'DATA_TYPE'
      , p_value => l_parameter.data_type
      , p_write_null => true
      );
      
      apex_json.write
      (
        p_name  => 'VALUE'
      , p_value => case l_parameter.static_id
                   when 'PROCESS_ID' then chr(38) || 'F4A$PROCESS_ID.'
                   when 'SUBFLOW_ID' then chr(38) || 'F4A$SUBFLOW_ID.'
                   when 'STEP_KEY' then chr(38) || 'F4A$STEP_KEY.'
                   else ''
                   end
      , p_write_null => true
      );
      
      apex_json.close_object;
    end loop;
    apex_json.close_array;
  end get_json_parameters;


  procedure get_form_templates
  as
    l_result clob;
    cursor c_form_templates is select * from flow_simple_form_templates order by sfte_name;
    l_form_template flow_simple_form_templates%rowtype;
  begin
    l_result := '[{"label":"","value":""},';
    open c_form_templates;
    loop
      fetch c_form_templates into l_form_template;
      exit when c_form_templates%NOTFOUND;
      l_result := l_result || '{"label":"' || l_form_template.sfte_name || '","value":"' || l_form_template.sfte_static_id || '"},';
    end loop;
    l_result := rtrim(l_result, ',') || ']';
    htp.p(l_result);
  end get_form_templates;


  procedure parse_code
  as
    v_cur     int;
    v_command varchar2(100);
    v_input   varchar2(4000);
    v_json    json_element_t;

    l_result  clob := '{"message":""}';
  begin
    if (apex_application.g_x02 is not null) then
      case apex_application.g_x03
      when 'sql' then
        v_command := upper(substr(ltrim(apex_application.g_x02), 1, instr(ltrim(apex_application.g_x02), ' ') - 1));
        if v_command in ( 'ALTER', 'COMPUTE', 'CREATE', 'DROP', 'GRANT', 'REVOKE') then
          l_result := '{"message":"Forbidden DDL statement","success":"false"}';
        elsif v_command in ( 'SELECT', 'INSERT', 'UPDATE', 'DELETE' ) then
          v_input := rtrim(apex_application.g_x02, ';');
          begin
            v_cur := dbms_sql.open_cursor();
            dbms_sql.parse(v_cur, v_input, dbms_sql.native);
            dbms_sql.close_cursor(v_cur);
            l_result := '{"message":"Validation successful","success":"true"}';
          exception
            when others then l_result := '{"message":"' || apex_escape.json(sqlerrm) || '","success":"false"}';
          end;
        else
          l_result := '{"message":"Unparsable SQL","success":"false"}';
        end if;
      when 'plsql' then
        case apex_application.g_x04
        when 'plsqlProcess' then
          v_input := 'begin' || apex_application.lf || apex_application.g_x02 || apex_application.lf || 'end;';
        when 'plsqlExpression' then
          v_input := 'declare dummy varchar2(4000) :='
                     || apex_application.lf || rtrim(apex_application.g_x02, ';') || ';' || apex_application.lf || 'begin null; end;';
        when 'plsqlRawExpression' then -- use the same snippet as non-raw
          v_input := 'declare dummy varchar2(4000) :='
                     || apex_application.lf || rtrim(apex_application.g_x02, ';') || ';' || apex_application.lf || 'begin null; end;';
        when 'plsqlExpressionBoolean' then
          v_input := 'declare dummy boolean :='
                     || apex_application.lf || rtrim(apex_application.g_x02, ';') || ';' || apex_application.lf || 'begin null; end;';
        when 'plsqlFunctionBody' then
          v_input := 'declare function dummy return varchar2 is begin'
                     || apex_application.lf || apex_application.g_x02 || apex_application.lf || 'end; begin null; end;';
        when 'plsqlRawFunctionBody' then -- use the same snippet as non-raw
          v_input := 'declare function dummy return varchar2 is begin'
                     || apex_application.lf || apex_application.g_x02 || apex_application.lf || 'end; begin null; end;';               
        when 'plsqlFunctionBodyBoolean' then
          v_input := 'declare function dummy return boolean is begin'
                     || apex_application.lf || apex_application.g_x02 || apex_application.lf || 'end; begin null; end;';
        end case;
        begin
          v_cur := dbms_sql.open_cursor();
          dbms_sql.parse(v_cur, v_input, dbms_sql.native);
          dbms_sql.close_cursor(v_cur);
          l_result := '{"message":"Validation successful","success":"true"}';
        exception
            when others then l_result := '{"message":"' || apex_escape.json(sqlerrm) || '","success":"false"}';
        end;
      when 'json' then
        begin
          v_json := json_element_t.parse(apex_application.g_x02);
          l_result := '{"message":"Validation successful","success":"true"}';
        exception
          when others then l_result := '{"message":"' || apex_escape.json(sqlerrm) || '","success":"false"}';
        end;
      end case;
    end if;
    htp.p(l_result);
  end parse_code;


  procedure ajax
  (
    p_plugin in            apex_plugin.t_plugin
  , p_region in            apex_plugin.t_region
  , p_param  in            apex_plugin.t_region_ajax_param
  , p_result in out nocopy apex_plugin.t_region_ajax_result
  )
  as
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
      when 'GET_JSON_PLACEHOLDERS' then get_json_placeholders;
      when 'GET_DIAGRAMS' then get_diagrams;
      when 'GET_VARIABLE_MAPPING' then get_variable_mapping;
      when 'GET_USERNAMES' then get_usernames;
      when 'GET_TASKS' then get_tasks;
      when 'GET_JSON_PARAMETERS' then get_json_parameters;
      when 'GET_FORM_TEMPLATES' then get_form_templates;
      else null;
    end case;
  end ajax;
end flow_modeler;
/
