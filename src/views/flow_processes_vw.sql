create or replace view flow_processes_vw
as
  select prcs.prcs_id
       , prcs.prcs_dgrm_id
       , prcs.prcs_name
       , prcs.prcs_status
       , prcs.prcs_init_ts
       , prcs.prcs_last_update
  from flow_processes prcs
with read only;
