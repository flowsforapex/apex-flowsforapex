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
