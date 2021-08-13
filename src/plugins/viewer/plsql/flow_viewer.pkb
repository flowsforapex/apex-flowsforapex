create or replace package body flow_viewer
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

    sys.htp.p( '<div id="' || p_region.static_id || '_canvas" class="mtbv-rendercanvas" style="display: none;"></div>' );
    sys.htp.p( '<span id="' || p_region.static_id || '_ndf" class="nodatafound" style="display: none;">' || coalesce(p_region.no_data_found_message, 'No data found.') || '</span>' );

    apex_javascript.add_onload_code
    (
      p_code => 'apex.jQuery("#' || p_region.static_id || '").bpmnviewer({' ||
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
                    p_name      => 'enableExpandModule'
                  , p_value     => ( p_region.attribute_10 = 'Y' )
                  , p_add_comma => true
                  ) ||
                  apex_javascript.add_attribute
                  (
                    p_name      => 'useNavigatedViewer'
                  , p_value     => ( p_region.attribute_11 = 'Y' )
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

    l_context           apex_exec.t_context;
    l_diagram_col_idx   pls_integer;
    l_current_col_idx   pls_integer;
    l_completed_col_idx pls_integer;
    l_error_col_idx     pls_integer;
    l_row_found         boolean;
    l_column_value_list apex_plugin_util.t_column_value_list2;
    l_data_type_list    apex_application_global.vc_arr2;

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
        p_first_row => 1
      , p_max_rows  => 1
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

    apex_json.open_object;


    if apex_exec.next_row( p_context => l_context ) then

      apex_json.write
      (
        p_name  => 'found'
      , p_value => true
      );

      apex_json.open_object
      (
        p_name => 'data'
      );

      apex_json.write
      (
        p_name  => 'diagram'
      , p_value => apex_exec.get_clob( p_context => l_context, p_column_idx => l_diagram_col_idx )
      );

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

    else
      apex_json.write
      (
        p_name  => 'found'
      , p_value => false
      );

    end if;

    apex_json.close_all;
    return l_return;
  end ajax;

end flow_viewer;
