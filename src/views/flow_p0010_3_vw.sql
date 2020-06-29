create view FLOW_P0010_3_VW
as
select prcs.prcs_id
       , conn.conn_name d
       , conn.conn_name r
    from flow_connections conn
    join flow_processes   prcs on (conn.conn_dgrm_name = prcs.prcs_dgrm_name)
order by conn.conn_name asc
/
