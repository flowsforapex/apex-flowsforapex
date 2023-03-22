create or replace package flow_db_exec
as 
/* 
-- Flows for APEX - flow_db_exec.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
--
-- Created  08-Dec-2022  Richard Allen (Oracle Corporation)
-- Changed  21-FEB-2023  Moritz Klein (MT GmbH)
--
*/
  c_wrap_vc2_expr_pre       constant flow_types_pkg.t_expr_type := q'#begin :BIND_OUT_VAR := #';
  c_wrap_vc2_expr_post      constant flow_types_pkg.t_expr_type := q'# ; end;#';
  c_wrap_vc2_func_pre       constant flow_types_pkg.t_expr_type := q'#declare function x return varchar2 is begin #';
  c_wrap_vc2_func_post      constant flow_types_pkg.t_expr_type := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';

  c_wrap_num_expr_pre       constant flow_types_pkg.t_expr_type := q'#begin :BIND_OUT_VAR := #';
  c_wrap_num_expr_post      constant flow_types_pkg.t_expr_type := q'# ; end;#';
  c_wrap_num_raw_expr_pre   constant flow_types_pkg.t_expr_type := q'#begin :BIND_OUT_VAR := to_char( #';
  c_wrap_num_raw_expr_post  constant flow_types_pkg.t_expr_type := q'# ) ; end;#';
  c_wrap_num_func_pre       constant flow_types_pkg.t_expr_type := q'#declare function x return varchar2 is begin #';
  c_wrap_num_func_post      constant flow_types_pkg.t_expr_type := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';
  c_wrap_num_raw_func_pre   constant flow_types_pkg.t_expr_type := q'#declare function x return number is begin #';
  c_wrap_num_raw_func_post  constant flow_types_pkg.t_expr_type := q'#return null; end; begin :BIND_OUT_VAR := cast (x as varchar2); end;#';

  c_wrap_date_expr_pre      constant flow_types_pkg.t_expr_type := q'#begin :BIND_OUT_VAR := #';
  c_wrap_date_expr_post     constant flow_types_pkg.t_expr_type := q'#; end;#';
  c_wrap_date_raw_expr_pre  constant flow_types_pkg.t_expr_type := q'#begin :BIND_OUT_VAR := to_char( #';
  c_wrap_date_raw_expr_post constant flow_types_pkg.t_expr_type := q'# ,'#'||flow_constants_pkg.gc_prov_default_date_format||q'#'); end;#';
  c_wrap_date_func_pre      constant flow_types_pkg.t_expr_type := q'#declare function x return varchar2 is begin #';
  c_wrap_date_func_post     constant flow_types_pkg.t_expr_type := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';
  c_wrap_date_raw_func_pre  constant flow_types_pkg.t_expr_type := q'#declare function x return date is begin #';
  c_wrap_date_raw_func_post constant flow_types_pkg.t_expr_type := q'#return null; end; begin :BIND_OUT_VAR := to_char(x, '#'||flow_constants_pkg.gc_prov_default_date_format||q'#'); end;#';

  c_wrap_tstz_expr_pre      constant flow_types_pkg.t_expr_type := q'#begin :BIND_OUT_VAR := #';
  c_wrap_tstz_expr_post     constant flow_types_pkg.t_expr_type := q'#; end;#';
  c_wrap_tstz_raw_expr_pre  constant flow_types_pkg.t_expr_type := q'#begin :BIND_OUT_VAR := to_char( #';
  c_wrap_tstz_raw_expr_post constant flow_types_pkg.t_expr_type := q'# ,'#'||flow_constants_pkg.gc_prov_default_tstz_format||q'#'); end;#';
  c_wrap_tstz_func_pre      constant flow_types_pkg.t_expr_type := q'#declare function x return varchar2 is begin #';
  c_wrap_tstz_func_post     constant flow_types_pkg.t_expr_type := q'#return null; end; begin :BIND_OUT_VAR := x; end;#';
  c_wrap_tstz_raw_func_pre  constant flow_types_pkg.t_expr_type := q'#declare function x return timestamp with time zone is begin #';
  c_wrap_tstz_raw_func_post constant flow_types_pkg.t_expr_type := q'#return null; end; begin :BIND_OUT_VAR := to_char(x, '#'||flow_constants_pkg.gc_prov_default_tstz_format||q'#'); end;#';


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



end flow_db_exec;
/
