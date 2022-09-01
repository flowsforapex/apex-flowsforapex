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
     and ( select count(*) from flow_connections conn where conn.conn_src_objt_id = obj.objt_id ) > 1
with read only;
