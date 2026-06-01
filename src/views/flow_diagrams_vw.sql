create or replace view flow_diagrams_vw
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_short_description
       , dgrm.dgrm_description
       , dgrm.dgrm_icon
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , case dgrm_status
          when 'draft'      then 'fa fa-wrench'
          when 'released'   then 'fa fa-check'
          when 'deprecated' then 'fa fa-ban'
          when 'archived'   then 'fa fa-archive'
         end as dgrm_status_icon
       , dgrm.dgrm_category
       , dgrm.dgrm_last_update
       , dgrm.dgrm_content
  from flow_diagrams dgrm
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Process diagrams with metadata, status icons, and BPMN XML content'
  );

alter view flow_diagrams_vw modify (dgrm_status_icon annotations (add content 'Font Awesome icon CSS class for the diagram status'));
whenever sqlerror exit failure
