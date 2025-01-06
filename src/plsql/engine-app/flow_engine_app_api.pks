create or replace package flow_engine_app_api
  authid definer
as

  function apex_error_handling (
    p_error in apex_error.t_error 
  )
  return apex_error.t_error_result;

  procedure handle_ajax;

  /* general */
  function get_objt_list(
    p_prcs_id in flow_processes.prcs_id%type
  ) return varchar2;
  
  function get_objt_list(
    p_dgrm_id in flow_diagrams.dgrm_id%type
  ) return varchar2;

    function get_objt_list(
    p_prdg_id in flow_instance_diagrams.prdg_id%type
  ) return varchar2;
  
  function get_objt_name(
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_dgrm_id      in flow_diagrams.dgrm_id%type
  ) return flow_objects.objt_name%type;

  function get_objt_name(
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_prcs_id      in flow_processes.prcs_id%type
  ) return flow_objects.objt_name%type;

  function get_objt_name(
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_prdg_id      in flow_instance_diagrams.prdg_id%type
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
  , pi_prdg_id flow_instance_diagrams.prdg_id%type
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

  /* page 3 */
  function check_version_mismatch(
    p_app_id number default apex_application.g_flow_id
  ) return varchar2;

  function check_apex_upgrade(
    p_app_id number default apex_application.g_flow_id
  ) return varchar2;

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

  function get_current_diagram
    ( pi_dgrm_name              in flow_diagrams.dgrm_name%type
    , pi_dgrm_calling_method    in flow_types_pkg.t_bpmn_attribute_vc2
    , pi_dgrm_version           in flow_diagrams.dgrm_version%type
    )
  return flow_diagrams.dgrm_id%type;

  /* page 8 */

  function check_is_date(
    pi_value       in varchar2,
    pi_format_mask in varchar2)
    return varchar2;

  function check_is_tstz(
    pi_value       in varchar2,
    pi_format_mask in varchar2)
    return varchar2;

  function check_is_number(
    pi_value in varchar2)
    return varchar2;
    
  procedure pass_variable;
  
  function get_connection_select_option(
    pi_gateway in flow_objects.objt_bpmn_id%type
  , pi_prdg_id in flow_instance_diagrams.prdg_id%type
  )
  return varchar2;

  function get_scope(
      pi_gateway in flow_objects.objt_bpmn_id%type
    , pi_prdg_id in flow_instance_diagrams.prdg_id%type
  ) return number;

  procedure download_instance_summary(
    pi_prcs_id in flow_processes.prcs_id%type
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

  /* page 51 */

  procedure process_page_p51
  (
    pio_sfte_id       in out nocopy flow_simple_form_templates.sfte_id%type
  , pi_sfte_name      in flow_simple_form_templates.sfte_name%type
  , pi_sfte_static_id in flow_simple_form_templates.sfte_static_id%type
  , pi_sfte_content   in flow_simple_form_templates.sfte_content%type
  , pi_request        in varchar2
  );

  /* configuration */
  procedure set_logging_settings(
    pi_logging_language          in flow_configuration.cfig_value%type
  , pi_logging_level             in flow_configuration.cfig_value%type
  , pi_logging_hide_userid       in flow_configuration.cfig_value%type
  , pi_logging_retain_logs       in flow_configuration.cfig_value%type
  , pi_logging_message_flow_recd in flow_configuration.cfig_value%type
  , pi_logging_retain_msg_flow   in flow_configuration.cfig_value%type
  );

  procedure set_archiving_settings(
    pi_archiving_enabled  in flow_configuration.cfig_value%type
  );

  procedure set_statistics_settings(
    pi_stats_retain_daily in flow_configuration.cfig_value%type
  , pi_stats_retain_month in flow_configuration.cfig_value%type
  , pi_stats_retain_qtr   in flow_configuration.cfig_value%type
  );

-- set_statictis_settings was included in 23.1 and 24.1 and is retained here for upwards
-- compatibility (but just calls set_statistics_settings)
  procedure set_statictis_settings(
    pi_stats_retain_daily in flow_configuration.cfig_value%type
  , pi_stats_retain_month in flow_configuration.cfig_value%type
  , pi_stats_retain_qtr   in flow_configuration.cfig_value%type
  );

  procedure set_engine_app_settings(
    pi_engine_app_mode in flow_configuration.cfig_value%type
  );

  procedure set_engine_settings(
    pi_duplicate_step_prevention in flow_configuration.cfig_value%type
  , pi_default_workspace         in flow_configuration.cfig_value%type
  , pi_default_email_sender      in flow_configuration.cfig_value%type
  , pi_default_application       in flow_configuration.cfig_value%type
  , pi_default_pageid            in flow_configuration.cfig_value%type
  , pi_default_username          in flow_configuration.cfig_value%type
  );

  procedure set_timers_settings(
    pi_timer_max_cycles       in flow_configuration.cfig_value%type
  , pi_timer_status           in sys.all_scheduler_jobs.enabled%type
  , pi_timer_repeat_interval  in sys.all_scheduler_jobs.repeat_interval%type
  );

end flow_engine_app_api;
/
