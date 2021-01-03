create or replace view flow_diagrams_vw
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
       , dgrm.dgrm_last_update
       , dgrm.dgrm_content
  from flow_diagrams dgrm
with read only;
