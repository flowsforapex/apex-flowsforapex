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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_variable_event_timeline_vw annotations
  ( add app     'Flows for APEX'
  , add type    'logging'
  , add content 'Timeline of variable assignments with object and scope context for audit and debugging'
  );

alter view flow_variable_event_timeline_vw modify (lgvr_var_name_uc annotations (add content 'Upper-case variable name for case-insensitive filtering'));
alter view flow_variable_event_timeline_vw modify (lgvr_var_value annotations (add content 'Current value of the variable retrieved as VARCHAR2'));
alter view flow_variable_event_timeline_vw modify (lgvr_objt_name annotations (add content 'Display name of the BPMN object that set the variable'));
whenever sqlerror exit failure
