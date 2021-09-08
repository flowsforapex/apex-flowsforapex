create or replace view flow_p0008_subflows_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_prcs_id
       , sbfl.sbfl_current_name as sbfl_current
       , sbfl.sbfl_starting_object_name as sbfl_starting_object
       , sbfl.sbfl_last_update
       , sbfl.sbfl_status
       , sbfl.sbfl_current_lane_name as sbfl_current_lane
       , sbfl.sbfl_reservation
       , null as actions   
       , apex_item.checkbox2(p_idx => 2, p_value => sbfl.sbfl_id, p_attributes => 'data-status="'|| sbfl.sbfl_status ||'" data-prcs="'|| sbfl.sbfl_prcs_id ||'" data-reservation="'|| sbfl.sbfl_reservation ||'"') as checkbox
        , case 
            when sbfl.sbfl_status = 'error' then 'fa-redo-arrow'
            when sbfl.sbfl_status = 'running' then 'fa-sign-out'
          end as quick_action_icon 
        , case 
            when sbfl.sbfl_status = 'error' then 'restart-step'
            when sbfl.sbfl_status = 'running' then 'complete-step'
          end as quick_action 
    from flow_subflows_vw sbfl
with read only
;
