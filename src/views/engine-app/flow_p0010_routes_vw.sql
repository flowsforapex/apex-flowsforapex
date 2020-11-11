create or replace view flow_p0010_routes_vw
as
  select prcs.prcs_id
       , sbfl.sbfl_id
       , objt.objt_bpmn_id
       , coalesce( conn.conn_name, conn.conn_bpmn_id ) as d
       , conn.conn_bpmn_id as r
       , case conn.conn_is_default when 1 then 'Y' else 'N' end conn_is_default
    from flow_connections conn
    join flow_objects objt
      on objt.objt_id = conn.conn_src_objt_id
    join flow_processes prcs
      on prcs.prcs_dgrm_id = conn.conn_dgrm_id
     and prcs.prcs_dgrm_id = objt.objt_dgrm_id
    join flow_subflows sbfl
      on sbfl.sbfl_prcs_id = prcs.prcs_id
   where conn.conn_tag_name = 'bpmn:sequenceFlow'
with read only;
