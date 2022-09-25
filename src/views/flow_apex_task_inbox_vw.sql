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
     )
as
select null as app_id
     , null as task_id
     , null as task_def_id
     , coalesce( objt_curr.objt_name, sbfl.sbfl_current ) as task_def_name
     , null as task_def_static_id
     , prcs.prcs_name||' '||coalesce( objt_curr.objt_name, sbfl.sbfl_current) as subject
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
     , cast(sbfl.sbfl_became_current as date) + 1 as due_on    --- F4A v22.2 All Tasks due in 24 Hours!
     , floor((cast(sbfl.sbfl_became_current as date) + 1 - sysdate )*24) as due_in_hours
     , 'due in '||floor((cast(sbfl.sbfl_became_current as date) + 1 - sysdate )*24)||' hours' as due_in
     , null as due_code   --- tbd
     , 3 as priority
     , 'medium' as priority_level
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
     , 'Ready for Action' as badge_text
     , floor((sysdate - cast(sbfl_became_current as date) )*24) as created_ago_hours
     , 'created '||floor((sysdate - cast(sbfl_became_current as date) )*24)||' hours ago' as created_ago
     , prcs.prcs_init_by as created_by     
     , sbfl.sbfl_became_current as created_on
     , sbfl.sbfl_last_update_by as last_updated_by     
     , sbfl.sbfl_last_update as last_updated_on
     , prcs.prcs_id
     , sbfl.sbfl_id
     , sbfl.sbfl_step_key
     from flow_subflows sbfl
     join flow_processes prcs
       on prcs.prcs_id = sbfl.sbfl_prcs_id
left join flow_objects objt_curr
       on objt_curr.objt_bpmn_id = sbfl.sbfl_current
      and objt_curr.objt_dgrm_id = sbfl.sbfl_dgrm_id
     join flow_diagrams dgrm 
       on dgrm.dgrm_id = prcs.prcs_dgrm_id
/*left join flow_timers timr
       on timr.timr_prcs_id = sbfl.sbfl_prcs_id
      and timr.timr_sbfl_id = sbfl.sbfl_id
      and timr.timr_status != 'E' */
where objt_curr.objt_tag_name = 'bpmn:userTask' 
with read only