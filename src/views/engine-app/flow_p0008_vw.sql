create or replace view flow_p0008_vw
as
  select dgrm_content
       , prcs_id
       , all_completed
       , all_errors
       , all_current
       , dgrm_id
       , calling_dgrm
       , calling_objt
       , breadcrumb
       , sub_prcs_insight
    from flow_instance_details_vw
with read only;
