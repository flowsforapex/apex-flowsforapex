create or replace view flow_diagrams_instanciated_lov
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
    from flow_diagrams dgrm
   where exists 
         ( select null
             from flow_objects objt
            where objt.objt_dgrm_id = dgrm.dgrm_id
         )
    and exists (
      select 1
      from flow_instance_diagrams prdg
      where prdg.prdg_dgrm_id = dgrm.dgrm_id
    )
  with read only
  ;
