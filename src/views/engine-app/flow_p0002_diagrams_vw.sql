
create or replace view flow_p0002_diagrams_vw
as
  select d.dgrm_id
       , d.dgrm_name
       , d.dgrm_version
       , d.dgrm_status
       , d.dgrm_category
       , d.dgrm_last_update
       , '<button type="button" title="Edit" aria-label="Edit" class="t-Button t-Button--noLabel t-Button--icon" onclick="location.href='''||apex_page.get_url(p_page => 7, p_items => 'P7_DGRM_ID', p_values => d.dgrm_id)||'''"><span aria-hidden="true" class="t-Icon fa fa-pencil"></span></button>'||
         '<button type="button" title="New Version" aria-label="New Version" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || d.dgrm_id || '" data-action="new_version"><span aria-hidden="true" class="t-Icon fa fa-arrow-circle-o-up"></span></button>'||
         '<button type="button" title="Create instance" aria-label="Create instance" class="t-Button t-Button--noLabel t-Button--icon" onclick="'||apex_page.get_url(p_page => 11, p_items => 'P11_DGRM_ID', p_values => d.dgrm_id)||'"><span aria-hidden="true" class="t-Icon fa fa-plus"></span></button>'
         as btn
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
  from flow_diagrams_vw d
with read only
;
