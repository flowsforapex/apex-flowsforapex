create or replace package flow_settings
as 
/* 
-- Flows for APEX - flow_settings.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright Flowquest Consulting Limited. 2024
--
-- Created    21-Nov-2022  Richard Allen (Oracle)
-- Modified   11-Feb-2024  Richard Allen (Flowquest Consulting)
--
*/

  --- Datatype Specific Settings Getters - Use if setting has no special options
  function get_vc2_expression
  ( pi_prcs_id       flow_processes.prcs_id%type default null
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2 default null
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;

  function get_clob_expression
  ( pi_prcs_id       flow_processes.prcs_id%type  default null
  , pi_sbfl_id       flow_subflows.sbfl_id%type  default null
  , pi_expr          clob
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   clob;

  -- setting-specific getters - use if the setting is not standard...
  function get_due_on
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_objects.objt_attributes%type
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return timestamp with time zone;

  function get_priority
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type default null
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return flow_processes.prcs_priority%type;

  function get_endpoint
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;  

  function get_iteration_settings
  ( pi_expr          sys.json_object_t
  ) return   flow_types_pkg.t_iteration_vars;    

end flow_settings;
/
