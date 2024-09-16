create or replace view flow_p0010_vw
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
       , drilldown_allowed
       , prdg_id
       , prdg_prdg_id
       , user_task_urls
    from flow_instance_details_vw
with read only;
