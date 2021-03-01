create or replace view flow_instance_details_vw
as
with all_completed as (
  select sflg.sflg_prcs_id as prcs_id
       , listagg(sflg.sflg_objt_id, ':') within group (order by sflg.sflg_objt_id) as bpmn_ids
    from flow_subflow_log sflg
   where sflg.sflg_objt_id not in ( select sbfl.sbfl_last_completed
                                      from flow_subflows sbfl
                                     where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                     union
                                    select sbfl.sbfl_current
                                      from flow_subflows sbfl
                                     where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                       and sbfl.sbfl_current is not null
                                  )
group by sflg.sflg_prcs_id
), last_completed as (
  select sbfl_prcs_id as prcs_id
       , listagg(sbfl_last_completed, ':') within group ( order by sbfl_last_completed ) as bpmn_ids
    from flow_subflows
   where sbfl_last_completed is not null
group by sbfl_prcs_id
), all_current as (
  select sbfl_prcs_id as prcs_id
       , listagg(sbfl_current, ':') within group ( order by sbfl_current ) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
group by sbfl_prcs_id
)
  select prcs.prcs_id
       , prcs.prcs_name
       , dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
       , dgrm.dgrm_content
       , ( select acomp.bpmn_ids
             from all_completed acomp
            where acomp.prcs_id = prcs.prcs_id
         ) as all_completed
       , ( select lcomp.bpmn_ids
             from last_completed lcomp
            where lcomp.prcs_id = prcs.prcs_id
         ) as last_completed
       , ( select acurr.bpmn_ids
             from all_current acurr
            where acurr.prcs_id = prcs.prcs_id
         ) as all_current
    from flow_processes prcs
    join flow_diagrams dgrm
      on dgrm.dgrm_id = prcs.prcs_dgrm_id
with read only;
