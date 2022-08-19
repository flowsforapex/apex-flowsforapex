create or replace view flow_p0013_called_diagrams_vw
as
   select 
      prdg.prdg_prdg_id,
      prdg.prdg_calling_dgrm,
      prdg.prdg_calling_objt,
      prdg.prdg_diagram_level,
      dgrm.dgrm_name,
      dgrm.dgrm_version,
      dgrm.dgrm_status,
      prdg.prdg_diagram_level as scope
   from flow_instance_diagrams prdg
   join flow_diagrams dgrm on dgrm.dgrm_id = prdg.prdg_dgrm_id
with read only;
