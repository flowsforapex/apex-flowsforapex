/* 
-- Flows for APEX - flow_process_vars.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created 22-SEP-2020  Richard Allen (Flowquest) 
-- Edited  13-APR-2022 - Richard Allen (Oracle)
--
*/
create or replace package flow_process_vars
as 
 /********************************************************************************
**
**        PROCESS VARIABLE SYSTEM (get / set / etc)
**        Process Variable System API for Application Developers
**
********************************************************************************/ 
 
-- Set_var - Signature 1a - Set a varchar2 variable using scope (defaulting to 0, top level scope) 
procedure set_var
( pi_prcs_id    in flow_processes.prcs_id%type
, pi_var_name   in flow_process_variables.prov_var_name%type
, pi_vc2_value  in flow_process_variables.prov_var_vc2%type
, pi_scope      in flow_process_variables.prov_scope%type default 0
);

-- Set_var - Signature 1b - Set a varchar2 variable using current subflow id 
procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_vc2_value in flow_process_variables.prov_var_vc2%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
);

-- set_var - signature 2a - Set a number variable using scope (defaulting to 0, top level scope) 
procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_num_value in flow_process_variables.prov_var_num%type
, pi_scope in flow_process_variables.prov_scope%type default 0
);

-- Set_var - Signature 2b - Set a number variable using current subflow id 

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_num_value in flow_process_variables.prov_var_num%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
);

-- Set_var - Signature 3a - Set a date variable using scope (defaulting to 0, top level scope) 

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
, pi_scope in flow_process_variables.prov_scope%type default 0
);

-- Set_var - Signature 3b - Set a date variable using current subflow id 

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_date_value in flow_process_variables.prov_var_date%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
);

-- Set_var - Signature 4a - Set a CLOB variable using scope (defaulting to 0, top level scope) 

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
, pi_scope in flow_process_variables.prov_scope%type default 0
);

-- Set_var - Signature 4b - Set a CLOB variable using current subflow id 

procedure set_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_clob_value in flow_process_variables.prov_var_clob%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
);


-- getters return

-- get_var_vc2:  varchar2 type - signature 1

function get_var_vc2
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_vc2%type;

-- get_var_vc2:  varchar2 type - signature 2

function get_var_vc2
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_vc2%type;

-- get_var_num:  number type - signature 1

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_num%type;

-- get_var_num:  number type - signature 2

function get_var_num
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_num%type;

-- get_var_date:  date type - signature 1

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_date%type;

-- get_var_date:  date type - signature 2

function get_var_date
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_date%type;


-- get_var_CLOB:  CLOB type - signature 1

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_clob%type;

-- get_var_CLOB:  CLOB type - signature 2

function get_var_clob
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_clob%type;

-- get_var_type - signature 1 - by scope, including default scope

function get_var_type
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_type%type;

-- get_var_type - signature 2 - by subflow_id

function get_var_type
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_exception_on_null in boolean default false
) return flow_process_variables.prov_var_type%type;

-- delete_var - Signature 1 - by scope, including default scope

procedure delete_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_scope in flow_process_variables.prov_scope%type default 0
);

-- delete_var - Signature 2 - by subflow_id

procedure delete_var
( pi_prcs_id in flow_processes.prcs_id%type
, pi_var_name in flow_process_variables.prov_var_name%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
);

/********************************************************************************
**
**        SPECIAL CASE / BUILT-IN PROCESS VARIABLES
**
********************************************************************************/ 

procedure set_business_ref
( pi_prcs_id in flow_processes.prcs_id%type
, pi_vc2_value in flow_process_variables.prov_var_vc2%type
, pi_sbfl_id in flow_subflows.sbfl_id%type default null
, pi_objt_bpmn_id in flow_objects.objt_bpmn_id%type default null 
, pi_expr_set in flow_object_expressions.expr_set%type default null
);

function get_business_ref
( pi_prcs_id in flow_processes.prcs_id%type)
return flow_process_variables.prov_var_vc2%type;

 /********************************************************************************
**
**        FOR FLOW_ENGINE USE  - move to flow_proc_vars only?
**
********************************************************************************/ 
/*
procedure delete_all_for_process
( pi_prcs_id in flow_processes.prcs_id%type
, pi_retain_builtins in boolean default false
);

procedure do_substitution
(
  pi_prcs_id in flow_processes.prcs_id%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_step_key in flow_subflows.sbfl_step_key%type default null
, pio_string in out nocopy varchar2
);

procedure do_substitution
(
  pi_prcs_id in flow_processes.prcs_id%type
, pi_sbfl_id in flow_subflows.sbfl_id%type
, pi_step_key in flow_subflows.sbfl_step_key%type default null
, pio_string in out nocopy clob
);
*/

end flow_process_vars;
/
