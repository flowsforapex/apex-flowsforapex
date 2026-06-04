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
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Process diagrams with metadata, status icons, and BPMN XML content'
  )]';
    execute immediate q'[alter view flow_diagrams_vw modify (dgrm_status_icon annotations (add content 'Font Awesome icon CSS class for the diagram status'))]';
  end if;
end;
/

whenever sqlerror exit failure
