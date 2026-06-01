create or replace view flow_instance_scopes_vw
as
  select prdg_prcs_id         iscp_prcs_id
       , prdg_diagram_level   iscp_valid_scope
    from flow_instance_diagrams
   where prdg_diagram_level is not null
  union
  select distinct iter_prcs_id iscp_prcs_id
       , iter_scope            iscp_valid_scope
    from flow_iterations
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_instance_scopes_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Valid process variable scopes derived from sub-diagram levels and multi-instance iterations'
  );

alter view flow_instance_scopes_vw modify (iscp_prcs_id     annotations (add content 'Process instance identifier'));
alter view flow_instance_scopes_vw modify (iscp_valid_scope annotations (add content 'Valid scope number for process variable lookup within this instance'));

whenever sqlerror exit failure
