create or replace view flow_instance_connections_lov as
select cn.conn_bpmn_id, coalesce(cn.conn_name,conn_bpmn_id) conn_name , cn.conn_src_objt_id, ins.prcs_id
from flow_instances_vw ins
join flow_connections cn on cn.conn_dgrm_id = ins.dgrm_id and  cn.conn_tag_name = 'bpmn:sequenceFlow';