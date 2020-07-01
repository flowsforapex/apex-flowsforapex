create view FLOW_P0001_VW
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_content
    from flow_diagrams dgrm
with read only
;
