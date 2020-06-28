create view flow_p0010_vw
as
  select dgrm.dgrm_content
       , prcs.prcs_current
       , prcs.prcs_id 
    from flow_diagrams dgrm
    join flow_processes prcs
      on dgrm.dgrm_id = prcs.prcs_dgrm_id
;
