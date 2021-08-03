
create or replace view flow_p0002_diagrams_vw
as
  select d.dgrm_id
       , d.dgrm_name
       , d.dgrm_version
       , d.dgrm_status
       , d.dgrm_category
       , d.dgrm_last_update
       , null as btn
       , apex_page.get_url(p_page => 7, p_items => 'P7_DGRM_ID', p_values => d.dgrm_id) as edit_link
       , apex_page.get_url(p_page => 11, p_items => 'P11_DGRM_ID', p_values => d.dgrm_id) as create_instance_link
       , coalesce( (select count(*) from flow_instances_vw i where i.dgrm_id = d.dgrm_id), 0 ) as instances 
       , case when coalesce( (select count(*) from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id), 0 ) = 0 then 'No' else 'Yes' end as diagram_parsed
       , case when coalesce( (select count(*) from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id), 0 ) = 0 then 'fa-times-circle-o fa-lg u-danger-text' else 'fa-check-circle-o fa-lg u-success-text' end as diagram_parsed_icon
       , null as instances_badges
       , ( select count(*) from flow_instances_vw ins where ins.dgrm_id = d.dgrm_id and prcs_status = 'created') as instance_created
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',created', p_clear_cache => 'RP,RIR') as instance_created_link
       , ( select count(*) from flow_instances_vw ins where ins.dgrm_id = d.dgrm_id and prcs_status = 'running') as instance_running
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',running', p_clear_cache => 'RP,RIR') as instance_running_link
       , ( select count(*) from flow_instances_vw ins where ins.dgrm_id = d.dgrm_id and prcs_status = 'completed') as instance_completed
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',completed', p_clear_cache => 'RP,RIR') as instance_completed_link
       , ( select count(*) from flow_instances_vw ins where ins.dgrm_id = d.dgrm_id and prcs_status = 'terminated') as instance_terminated
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',terminated', p_clear_cache => 'RP,RIR') as instance_terminated_link
       , ( select count(*) from flow_instances_vw ins where ins.dgrm_id = d.dgrm_id and prcs_status = 'error') as instance_error
       , apex_page.get_url(p_page => 10, p_items => 'IR_PRCS_DGRM_NAME,IR_PRCS_DGRM_VERSION,IR_PRCS_STATUS', p_values => dgrm_name||','||dgrm_version||',error', p_clear_cache => 'RP,RIR') as instance_error_link
       , apex_item.checkbox2(p_idx => 1, p_value => d.dgrm_id) as checkbox
  from flow_diagrams_vw d
with read only
;
