-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025-2026.
--
--
-- Created    15-Nov-2025  Richard Allen,  Flowquest Limited

create or replace view flow_p0022_started_adhoc_activities_vw as
  select ahsf.ahsf_sbfl_id                             as  sbfl_id
       , ahsp.ahsp_prcs_id                             as  prcs_id 
       , ahsp.ahsp_dgrm_id                             as  dgrm_id
       , ahsp.ahsp_bpmn_id                             as  subproc_bpmn_id  
       , ahsp.ahsp_sbfl_id                             as  subproc_sbfl_id 
       , ahsp.ahsp_step_key                            as  subproc_step_key
       , ahsf.ahsf_starting_object                     as  starting_object
       , (select coalesce(objt.objt_name, ahsf.ahsf_starting_object)
               from flow_objects objt
              where objt.objt_dgrm_id  = ahsp.ahsp_dgrm_id
                and objt.objt_bpmn_id  = ahsf.ahsf_starting_object)
                                                       as  starting_object_name
       , ahsf.ahsf_starting_step_key                   as  starting_step_key
       , ahsf.ahsf_repeat_count                        as  repeat_count
       , ahsf.ahsf_status                              as  status
       , ahsf.ahsf_start_time                          as  start_time
       , ahsf.ahsf_complete_time                       as  complete_time
       , ahsf.ahsf_inputs                              as  inputs
       , ahsf.ahsf_outputs                            as  outputs
    from flow_adhoc_subflows ahsf
    join flow_adhoc_subprocs ahsp
      on ahsf.ahsf_ahsp_id = ahsp.ahsp_id
    join flow_objects objt
      on objt.objt_dgrm_id  = ahsp.ahsp_dgrm_id
     and objt.objt_bpmn_id  = ahsf.ahsf_starting_object
with read only;
