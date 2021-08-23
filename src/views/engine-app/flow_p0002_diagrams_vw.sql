
create or replace view flow_p0002_diagrams_vw
as
 with instance_numbers as
(
  select dgrm_id
       , created_cnt
       , running_cnt
       , completed_cnt
       , terminated_cnt
       , error_cnt
       , created_cnt + running_cnt + completed_cnt + terminated_cnt + error_cnt as total_cnt
    from (select dgrm_id, prcs_status from flow_instances_vw)
   pivot (
     count(*) as cnt
     for prcs_status in ( 'created' as created, 'running' as running, 'completed' as completed, 'terminated' as terminated, 'error' as error ) 
         )
)
  select d.dgrm_id
       , d.dgrm_name
       , d.dgrm_version
       , d.dgrm_status
       , d.dgrm_category
       , d.dgrm_last_update
       , null as btn
       , apex_page.get_url(p_page => 7, p_items => 'P7_DGRM_ID', p_values => d.dgrm_id) as edit_link
       , apex_page.get_url(p_page => 11, p_items => 'P11_DGRM_ID', p_values => d.dgrm_id) as create_instance_link
       , coalesce( inst_nums.total_cnt, 0 ) as instances 
       , case when coalesce( (select count(*) from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id), 0 ) = 0 then 'No' else 'Yes' end as diagram_parsed
       , case when coalesce( (select count(*) from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id), 0 ) = 0 then 'fa-times-circle-o fa-lg u-danger-text' else 'fa-check-circle-o fa-lg u-success-text' end as diagram_parsed_icon
       , case dgrm_status
           when 'draft' then 'fa fa-wrench'
           when 'released' then 'fa fa-check'
           when 'deprecated' then 'fa fa-ban'
           when 'archived' then 'fa fa-archive'
         end as dgrm_status_icon
       , coalesce( inst_nums.created_cnt, 0) as instance_created
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',created', p_clear_cache => 'RP,RIR') as instance_created_link
       , coalesce( inst_nums.running_cnt, 0) as instance_running
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',running', p_clear_cache => 'RP,RIR') as instance_running_link
       , coalesce( inst_nums.completed_cnt, 0) as instance_completed
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',completed', p_clear_cache => 'RP,RIR') as instance_completed_link
       , coalesce( inst_nums.terminated_cnt, 0) as instance_terminated
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',terminated', p_clear_cache => 'RP,RIR') as instance_terminated_link
       , coalesce( inst_nums.error_cnt, 0) as instance_error
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',error', p_clear_cache => 'RP,RIR') as instance_error_link
       , apex_item.checkbox2(p_idx => 1, p_value => d.dgrm_id, p_attributes => 'data-name = "' || dgrm_name || '" data-version = "' || dgrm_version || '"') as checkbox
  from flow_diagrams_vw d
left join instance_numbers inst_nums
       on inst_nums.dgrm_id = d.dgrm_id
with read only
;
