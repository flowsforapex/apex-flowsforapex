create or replace view flow_diagrams_lov
as
  select drgm.dgrm_id
       , drgm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
    from flow_diagrams drgm
with read only
;
