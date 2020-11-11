create or replace package flow_p0010_api
  authid definer
as

  procedure process_action
  (
    pi_action  in varchar2
  , pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  );

  procedure process_variables_row
  (
    pi_row_status    in varchar2
  , pi_prov_prcs_id  in out nocopy flow_process_variables.prov_prcs_id%type
  , pi_prov_var_name in out nocopy flow_process_variables.prov_var_name%type
  , pi_prov_var_type in flow_process_variables.prov_var_type%type
  , pi_prov_var_vc2  in flow_process_variables.prov_var_vc2%type
  , pi_prov_var_num  in flow_process_variables.prov_var_num%type
  , pi_prov_var_date in flow_process_variables.prov_var_date%type
  , pi_prov_var_clob in flow_process_variables.prov_var_clob%type
  );

end flow_p0010_api;
/
