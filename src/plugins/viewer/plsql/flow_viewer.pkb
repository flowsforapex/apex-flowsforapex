create or replace package body flow_viewer
as

  /* Legacy plugin functions pre-25.1 */

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
    sys.htp.p( '<div id="' || p_region.static_id || '_viewer" class="flows4apex-viewer ' || v('THEME_PLUGIN_CLASS') || '">' );
    sys.htp.p( '<div id="' || p_region.static_id || '_canvas" class="canvas" style="display: none;"></div>' );
    sys.htp.p( '<span id="' || p_region.static_id || '_ndf" class="nodatafound" style="display: none;">' || coalesce(p_region.no_data_found_message, 'No data found.') || '</span>' );
    sys.htp.p( '</div>' );
    apex_javascript.add_onload_code
    (
      p_code => 'apex.jQuery("#' || p_region.static_id || '").viewer({' ||
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
                  , p_value     => ( p_region.attribute_08 = 'Y' )
                  , p_add_comma => true
                  ) ||
                  apex_javascript.add_attribute
                  (
                    p_name      => 'showToolbar'
                  , p_value     => ( p_region.attribute_11 = 'Y' )
                  , p_add_comma => true
                  ) ||
                  apex_javascript.add_attribute
                  (
                    p_name      => 'addHighlighting'
                  , p_value     => ( p_region.attribute_09 = 'Y' )
                  , p_add_comma => true
                  ) ||    
                  apex_javascript.add_attribute
                  (
                    p_name      => 'enableCallActivities'
                  , p_value     => ( p_region.attribute_14 = 'Y' )
                  , p_add_comma => true
                  ) ||  
                  apex_javascript.add_attribute
                  (
                    p_name      => 'enableMousewheelZoom'
                  , p_value     => ( p_region.attribute_15 = 'Y' )
                  , p_add_comma => true
                  ) ||
                  apex_javascript.add_attribute
                  (
                    p_name      => 'useBPMNcolors'
                  , p_value     => ( p_region.attribute_16 = 'Y' )
                  , p_add_comma => true
                  ) ||
                  '"config":' || p_region.init_javascript_code || '({})' ||
                '})'
    );

    return l_return;
  end render;

  function ajax
  (
    p_region              in  apex_plugin.t_region
  , p_plugin              in  apex_plugin.t_plugin
  )
    return apex_plugin.t_region_ajax_result
  as

    l_context                  apex_exec.t_context;
    l_diagram_col_idx          pls_integer;
    l_current_col_idx          pls_integer;
    l_completed_col_idx        pls_integer;
    l_error_col_idx            pls_integer;
    l_dgrm_id_col_idx          pls_integer;
    l_calling_dgrm_col_idx     pls_integer;
    l_calling_objt_col_idx     pls_integer;
    l_breadcrumb_col_idx       pls_integer;
    l_sub_prcs_insight_col_idx pls_integer;
    l_iteration_data_col_idx   pls_integer;
    l_user_task_urls_col_idx   pls_integer;

    l_current_nodes   apex_t_varchar2;
    l_completed_nodes apex_t_varchar2;
    l_error_nodes     apex_t_varchar2;

    l_return apex_plugin.t_region_ajax_result;
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
      , p_column_name => p_region.attribute_01
      , p_is_required => true
      , p_data_type   => apex_exec.c_data_type_clob
      );

    l_current_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_02
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_varchar2
      );

    l_completed_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_04
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_varchar2
      );

    l_error_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_06
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_varchar2
      );

    l_dgrm_id_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_03
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_number
      );

    l_calling_dgrm_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_05 
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_number
      );

    l_calling_objt_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_07 
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_varchar2
      );
    l_breadcrumb_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_12 
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_varchar2
      );
    l_sub_prcs_insight_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_13
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_number
      );
    l_iteration_data_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_17
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_clob
      );
    l_user_task_urls_col_idx :=
      apex_exec.get_column_position
      (
        p_context     => l_context
      , p_column_name => p_region.attribute_18
      , p_is_required => false
      , p_data_type   => apex_exec.c_data_type_clob
      );

    apex_json.open_object;

    if apex_exec.get_total_row_count( p_context => l_context ) > 0 then

      -- multiple rows found but call activity option disabled
      if apex_exec.get_total_row_count( p_context => l_context ) > 1 and p_region.attribute_14 = 'N' then

        apex_json.write
        (
          p_name  => 'found'
        , p_value => false
        );

        apex_json.write
        (
          p_name  => 'message'
        , p_value => flow_api_pkg.message( p_message_key => 'plugin-multiple-rows', p_lang => apex_util.get_session_lang() )
        );

      else

        apex_json.write
        (
          p_name  => 'found'
        , p_value => true
        );

        apex_json.open_array
        (
          p_name => 'data'
        );

        while apex_exec.next_row( p_context => l_context ) loop
          apex_json.open_object;

          apex_json.write
          (
            p_name  => 'diagram'
          , p_value => apex_exec.get_clob( p_context => l_context, p_column_idx => l_diagram_col_idx )
          );

          if l_dgrm_id_col_idx is not null then
              apex_json.write
              (
                p_name  => 'diagramIdentifier'
              , p_value => apex_exec.get_number( p_context => l_context, p_column_idx => l_dgrm_id_col_idx )
              );
          end if;

          if l_calling_dgrm_col_idx is not null then
              apex_json.write
              (
                p_name  => 'callingDiagramIdentifier'
              , p_value => apex_exec.get_number( p_context => l_context, p_column_idx => l_calling_dgrm_col_idx )
              );
          end if;

          if l_calling_objt_col_idx is not null then
              apex_json.write
              (
                p_name  => 'callingObjectId'
              , p_value => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_calling_objt_col_idx )
              );
          end if;

          if l_breadcrumb_col_idx is not null then
              apex_json.write
              (
                p_name  => 'breadcrumb'
              , p_value => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_breadcrumb_col_idx )
              );
          end if;

          if l_sub_prcs_insight_col_idx is not null then
              apex_json.write
              (
                p_name  => 'insight'
              , p_value => apex_exec.get_number( p_context => l_context, p_column_idx => l_sub_prcs_insight_col_idx )
              );
          end if;

          if l_iteration_data_col_idx is not null then
              apex_json.write
              (
                p_name  => 'iterationData'
              , p_value => apex_exec.get_clob( p_context => l_context, p_column_idx => l_iteration_data_col_idx )
              );
          end if;

          if l_user_task_urls_col_idx is not null then
              apex_json.write
              (
                p_name  => 'userTaskData'
              , p_value => apex_exec.get_clob( p_context => l_context, p_column_idx => l_user_task_urls_col_idx )
              );
          end if;

          apex_json.open_array
          (
            p_name => 'current'
          );

          if l_current_col_idx is not null then
            l_current_nodes :=
              apex_string.split
              (
                p_str => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_current_col_idx )
              , p_sep => ':'
              );

            for i in 1..l_current_nodes.count loop
              apex_json.write( p_value => l_current_nodes(i) );
            end loop;
          end if;

          apex_json.close_array;

          apex_json.open_array
          (
            p_name => 'completed'
          );

          if l_completed_col_idx is not null then
            l_completed_nodes :=
              apex_string.split
              (
                p_str => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_completed_col_idx )
              , p_sep => ':'
              );

            for i in 1..l_completed_nodes.count loop
              apex_json.write( p_value => l_completed_nodes(i) );
            end loop;
          end if;

          apex_json.close_array;

          apex_json.open_array
          (
            p_name => 'error'
          );

          if l_error_col_idx is not null then
            l_error_nodes :=
              apex_string.split
              (
                p_str => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_error_col_idx )
              , p_sep => ':'
              );

            for i in 1..l_error_nodes.count loop
              apex_json.write( p_value => l_error_nodes(i) );
            end loop;
          end if;

          apex_json.close_array;

          apex_json.close_object;
        end loop;

        apex_exec.close( p_context => l_context );

        apex_json.close_array;

      end if;

    else
      apex_json.write
      (
        p_name  => 'found'
      , p_value => false
      );

    end if;

    apex_json.close_object;
    return l_return;
  end ajax;

  /* Plugin procedures 25.1 */

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
    
    l_data_row  json_object_t;
    l_data_clob clob;
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

          l_data_row := json_object_t();
          
          l_data_row.put( 'xml', apex_exec.get_clob( p_context => l_context, p_column_idx => l_diagram_col_idx ) );

          if l_dgrm_id_col_idx is not null then
            l_data_row.put( 'diagramIdentifier', apex_exec.get_number( p_context => l_context, p_column_idx => l_dgrm_id_col_idx ) );
          end if;

          if l_highlighting_data_col_idx is not null then
            l_data_clob := apex_exec.get_clob( p_context => l_context, p_column_idx => l_highlighting_data_col_idx );

            if l_data_clob is not null then
              begin
                l_data_row.put( 'highlightingData', json_object_t.parse( l_data_clob ) );
              exception
                when e_json_parse then
                  l_data_row.put( 'highlightingData', json_object_t() );
              end;
            end if;
          end if;

          if l_call_activity_data_col_idx is not null then
            l_data_clob := apex_exec.get_clob( p_context => l_context, p_column_idx => l_call_activity_data_col_idx );

            if l_data_clob is not null then
              begin
                l_data_row.put( 'callActivityData', json_object_t.parse( l_data_clob ) );
              exception
                when e_json_parse then
                    l_data_row.put( 'callActivityData', json_object_t() );
              end;
            end if;
          end if;
              
          if l_iteration_data_col_idx is not null then
            l_data_clob := apex_exec.get_clob( p_context => l_context, p_column_idx => l_iteration_data_col_idx );

            if l_data_clob is not null then
              begin
                l_data_row.put( 'iterationData', json_object_t.parse( l_data_clob ) );
              exception
                when e_json_parse then
                    l_data_row.put( 'iterationData', json_object_t() );
              end;
            end if;
          end if;
              
          if l_user_task_data_col_idx is not null then
            l_data_clob := apex_exec.get_clob( p_context => l_context, p_column_idx => l_user_task_data_col_idx );

            if l_data_clob is not null then
              begin
                l_data_row.put( 'userTaskData', json_object_t.parse( l_data_clob ) );
              exception
                when e_json_parse then
                    l_data_row.put( 'userTaskData', json_object_t() );
              end;
            end if;
          end if;
              
          if l_badges_data_col_idx is not null then
            l_data_clob := apex_exec.get_clob( p_context => l_context, p_column_idx => l_badges_data_col_idx );

            if l_data_clob is not null then
              begin
                l_data_row.put( 'badgesData', json_object_t.parse( l_data_clob ) );
              exception
                when e_json_parse then
                    l_data_row.put( 'badgesData', json_object_t() );
              end;
            end if;
          end if;

          l_data.append( l_data_row );
        
        end loop;

        l_result.put( 'data', l_data );

      end if;

    else
      
      l_result.put( 'found', false );
    
    end if;

    -- htp.p(l_result.to_clob());
    apex_util.prn(l_result.to_clob(), false);

  end ajax;

end flow_viewer;
/
