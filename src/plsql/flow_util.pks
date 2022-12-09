create or replace package flow_util
as 
/* 
-- Flows for APEX - flow_util.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created  08-Dec-2022  Richard Allen (Oracle Corporation)
--
*/
  function exec_flows_sql
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type
  , pi_sql_text       varchar2
  , pi_result_type    varchar2  
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_is_multi       boolean default false
  ) return flow_proc_vars_int.t_proc_var_value;


end flow_util;