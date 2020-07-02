create or replace view flow_r_diagrams_parsed
as
  select dgrm.dgrm_name as r
       , dgrm.dgrm_name as d
    from flow_diagrams dgrm
   where exists 
         ( select 1
             from flow_objects objt
            where objt.objt_dgrm_id = dgrm.dgrm_id
         )
  with read only
  ;