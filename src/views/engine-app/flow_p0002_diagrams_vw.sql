
create or replace view flow_p0002_diagrams_vw
as
  select d.dgrm_id
       , d.dgrm_name
       , d.dgrm_version
       , d.dgrm_status
       , d.dgrm_category
       , d.dgrm_last_update
       , '<button type="button" title="Edit" aria-label="Edit" class="t-Button t-Button--noLabel t-Button--icon" onclick="location.href='''||apex_page.get_url(p_page => 7, p_items => 'P7_DGRM_ID', p_values => d.dgrm_id)||'''"><span aria-hidden="true" class="t-Icon fa fa-pencil"></span></button>'||
          '<button type="button" title="Model" aria-label="Model" class="t-Button t-Button--noLabel t-Button--icon" onclick="location.href='''||apex_page.get_url(p_page => 4, p_items => 'P4_DGRM_ID', p_values => d.dgrm_id)||'''" '||case when d.dgrm_status != 'draft' then 'disabled' end||'><span aria-hidden="true" class="t-Icon fa fa-apex"></span></button>' ||
          '<button type="button" title="Export" aria-label="Export" class="t-Button t-Button--noLabel t-Button--icon" onclick="'||apex_page.get_url(p_page => 5, p_items => 'P5_DGRM_ID', p_values => d.dgrm_id)||'"><span aria-hidden="true" class="t-Icon fa fa-download"></span></button>'
         as btn
       , coalesce( (select count(*) from flow_instances_vw i where i.dgrm_id = d.dgrm_id), 0 ) as instances 
       , case when coalesce( (select count(*) from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id), 0 ) = 0 then 'No' else 'Yes' end as diagram_parsed
  from flow_diagrams_vw d
with read only
;
