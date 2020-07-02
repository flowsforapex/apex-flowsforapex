create or replace view flow_diagrams_lov
as
  select drgm.dgrm_id
       , drgm.dgrm_name
    from flow_diagrams drgm
with read only
;
