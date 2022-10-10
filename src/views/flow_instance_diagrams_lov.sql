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
