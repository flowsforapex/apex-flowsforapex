/* 
-- Flows for APEX - flow_instance_details_vw.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created    Nov-2020 Moritz Klein,  MT AG
-- Edited  16-Mar-2022 Richard Allen, Oracle Corporation
-- Edited  21-Jun-2024 Dennis Amthor, Hyand Solutions GmbH
--
-- NOTE THAT THIS VIEW HAS AN ENTERPRISE EDITION VERSION WHICH INCLUDES COMPLEX
-- PROCESSING TO GENERATE THE ITERATION_DATA COLUMN.
-- ANY CHANGES TO THIS VIEW SHOULD ALSO UPDATE THE ENTERPRISE EDITION VERSION IN ADDITION.
*/
create or replace view flow_instance_details_vw
as
with completed_objects as (
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
                                             and sbfl.sbfl_status != 'delete on resume'
                                        )
), all_completed as ( 
    select prcs_id, dgrm_id, diagram_level,
           listagg( objt_id, ':') within group (order by objt_id) as bpmn_ids
    from completed_objects
    group by prcs_id, dgrm_id, diagram_level
), all_current as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level 
       , listagg(sbfl_current, ':') within group ( order by sbfl_current ) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null 
     and sbfl_status != 'delete on resume' 
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
), user_tasks as (
    select process_id as prcs_id
         , json_objectagg
           (
               key current_obj
               value details_link_target
               absent on null
               returning clob
           ) as user_task_urls
      from flow_apex_my_combined_task_list_vw
     group by process_id
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
       , usta.user_task_urls
       , to_clob(null) as iteration_data
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
    left join user_tasks usta
      on prcs.prcs_id = usta.prcs_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_instance_details_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Per-diagram-level view for each instance showing current, completed, and error objects with user task URLs'
  );

alter view flow_instance_details_vw modify (prcs_id           annotations (add content 'Process instance identifier'));
alter view flow_instance_details_vw modify (prcs_name         annotations (add content 'Process instance name'));
alter view flow_instance_details_vw modify (prdg_id           annotations (add content 'Instance diagram record for this level'));
alter view flow_instance_details_vw modify (prdg_prdg_id      annotations (add content 'Parent instance diagram record (FK: flow_instance_diagrams)'));
alter view flow_instance_details_vw modify (diagram_level     annotations (add content 'Nesting depth of this diagram within the instance'));
alter view flow_instance_details_vw modify (calling_dgrm      annotations (add content 'Name of the diagram that called this sub-diagram'));
alter view flow_instance_details_vw modify (calling_objt      annotations (add content 'BPMN ID of the call activity that invoked this sub-diagram'));
alter view flow_instance_details_vw modify (breadcrumb        annotations (add content 'Slash-separated path of diagram names from root to this level'));
alter view flow_instance_details_vw modify (drilldown_allowed annotations (add content 'Y if the user may drill into this sub-diagram level'));
alter view flow_instance_details_vw modify (dgrm_content      annotations (add content 'BPMN XML content for this diagram level'));
alter view flow_instance_details_vw modify (all_completed     annotations (add content 'Comma-separated BPMN IDs of all completed objects at this level'));
alter view flow_instance_details_vw modify (last_completed    annotations (add content 'BPMN ID of the most recently completed object'));
alter view flow_instance_details_vw modify (all_current       annotations (add content 'Comma-separated BPMN IDs of all objects currently active'));
alter view flow_instance_details_vw modify (all_errors        annotations (add content 'Comma-separated BPMN IDs of objects currently in error'));
alter view flow_instance_details_vw modify (user_task_urls    annotations (add content 'JSON structure of user task step keys and their APEX page URLs'));
alter view flow_instance_details_vw modify (iteration_data    annotations (add content 'JSON structure describing loop and multi-instance iteration state'));
alter view flow_instance_details_vw modify (prcs_business_ref annotations (add content 'Business reference key value for this instance'));

whenever sqlerror exit failure
