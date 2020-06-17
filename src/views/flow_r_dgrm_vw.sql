create view FLOW_R_DRGM_VW
as
  select drgm.dgrm_name r
       , drgm.dgrm_name d
    from flow_diagrams drgm
/