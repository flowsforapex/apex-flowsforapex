
create or replace view flow_p0002_diagrams_vw
as
  select d.dgrm_id
       , d.dgrm_name
       , d.dgrm_version
       , d.dgrm_status
       , d.dgrm_category
       , d.dgrm_last_update
       , '<button type="button" title="Edit" aria-label="Edit" class="t-Button t-Button--noLabel t-Button--icon" onclick="location.href='''||apex_page.get_url(p_page => 7, p_items => 'P7_DGRM_ID', p_values => d.dgrm_id)||'''"><span aria-hidden="true" class="t-Icon fa fa-pencil"></span></button>'||
         '<button type="button" title="New Version" aria-label="New Version" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || d.dgrm_id || '" data-action="new_version"><span aria-hidden="true" class="t-Icon fa fa-plus"></span></button>'
         as btn
       , coalesce( (select count(*) from flow_instances_vw i where i.dgrm_id = d.dgrm_id), 0 ) as instances 
       , case when coalesce( (select count(*) from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id), 0 ) = 0 then 'No' else 'Yes' end as diagram_parsed
       , case when coalesce( (select count(*) from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id), 0 ) = 0 then 'fa-times-circle-o fa-lg u-danger-text' else 'fa-check-circle-o fa-lg u-success-text' end as diagram_parsed_icon
  from flow_diagrams_vw d
with read only
;
