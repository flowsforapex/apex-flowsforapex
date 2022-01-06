create or replace package flow_engine_app_api
  authid definer
as

  procedure handle_ajax;

  /* general */
  function get_objt_list(
    p_prcs_id flow_processes_vw.prcs_id%type
  ) return varchar2;

  
  function get_objt_list(
    p_dgrm_id flow_diagrams_vw.dgrm_id%type
  ) return varchar2;
  
  
  function get_objt_name(
    p_objt_bpmn_id flow_objects_vw.objt_bpmn_id%type
  ) return varchar2;

  procedure set_viewport(
    p_display_setting in varchar2);

  procedure add_viewport_script;

  /* page 2 */

  function validate_flow_exists_bulk
    return varchar2;


  function validate_flow_exists
    return varchar2;
    
  
  function validate_flow_copy_bulk
  return varchar2;
  
    
  function validate_flow_copy
  return varchar2;


  procedure copy_selection_to_collection;


  procedure add_new_version;
  
  
  procedure copy_model;

  /* page 4 */

  function get_region_title
  return varchar2;

  /* page 5 */

  function get_file_name(
      p_dgrm_id in number,
      p_include_version in varchar2,
      p_include_status in varchar2,
      p_include_category in varchar2,
      p_include_last_change_date in varchar2,
      p_download_as in varchar2
  ) return varchar2;

  procedure download_file(
      p_dgrm_id in number,
      p_file_name in varchar2,
      p_download_as in varchar2,
      p_multi_file in boolean default false
  );

  /* page 6 */

  function is_file_uploaded(
      pi_file_name in varchar2
  )
  return boolean;
    
  function is_valid_xml(
      pi_import_from in varchar2,
      pi_dgrm_content in flow_diagrams_vw.dgrm_content%type,
      pi_file_name in varchar2
  )
  return boolean;
  
  function is_valid_multi_file_archive(
      pi_file_name in varchar2
  )
  return varchar2;

  procedure upload_and_parse(
      pi_import_from     in varchar2,
      pi_dgrm_name       in flow_diagrams_vw.dgrm_name%type,
      pi_dgrm_category   in flow_diagrams_vw.dgrm_category%type,
      pi_dgrm_version    in flow_diagrams_vw.dgrm_version%type,
      pi_dgrm_content    in flow_diagrams_vw.dgrm_content%type,
      pi_file_name       in varchar2,
      pi_force_overwrite in varchar2
  );
  
  procedure multiple_flow_import(
      pi_file_name       in varchar2,
      pi_force_overwrite in varchar2
  );

  /* page 7 */

  procedure p7_prepare_url;
  
  
  function diagram_is_modifiable
  return boolean;
  

  function validate_new_version
  return varchar2;
  
  
  procedure p7_process_page
  (
    pio_dgrm_id      in out nocopy flow_diagrams_vw.dgrm_id%type
  , pi_dgrm_name     in flow_diagrams_vw.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams_vw.dgrm_version%type
  , pi_dgrm_category in flow_diagrams_vw.dgrm_category%type
  , pi_new_version   in flow_diagrams_vw.dgrm_version%type
  , pi_cascade       in varchar2
  , pi_request       in varchar2
  );
  
  function get_page_title
  return varchar2;

  /* page 8 */

  function check_is_date(
    pi_value in varchar2,
    pi_format_mask in varchar2)
    return varchar2;

  function check_is_number(
    pi_value in varchar2)
    return varchar2;
    
  procedure pass_variable;
  
  procedure p8_prepare_url;
  
  function get_connection_select_option
  return varchar2;

  /* page 9 */

  procedure set_settings;

  /* page 10 */  
    
  procedure p10_prepare_url;
  

  /* page 11 */

  procedure create_instance;

  /* page 12 */

  procedure p12_prepare_url;
  
  function get_prcs_name
  return varchar2;

  /* page 13 */

  function has_error(
    pi_prcs_id in flow_subflows_vw.sbfl_prcs_id%type,
    pi_objt_id in flow_subflows_vw.sbfl_current%type)
  return boolean;

end flow_engine_app_api;
/
