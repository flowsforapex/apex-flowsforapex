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

    sys.htp.p( '<div id="' || p_region.static_id || '_canvas" ' ||
               'style="height: 100vw; background-color: #f0f0f0;"></div>'
             );

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
                  , p_value     => p_region.ajax_items_to_submit
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
    l_column_value_list apex_plugin_util.t_column_value_list2;
    l_data_type_list    apex_application_global.vc_arr2;

    l_return apex_plugin.t_region_ajax_result;
  begin

    l_data_type_list(1) := apex_plugin_util.c_data_type_clob;
    l_data_type_list(2) := apex_plugin_util.c_data_type_varchar2;

    l_column_value_list :=
      apex_plugin_util.get_data2
      (
        p_sql_statement  => p_region.source
      , p_min_columns    => 1
      , p_max_columns    => 2
      , p_data_type_list => l_data_type_list
      , p_component_name => p_region.name
      );

    apex_json.open_object;

    apex_json.write
    (
      p_name  => 'diagram'
    , p_value => l_column_value_list(1).value_list(1).clob_value
    );

    apex_json.write
    (
      p_name  => 'current'
    , p_value => l_column_value_list(2).value_list(1).varchar2_value
    );

    apex_json.close_all;
    return l_return;
  end ajax;

end flow_wfp_plugin;
/
