create or replace view flow_process_variables_vw
as
  select prov.prov_prcs_id
       , prov.prov_var_name
       , prov.prov_var_type
       , prov.prov_var_vc2
       , prov.prov_var_num
       , prov.prov_var_date
       , prov.prov_var_clob
  from flow_process_variables prov
with read only;
