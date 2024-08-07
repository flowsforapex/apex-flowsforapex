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
                  , sflg.sflg_sbfl_iteration_path as iter_path
                  , sflg.sflg_objt_id as objt_id
      from flow_subflow_log sflg
     where sflg.sflg_objt_id not in (   
                                      select sbfl.sbfl_current
                                        from flow_subflows sbfl
                                       where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                         and sbfl.sbfl_diagram_level = sflg.sflg_diagram_level
                                         and sbfl.sbfl_iteration_path = sflg.sflg_sbfl_iteration_path
                                         and sbfl.sbfl_current is not null
                                    )
       and sflg.sflg_sbfl_iteration_path is not null
), iter_comp as (
  select prcs_id, dgrm_id, diagram_level, iter_path
      , json_arrayagg( objt_id order by objt_id returning varchar2(2000)) as bpmn_ids
    from iter_comp_steps
   group by prcs_id, dgrm_id, diagram_level, iter_path
),iter_current as (
    select sbfl_prcs_id as prcs_id
         , sbfl_dgrm_id as dgrm_id
         , sbfl_diagram_level as diagram_level 
         , sbfl_iteration_path as iter_path
         , json_arrayagg(sbfl_current order by sbfl_current returning varchar2(2000)) as bpmn_ids
      from flow_subflows
     where sbfl_current is not null  
       and sbfl_iteration_path is not null
  group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level, sbfl_iteration_path
), iter_errors as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level
       , sbfl_iteration_path as iter_path
       , json_arrayagg(sbfl_current order by sbfl_current returning varchar2(2000)) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
     and sbfl_status = 'error'
     and sbfl_iteration_path is not null
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level, sbfl_iteration_path
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
           and sflg.sflg_sbfl_iteration_path is null
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
), iter_arrays as (        -----  gets the iteration arrays from the process's process variables
select it.fita_parent_bpmn_id object_id
     , it.fita_step_key step_key
     , it.fita_diagram_level diagram_level
     , it.fita_dgrm_id  dgrm_id
     , pv.prov_var_json iter_array
     , it.fita_prcs_id prcs_id
  from flow_process_variables pv
  join flow_iterations it
    on pv.prov_prcs_id = it.fita_prcs_id
   and pv.prov_scope   = it.fita_var_scope
   and pv.prov_var_name = it.fita_iteration_var
   and pv.prov_var_type = 'JSON'
), iter_lines as (         -- gets all the components out of the iteration arrays that we need
select i.object_id
     , i.diagram_level
     , i.dgrm_id
     , jt.stepKey
     , jt.loopCounter
     , jt.description
     , jt.status
     , jt.iterationPath
     , i.prcs_id
  from iter_arrays i,
       json_table (i.iter_array, '$[*]'
         columns (
            loopCounter number path '$.loopCounter',
            description varchar2(150) path '$.description',
            stepKey varchar2(20) path '$.stepKey',
            status  varchar2(20) path '$.status', 
            iterationPath varchar2(2000) path '$.iterationPath'
            )) as jt
--  where jt.iterationPath is not null
), iteration_objt_status as (      ---- puts the json together again for iteration objects
       select json_object( 'stepKey'        value il.stepKey
                         , 'loopCounter'    value il.loopCounter
                         , 'description'    value il.description 
                         , 'iterationPath'  value il.iterationPath
                         , 'status'         value il.status
                         , 'highlighting'     value json_object 
                           ( 'completed'      value icomp.bpmn_ids 
                           , 'current'        value icurr.bpmn_ids 
                           , 'errors'         value ierr.bpmn_ids absent on null
                          returning varchar2(4000))
                          format json returning CLOB)  
                          iteration_info
            , il.prcs_id
            , il.object_id
            , il.diagram_level
            , il.dgrm_id
            , il.iterationPath
            , il.loopCounter
         from iter_lines il
         left join iter_comp icomp    
           on il.prcs_id       = icomp.prcs_id 
          and il.dgrm_id       = icomp.dgrm_id  
          and il.diagram_level = icomp.diagram_level
          and il.iterationPath = icomp.iter_path
         left join iter_current icurr   
           on il.prcs_id       = icurr.prcs_id 
          and il.dgrm_id       = icurr.dgrm_id  
          and il.diagram_level = icurr.diagram_level    
          and il.iterationPath = icurr.iter_path      
         left join iter_errors ierr   
           on il.prcs_id       = ierr.prcs_id 
          and il.dgrm_id       = ierr.dgrm_id  
          and il.diagram_level = ierr.diagram_level
          and il.iterationPath = ierr.iter_path             
), iter_info as (
  select json_arrayagg (os.iteration_info order by os.loopCounter returning clob)  iter_info_json
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

    
