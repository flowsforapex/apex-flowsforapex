create or replace view flow_p0007_vw
as
  select 
      dgrm.dgrm_content
    , dgrm.dgrm_id
  from flow_diagrams dgrm
with read only;
