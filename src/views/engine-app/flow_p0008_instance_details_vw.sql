create or replace view flow_p0008_instance_details_vw
as
  select 
       prcs_id,
       prcs_name,
       dgrm_name,
       dgrm_short_description,
       dgrm_version,
       prcs_status as status,
       prcs_priority as priority,
       prcs_init_ts at time zone sessiontimezone as initialized_on,
       prcs_last_update at time zone sessiontimezone as last_update_on,
       prcs_due_on at time zone sessiontimezone as due_on,
       prcs_business_ref as business_reference,
       prcs_was_altered as was_altered
  from flow_instances_vw
with read only;
