
create or replace view flow_p0002_diagrams_vw
as
  select 
    dgrm_id
    , dgrm_name
    , dgrm_version
    , dgrm_status
    , dgrm_category
    , dgrm_last_update
    , '<button type="button" title="View" aria-label="View" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || dgrm_id || '" data-action="dgrm_view"><span aria-hidden="true" class="t-Icon fa fa-eye"></span></button>'||
      case dgrm_status when 'draft' then '<button type="button" title="Edit" aria-label="Edit" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || dgrm_id || '" data-action="dgrm_edit"><span aria-hidden="true" class="t-Icon fa fa-pencil"></span></button>' end||
      '<button type="button" title="New version" aria-label="New version" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || dgrm_id || '" data-action="dgrm_new_version"><span aria-hidden="true" class="t-Icon fa fa-plus"></span></button>'||
      case dgrm_status when 'draft' then '<button type="button" title="Release" aria-label="Release" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || dgrm_id || '" data-action="dgrm_release"><span aria-hidden="true" class="t-Icon fa fa-check"></span></button>' end||
      case dgrm_status when 'released' then '<button type="button" title="Deprecate" aria-label="Deprecate" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || dgrm_id || '" data-action="dgrm_deprecate"><span aria-hidden="true" class="t-Icon fa fa-ban"></span></button>' end||
      case dgrm_status when 'deprecated' then '<button type="button" title="Archive" aria-label="Archive" class="clickable-action t-Button t-Button--noLabel t-Button--icon" data-dgrm="' || dgrm_id || '" data-action="dgrm_archive"><span aria-hidden="true" class="t-Icon fa fa-archive"></span></button>' end
    as btn,
    case when max(dgrm_version) over (partition by dgrm_name) = dgrm_version then 'Y' else 'N' end as last_version
  from flow_diagrams_vw
with read only
;
