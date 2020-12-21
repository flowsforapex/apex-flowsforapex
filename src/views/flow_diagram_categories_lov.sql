create or replace view flow_diagram_categories_lov
as
  select distinct dgrm.dgrm_category
    from flow_diagrams drgm
with read only
;