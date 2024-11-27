create or replace view flow_p0008_vw
as
  with user_tasks as (
    select process_id as prcs_id
         , json_objectagg
           (
               key current_obj
               value details_link_target
               absent on null
               returning clob
           ) as user_task_urls
      from flow_apex_my_combined_task_list_vw
     group by process_id
)
  select dgrm_content
       , fid.prcs_id
       , all_completed
       , all_errors
       , all_current
       , dgrm_id
       , calling_dgrm
       , calling_objt
       , breadcrumb
       , drilldown_allowed
       , iteration_data
       , prdg_id
       , prdg_prdg_id
       , usta.user_task_urls
    from flow_instance_details_vw fid
    left join user_tasks usta
      on fid.prcs_id = usta.prcs_id
with read only;
