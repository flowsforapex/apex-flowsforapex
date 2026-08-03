-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025-2026.
--
--
-- Created    15-Nov-2025  Richard Allen,  Flowquest Limited
-- Modified   06-Jun-2026  Richard Allen,  Flowquest Limited

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
       , case ahsf.ahsf_status
             when 'running' then 'fa-play-circle-o'
             when 'created' then 'fa-plus-circle-o'
             when 'completed' then 'fa-check-circle-o'
             when 'terminated' then 'fa-stop-circle-o'
             when 'suspended' then 'fa-pause-circle-o'
             when 'error' then 'fa-exclamation-circle-o'
             when 'split' then 'fa fa-share-alt'
             when 'in subprocess' then 'fa fa-share-alt'
             when 'in call activity' then 'fa fa-share-alt'
             when 'in adhoc subprocess' then 'fa fa-user-play'
             when 'waiting at gateway' then 'fa fa-hand-stop-o'
             when 'waiting for timer' then 'fa fa-clock-o'
             when 'waiting for event' then 'fa fa-hand-stop-o'
             when 'waiting for approval' then 'fa fa-question-square-o'
             when 'waiting for message' then 'fa fa-envelope-o'
             when 'waiting iterations' then 'fa fa-align-justify fa-rotate-90'
             when 'iterating' then 'fa fa-align-justify fa-rotate-90'
             when 'delete on resume' then 'fa fa-trash fam-pause fam-is-danger'
             when 'restart on resume' then 'fa fa-pause-circle-o'
             when 'canceling task' then 'fa fa-trash fam-play fam-is-danger'
         end as status_icon
       , ahsf.ahsf_start_time                          as  start_time
       , ahsf.ahsf_complete_time                       as  complete_time
       , json_query(ahsf.ahsf_inputs, '$' returning clob pretty)  as  inputs
       , json_query(ahsf.ahsf_outputs,'$' returning clob pretty)  as  outputs
    from flow_adhoc_subflows ahsf
    join flow_adhoc_subprocs ahsp
      on ahsf.ahsf_ahsp_id = ahsp.ahsp_id
    join flow_objects objt
      on objt.objt_dgrm_id  = ahsp.ahsp_dgrm_id
     and objt.objt_bpmn_id  = ahsf.ahsf_starting_object
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0022_started_adhoc_activities_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Started ad-hoc activities with inputs and outputs for engine app page 22'
  )]';
  end if;
end;
/