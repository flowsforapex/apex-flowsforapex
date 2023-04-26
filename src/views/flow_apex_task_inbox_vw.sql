create or replace view flow_apex_task_inbox_vw 
     ( app_id
     , task_id
     , task_def_id
     , task_def_name
     , task_def_static_id
     , subject
     , details_app_id
     , details_app_name
     , details_link_target
     , due_on
     , due_in_hours
     , due_in 
     , due_code
     , priority
     , priority_level
     , initiator
     , initiator_lower
     , actual_owner
     , actual_owner_lower
     , state_code
     , state
     , is_completed
     , outcome_code
     , outcome
     , badge_css_classes
     , badge_text
     , created_ago_hours
     , created_ago
     , created_by
     , created_on
     , last_updated_by
     , last_updated_on
     , process_id
     , subflow_id
     , step_key
     , lane_name
     )
as
select null as app_id
     , null as task_id
     , null as task_def_id
     , coalesce( objt_curr.objt_name, sbfl.sbfl_current ) as task_def_name
     , null as task_def_static_id
     , prcs.prcs_name||' ('||bref.prov_var_vc2||') - '||coalesce( objt_curr.objt_name, sbfl.sbfl_current) as subject
     , null as details_app_id
     , dgrm.dgrm_name as details_app_name
     , case objt_curr.objt_tag_name
            when 'bpmn:userTask' then
              flow_usertask_pkg.get_url
              (
                pi_prcs_id  => sbfl_prcs_id
              , pi_sbfl_id  => sbfl_id
              , pi_objt_id  => objt_curr.objt_id   
              , pi_step_key => sbfl_step_key
              , pi_scope    => sbfl_scope
              )
            else null 
            end as details_link_target
     , sbfl.sbfl_due_on   
     , flow_api_pkg.intervalDStoHours(sbfl.sbfl_due_on - systimestamp) as due_in_hours
     , apex_util.get_since (p_value => sbfl.sbfl_due_on ) as due_in
     , case 
            when flow_api_pkg.intervalDStoHours(sbfl.sbfl_due_on - systimestamp) <= 0 then 
              'OVERDUE'
            when flow_api_pkg.intervalDStoHours(sbfl.sbfl_due_on - systimestamp) < 1 then
              'NEXT_HOUR'
            when flow_api_pkg.intervalDStoHours(sbfl.sbfl_due_on - systimestamp) < 24 then
              'NEXT_24_HOURS'
            when flow_api_pkg.intervalDStoHours(sbfl.sbfl_due_on - systimestamp) < 168 then
              'NEXT_WEEK'
            else null
            end as due_code  
     , sbfl.sbfl_priority as priority
     , case sbfl.sbfl_priority
          when 1 then 'urgent'
          when 2 then 'high'
          when 3 then 'medium'
          when 4 then 'low'
          when 5 then 'lowest'
        end as priority_level
     , prcs.prcs_init_by as initiator
     , lower(prcs.prcs_init_by) as initiator_lower
     , sbfl.sbfl_reservation as actual_owner
     , lower(sbfl.sbfl_reservation) as actual_owner_lower
     , null as state_code
     , sbfl.sbfl_status as state
     , null as is_completed
     , null as outcome_code
     , null as outcome
     , null as badge_css_classes
     , nvl2 (sbfl.sbfl_reservation, null, 'unassigned') as badge_text
     , floor((sysdate - cast(sbfl_became_current as date) )*24) as created_ago_hours
     , apex_util.get_since(p_value => sbfl_became_current)  as created_ago
     , prcs.prcs_init_by as created_by     
     , sbfl.sbfl_became_current as created_on
     , sbfl.sbfl_last_update_by as last_updated_by     
     , sbfl.sbfl_last_update as last_updated_on
     , prcs.prcs_id
     , sbfl.sbfl_id
     , sbfl.sbfl_step_key
     , sbfl.sbfl_lane_name
     from flow_subflows sbfl
     join flow_processes prcs
       on prcs.prcs_id = sbfl.sbfl_prcs_id
left join flow_objects objt_curr
       on objt_curr.objt_bpmn_id = sbfl.sbfl_current
      and objt_curr.objt_dgrm_id = sbfl.sbfl_dgrm_id
     join flow_diagrams dgrm 
       on dgrm.dgrm_id = prcs.prcs_dgrm_id
left join flow_process_variables bref
       on bref.prov_prcs_id = sbfl.sbfl_prcs_id
      and bref.prov_var_name = 'BUSINESS_REF'
      and bref.prov_scope = 0
/*left join flow_timers timr
       on timr.timr_prcs_id = sbfl.sbfl_prcs_id
      and timr.timr_sbfl_id = sbfl.sbfl_id
      and timr.timr_status != 'E' */
where objt_curr.objt_tag_name = 'bpmn:userTask' 
  and sbfl.sbfl_status = 'running'
with read only;
