create or replace view flow_diagrams_parsed_lov
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
    from flow_diagrams dgrm
   where exists 
         ( select null
             from flow_objects objt
            where objt.objt_dgrm_id = dgrm.dgrm_id
         )
  with read only
  ;
