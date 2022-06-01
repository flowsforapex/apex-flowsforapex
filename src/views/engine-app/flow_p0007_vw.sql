create or replace view flow_p0007_vw
as
  with diagrams as
  (
    select dgrm.dgrm_content
         , dgrm.dgrm_id
         , null as calling_dgrm
         , null as calling_objt
         , dgrm.dgrm_name || ' (' || dgrm.dgrm_version || ')' as breadcrumb
         , 1 as sub_prcs_insight
      from flow_diagrams dgrm
     union all
    select dgrm.dgrm_content
         , dgrm.dgrm_id
         , objt.objt_dgrm_id as calling_dgrm
         , objt.objt_bpmn_id as calling_objt
         , dgrm.dgrm_name || ' (' || dgrm.dgrm_version || ')' as breadcrumb
         , 1 as sub_prcs_insight
      from flow_objects objt
      join flow_diagrams dgrm
        on objt.objt_attributes."apex"."calledDiagram" = dgrm.dgrm_name
       and (  (   objt.objt_attributes."apex"."calledDiagramVersionSelection" = 'latestVersion'
              and ( dgrm.dgrm_status = 'released'
                  or ( dgrm.dgrm_status = 'draft' and dgrm.dgrm_version = '0' )
                  )
              )
           or ( objt.objt_attributes."apex"."calledDiagramVersionSelection" = 'namedVersion'
              and dgrm.dgrm_version = objt.objt_attributes."apex"."calledDiagramVersion"
              )
           )
  )
  select dgrm.dgrm_content
       , dgrm.dgrm_id
       , dgrm.calling_dgrm
       , dgrm.calling_objt
       , dgrm.breadcrumb
       , dgrm.sub_prcs_insight
       , connect_by_root(dgrm.dgrm_id) as root_dgrm
    from diagrams dgrm
   start with dgrm.calling_dgrm is null
 connect by dgrm.calling_dgrm = prior dgrm.dgrm_id
with read only;
