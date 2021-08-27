create or replace package flow_p0008_api
  authid definer
as

  procedure process_action
  (
    pi_action  in varchar2
  , pi_prcs_ids in apex_application.g_f01%type
  , pi_sbfl_ids in apex_application.g_f02%type
  , pi_dgrm_ids in apex_application.g_f03%type
  , pi_prcs_names in apex_application.g_f04%type
  , pi_reservation in varchar2
  );

  procedure process_variables_row
  (
    pi_request         in varchar2
  , pi_delete_prov_var in boolean default false
  , pi_prov_prcs_id    in out nocopy flow_process_variables.prov_prcs_id%type
  , pi_prov_var_name   in out nocopy flow_process_variables.prov_var_name%type
  , pi_prov_var_type   in flow_process_variables.prov_var_type%type
  , pi_prov_var_vc2    in flow_process_variables.prov_var_vc2%type
  , pi_prov_var_num    in flow_process_variables.prov_var_num%type
  , pi_prov_var_date   in flow_process_variables.prov_var_date%type
  , pi_prov_var_clob   in flow_process_variables.prov_var_clob%type
  );

end flow_p0008_api;
/
