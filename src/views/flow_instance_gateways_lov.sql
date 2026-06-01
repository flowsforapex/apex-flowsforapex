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
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_instance_gateways_lov annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Exclusive and inclusive gateways with multiple outgoing flows for manual conditional routing selection'
  );

alter view flow_instance_gateways_lov modify (objt_id            annotations (add content 'System ID of the gateway object'));
alter view flow_instance_gateways_lov modify (objt_bpmn_id       annotations (add content 'BPMN identifier of the gateway'));
alter view flow_instance_gateways_lov modify (calling_object     annotations (add content 'BPMN ID of the subflow object calling this gateway selection'));
alter view flow_instance_gateways_lov modify (objt_name          annotations (add content 'Display name of the gateway'));
alter view flow_instance_gateways_lov modify (select_option      annotations (add content 'Outgoing connection option available for manual routing selection'));
alter view flow_instance_gateways_lov modify (prcs_id            annotations (add content 'Process instance identifier'));
alter view flow_instance_gateways_lov modify (prdg_diagram_level annotations (add content 'Diagram level of the subflow executing this gateway'));
alter view flow_instance_gateways_lov modify (prdg_dgrm_id       annotations (add content 'Diagram ID of the sub-diagram'));
alter view flow_instance_gateways_lov modify (prdg_prdg_id       annotations (add content 'Parent instance diagram record'));
alter view flow_instance_gateways_lov modify (prdg_id            annotations (add content 'Instance diagram record for this gateway'));

whenever sqlerror exit failure
