create or replace view flow_instance_details_vw
as
with completed_objects as (
        select distinct sflg.sflg_prcs_id as prcs_id, sflg.sflg_objt_id as objt_id
          from flow_subflow_log sflg
         where sflg.sflg_objt_id not in ( /*select sbfl.sbfl_last_completed
                                              from flow_subflows sbfl
                                             where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                             union*/
                                            select sbfl.sbfl_current
                                              from flow_subflows sbfl
                                             where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                               and sbfl.sbfl_current is not null
                                          )
), all_completed as ( 
    select prcs_id, 
           listagg( objt_id, ':') within group (order by objt_id) as bpmn_ids
    from completed_objects
    group by prcs_id
), last_completed as (         -- remove in v22.1
  select sbfl_prcs_id as prcs_id
       , listagg(sbfl_last_completed, ':') within group ( order by sbfl_last_completed ) as bpmn_ids
    from flow_subflows
   where sbfl_last_completed is not null
group by sbfl_prcs_id
), all_current as (
  select sbfl_prcs_id as prcs_id
       , listagg(sbfl_current, ':') within group ( order by sbfl_current ) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null  -- should this include  "and sbfl_status != 'error' "???
group by sbfl_prcs_id
), all_errors as (
  select sbfl_prcs_id as prcs_id
       , listagg(sbfl_current, ':') within group (order by sbfl_current) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
     and sbfl_status = 'error'
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
         ) as last_completed     -- remove in v22.1
       , ( select acurr.bpmn_ids
             from all_current acurr
            where acurr.prcs_id = prcs.prcs_id
         ) as all_current
       , ( select aerr.bpmn_ids
             from all_errors aerr
            where aerr.prcs_id = prcs.prcs_id
         ) as all_errors
       , ( select prov.prov_var_vc2
             from flow_process_variables prov
            where prov.prov_var_name = 'BUSINESS_REF'
              and prov.prov_var_type = 'VARCHAR2'
              and prov.prov_prcs_id = prcs.prcs_id
         ) as prcs_business_ref
    from flow_processes prcs
    join flow_diagrams dgrm
      on dgrm.dgrm_id = prcs.prcs_dgrm_id
with read only;
