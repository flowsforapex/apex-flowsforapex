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
