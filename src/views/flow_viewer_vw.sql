/* 
-- Flows for APEX - flow_viewer_vw.sql
-- 
-- (c) Copyright Hyand Solutions GmbH, 2025.
--
-- Created    Apr-2025 Dennis Amthor, Hyand Solutions GmbH
--
-- NOTE THAT THIS VIEW HAS AN ENTERPRISE EDITION VERSION WHICH INCLUDES COMPLEX
-- PROCESSING TO GENERATE THE ITERATION_DATA COLUMN.
-- ANY CHANGES TO THIS VIEW SHOULD ALSO UPDATE THE ENTERPRISE EDITION VERSION IN ADDITION.
*/
create or replace view flow_viewer_vw
as
with all_completed as ( 
    select sflg.sflg_prcs_id as prcs_id
         , sflg.sflg_dgrm_id as dgrm_id
         , sflg.sflg_diagram_level as diagram_level
         , json_arrayagg(sflg.sflg_objt_id) as bpmn_ids
      from flow_subflow_log sflg
     where sflg.sflg_objt_id not in (   
             select sbfl.sbfl_current
               from flow_subflows sbfl
              where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                and sbfl.sbfl_diagram_level = sflg.sflg_diagram_level
                and sbfl.sbfl_current is not null
           )
     group by sflg.sflg_prcs_id
            , sflg.sflg_dgrm_id
            , sflg.sflg_diagram_level
), all_current as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level 
       , json_arrayagg(sbfl_current) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
   group by sbfl_prcs_id
          , sbfl_dgrm_id
          , sbfl_diagram_level
), all_errors as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level
       , json_arrayagg(sbfl_current) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
     and sbfl_status = 'error'
   group by sbfl_prcs_id
          , sbfl_dgrm_id
          , sbfl_diagram_level
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
       , prdg.prdg_id
       , dgrm.dgrm_content
       , json_object
         (
           key 'current'   value acurr.bpmn_ids
         , key 'completed' value acomp.bpmn_ids
         , key 'error'     value aerr.bpmn_ids
         ) as highlighting_data
       , json_object
         (
           key 'callingDiagramIdentifier' value prdg.prdg_prdg_id
         , key 'callingObjectId'          value prdg.prdg_calling_objt
         , key 'breadcrumb'               value dgrm.dgrm_name || case when prdg.prdg_diagram_level is not null then ' (' || prdg.prdg_diagram_level || ')' else '' end
         , key 'insight'                  value 1
         ) as call_activity_data
       , to_clob(null)       as iteration_data
       , usta.user_task_urls as user_task_data
       , to_clob(null)       as badges_data
    from flow_processes prcs
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = prcs.prcs_id
    join flow_diagrams dgrm
      on prdg.prdg_dgrm_id = dgrm.dgrm_id
    left join all_completed acomp
      on acomp.prcs_id = prcs.prcs_id
     and acomp.dgrm_id = dgrm.dgrm_id
     and acomp.diagram_level =  prdg.prdg_diagram_level
    left join all_current acurr
      on acurr.prcs_id = prcs.prcs_id
     and acurr.dgrm_id = dgrm.dgrm_id
     and acurr.diagram_level =  prdg.prdg_diagram_level
    left join all_errors aerr
      on aerr.prcs_id = prcs.prcs_id
     and aerr.dgrm_id = dgrm.dgrm_id
     and aerr.diagram_level =  prdg.prdg_diagram_level
    left join user_tasks usta
      on prcs.prcs_id = usta.prcs_id
with read only;
