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
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_p0013_called_diagrams_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Called diagrams hierarchy for the active process instance in engine app page 13'
  );

alter view flow_p0013_called_diagrams_vw modify (scope annotations (add content 'Diagram nesting level at which this called diagram is executing'));

whenever sqlerror exit failure
