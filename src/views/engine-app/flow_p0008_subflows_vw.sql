create or replace view flow_p0008_subflows_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_prcs_id
       , sbfl.sbfl_current_name as sbfl_current
       , sbfl.sbfl_current as sbfl_current_bpmn_id
       , sbfl.sbfl_iteration_path
       , sbfl.sbfl_step_key
       , sbfl.sbfl_sbfl_dgrm_id
       , sbfl.sbfl_diagram_level
       , sbfl.sbfl_process_level
       , sbfl.sbfl_apex_task_id
       , sbfl.sbfl_loop_counter
       , sbfl.sbfl_loop_total_instances
       , sbfl.sbfl_scope
       , sbfl.sbfl_calling_sbfl
       , ( select nvl(objt.objt_name ,'Main Diagram')
             from flow_objects objt
             join flow_instance_diagrams prdg 
               on prdg.prdg_calling_objt = objt.objt_bpmn_id
              and prdg.prdg_calling_dgrm = objt.objt_dgrm_id
            where prdg.prdg_diagram_level = sbfl.sbfl_diagram_level ) as Calling_object
       , sbfl.sbfl_starting_object_name as sbfl_starting_object
       , sbfl.sbfl_last_update at time zone sessiontimezone as sbfl_last_update
       , sbfl.sbfl_status
       , case sbfl.sbfl_status
             when 'running'             then 'fa-play-circle-o'
             when 'created'             then 'fa-plus-circle-o'
             when 'completed'           then 'fa-check-circle-o'
             when 'terminated'          then 'fa-stop-circle-o'
             when 'suspended'           then 'fa-pause-circle-o'
             when 'error'               then 'fa-exclamation-circle-o'
             when 'split'               then 'fa-share-alt'
             when 'in subprocess'       then 'fa-share-alt'
             when 'in call activity'    then 'fa-share-alt'
             when 'in adhoc subprocess' then 'fa-box-arrow-in-east'
             when 'waiting at gateway'  then 'fa-hand-stop-o'
             when 'waiting for timer'   then 'fa-clock-o'
             when 'waiting for event'   then 'fa-hand-stop-o'
             when 'waiting for approval'then 'fa-question-square-o'
             when 'waiting for message' then 'fa-envelope-o'
             when 'waiting iterations'  then 'fa-align-justify fa-rotate-90'
             when 'iterating'           then 'fa-align-justify fa-rotate-90'
             when 'delete on resume'    then 'fa-trash fam-pause fam-is-danger'
             when 'restart on resume'   then 'fa-pause-circle-o'
             when 'canceling task'      then 'fa-trash fam-play fam-is-danger'
         end as sbfl_status_icon
       , sbfl.sbfl_priority
       , sbfl.sbfl_due_on
       , sbfl.timr_start_on at time zone sessiontimezone as sbfl_timr_start_on
       , sbfl.sbfl_current_lane_name as sbfl_current_lane
       , sbfl.sbfl_reservation
       , sbfl.sbfl_potential_users
       , sbfl.sbfl_potential_groups
       , sbfl.sbfl_excluded_users
       , null as actions   
       , apex_item.checkbox2(p_idx => 2, p_value => sbfl.sbfl_id, p_attributes => 'data-status="'|| sbfl.sbfl_status ||'" data-prcs="'|| sbfl.sbfl_prcs_id ||'" data-key="'|| sbfl.sbfl_step_key ||'" data-reservation="'|| sbfl.sbfl_reservation ||'"') as checkbox
        , case 
            when sbfl.sbfl_status = 'error' then 'fa-redo-arrow'
            when sbfl.sbfl_status = 'running' then 'fa-sign-out'
            when sbfl.sbfl_status = 'waiting for timer' then 'fa-clock-o'
            when sbfl.sbfl_status = 'in adhoc subprocess' then 'fa-box-arrow-in-east'
          end as quick_action_icon 
        , case 
            when sbfl.sbfl_status = 'error' then apex_lang.message('APP_RESTART_STEP')
            when sbfl.sbfl_status = 'running' then apex_lang.message('APP_COMPLETE_STEP')
            when sbfl.sbfl_status = 'waiting for timer' then apex_lang.message('APP_RESCHEDULE_TIMER')
            when sbfl.sbfl_status = 'in adhoc subprocess' then apex_lang.message('APP_ADHOC_DETAILS')
          end as quick_action_label 
        , case 
            when sbfl.sbfl_status = 'error' then 'restart-step'
            when sbfl.sbfl_status = 'running' then 'complete-step'
            when sbfl.sbfl_status = 'waiting for timer' then 'reschedule-timer'
            when sbfl.sbfl_status = 'in adhoc subprocess' then 'open-adhoc-activities'
          end as quick_action 
        , case when sbfl.sbfl_status = 'waiting for timer' then ' @ ' || sbfl.timr_start_on at time zone sessiontimezone end as timer_status_info
    from flow_subflows_vw sbfl
with read only
;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_p0008_subflows_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Subflow list with status icons, quick action controls, and checkbox widget for engine app page 8'
  )]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (sbfl_current annotations (add content 'Display name of the current BPMN object'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (sbfl_current_bpmn_id annotations (add content 'Raw BPMN ID of the current object'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (calling_object annotations (add content 'Display name of the calling object or Main Diagram for the root level'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (sbfl_starting_object annotations (add content 'Display name of the subflow starting object'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (sbfl_status_icon annotations (add content 'FA icon CSS class for the subflow status'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (sbfl_timr_start_on annotations (add content 'Scheduled timer start time in session timezone'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (sbfl_current_lane annotations (add content 'Display name of the lane where the current step is executing'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (actions annotations (add content 'Null placeholder for inline actions column'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (checkbox annotations (add content 'APEX checkbox widget with status, process, step key, and reservation data attributes'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (quick_action_icon annotations (add content 'FA icon CSS class for the quick action'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (quick_action_label annotations (add content 'Translated label for the quick action button'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (quick_action annotations (add content 'Action identifier string for the JavaScript handler'))]';
    execute immediate q'[alter view flow_p0008_subflows_vw modify (timer_status_info annotations (add content 'Formatted timer time for subflows waiting for a timer'))]';
  end if;
end;
/

whenever sqlerror exit failure
