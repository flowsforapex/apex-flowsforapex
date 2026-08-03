create or replace view flow_diagram_categories_lov
as
  select distinct
         dgrm_category d
       , dgrm_category r
    from flow_diagrams
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_diagram_categories_lov annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Distinct diagram category values for LOV dropdown selection'
  )]';
    execute immediate q'[alter view flow_diagram_categories_lov modify (d annotations (add content 'Display value: category name'))]';
    execute immediate q'[alter view flow_diagram_categories_lov modify (r annotations (add content 'Return value: category name'))]';
  end if;
end;
/

whenever sqlerror exit failure
