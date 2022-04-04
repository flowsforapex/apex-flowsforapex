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
      from ( select obat_objt_id
                  , obat_key
                  , obat_vc_value
               from flow_object_attributes
           )
     pivot ( min(obat_vc_value) for obat_key in
             ( 'apex:calledDiagram' as called_diagram
             , 'apex:calledDiagramVersionSelection' as called_diagram_version_selection
             , 'apex:calledDiagramVersion' as called_diagram_version
             )
           ) attr
      join flow_diagrams dgrm
        on ( attr.called_diagram = dgrm.dgrm_name
             and case when attr.called_diagram_version_selection = 'latestVersion' and (dgrm.dgrm_status = 'released' or (dgrm.dgrm_status = 'draft' and dgrm.dgrm_version = '0')) then 1
                      when attr.called_diagram_version_selection = 'namedVersion' and dgrm.dgrm_version = attr.called_diagram_version then 1
                      else 0
                  end = 1
           )
      join flow_objects objt
        on attr.obat_objt_id = objt.objt_id
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
