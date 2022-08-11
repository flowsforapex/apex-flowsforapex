create or replace package flow_engine_app_api
  authid definer
as

  procedure handle_ajax;

  /* general */
  function get_objt_list(
    p_prcs_id in flow_processes.prcs_id%type
  ) return varchar2;
  
  function get_objt_list(
    p_dgrm_id in flow_diagrams.dgrm_id%type
  ) return varchar2;
  
  function get_objt_name(
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_dgrm_id      in flow_diagrams.dgrm_id%type
  ) return flow_objects.objt_name%type;

  function get_objt_name(
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_prcs_id      in flow_processes.prcs_id%type
  ) return flow_objects.objt_name%type;

  procedure set_viewport(
    p_display_setting in varchar2);

  procedure add_viewport_script(
    p_item in varchar2
  );

  procedure get_url_p13(
    pi_dgrm_id flow_diagrams.dgrm_id%type
  , pi_objt_id varchar2
  , pi_title varchar2
  );

  procedure get_url_p13(
    pi_prcs_id flow_processes.prcs_id%type
  , pi_dgrm_id flow_processes.prcs_dgrm_id%type    
  , pi_objt_id varchar2
  , pi_title varchar2
  );

  /* page 2 */

  function validate_flow_exists_bulk(
    pi_dgrm_id_list in varchar2
  , pi_new_version  in flow_diagrams.dgrm_version%type 
  ) return varchar2;

  function validate_flow_exists(
    pi_dgrm_id     in flow_diagrams.dgrm_id%type
  , pi_new_version in flow_diagrams.dgrm_version%type 
  ) return varchar2;
    
  function validate_flow_copy_bulk(
    pi_dgrm_id_list in varchar2
  , pi_new_name     in flow_diagrams.dgrm_name%type 
  ) return varchar2;
    
  function validate_flow_copy(
    pi_new_name in flow_diagrams.dgrm_name%type 
  ) return varchar2;

  procedure copy_selection_to_collection;

  procedure add_new_version(
    pi_dgrm_id_list in varchar2
  , pi_new_version  in flow_diagrams.dgrm_version%type 
  );
  
  procedure copy_model(
    pi_dgrm_id_list in varchar2
  , pi_new_name     in flow_diagrams.dgrm_name%type 
  );

  /* page 4 */

  function get_region_title(
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  )
  return varchar2;

  /* page 5 */

  function get_file_name(
      p_dgrm_id                  in number,
      p_include_version          in varchar2,
      p_include_status           in varchar2,
      p_include_category         in varchar2,
      p_include_last_change_date in varchar2,
      p_download_as              in varchar2
  ) return varchar2;

  procedure download_file(
      p_dgrm_id     in number,
      p_file_name   in varchar2,
      p_download_as in varchar2,
      p_multi_file  in boolean default false
  );

  /* page 6 */

  function is_file_uploaded(
      pi_file_name in varchar2
  )
  return boolean;
    
  function is_valid_xml(
      pi_import_from  in varchar2,
      pi_dgrm_content in flow_diagrams.dgrm_content%type,
      pi_file_name    in varchar2
  )
  return boolean;
  
  function is_valid_multi_file_archive(
      pi_file_name in varchar2
  )
  return varchar2;

  function upload_and_parse(
      pi_import_from     in varchar2,
      pi_dgrm_name       in flow_diagrams.dgrm_name%type,
      pi_dgrm_category   in flow_diagrams.dgrm_category%type,
      pi_dgrm_version    in flow_diagrams.dgrm_version%type,
      pi_dgrm_content    in flow_diagrams.dgrm_content%type,
      pi_file_name       in varchar2,
      pi_force_overwrite in varchar2
  )
  return flow_diagrams.dgrm_id%type;
  
  procedure multiple_flow_import(
      pi_file_name       in varchar2,
      pi_force_overwrite in varchar2
  );

  /* page 7 */
  
  function validate_new_version(
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type
  )
  return varchar2;
    
  procedure process_page_p7
  (
    pio_dgrm_id      in out nocopy flow_diagrams.dgrm_id%type
  , pi_dgrm_name     in flow_diagrams.dgrm_name%type
  , pi_dgrm_version  in flow_diagrams.dgrm_version%type
  , pi_dgrm_category in flow_diagrams.dgrm_category%type
  , pi_new_version   in flow_diagrams.dgrm_version%type
  , pi_cascade       in varchar2
  , pi_request       in varchar2
  );
  
  function get_page_title(
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type
  )
  return varchar2;

  /* page 8 */

  function check_is_date(
    pi_value       in varchar2,
    pi_format_mask in varchar2)
    return varchar2;

  function check_is_number(
    pi_value in varchar2)
    return varchar2;
    
  procedure pass_variable;
  
  function get_connection_select_option(
    pi_gateway in flow_objects.objt_bpmn_id%type
  , pi_prcs_id in flow_processes.prcs_id%type
  )
  return varchar2;

  /* page 9 */

  procedure set_settings(
    pi_logging_language          in flow_configuration.cfig_value%type
  , pi_logging_level             in flow_configuration.cfig_value%type
  , pi_logging_hide_userid       in flow_configuration.cfig_value%type
  , pi_engine_app_mode           in flow_configuration.cfig_value%type
  , pi_duplicate_step_prevention in flow_configuration.cfig_value%type
  );

  /* page 11 */

  function create_instance(
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_prcs_name    in flow_processes.prcs_name%type
  , pi_business_ref in flow_process_variables.prov_var_vc2%type
  )
  return flow_processes.prcs_id%type;

  /* page 12 */
  
  function get_prcs_name(
    pi_prcs_id in flow_processes.prcs_id%type
  )
  return flow_processes.prcs_name%type;

  /* page 13 */

  function has_error(
    pi_prcs_id in flow_processes.prcs_id%type,
    pi_objt_id in flow_subflows.sbfl_current%type)
  return boolean;

end flow_engine_app_api;
/
