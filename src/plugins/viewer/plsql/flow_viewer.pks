create or replace package flow_viewer
as

  procedure render
  (
    p_plugin in            apex_plugin.t_plugin
  , p_region in            apex_plugin.t_region
  , p_param  in            apex_plugin.t_region_render_param
  , p_result in out nocopy apex_plugin.t_region_render_result
  );

  procedure ajax
  (
    p_plugin in            apex_plugin.t_plugin
  , p_region in            apex_plugin.t_region
  , p_param  in            apex_plugin.t_region_ajax_param
  , p_result in out nocopy apex_plugin.t_region_ajax_result
  );

end flow_viewer;
/
