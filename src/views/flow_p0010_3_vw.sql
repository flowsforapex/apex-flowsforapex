create view FLOW_P0010_3_VW
as
  select prcs.prcs_id
       , conn.conn_name d
       , conn.conn_id r
    from flow_connections conn
    join flow_processes prcs
      on conn.conn_source_ref = prcs.prcs_current
   where conn.conn_dgrm_id = prcs.prcs_dgrm_id
order by conn.conn_name asc
;
