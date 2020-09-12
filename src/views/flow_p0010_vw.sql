create or replace view flow_p0010_vw
as
  select dgrm_content
       , prcs_id
       , all_completed
       , last_completed
       , all_current
    from flow_processes_vw
with read only;
