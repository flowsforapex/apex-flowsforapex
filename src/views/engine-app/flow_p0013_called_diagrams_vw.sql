create or replace view flow_p0013_called_diagrams_vw
as
   select 
      prdg.prdg_prdg_id,
      prdg.prdg_calling_dgrm,
      prdg.prdg_calling_objt,
      prdg.prdg_diagram_level,
      dgrm.dgrm_name,
      dgrm.dgrm_version,
      dgrm.dgrm_status,
      prdg.prdg_diagram_level as scope
   from flow_instance_diagrams prdg
   join flow_diagrams dgrm on dgrm.dgrm_id = prdg.prdg_dgrm_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0013_called_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Called diagrams hierarchy for the active process instance in engine app page 13'
  )]';
    execute immediate q'[alter view flow_p0013_called_diagrams_vw modify (scope annotations (add content 'Diagram nesting level at which this called diagram is executing'))]';
  end if;
end;
/

whenever sqlerror exit failure
