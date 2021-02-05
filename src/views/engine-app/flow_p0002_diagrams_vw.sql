
create or replace view flow_p0002_diagrams_vw
as
  select d.dgrm_id
       , d.dgrm_name
       , d.dgrm_version
       , d.dgrm_status
       , d.dgrm_category
       , d.dgrm_last_update
       , '<button type="button" title="View" aria-label="View" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || d.dgrm_id || '" data-action="dgrm_view"><span aria-hidden="true" class="t-Icon fa fa-eye"></span></button>'||
           case d.dgrm_status when 'draft' then '<button type="button" title="Edit" aria-label="Edit" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || d.dgrm_id || '" data-action="dgrm_edit"><span aria-hidden="true" class="t-Icon fa fa-pencil"></span></button>' end||
           '<button type="button" title="Create instance" aria-label="Create instance" class="t-Button t-Button--noLabel t-Button--icon" onclick="'||apex_page.get_url(p_page => 11, p_items => 'P11_DGRM_ID', p_values => d.dgrm_id)||'"><span aria-hidden="true" class="t-Icon fa fa-plus"></span></button>'||
           case d.dgrm_status when 'draft' then '<button type="button" title="Release" aria-label="Release" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || d.dgrm_id || '" data-action="dgrm_release"><span aria-hidden="true" class="t-Icon fa fa-check"></span></button>' end||
           case d.dgrm_status when 'released' then '<button type="button" title="Deprecate" aria-label="Deprecate" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || d.dgrm_id || '" data-action="dgrm_deprecate"><span aria-hidden="true" class="t-Icon fa fa-ban"></span></button>' end||
           case d.dgrm_status when 'deprecated' then '<button type="button" title="Archive" aria-label="Archive" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || d.dgrm_id || '" data-action="dgrm_archive"><span aria-hidden="true" class="t-Icon fa fa-archive"></span></button>' end
         as btn
       , coalesce( (select count(*) from flow_instances_vw i where i.dgrm_id = d.dgrm_id), 0 ) as instances 
  from flow_diagrams_vw d
 where exists ( select null from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id )
with read only
;
