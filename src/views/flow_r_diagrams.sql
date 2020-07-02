create or replace view flow_r_diagrams
as
  select drgm.dgrm_name as r
       , drgm.dgrm_name as d
    from flow_diagrams drgm
with read only
;
