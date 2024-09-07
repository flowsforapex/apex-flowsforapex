/* 
-- Flows for APEX - flow_instance_details_vw.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
-- (c) Copyright Flowquest Limited and / or its affiliates, 2024.
--
-- Created    Nov-2020 Moritz Klein,  MT AG
-- Edited  16-Mar-2022 Richard Allen, Oracle Corporation  
-- Rewritten  5-Aug-24 Richard Allen Flowquest Limited
*/
create or replace view flow_instance_details_vw
as
with iter_comp_steps as (
    select distinct sflg.sflg_prcs_id as prcs_id
                  , sflg.sflg_dgrm_id  as dgrm_id
                  , sflg.sflg_diagram_level as diagram_level
                  , sflg.sflg_iter_id as iter_id
                  , sflg.sflg_objt_id as objt_id
      from flow_subflow_log sflg
     where sflg.sflg_objt_id not in (   
                                      select sbfl.sbfl_current
                                        from flow_subflows sbfl
                                       where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                         and sbfl.sbfl_diagram_level = sflg.sflg_diagram_level
                                         and sbfl.sbfl_iter_id = sflg.sflg_iter_id
                                         and sbfl.sbfl_current is not null
                                    )
       and sflg.sflg_iter_id is not null
), iter_comp as (
  select prcs_id, dgrm_id, diagram_level, iter_id
      , json_arrayagg( objt_id order by objt_id returning varchar2(2000)) as bpmn_ids
    from iter_comp_steps
   group by prcs_id, dgrm_id, diagram_level, iter_id
)
,iter_current as (
    select sbfl.sbfl_prcs_id as prcs_id
         , sbfl.sbfl_dgrm_id as dgrm_id
         , sbfl.sbfl_diagram_level as diagram_level 
         , sbfl.sbfl_iter_id as iter_id
         , json_arrayagg(sbfl.sbfl_current order by sbfl.sbfl_current returning varchar2(2000)) as bpmn_ids
      from flow_subflows   sbfl
      join flow_iterations iter
        on sbfl.sbfl_iter_id = iter.iter_id
     where sbfl.sbfl_current is not null  
       and sbfl.sbfl_iter_id is not null
       and (   sbfl.sbfl_iobj_id is null
           or  sbfl.sbfl_iobj_id != iter.iter_iobj_id )
  group by sbfl.sbfl_prcs_id, sbfl.sbfl_dgrm_id, sbfl.sbfl_diagram_level, sbfl.sbfl_iter_id
), iter_errors as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level
       , sbfl_iter_id as iter_id
       , json_arrayagg(sbfl_current order by sbfl_current returning varchar2(2000)) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
     and sbfl_status = 'error'
     and sbfl_iter_id is not null
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level, sbfl_iter_id
), completed_objects as (
        select distinct sflg.sflg_prcs_id as prcs_id
                      , sflg.sflg_dgrm_id  as dgrm_id
                      , sflg.sflg_diagram_level as diagram_level
                      , sflg.sflg_objt_id as objt_id
          from flow_subflow_log sflg
         where sflg.sflg_objt_id not in (   
                                          select sbfl.sbfl_current
                                            from flow_subflows sbfl
                                           where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                             and sbfl.sbfl_diagram_level = sflg.sflg_diagram_level
                                             and sbfl.sbfl_current is not null
                                        )
           --and sflg.sflg_iter_id is null ------------------------------------------
), all_completed as ( 
    select prcs_id, dgrm_id, diagram_level
         , listagg( objt_id, ':') within group (order by objt_id) as bpmn_ids
      from completed_objects
    group by prcs_id, dgrm_id, diagram_level
), all_current as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level 
       , listagg(sbfl_current, ':') within group ( order by sbfl_current ) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null  
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level
), all_errors as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level
       , listagg(sbfl_current, ':') within group (order by sbfl_current) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
     and sbfl_status = 'error'
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level
), iterations as (
select child_iobj.iobj_prcs_id         prcs_id
     , child_iobj.iobj_parent_bpmn_id
     , parent_iter.iter_step_key       parent_step_key
     , child_iobj.iobj_diagram_level
     , child_iobj.iobj_dgrm_id
     , child_iter.iter_id
     , child_iter.iter_step_Key
     , child_iter.iter_loop_Counter
     , child_iter.iter_description
     , child_iter.iter_status
     , child_iter.iter_display_name
  from flow_iterations child_iter
  join flow_iterated_objects child_iobj
    on child_iter.iter_iobj_id = child_iobj.iobj_id
  left join flow_iterations parent_iter
    on child_iobj.iobj_parent_iter_id = parent_iter.iter_id
), iteration_objt_status as (      ---- puts the json together again for iteration objects
       select json_object( 'stepKey'        value il.iter_step_Key
                         , 'loopCounter'    value il.iter_loop_Counter
                         , 'description'    value il.iter_description 
                         , 'parentStepKey'  value il.parent_step_key
                         , 'iterationPath'  value il.iter_display_name
                         , 'status'         value il.iter_status
                         , 'highlighting'     value json_object 
                           ( 'completed'      value icomp.bpmn_ids 
                           , 'current'        value icurr.bpmn_ids 
                           , 'errors'         value ierr.bpmn_ids absent on null
                          returning varchar2(4000))
                          format json returning CLOB)  
                          iteration_info
            , il.prcs_id              prcs_id
            , il.iobj_parent_bpmn_id  object_id
            , il.iobj_diagram_level   diagram_level
            , il.iobj_dgrm_id         dgrm_id
            , il.iter_display_name
            , il.iter_loop_Counter    loop_counter
         from iterations il
         left join iter_comp icomp    
           on il.prcs_id            = icomp.prcs_id 
          and il.iobj_dgrm_id       = icomp.dgrm_id  
          and il.iobj_diagram_level = icomp.diagram_level
          and il.iter_id            = icomp.iter_id
         left join iter_current icurr   
           on il.prcs_id            = icurr.prcs_id 
          and il.iobj_dgrm_id       = icurr.dgrm_id  
          and il.iobj_diagram_level = icurr.diagram_level    
          and il.iter_id            = icurr.iter_id      
         left join iter_errors ierr   
           on il.prcs_id            = ierr.prcs_id 
          and il.iobj_dgrm_id       = ierr.dgrm_id  
          and il.iobj_diagram_level = ierr.diagram_level
          and il.iter_id            = ierr.iter_id             
), iter_info as (
  select json_arrayagg (os.iteration_info order by os.loop_Counter returning clob)  iter_info_json
       , os.prcs_id
       , os.dgrm_id
       , os.diagram_level
       , os.object_id
    from iteration_objt_status os
   group by os.prcs_id, os.dgrm_id, os.diagram_level, os.object_id
)
  select prcs.prcs_id
       , prcs.prcs_name
       , prdg.prdg_id
       , prdg.prdg_prdg_id
       , prdg.prdg_diagram_level as diagram_level
       , prdg.prdg_calling_dgrm as calling_dgrm
       , prdg.prdg_calling_objt as calling_objt
       , dgrm.dgrm_name || case when prdg.prdg_diagram_level is not null then ' ( Level: ' || prdg.prdg_diagram_level || ' )' else '' end as breadcrumb
       , 1 as drilldown_allowed
       , dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
       , dgrm.dgrm_content  
       , ( select acomp.bpmn_ids
             from all_completed acomp
            where acomp.prcs_id = prcs.prcs_id
              and acomp.dgrm_id = dgrm.dgrm_id
              and acomp.diagram_level =  prdg.prdg_diagram_level
         ) as all_completed
       , null as last_completed     -- remove in v22.1
       , ( select acurr.bpmn_ids
             from all_current acurr
            where acurr.prcs_id = prcs.prcs_id
              and acurr.dgrm_id = dgrm.dgrm_id
              and acurr.diagram_level =  prdg.prdg_diagram_level
         ) as all_current
       , ( select aerr.bpmn_ids
             from all_errors aerr
            where aerr.prcs_id = prcs.prcs_id
              and aerr.dgrm_id = dgrm.dgrm_id
              and aerr.diagram_level =  prdg.prdg_diagram_level
         ) as all_errors
       , ( select json_objectagg (object_id value iter_info_json format json returning clob)
             from iter_info iter
            where iter.prcs_id = prcs.prcs_id
              and iter.dgrm_id = dgrm.dgrm_id
              and iter.diagram_level =  prdg.prdg_diagram_level
         ) as iteration_data
       , prov.prov_var_vc2 as prcs_business_ref
    from flow_processes prcs
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = prcs.prcs_id
    join flow_diagrams dgrm
      on prdg.prdg_dgrm_id = dgrm.dgrm_id
    left join flow_process_variables prov
      on prov.prov_prcs_id  = prcs.prcs_id
     and prov.prov_var_name = 'BUSINESS_REF'
     and prov.prov_var_type = 'VARCHAR2'
     and prov.prov_scope    = 0
     with read only;

    
