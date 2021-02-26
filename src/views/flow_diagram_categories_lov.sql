create or replace view flow_diagram_categories_lov
as
  select distinct
         dgrm_category d
       , dgrm_category r
    from flow_diagrams
with read only;
