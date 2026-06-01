create or replace view flow_diagram_categories_lov
as
  select distinct
         dgrm_category d
       , dgrm_category r
    from flow_diagrams
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_diagram_categories_lov annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Distinct diagram category values for LOV dropdown selection'
  );

alter view flow_diagram_categories_lov modify (d annotations (add content 'Display value: category name'));
alter view flow_diagram_categories_lov modify (r annotations (add content 'Return value: category name'));

whenever sqlerror exit failure
