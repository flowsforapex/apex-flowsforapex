create or replace view flow_p0010_branches_vw
as
  select prcs.prcs_id
       , sbfl.sbfl_id
       , coalesce( conn.conn_name, conn.conn_bpmn_id ) as d
       , conn.conn_bpmn_id as r
    from flow_connections conn
    join flow_objects src_objt
      on src_objt.objt_id = conn.conn_src_objt_id
    join flow_subflows sbfl
      on sbfl.sbfl_current = src_objt.objt_bpmn_id
    join flow_processes prcs
      on prcs.prcs_id = sbfl.sbfl_prcs_id
     and prcs.prcs_dgrm_id = src_objt.objt_dgrm_id
     and prcs.prcs_dgrm_id = conn.conn_dgrm_id
order by conn.conn_name asc
;
