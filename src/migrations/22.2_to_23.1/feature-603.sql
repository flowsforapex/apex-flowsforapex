PROMPT >> Performance Improvements for Instance Numbers and General Performance Enhancements

PROMPT >> Instance Numbers
create index flow_prcs_dgrm_status_ix
  on flow_processes (prcs_dgrm_id, prcs_status);

alter table flow_instance_diagrams
  add constraint flow_prdg_pk primary key ( prdg_id );

create index flow_prdg_dgrm_prcs_ix
  on flow_instance_diagrams (prdg_prcs_id, prdg_dgrm_id);

PROMPT >> Updated View flow_p0002_diagrams_vw will get installed via common_db_objects.sql

PROMPT >> General
create index flow_sbfl_dgrm_prcs_ix on flow_subflows( sbfl_dgrm_id, sbfl_prcs_id );
