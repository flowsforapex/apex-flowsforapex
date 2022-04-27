/* 
-- Flows for APEX - flow_usertask_pkg.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2020-2022.
--
-- Created 12-Nov-2020  Moritz Klein ( MT AG) 
-- Edited  13-Apr-2022 - Richard Allen (Oracle)
--
*/

create or replace package flow_usertask_pkg
  authid definer
as

  function get_url
  (
    pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  , pi_objt_id in flow_objects.objt_id%type
  , pi_step_key in flow_subflows.sbfl_step_key%type default null
  , pi_scope    in flow_subflows.sbfl_scope%type default 0
  ) return varchar2;

end flow_usertask_pkg;
/
