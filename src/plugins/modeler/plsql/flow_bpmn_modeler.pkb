create or replace package body flow_bpmn_modeler
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

    sys.htp.p( '<div id="' || p_region.static_id || '_modeler" class="mtag-bpmn-modeler">' );
    sys.htp.p( '<div id="' || p_region.static_id || '_canvas" class="mtbm-rendercanvas"></div>' );
    sys.htp.p( '<div id="' || p_region.static_id || '_properties" class="properties-panel-parent"></div>' );
    sys.htp.p( '</div>' );

    apex_javascript.add_onload_code
    (
      p_code =>
        'apex.jQuery("#' || p_region.static_id || '").bpmnmodeler({' ||
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
      , p_value => 'No data found. Check if Diagram with given ID exists.'
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
      , p_value => 'Unexpected error, please contact your administrator.'
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
    apex_json.close_all;
  exception
    when others then
      apex_json.open_object;
      apex_json.write( p_name => 'success', p_value => false );
      apex_json.write
      (
        p_name  => 'message'
      , p_value => 'Unexpected error, please contact your administrator.'
      );
      apex_json.close_all;
  end save;

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
      else null;
    end case;

    return l_return;
  end ajax;

end flow_bpmn_modeler;
/
