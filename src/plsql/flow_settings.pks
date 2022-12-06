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



  function get_due_date
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_expr          flow_objects.objt_attributes%type
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return timestamp with time zone;

  function get_priority
  ( pi_prcs_id       flow_processes.prcs_id%type
  , pi_expr          flow_types_pkg.t_bpmn_attribute_vc2
  , pi_scope         flow_subflows.sbfl_scope%type default 0
  ) return flow_processes.prcs_priority%type;

end flow_settings;