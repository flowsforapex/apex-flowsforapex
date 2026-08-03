/* 
-- Flows for APEX - flow_startable_adhoc_activities_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025-2026.
--
-- todo - should this be a materialized view?
--
-- Created    22-Nov-2025  Richard Allen,  Flowquest Limited
*/
create or replace view flow_startable_adhoc_activities_vw as
  select ahat.dgrm_id                   as  dgrm_id
       , sbfl.sbfl_id                   as  subproc_sbfl_id
       , sbfl.sbfl_prcs_id              as  prcs_id  
       , sbfl.sbfl_step_key             as  subproc_step_key
       , ahat.subprocess_bpmn_id        as  subproc_bpmn_id
       , sbfl.sbfl_ahsp_id              as  ahsp_id
       , ahat.activity_bpmn_id          as  activity_bpmn_id
       , ahat.activity_name             as  activity_name 
       , ahat.activity_description      as  activity_description
       , ahat.activity_grouping         as  activity_grouping
       , ahat.activity_display_order    as  activity_display_order
       , ahat.activity_tag_name         as  activity_tag_name
       , ahat.activity_is_repeatable    as  activity_is_repeatable 
       , ahat.activity_input_parameters  as  activity_input_parameters
       , ahat.activity_output_parameters as  activity_output_parameters
    from flow_adhoc_activities_vw ahat
    join flow_subflows sbfl
      on sbfl.sbfl_dgrm_id  = ahat.dgrm_id
     and sbfl.sbfl_current  = ahat.subprocess_bpmn_id
   where ( ahat.activity_is_repeatable = 'Y'
            or not exists ( select 1
                              from flow_adhoc_subflows ahsf
                             where ahsf.ahsf_starting_object = ahat.activity_bpmn_id
                               and ahsf.ahsf_ahsp_id         = sbfl.sbfl_ahsp_id)
         )
     -- Add start condition filtering - if condition exists, it must be met  
     and (ahat.activity_start_condition is null 
          or flow_adhoc_subprocesses.activity_start_condition_met_YN 
              ( p_process_id =>sbfl.sbfl_prcs_id
              , p_activity_start_condition => ahat.activity_start_condition 
              , p_scope => sbfl.sbfl_scope
              ) = 'Y')
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_startable_adhoc_activities_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Ad-hoc activities eligible to start for the current subflow, filtered by repeatability and start conditions'
  )]';
  end if;
end;
/

whenever sqlerror exit failure
