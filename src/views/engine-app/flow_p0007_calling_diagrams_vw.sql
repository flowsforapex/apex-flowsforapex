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
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0007_calling_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Call activity references showing which diagrams are called by this diagram, for engine app page 7'
  )]';
    execute immediate q'[alter view flow_p0007_calling_diagrams_vw modify (called_diagram annotations (add content 'Name or ID of the diagram called by this call activity'))]';
    execute immediate q'[alter view flow_p0007_calling_diagrams_vw modify (called_diagram_version_selection annotations (add content 'Version selection method for the called diagram'))]';
    execute immediate q'[alter view flow_p0007_calling_diagrams_vw modify (called_diagram_version annotations (add content 'Specific version constraint for the called diagram'))]';
  end if;
end;
/

whenever sqlerror exit failure
