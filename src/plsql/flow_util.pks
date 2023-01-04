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
  , pi_sbfl_id        flow_subflows.sbfl_id%type default null
  , pi_sql_text       varchar2
  , pi_result_type    varchar2  
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_expr_type      flow_types_pkg.t_expr_type
  ) return flow_proc_vars_int.t_proc_var_value;

  function exec_flows_plsql
  ( pi_prcs_id        flow_processes.prcs_id%type
  , pi_sbfl_id        flow_subflows.sbfl_id%type default null
  , pi_plsql_text     varchar2
  , pi_result_type    varchar2  
  , pi_scope          flow_subflows.sbfl_scope%type
  , pi_expr_type      flow_types_pkg.t_expr_type
  ) return flow_proc_vars_int.t_proc_var_value;

  -- pi_expr_type    = flow_constants_pkg.gc_expr_type_plsql_function_body 
  --                 = flow_constants_pkg.gc_expr_type_plsql_raw_function_body
  --                 = flow_constants_pkg.gc_expr_type_plsql_expression
  --                 = flow_constants_pkg.gc_expr_type_plsql_raw_expression

end flow_util;