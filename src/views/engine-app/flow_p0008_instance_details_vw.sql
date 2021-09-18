create or replace view flow_p0008_instance_details_vw
as
  select 
       prcs_id,
       prcs_name,
       dgrm_name,
       dgrm_version,
       prcs_status as status,
       prcs_init_ts as initialized_on,
       prcs_last_update as last_update_on,
       prcs_business_ref as business_reference
  from flow_instances_vw
with read only;
