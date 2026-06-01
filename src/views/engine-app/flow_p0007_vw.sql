create or replace view flow_p0007_vw
as
  select 
      dgrm.dgrm_content
    , dgrm.dgrm_id
  from flow_diagrams dgrm
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0007_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Diagram BPMN content and ID for the modeler editor in engine app page 7'
  );

whenever sqlerror exit failure
