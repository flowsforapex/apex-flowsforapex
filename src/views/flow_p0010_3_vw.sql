create view FLOW_P0010_3_VW
as
  select prcs.prcs_id
       , conn.conn_name d
       , conn.conn_id r
    from flow_connections conn
    join flow_objects src_objt
      on src_objt.objt_id = conn.conn_src_objt_id
    join flow_processes prcs
      on prcs.prcs_current = src_objt.objt_bpmn_id
     and prcs.prcs_dgrm_id = src_objt.objt_dgrm_id
     and prcs.prcs_dgrm_id = conn.conn_dgrm_id
order by conn.conn_name asc
;
