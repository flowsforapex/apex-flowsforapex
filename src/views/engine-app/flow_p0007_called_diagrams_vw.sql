create or replace view flow_p0007_called_diagrams_vw
as
  with diagrams as
      (
         select dgrm.dgrm_id,
                null    as calling_dgrm,
                null    as calling_objt,
                dgrm.dgrm_name,
                dgrm.dgrm_version
           from flow_diagrams dgrm
         union all
         select dgrm.dgrm_id,
                objt.objt_dgrm_id as calling_dgrm,
                objt.objt_bpmn_id as calling_objt,
                dgrm.dgrm_name,
                dgrm.dgrm_version
           from flow_objects  objt
           join flow_diagrams dgrm
             on objt.objt_tag_name = 'bpmn:callActivity'
            and dgrm_id = flow_engine_app_api.get_current_diagram(
                   pi_dgrm_name           => objt.objt_attributes."apex"."calledDiagram",
                   pi_dgrm_calling_method => objt.objt_attributes."apex"."calledDiagramVersionSelection",
                   pi_dgrm_version        => objt.objt_attributes."apex"."calledDiagramVersion"
                )
      )
   select dgrm.dgrm_id,
          dgrm.calling_dgrm,
          dgrm.calling_objt,
          dgrm.dgrm_name,
          dgrm_version,
          connect_by_root(dgrm.dgrm_id) as root_dgrm,
          connect_by_iscycle as has_recursion
     from diagrams dgrm
    start with dgrm.calling_dgrm is null
  connect by nocycle dgrm.calling_dgrm = prior dgrm.dgrm_id
with read only;
