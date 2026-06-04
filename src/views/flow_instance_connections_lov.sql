create or replace view flow_instance_connections_lov
as
  select cn.conn_bpmn_id
       , coalesce(cn.conn_name,conn_bpmn_id) conn_name
       , cn.conn_src_objt_id
       , objt.objt_bpmn_id as src_objt_bpmn_id
       , ins.prcs_id
       , prdg.prdg_id
    from flow_instances_vw ins
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = ins.prcs_id
    join flow_connections cn 
      on cn.conn_dgrm_id = prdg.prdg_dgrm_id
     and cn.conn_tag_name = 'bpmn:sequenceFlow'
    join flow_objects objt
      on objt.objt_id = cn.conn_src_objt_id
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_instance_connections_lov annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Sequence flow connections for active process instances for manual routing LOV selection'
  )]';
    execute immediate q'[alter view flow_instance_connections_lov modify (conn_bpmn_id     annotations (add content 'BPMN identifier of the sequence flow connection'))]';
    execute immediate q'[alter view flow_instance_connections_lov modify (conn_name        annotations (add content 'Display name of the connection'))]';
    execute immediate q'[alter view flow_instance_connections_lov modify (conn_src_objt_id annotations (add content 'Source object system ID (FK: flow_objects)'))]';
    execute immediate q'[alter view flow_instance_connections_lov modify (src_objt_bpmn_id annotations (add content 'BPMN identifier of the source gateway or object'))]';
    execute immediate q'[alter view flow_instance_connections_lov modify (prcs_id          annotations (add content 'Process instance this connection belongs to'))]';
    execute immediate q'[alter view flow_instance_connections_lov modify (prdg_id          annotations (add content 'Instance diagram record for this connection'))]';
  end if;
end;
/

whenever sqlerror exit failure
