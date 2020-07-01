create or replace package body flow_wfp_plugin
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

    sys.htp.p( '<div id="' || p_region.static_id || '_canvas" class="rendercanvas"></div>' );

    apex_javascript.add_onload_code
    (
      p_code => 'apex.jQuery("#' || p_region.static_id || '").wfp({' ||
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
                  , p_add_comma => false
                  ) ||
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
    l_last_comp_col_idx pls_integer;
    l_row_found         boolean;
    l_column_value_list apex_plugin_util.t_column_value_list2;
    l_data_type_list    apex_application_global.vc_arr2;

    l_completed_markers apex_t_varchar2;
    l_last_comp_markers apex_t_varchar2;
    l_current_markers   apex_t_varchar2;

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

    l_last_comp_col_idx :=
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
        l_current_markers :=
          apex_string.split
          (
            p_str => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_current_col_idx )
          , p_sep => p_region.attribute_03
          );
        
        for i in 1..l_current_markers.count loop
          apex_json.write( p_value => l_current_markers(i) );
        end loop;
      end if;

      apex_json.close_array;

      apex_json.open_array
      (
        p_name => 'completed'
      );
      
      if l_completed_col_idx is not null then
        l_completed_markers :=
          apex_string.split
          (
            p_str => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_completed_col_idx )
          , p_sep => p_region.attribute_05
          );
        
        for i in 1..l_completed_markers.count loop
          apex_json.write( p_value => l_completed_markers(i) );
        end loop;
      end if;

      apex_json.close_array;

      apex_json.open_array
      (
        p_name => 'lastCompleted'
      );

      if l_last_comp_col_idx is not null then
        l_last_comp_markers :=
          apex_string.split
          (
            p_str => apex_exec.get_varchar2( p_context => l_context, p_column_idx => l_last_comp_col_idx )
          , p_sep => p_region.attribute_07
          );
        
        for i in 1..l_last_comp_markers.count loop
          apex_json.write( p_value => l_last_comp_markers(i) );
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

end flow_wfp_plugin;
/
