create view FLOW_P0010_VW
as
    select dgrm.dgrm_content
         , prcs.prcs_id
         , sbfl.sbfl_current
         , sbfl.sbfl_id
      from flow_diagrams  dgrm
      join flow_processes prcs on (dgrm.dgrm_name = prcs.prcs_dgrm_name)
 left join flow_subflows  sbfl on (sbfl.sbfl_parent_process = prcs.prcs_id)
 /