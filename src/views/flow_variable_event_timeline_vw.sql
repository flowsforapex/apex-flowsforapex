create or replace view flow_variable_event_timeline_vw as
with instance_dgrms as (
  select distinct prdg_prcs_id prcs_id, prdg_dgrm_id dgrm_id
  from flow_instance_diagrams
)
select lgvr_prcs_id
     , lgvr_var_name
     , upper(lgvr_var_name) as lgvr_var_name_uc
     , lgvr_scope
     , lgvr_var_type
     , flow_proc_vars_int.get_var_as_vc2 ( pi_prcs_id => lgvr_prcs_id, 
                                           pi_var_name => lgvr_var_name, 
                                           pi_scope => lgvr_scope) as lgvr_var_value 
     , lgvr_objt_id
     , (select coalesce(objt_name, objt_bpmn_id) 
          from flow_objects objt
         where objt.objt_bpmn_id = lgvr_objt_id
           and objt.objt_dgrm_id in (select dgrm_id 
                                      from instance_dgrms 
                                     where prcs_id = lgvr_prcs_id)
       ) as lgvr_objt_name
     , lgvr_sbfl_id
     , lgvr_expr_set
     , lgvr_timestamp
     , lgvr_user
  from flow_variable_event_log
  order by lgvr_timestamp
with read only;
