create or replace view flow_instance_gateways_lov
as
  select obj.objt_id
       , obj.objt_bpmn_id
       , coalesce(obj.objt_name, obj.objt_bpmn_id) objt_name
       , case obj.objt_tag_name
           when 'bpmn:exclusiveGateway' then 'single'
           when 'bpmn:inclusiveGateway' then 'multi'
           else null
         end as select_option
       , ins.prcs_id
    from flow_instances_vw ins
    join flow_objects obj
      on obj.objt_dgrm_id = ins.dgrm_id
   where obj.objt_tag_name in ('bpmn:exclusiveGateway', 'bpmn:inclusiveGateway')
     and ( select count(*) from flow_connections conn where conn.conn_tgt_objt_id = obj.objt_id ) = 1
with read only;
