create or replace package flow_rest_constants
  authid definer
as
  c_config_prefix    constant varchar2(50 char)  := 'rest_';
  c_config_key_base  constant varchar2(50 char)  := 'base';

  c_cgi_env_base_path   constant varchar2(50 char)  := 'X-APEX-BASE';

  c_split_sep   constant varchar2(1 char) := ':';

  c_module    constant varchar2(200 char) := 'v1/';      

  c_path_diagrams           constant varchar2(200 char) := 'diagrams/:id';
  c_path_diagram_processes  constant varchar2(200 char) := 'diagrams/:id/processes';
  c_path_processes          constant varchar2(200 char) := 'processes/:id';
  c_path_process_vars       constant varchar2(200 char) := 'processes/:id/process_vars';
  c_path_process_start      constant varchar2(200 char) := 'processes/:id/start';
  c_path_process_reset      constant varchar2(200 char) := 'processes/:id/reset';
  c_path_process_terminate  constant varchar2(200 char) := 'processes/:id/terminate';
  c_path_steps              constant varchar2(200 char) := 'steps/:id';
  c_path_message_subscriptions   constant varchar2(200 char) := 'processes/:id/message_subscriptions';

  c_http_action_get     constant varchar2(3 char)   := 'GET';
  c_http_action_post    constant varchar2(4 char)   := 'POST';
  c_http_action_put     constant varchar2(3 char)   := 'PUT';
  c_http_action_delete  constant varchar2(6 char)   := 'DELETE';

  c_http_code_OK        constant number := 200;
  c_http_code_ERROR     constant number := 500;

  c_object_type_diagram        constant varchar2(100 char) := 'diagram';
  c_object_type_process        constant varchar2(100 char) := 'process';
  c_object_type_process_vars   constant varchar2(100 char) := 'process_vars';
  c_object_type_step           constant varchar2(100 char) := 'step';
  c_object_type_step_usertask  constant varchar2(100 char) := 'usertask_url';

  c_process_status_start      constant varchar2(20 char) := 'start';
  c_process_status_reset      constant varchar2(20 char) := 'reset';
  c_process_status_terminate  constant varchar2(20 char) := 'terminate';
  c_process_status_delete     constant varchar2(20 char) := 'delete';

  
  c_step_status_status            constant varchar2(20 char) := 'status';
  c_step_status_start             constant varchar2(20 char) := 'start';
  c_step_status_reserve           constant varchar2(20 char) := 'reserve';
  c_step_status_release           constant varchar2(20 char) := 'release';
  c_step_status_complete          constant varchar2(20 char) := 'complete';
  c_step_status_restart           constant varchar2(20 char) := 'restart';
  c_step_status_reschedule_timer  constant varchar2(20 char) := 'reschedule_timer';

  c_pvar_type_varchar   constant varchar2(10 char) := 'varchar';
  c_pvar_type_number    constant varchar2(10 char) := 'number';
  c_pvar_type_date      constant varchar2(10 char) := 'date';
  c_pvar_type_clob      constant varchar2(10 char) := 'clob';

  c_json_errors_key   constant varchar2(20 char) := 'errors';
  c_json_error_type   constant varchar2(20 char) := 'type';
  c_json_error_value  constant varchar2(20 char) := 'value';
  c_json_error_type_missing_attr    constant varchar2(20 char) := 'missing attribute';
  c_json_error_type_item_not_found  constant varchar2(20 char) := 'item not found';
  c_json_error_type_processing_error  constant varchar2(20 char) := 'processing error';

  -- JSON attributes key-names Process variables
  c_json_prov_sbfl_id    constant varchar2(20 char) := 'sbfl_id';
  c_json_prov_name       constant varchar2(20 char) := 'name';
  c_json_prov_type       constant varchar2(20 char) := 'type';
  c_json_prov_scope      constant varchar2(20 char) := 'scope';
  c_json_prov_value      constant varchar2(20 char) := 'value';

  -- mandatory JSON attributes to be checked for objects
  c_check_attr_process_create     constant varchar2(20 char) := 'name';
  c_check_attr_process_update     constant varchar2(20 char) := 'status';
  c_check_attr_process_var_update constant varchar2(20 char) := 'name:type:value';
  c_check_attr_process_var_delete constant varchar2(20 char) := 'name';
  c_check_attr_step_update        constant varchar2(20 char) := 'status:step_key';
  c_check_attr_message_update     constant varchar2(20 char) := 'key:value:payload';

  c_check_item_dgrm_version    constant varchar2(20 char) := 'version';
  
  -- Rest Roles and Privileges
  c_rest_grant_type    constant varchar2(50 char) := 'client_credentials';
  c_rest_priv_read     constant varchar2(50 char) := 'flowsforapex.read';
  c_rest_priv_write    constant varchar2(50 char) := 'flowsforapex.write';
  c_rest_priv_admin    constant varchar2(50 char) := 'flowsforapex.admin';
  c_rest_role_read     constant varchar2(50 char) := 'Flows for Apex - Read';
  c_rest_role_write    constant varchar2(50 char) := 'Flows for Apex - Write';
  c_rest_role_admin    constant varchar2(50 char) := 'Flows for Apex - Admin';
  c_rest_role_sep      constant varchar2(50 char) := ':';

  e_payload_not_acceptable exception;
  e_multiple_object_error  exception;
  e_attribute_not_found    exception;
  e_item_not_found         exception;
  e_processing_error       exception;
  e_process_unknown_status exception;
  e_step_unknown_operation exception;
  e_privilege_not_granted  exception;

end flow_rest_constants;
/
