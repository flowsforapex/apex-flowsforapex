create or replace package flow_viewer
as

  /* Legacy plugin functions pre-25.1 */

  function render
  (
    p_region              in  apex_plugin.t_region
  , p_plugin              in  apex_plugin.t_plugin
  , p_is_printer_friendly in  boolean
  )
    return apex_plugin.t_region_render_result;

  function ajax
  (
    p_region              in  apex_plugin.t_region
  , p_plugin              in  apex_plugin.t_plugin
  )
    return apex_plugin.t_region_ajax_result;

  /* Plugin procedures 25.1 */

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
