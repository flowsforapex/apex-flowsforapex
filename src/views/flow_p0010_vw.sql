create view flow_p0010_vw
as
    select dgrm.dgrm_content
         , prcs.prcs_id
         , sbfl.sbfl_current
         , sbfl.sbfl_id
      from flow_diagrams dgrm
      join flow_processes prcs
        on dgrm.dgrm_id = prcs.prcs_dgrm_id
 left join flow_subflows sbfl
        on sbfl.sbfl_sbfl_id = prcs.prcs_id
;
