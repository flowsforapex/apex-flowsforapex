create or replace view flow_p0013_expressions_vw
as
  select objt.objt_bpmn_id
       , expr.expr_set
       , expr.expr_var_name
       , expr.expr_var_type
       , expr.expr_type
       , expr.expr_expression
       , objt.objt_dgrm_id
       , case when instr(expr.expr_type, 'sql') > 0 then '<pre><code class="language-' || case when instr(expr.expr_type, 'plsql') > 0 then 'plsql' else 'sql' end ||'">' end as pretag
       , case when instr(expr.expr_type, 'sql') > 0 then '</code></pre>' end as posttag
    from flow_object_expressions expr
    join flow_objects objt
      on expr.expr_objt_id = objt.objt_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0013_expressions_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Step expression definitions with SQL syntax highlighting tags for the debug panel in engine app page 13'
  )]';
    execute immediate q'[alter view flow_p0013_expressions_vw modify (pretag annotations (add content 'HTML pre/code open tag with SQL or PL/SQL syntax highlighting class'))]';
    execute immediate q'[alter view flow_p0013_expressions_vw modify (posttag annotations (add content 'HTML pre/code close tag for expression code display'))]';
  end if;
end;
/

whenever sqlerror exit failure
