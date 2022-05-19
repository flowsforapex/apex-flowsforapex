create or replace view flow_p0008_subflows_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_prcs_id
       , sbfl.sbfl_current_name as sbfl_current
       , sbfl.sbfl_step_key
       , sbfl.sbfl_sbfl_dgrm_id
       , sbfl.sbfl_diagram_level
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
             when 'running' then 'fa-play-circle-o'
             when 'created' then 'fa-plus-circle-o'
             when 'completed' then 'fa-check-circle-o'
             when 'terminated' then 'fa-stop-circle-o'
             when 'error' then 'fa-exclamation-circle-o'
             when 'split' then 'fa fa-share-alt'
             when 'in subprocess' then 'fa fa-share-alt'
             when 'in call activity' then 'fa fa-share-alt'
             when 'waiting at gateway' then 'fa fa-hand-stop-o'
             when 'waiting for timer' then 'fa fa-clock-o'
             when 'waiting for event' then 'fa fa-hand-stop-o'
         end as sbfl_status_icon
       , sbfl.timr_start_on at time zone sessiontimezone as sbfl_timr_start_on
       , sbfl.sbfl_current_lane_name as sbfl_current_lane
       , sbfl.sbfl_reservation
       , null as actions   
       , apex_item.checkbox2(p_idx => 2, p_value => sbfl.sbfl_id, p_attributes => 'data-status="'|| sbfl.sbfl_status ||'" data-prcs="'|| sbfl.sbfl_prcs_id ||'" data-key="'|| sbfl.sbfl_step_key ||'" data-reservation="'|| sbfl.sbfl_reservation ||'"') as checkbox
        , case 
            when sbfl.sbfl_status = 'error' then 'fa-redo-arrow'
            when sbfl.sbfl_status = 'running' then 'fa-sign-out'
            when sbfl.sbfl_status = 'waiting for timer' then 'fa-clock-o'
          end as quick_action_icon 
        , case 
            when sbfl.sbfl_status = 'error' then apex_lang.message('APP_RESTART_STEP')
            when sbfl.sbfl_status = 'running' then apex_lang.message('APP_COMPLETE_STEP')
            when sbfl.sbfl_status = 'waiting for timer' then apex_lang.message('APP_RESCHEDULE_TIMER')
          end as quick_action_label 
        , case 
            when sbfl.sbfl_status = 'error' then 'restart-step'
            when sbfl.sbfl_status = 'running' then 'complete-step'
            when sbfl.sbfl_status = 'waiting for timer' then 'reschedule-timer'
          end as quick_action 
        , case when sbfl.sbfl_status = 'waiting for timer' then ' @ ' || sbfl.timr_start_on at time zone sessiontimezone end as timer_status_info
    from flow_subflows_vw sbfl
with read only
;
