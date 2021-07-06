create or replace package flow_process_vars
as 
 /********************************************************************************
**
**        PROCESS VARIABLE SYSTEM (get / set / etc)
**
********************************************************************************/ 
 

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_vc2_value in flow_process_variables.prov_var_vc2%type
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_num_value in flow_process_variables.prov_var_num%type
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
);

-- getters return

function get_var_vc2
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_vc2%type;

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_num%type;

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_date%type;

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type)
return flow_process_variables.prov_var_clob%type;

 /********************************************************************************
**
**        FOR FLOW_ENGINE USE
**
********************************************************************************/ 

procedure delete_all_for_process
( pi_prcs_id in flow_processes.prcs_id%type
);

procedure do_substitution
(
  pi_prcs_id in flow_processes.prcs_id%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pio_string in out nocopy varchar2
);

end flow_process_vars;
/
