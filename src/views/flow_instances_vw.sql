create or replace view flow_instances_vw
as
  select prcs.prcs_id
       , prcs.prcs_name
       , dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
       , prcs.prcs_status
       , prcs.prcs_init_ts
       , prcs.prcs_last_update
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
