create or replace view flow_dgrm_lov
as
  select drgm.dgrm_name as r
       , drgm.dgrm_name as d
    from flow_diagrams drgm
with read only
;
