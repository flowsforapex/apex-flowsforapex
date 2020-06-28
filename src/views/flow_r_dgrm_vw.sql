create view flow_dgrm_lov
as
  select drgm.dgrm_id r
       , drgm.dgrm_name d
    from flow_diagrams drgm
with read only
;
