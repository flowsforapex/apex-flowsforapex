create or replace view flow_p0010_variables_vw
as
  select prov_prcs_id
       , prov_var_name
       , prov_var_type
       , prov_var_vc2
       , prov_var_num
       , prov_var_date
       , prov_var_clob
    from flow_instance_variables_vw
with read only;
