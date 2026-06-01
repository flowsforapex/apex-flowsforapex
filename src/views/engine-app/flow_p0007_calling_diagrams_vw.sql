create or replace view flow_p0007_calling_diagrams_vw
as
  select 
    dgrm.dgrm_id,
    dgrm.dgrm_name,
    dgrm.dgrm_version,
    objt.objt_name,
    objt.objt_attributes."apex"."calledDiagram" as called_diagram,
    objt.objt_attributes."apex"."calledDiagramVersionSelection" as called_diagram_version_selection,
    objt.objt_attributes."apex"."calledDiagramVersion" as called_diagram_version
  from flow_objects  objt
  join flow_diagrams dgrm
    on objt.objt_tag_name = 'bpmn:callActivity'
  and objt.objt_dgrm_id = dgrm.dgrm_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0007_calling_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Call activity references showing which diagrams are called by this diagram, for engine app page 7'
  );

alter view flow_p0007_calling_diagrams_vw modify (called_diagram annotations (add content 'Name or ID of the diagram called by this call activity'));
alter view flow_p0007_calling_diagrams_vw modify (called_diagram_version_selection annotations (add content 'Version selection method for the called diagram'));
alter view flow_p0007_calling_diagrams_vw modify (called_diagram_version annotations (add content 'Specific version constraint for the called diagram'));

whenever sqlerror exit failure
