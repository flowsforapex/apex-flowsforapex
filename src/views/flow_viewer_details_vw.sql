/* 
-- Flows for APEX - flow_viewer_details_vw.sql
-- 
-- (c) Copyright Flowquest Limited, 2022.
--
-- Created  23-Jun-2024 Richard Allen Flowquest Limited. 
--
*/
--create or replace view flow_viewer_details_vw
--as



with completed_objects as (
        select distinct sflg.sflg_prcs_id             as prcs_id
                      , sflg.sflg_dgrm_id             as dgrm_id
                      , sflg.sflg_diagram_level       as diagram_level
                      , sflg.sflg_objt_id             as objt_id
                      , sflg.sflg_sbfl_iteration_path as iter_path
                      , sflg.sflg_step_key            as step_key
          from flow_subflow_log sflg
         where sflg.sflg_objt_id not in (   
                                          select sbfl.sbfl_current
                                            from flow_subflows sbfl
                                           where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                             and sbfl.sbfl_diagram_level = sflg.sflg_diagram_level
                                             and sbfl.sbfl_iteration_path = sflg.sflg_sbfl_iteration_path
                                             and sbfl.sbfl_current is not null
                                        )
), all_completed as ( 
    select prcs_id, dgrm_id, diagram_level, iter_path,
           listagg( objt_id, ':') within group (order by objt_id) as bpmn_ids
    from completed_objects
    group by prcs_id, dgrm_id, diagram_level, iter_path
), all_current as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level 
       , sbfl_iteration_path as iter_path
       , listagg(sbfl_current, ':') within group ( order by sbfl_current ) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null  
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level, sbfl_iteration_path
), all_errors as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level
       , sbfl_iteration_path as iter_path
       , listagg(sbfl_current, ':') within group (order by sbfl_current) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
     and sbfl_status = 'error'
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level, sbfl_iteration_path
), iteration_paths as (
select i.iobj_prcs_id as prcs_id
     , i.iobj_parent_bpmn_id
     , i.iobj_iteration_var
     , i.iobj_var_scope
     , i.iobj_step_key
     , iter.stepKey iteration_step_key
     , iter.loopCounter loopCounter
     , iter.description description
--     , iav.prov_var_json
     , iter.iteration_path as iter_path
     , iter.status
from   flow_iterated_objects i 
join   flow_process_variables iav
on     i.iobj_prcs_id       = iav.prov_prcs_id
and    i.iobj_iteration_var = iav.prov_var_name
and    i.iobj_var_scope     = iav.prov_scope
and    iav.prov_var_type = 'JSON'
join   json_table (iav.prov_var_json, '$[*]' 
       columns 
           ( Iteration_path varchar2(50) path '$.iterationPath',
             status         varchar2(20) path '$.status',
             loopCounter    number       path '$.loopCounter',
             description    varchar2(80) path '$.description',
             stepKey        varchar2(20) path '$.stepKey'
           )) iter
   on  1=1
--UNION ALL
--select prcs_id as prcs_id
--     , null, null, null, null, null, null, 'Main', null, prcs_status
--  from flow_processes 
) 
  select prcs.prcs_id
       , prcs.prcs_name
       , prdg.prdg_id
       , prdg.prdg_prdg_id
       , prdg.prdg_diagram_level as diagram_level
       , ip.iter_path
       , prdg.prdg_calling_dgrm as calling_dgrm
       , prdg.prdg_calling_objt as calling_objt
       , dgrm.dgrm_name || case when prdg.prdg_diagram_level is not null then ' ( Level: ' || prdg.prdg_diagram_level || ' )' else '' end as breadcrumb
       , 1 as drilldown_allowed
       , dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
--       , dgrm.dgrm_content
       , ( select acomp.bpmn_ids
             from all_completed acomp
            where acomp.prcs_id = prcs.prcs_id
              and acomp.dgrm_id = dgrm.dgrm_id
              and acomp.diagram_level =  prdg.prdg_diagram_level
              and ((acomp.iter_path = ip.iter_path and ip.iter_path is not null ) or (ip.iter_path is null and acomp.iter_path is null))
         ) as all_completed
       , null as last_completed     -- remove in v22.1
       , ( select acurr.bpmn_ids
             from all_current acurr
            where acurr.prcs_id = prcs.prcs_id
              and acurr.dgrm_id = dgrm.dgrm_id
              and acurr.diagram_level =  prdg.prdg_diagram_level
              and ((acurr.iter_path = ip.iter_path and ip.iter_path is not null ) or (ip.iter_path is null and acurr.iter_path is null))
         ) as all_current
       , ( select aerr.bpmn_ids
             from all_errors aerr
            where aerr.prcs_id = prcs.prcs_id
              and aerr.dgrm_id = dgrm.dgrm_id
              and aerr.diagram_level =  prdg.prdg_diagram_level
              and ((aerr.iter_path = ip.iter_path and ip.iter_path is not null ) or (ip.iter_path is null and aerr.iter_path is null))
         ) as all_errors
       , prov.prov_var_vc2 as prcs_business_ref
    from flow_processes prcs
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = prcs.prcs_id
    join flow_diagrams dgrm
      on prdg.prdg_dgrm_id = dgrm.dgrm_id
    join iteration_paths ip
      on ip.prcs_id = prcs.prcs_id
    left join flow_process_variables prov
      on prov.prov_prcs_id  = prcs.prcs_id
     and prov.prov_var_name = 'BUSINESS_REF'
     and prov.prov_var_type = 'VARCHAR2'
     and prov.prov_scope    = 0
     where prcs.prcs_id = 8416;


