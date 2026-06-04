create or replace view flow_p0007_vw
as
  select 
      dgrm.dgrm_content
    , dgrm.dgrm_id
  from flow_diagrams dgrm
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0007_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'Diagram BPMN content and ID for the modeler editor in engine app page 7'
  )]';
  end if;
end;
/

whenever sqlerror exit failure
