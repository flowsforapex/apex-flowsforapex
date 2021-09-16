create or replace view flow_p0013_expressions_vw
as
  select objt.objt_bpmn_id
       , expr.expr_set
       , expr.expr_var_name
       , expr.expr_var_type
       , expr.expr_type
       , expr.expr_expression
       , prcs.prcs_id
       , case when instr(expr.expr_type, 'sql') > 0 then '<pre><code class="language-' || case when instr(expr.expr_type, 'plsql') > 0 then 'plsql' else 'sql' end ||'">' end as pretag
       , case when instr(expr.expr_type, 'sql') > 0 then '</code></pre>' end as posttag
    from flow_object_expressions expr
    join flow_objects objt
      on expr.expr_objt_id = objt.objt_id
    join flow_processes prcs
      on objt.objt_dgrm_id = prcs.prcs_dgrm_id
with read only;
