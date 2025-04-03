create or replace package body flow_viewer
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
  begin

    apex_plugin_util.debug_region
    (
      p_plugin => p_plugin
    , p_region => p_region
    );

    apex_javascript.add_onload_code
    (
      p_code => 
        'f4a.plugins.viewer.render({' ||
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
          p_name      => 'noDataFoundMessage'
        , p_value     => p_region.no_data_found_message
        , p_add_comma => true
        ) ||
        apex_javascript.add_attribute
        (
          p_name      => 'refreshOnLoad'
        , p_value     => ( p_region.attributes.get_varchar2('refresh_on_load') = 'Y' )
        , p_add_comma => true
        ) ||
        apex_javascript.add_attribute
        (
          p_name      => 'showToolbar'
        , p_value     => ( p_region.attributes.get_varchar2('show_toolbar') = 'Y' )
        , p_add_comma => true
        ) ||
        apex_javascript.add_attribute
        (
          p_name      => 'enableMousewheelZoom'
        , p_value     => ( p_region.attributes.get_varchar2('enable_mousewheel_zoom') = 'Y' )
        , p_add_comma => true
        ) ||
        apex_javascript.add_attribute
        (
          p_name      => 'useBPMNcolors'
        , p_value     => ( p_region.attributes.get_varchar2('use_bpmn_colors') = 'Y' )
        , p_add_comma => true
        ) ||
        apex_javascript.add_attribute
        (
          p_name      => 'themePluginClass'
        , p_value     => v('THEME_PLUGIN_CLASS')
        , p_add_comma => true
        ) ||
        '"config":' || p_region.init_javascript_code || '({})' ||
    '})'
    );
  end render;

  procedure ajax
  (
    p_plugin in            apex_plugin.t_plugin
  , p_region in            apex_plugin.t_region
  , p_param  in            apex_plugin.t_region_ajax_param
  , p_result in out nocopy apex_plugin.t_region_ajax_result
  )
  as
    l_context                    apex_exec.t_context;
    
    l_diagram_col_idx            pls_integer;
    l_dgrm_id_col_idx            pls_integer;
    
    l_highlighting_data_col_idx  pls_integer;
    l_call_activity_data_col_idx pls_integer;
    l_iteration_data_col_idx     pls_integer;
    l_user_task_data_col_idx     pls_integer;
    l_badges_data_col_idx        pls_integer;

    e_json_parse exception;
    pragma exception_init (e_json_parse, -40834);

    l_result   json_object_t := json_object_t();
    l_data     json_array_t  := json_array_t();
    l_data_row json_object_t := json_object_t();
  begin
    apex_plugin_util.debug_region
    (
      p_plugin => p_plugin
    , p_region => p_region
    );

    l_context :=
      apex_exec.open_query_context
      (
        p_total_row_count => true
      );

    l_diagram_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attributes.get_varchar2('diagram_xml')
      , p_is_required => true
      , p_data_type   => apex_exec.c_data_type_clob
      );

    l_dgrm_id_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attributes.get_varchar2('diagram_identifier')
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_number
      );

    l_highlighting_data_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attributes.get_varchar2('highlighting_data')
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_clob
      );

    l_call_activity_data_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attributes.get_varchar2('call_activity_data')
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_clob
      );

    l_iteration_data_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attributes.get_varchar2('iteration_data')
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_clob
      );
    
    l_user_task_data_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attributes.get_varchar2('user_task_data')
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_clob
      );
    
    l_badges_data_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attributes.get_varchar2('badges_data')
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_clob
      );

    -- apex_json.open_object;

    if apex_exec.get_total_row_count( p_context => l_context ) > 0 then

      -- multiple rows found but no call activity data passed
      if apex_exec.get_total_row_count( p_context => l_context ) > 1 and l_call_activity_data_col_idx is null then

        l_result.put( 'found', false );

        l_result.put( 'message', flow_api_pkg.message( p_message_key => 'plugin-multiple-rows', p_lang => apex_util.get_session_lang() ) );

      else

        l_result.put( 'found', true );

        while apex_exec.next_row( p_context => l_context ) loop
          
          l_data_row.put( 'xml', apex_exec.get_clob( p_context => l_context, p_column_idx => l_diagram_col_idx ) );

          if l_dgrm_id_col_idx is not null then
            l_data_row.put( 'diagramIdentifier', apex_exec.get_number( p_context => l_context, p_column_idx => l_dgrm_id_col_idx ) );
          end if;

          if l_highlighting_data_col_idx is not null then
            begin
                l_data_row.put( 'highlightingData', json_object_t.parse( apex_exec.get_clob( p_context => l_context, p_column_idx => l_highlighting_data_col_idx ) ) );
            exception
                when e_json_parse then
                    l_data_row.put( 'highlightingData', json_object_t() );
            end;
          end if;

          if l_call_activity_data_col_idx is not null then
            begin
                l_data_row.put( 'callActivityData', json_object_t.parse( apex_exec.get_clob( p_context => l_context, p_column_idx => l_call_activity_data_col_idx ) ) );
            exception
                when e_json_parse then
                    l_data_row.put( 'callActivityData', json_object_t() );
            end;
          end if;
              
          if l_iteration_data_col_idx is not null then
            begin
                l_data_row.put( 'iterationData', json_object_t.parse( apex_exec.get_clob( p_context => l_context, p_column_idx => l_iteration_data_col_idx ) ) );
            exception
                when e_json_parse then
                    l_data_row.put( 'iterationData', json_object_t() );
            end;
          end if;
              
          if l_user_task_data_col_idx is not null then
            begin
                l_data_row.put( 'userTaskData', json_object_t.parse( apex_exec.get_clob( p_context => l_context, p_column_idx => l_user_task_data_col_idx ) ) );
            exception
                when e_json_parse then
                    l_data_row.put( 'userTaskData', json_object_t() );
            end;
          end if;
              
          if l_badges_data_col_idx is not null then
            begin
                l_data_row.put( 'badgesData', json_object_t.parse( apex_exec.get_clob( p_context => l_context, p_column_idx => l_badges_data_col_idx ) ) );
            exception
                when e_json_parse then
                    l_data_row.put( 'badgesData', json_object_t() );
            end;
          end if;

          l_data.append( l_data_row );
        
        end loop;

        l_result.put( 'data', l_data );

      end if;

    else
      
      l_result.put( 'found', false );
    
    end if;

    htp.p(l_result.to_clob());

  end ajax;

end flow_viewer;
/
