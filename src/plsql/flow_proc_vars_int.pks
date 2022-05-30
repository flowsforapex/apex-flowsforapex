/* 
-- Flows for APEX - flow_proc_vars_int.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created    12-Apr-2022  Richard Allen (Oracle)
--
*/

create or replace package flow_proc_vars_int
as 
 /********************************************************************************
**
**        PROCESS VARIABLE SYSTEM (get / set / etc) 
**        FOR USE ONLY BY THE FLOW ENGINE (PRIVATE TO ENGINE)
**
********************************************************************************/ 
 

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_vc2_value in flow_process_variables.prov_var_vc2%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_num_value in flow_process_variables.prov_var_num%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
);

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
, pi_scope in flow_process_variables.prov_scope%type default 0
);

-- getters return

function get_var_vc2
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_vc2%type;

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_num%type;

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_date%type;

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_clob%type;
  
function get_var_type
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_type%type;

procedure delete_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
);

/********************************************************************************
**
**        SPECIAL CASE / BUILT-IN PROCESS VARIABLES
**
********************************************************************************/ 

procedure set_business_ref
( pi_prcs_id in flow_processes.prcs_id%type
, pi_vc2_value in flow_process_variables.prov_var_vc2%type
, pi_scope in flow_subflows.sbfl_scope%type default 0
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
);

function get_business_ref
( pi_prcs_id in flow_processes.prcs_id%type
, pi_scope   in flow_subflows.sbfl_scope%type default 0
)
return flow_process_variables.prov_var_vc2%type;

 /********************************************************************************
**
**        FOR FLOW_ENGINE USE
**
********************************************************************************/ 

procedure delete_all_for_process
( pi_prcs_id in flow_processes.prcs_id%type
, pi_retain_builtins in boolean default false
);

procedure do_substitution
(
  pi_prcs_id  in flow_processes.prcs_id%type
, pi_sbfl_id  in flow_subflows.sbfl_id%type
, pi_scope    in flow_subflows.sbfl_scope%type
, pi_step_key in flow_subflows.sbfl_step_key%type default null
, pio_string  in out nocopy varchar2
);

procedure do_substitution
(
  pi_prcs_id  in flow_processes.prcs_id%type
, pi_sbfl_id  in flow_subflows.sbfl_id%type
, pi_scope    in flow_subflows.sbfl_scope%type
, pi_step_key in flow_subflows.sbfl_step_key%type default null
, pio_string  in out nocopy clob
);

function scope_is_valid
( pi_prcs_id in flow_processes.prcs_id%type
, pi_scope   in flow_subflows.sbfl_scope%type
) return boolean;

end flow_proc_vars_int;
/
