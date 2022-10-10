create or replace view flow_apex_task_inbox_my_tasks_vw 
     ( task_type
     , app_id
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
as select   
      'APEX_APPROVAL'
     , app_id
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
     , null
     , null
     , null
    from table ( apex_approval.get_tasks ( p_context => 'MY_TASKS' ) )
    UNION ALL
    select  
       'F4A_USERTASK'
     , fati.app_id
     , fati.task_id
     , fati.task_def_id
     , fati.task_def_name
     , fati.task_def_static_id
     , fati.subject
     , fati.details_app_id
     , fati.details_app_name
     , fati.details_link_target
     , fati.due_on
     , fati.due_in_hours
     , fati.due_in 
     , fati.due_code
     , fati.priority
     , fati.priority_level
     , fati.initiator
     , fati.initiator_lower
     , fati.actual_owner
     , fati.actual_owner_lower
     , fati.state_code
     , fati.state
     , fati.is_completed
     , fati.outcome_code
     , fati.outcome
     , fati.badge_css_classes
     , fati.badge_text
     , fati.created_ago_hours
     , fati.created_ago
     , fati.created_by
     , fati.created_on
     , fati.last_updated_by
     , fati.last_updated_on
     , fati.process_id
     , fati.subflow_id
     , fati.step_key
     from flow_apex_task_inbox_vw fati
    where fati.state = 'running'
      and ( fati.actual_owner = SYS_CONTEXT('APEX$SESSION','APP_USER') 
          OR fati.actual_owner is null )
      and fati.lane_name in ( select roles.role_static_id
                              from   apex_appl_acl_user_roles roles
                              where  roles.user_name = SYS_CONTEXT('APEX$SESSION','APP_USER')
                              and    roles.workspace_id = SYS_CONTEXT('APEX$SESSION','WORKSPACE_ID')
                              )
          --- if lanes not always being used, change this to your situation
     ;
