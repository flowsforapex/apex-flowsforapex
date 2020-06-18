create view FLOW_P0010_VW
as
  select dgrm.dgrm_content
       , prcs.prcs_current
       , prcs.prcs_id 
    from flow_diagrams  dgrm
    join flow_processes prcs on dgrm.dgrm_name = prcs.prcs_dgrm_name
/