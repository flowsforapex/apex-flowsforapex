create or replace view flow_instance_gateways_lov
as
  select obj.objt_id
       , obj.objt_bpmn_id
       , case when callobj.objt_id is null then 'Main Diagram' else callobj.objt_name end calling_object
       , case when obj.objt_name is null then obj.objt_bpmn_id else obj.objt_name || ' (' || obj.objt_bpmn_id ||')' end objt_name
       , case obj.objt_tag_name
           when 'bpmn:exclusiveGateway' then 'single'
           when 'bpmn:inclusiveGateway' then 'multi'
           else null
         end as select_option
       , ins.prcs_id
       , prdg.prdg_diagram_level
       , prdg.prdg_dgrm_id
       , prdg.prdg_prdg_id
       , prdg.prdg_id
    from flow_instances_vw ins
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = ins.prcs_id
     and prdg.prdg_diagram_level is not null
    join flow_objects obj
      on obj.objt_dgrm_id = prdg.prdg_dgrm_id
    left join flow_objects callobj
      on callobj.objt_dgrm_id = prdg.prdg_calling_dgrm
      and callobj.objt_bpmn_id = prdg.prdg_calling_objt
   where obj.objt_tag_name in ('bpmn:exclusiveGateway', 'bpmn:inclusiveGateway')
     and ( select count(*) 
           from flow_connections conn 
           where conn.conn_src_objt_id = obj.objt_id 
           and conn.conn_tag_name = 'bpmn:sequenceFlow') > 1
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_instance_gateways_lov annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Exclusive and inclusive gateways with multiple outgoing flows for manual conditional routing selection'
  )]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (objt_id            annotations (add content 'System ID of the gateway object'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (objt_bpmn_id       annotations (add content 'BPMN identifier of the gateway'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (calling_object     annotations (add content 'BPMN ID of the subflow object calling this gateway selection'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (objt_name          annotations (add content 'Display name of the gateway'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (select_option      annotations (add content 'Outgoing connection option available for manual routing selection'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (prcs_id            annotations (add content 'Process instance identifier'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (prdg_diagram_level annotations (add content 'Diagram level of the subflow executing this gateway'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (prdg_dgrm_id       annotations (add content 'Diagram ID of the sub-diagram'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (prdg_prdg_id       annotations (add content 'Parent instance diagram record'))]';
    execute immediate q'[alter view flow_instance_gateways_lov modify (prdg_id            annotations (add content 'Instance diagram record for this gateway'))]';
  end if;
end;
/

whenever sqlerror exit failure
