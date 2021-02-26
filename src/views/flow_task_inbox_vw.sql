create or replace view flow_task_inbox_vw
as 
   select sbfl_id
        , sbfl_sbfl_id
        , sbfl_prcs_id
        , sbfl_process_name
        , sbfl_prcs_init_ts
        , sbfl_dgrm_id
        , sbfl_dgrm_name
        , sbfl_dgrm_version
        , sbfl_dgrm_status
        , sbfl_dgrm_category
        , sbfl_starting_object
        , sbfl_starting_object_name
        , sbfl_route
        , sbfl_route_name
        , sbfl_last_completed
        , sbfl_last_completed_name
        , sbfl_current
        , sbfl_current_name
        , case sbfl_current_tag_name
            when 'bpmn:userTask' then
              flow_usertask_pkg.get_url
              (
                pi_prcs_id => sbfl_prcs_id
              , pi_sbfl_id => sbfl_id
              , pi_objt_id => sbfl_current_objt_id
              )
            else null
          end link_text
        , sbfl_current_tag_name
        , sbfl_last_update
        , sbfl_status
        , sbfl_next_step_type
        , sbfl_current_lane
        , sbfl_current_lane_name
        , sbfl_reservation
     from flow_subflows_vw sbfl
    where sbfl_status = 'running'
with read only
;
