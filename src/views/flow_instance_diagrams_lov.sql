create or replace view flow_instance_diagrams_lov
as
  select distinct
    case when callobj.objt_id is null then 'Main Diagram' else callobj.objt_name end as calling_diagram,
    prdg.prdg_id,
    prdg.prdg_prcs_id
  from flow_instance_diagrams prdg
  join flow_objects obj
        on obj.objt_dgrm_id = prdg.prdg_dgrm_id
  left join flow_objects callobj 
    on callobj.objt_dgrm_id = prdg.prdg_calling_dgrm
        and callobj.objt_bpmn_id = prdg.prdg_calling_objt
  where obj.objt_tag_name in ('bpmn:exclusiveGateway', 'bpmn:inclusiveGateway')
  and ( select count(*) from flow_connections conn where conn.conn_src_objt_id = obj.objt_id ) > 1
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_instance_diagrams_lov annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Diagrams active within a process instance for LOV selection'
  );

alter view flow_instance_diagrams_lov modify (calling_diagram annotations (add content 'Name of the calling diagram, or Main Diagram for the root level'));
whenever sqlerror exit failure
