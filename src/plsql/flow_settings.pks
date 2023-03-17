create or replace package flow_settings
as 
/* 
-- Flows for APEX - flow_settings.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created    21-Nov-2022  Richard Allen (Oracle)
--
*/

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

  function get_potential_users
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;

  function get_potential_groups
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;

  function get_excluded_users
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;

  function get_message_name
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;

  function get_correlation_key
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;

  function get_correlation_value
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;  

  function get_payload
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   clob;  

  function get_endpoint
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_sbfl_id       flow_subflows.sbfl_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return   flow_types_pkg.t_bpmn_attribute_vc2;  

end flow_settings;
/
