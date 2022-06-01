/* 
-- Flows for APEX - flow_globals.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created    25-Aug-2021  Richard Allen (Flowquest, for MT AG)
-- Modified   12-Apr-2022  Richard Allen (Oracle)
--
*/

create or replace package flow_globals
as

  process_id flow_processes.prcs_id%type;
  subflow_id flow_subflows.sbfl_id%type;
  step_key   flow_subflows.sbfl_step_key%type;
  scope      flow_subflows.sbfl_scope%type;

  function business_ref
  (pi_scope       flow_subflows.sbfl_scope%type default 0)
  return flow_process_variables.prov_var_vc2%type;

  function business_ref
  (pi_sbfl_id     flow_subflows.sbfl_id%type)
  return flow_process_variables.prov_var_vc2%type;

  procedure set_context
  ( pi_prcs_id  in flow_processes.prcs_id%type
  , pi_sbfl_id  in flow_subflows.sbfl_id%type default null
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  , pi_scope    in flow_subflows.sbfl_scope%type default null
  );

  procedure set_step_error
  ( p_has_error  in boolean default false
  );

  function get_step_error
  return boolean;

  procedure set_is_recursive_step
  ( p_is_recursive_step  in boolean default false
  );

  function get_is_recursive_step
  return boolean;

end flow_globals;
/
