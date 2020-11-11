create or replace view flow_instance_variables_vw
as
  select prov.prov_prcs_id
       , prov.prov_var_name
       , prov.prov_var_type
       , prov.prov_var_vc2
       , prov.prov_var_num
       , prov.prov_var_date
       , prov.prov_var_clob
       , prcs.prcs_name
       , prcs.prcs_status
    from flow_process_variables prov
    join flow_processes prcs
      on prcs.prcs_id = prov.prov_prcs_id
with read only;
