create or replace view flow_instances_vw
as
  select prcs.prcs_id
       , prcs.prcs_name
       , dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , prcs.prcs_priority
       , dgrm.dgrm_category
       , prcs.prcs_status
       , prcs.prcs_init_ts
       , prcs.prcs_init_by
       , prcs.prcs_start_ts
       , prcs.prcs_due_on
       , prcs.prcs_complete_ts
       , prcs.prcs_last_update
       , prcs.prcs_last_update_by
       , prov.prov_var_vc2 as prcs_business_ref
    from flow_processes prcs
    join flow_diagrams dgrm
      on dgrm.dgrm_id = prcs.prcs_dgrm_id
    left join flow_process_variables prov
      on prov.prov_prcs_id = prcs.prcs_id
     and prov.prov_var_name = 'BUSINESS_REF'
     and prov.prov_var_type = 'VARCHAR2' 
     and prov.prov_scope = 0
with read only;

create or replace view flow_subflows_vw
as
   select sbfl.sbfl_id
        , sbfl.sbfl_sbfl_id
        , sbfl.sbfl_prcs_id
        , coalesce( prcs.prcs_name, to_char(sbfl.sbfl_prcs_id)) as sbfl_process_name  -- flow instance ref
        , prcs.prcs_dgrm_id as sbfl_dgrm_id
        , sbfl.sbfl_dgrm_id as sbfl_sbfl_dgrm_id -- sbfl level dgrm id
        , dgrm.dgrm_name as sbfl_dgrm_name  -- flow name
        , dgrm.dgrm_version as sbfl_dgrm_version
        , dgrm.dgrm_status as sbfl_dgrm_status
        , dgrm.dgrm_category as sbfl_dgrm_category
        , sbfl.sbfl_starting_object
        , coalesce( objt_start.objt_name, sbfl.sbfl_starting_object ) as sbfl_starting_object_name
        , sbfl.sbfl_route
        , coalesce( conn.conn_name, sbfl.sbfl_route ) as sbfl_route_name
        , sbfl.sbfl_last_completed
        , coalesce( objt_last.objt_name, sbfl.sbfl_last_completed ) as sbfl_last_completed_name
        , sbfl.sbfl_current
        , coalesce( objt_curr.objt_name ||case 
                                          when sbfl_loop_counter is null then ''
                                          else '['||sbfl_loop_counter||']'
                                          end
                  , sbfl.sbfl_current 
                  ) as sbfl_current_name
        , iter.iter_display_name as sbfl_iteration_path
        , sbfl.sbfl_iter_id    -- remove from prod
        , sbfl.sbfl_iobj_id    -- remove from prod
        , sbfl.sbfl_iteration_type -- remove from prod
        , sbfl.sbfl_step_key
        , objt_curr.objt_tag_name as sbfl_current_tag_name
        , sbfl.sbfl_became_current
        , sbfl.sbfl_due_on
        , sbfl.sbfl_last_update
        , sbfl.sbfl_last_update_by
        , sbfl.sbfl_priority
        , sbfl.sbfl_status
        , sbfl.sbfl_lane as sbfl_current_lane
        , sbfl.sbfl_lane_name as sbfl_current_lane_name
        , sbfl.sbfl_lane_isrole
        , sbfl.sbfl_lane_role
        , sbfl.sbfl_apex_task_id
        , sbfl.sbfl_process_level
        , sbfl.sbfl_diagram_level
        , sbfl.sbfl_loop_counter
        , sbfl.sbfl_loop_total_instances
        , sbfl.sbfl_scope
        , sbfl.sbfl_calling_sbfl
        , sbfl.sbfl_reservation
        , sbfl.sbfl_potential_users
        , sbfl.sbfl_potential_groups
        , sbfl.sbfl_excluded_users
        , objt_curr.objt_id as sbfl_current_objt_id
        , prcs.prcs_init_ts as sbfl_prcs_init_ts
        , case sbfl.sbfl_status 
          when 'waiting for timer' then timr.timr_start_on
          else null
          end as timr_start_on
     from flow_subflows sbfl
     join flow_processes prcs
       on prcs.prcs_id = sbfl.sbfl_prcs_id
left join flow_objects objt_start
       on objt_start.objt_bpmn_id = sbfl.sbfl_starting_object
      and objt_start.objt_dgrm_id = sbfl.sbfl_dgrm_id
left join flow_objects objt_curr
       on objt_curr.objt_bpmn_id = sbfl.sbfl_current
      and objt_curr.objt_dgrm_id = sbfl.sbfl_dgrm_id
left join flow_objects objt_last
       on objt_last.objt_bpmn_id = sbfl.sbfl_last_completed
      and objt_last.objt_dgrm_id = sbfl.sbfl_dgrm_id
left join flow_connections conn
       on conn.conn_bpmn_id = sbfl.sbfl_route
      and conn.conn_dgrm_id = sbfl.sbfl_dgrm_id
     join flow_diagrams dgrm 
       on dgrm.dgrm_id = prcs.prcs_dgrm_id
left join flow_timers timr
       on timr.timr_prcs_id = sbfl.sbfl_prcs_id
      and timr.timr_sbfl_id = sbfl.sbfl_id
      and timr.timr_status in ('C', 'A', 'B')
left join flow_iterations iter
       on iter.iter_id = sbfl.sbfl_iter_id
with read only
;

create or replace view flow_diagrams_parsed_lov
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
    from flow_diagrams dgrm
   where exists 
         ( select null
             from flow_objects objt
            where objt.objt_dgrm_id = dgrm.dgrm_id
         )
    and dgrm_status in ('draft','released')
  with read only
  ;

create or replace view flow_diagram_categories_lov
as
  select distinct
         dgrm_category d
       , dgrm_category r
    from flow_diagrams
with read only;

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
     , lane_role
     , business_ref
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
     , sbfl.sbfl_lane_role
     , bref.prov_var_vc2
     from flow_subflows sbfl
     join flow_processes prcs
       on prcs.prcs_id = sbfl.sbfl_prcs_id
     join flow_diagrams dgrm 
       on dgrm.dgrm_id = prcs.prcs_dgrm_id  
left join flow_objects objt_curr
       on objt_curr.objt_bpmn_id = sbfl.sbfl_current
      and objt_curr.objt_dgrm_id = sbfl.sbfl_dgrm_id
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

create or replace view flow_apex_my_combined_task_list_vw
     ( manager
     , app_id
     , task_id
     , task_def_id
     , task_def_name
     , task_def_static_id
     , subject
     , task_type
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
     , current_obj
     )
as select   
      'APEX' as manager
     , app_id
     , task_id
     , task_def_id
     , task_def_name
     , task_def_static_id
     , subject
     , 'APPROVAL' as task_type
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
     , null
    from table ( apex_approval.get_tasks ( p_context => 'MY_TASKS' ) )
    UNION ALL
    select  
       manager
     , app_id
     , task_id
     , task_def_id
     , task_def_name
     , task_def_static_id
     , subject
     , task_type
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
     , current_obj
     from table ( flow_api_pkg.get_current_tasks ( p_context => 'MY_TASKS'))
     ;
/* 
-- Flows for APEX - flow_instance_details_vw.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
-- (c) Copyright MT AG, 2021-2022.
--
-- Created    Nov-2020 Moritz Klein,  MT AG
-- Edited  16-Mar-2022 Richard Allen, Oracle Corporation
-- Edited  21-Jun-2024 Dennis Amthor, Hyand Solutions GmbH
--
-- NOTE THAT THIS VIEW HAS AN ENTERPRISE EDITION VERSION WHICH INCLUDES COMPLEX
-- PROCESSING TO GENERATE THE ITERATION_DATA COLUMN.
-- ANY CHANGES TO THIS VIEW SHOULD ALSO UPDATE THE ENTERPRISE EDITION VERSION IN ADDITION.
*/
create or replace view flow_instance_details_vw
as
with completed_objects as (
        select distinct sflg.sflg_prcs_id as prcs_id
                      , sflg.sflg_dgrm_id  as dgrm_id
                      , sflg.sflg_diagram_level as diagram_level
                      , sflg.sflg_objt_id as objt_id
          from flow_subflow_log sflg
         where sflg.sflg_objt_id not in (   
                                          select sbfl.sbfl_current
                                            from flow_subflows sbfl
                                           where sbfl.sbfl_prcs_id = sflg.sflg_prcs_id
                                             and sbfl.sbfl_diagram_level = sflg.sflg_diagram_level
                                             and sbfl.sbfl_current is not null
                                        )
), all_completed as ( 
    select prcs_id, dgrm_id, diagram_level,
           listagg( objt_id, ':') within group (order by objt_id) as bpmn_ids
    from completed_objects
    group by prcs_id, dgrm_id, diagram_level
), all_current as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level 
       , listagg(sbfl_current, ':') within group ( order by sbfl_current ) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null  
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level
), all_errors as (
  select sbfl_prcs_id as prcs_id
       , sbfl_dgrm_id as dgrm_id
       , sbfl_diagram_level as diagram_level
       , listagg(sbfl_current, ':') within group (order by sbfl_current) as bpmn_ids
    from flow_subflows
   where sbfl_current is not null
     and sbfl_status = 'error'
group by sbfl_prcs_id, sbfl_dgrm_id, sbfl_diagram_level
), user_tasks as (
    select process_id as prcs_id
         , json_objectagg
           (
               key current_obj
               value details_link_target
               absent on null
               returning clob
           ) as user_task_urls
      from flow_apex_my_combined_task_list_vw
     group by process_id
)
  select prcs.prcs_id
       , prcs.prcs_name
       , prdg.prdg_id
       , prdg.prdg_prdg_id
       , prdg.prdg_diagram_level as diagram_level
       , prdg.prdg_calling_dgrm as calling_dgrm
       , prdg.prdg_calling_objt as calling_objt
       , dgrm.dgrm_name || case when prdg.prdg_diagram_level is not null then ' ( Level: ' || prdg.prdg_diagram_level || ' )' else '' end as breadcrumb
       , 1 as drilldown_allowed
       , dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
       , dgrm.dgrm_content
       , ( select acomp.bpmn_ids
             from all_completed acomp
            where acomp.prcs_id = prcs.prcs_id
              and acomp.dgrm_id = dgrm.dgrm_id
              and acomp.diagram_level =  prdg.prdg_diagram_level
         ) as all_completed
       , null as last_completed     -- remove in v22.1
       , ( select acurr.bpmn_ids
             from all_current acurr
            where acurr.prcs_id = prcs.prcs_id
              and acurr.dgrm_id = dgrm.dgrm_id
              and acurr.diagram_level =  prdg.prdg_diagram_level
         ) as all_current
       , ( select aerr.bpmn_ids
             from all_errors aerr
            where aerr.prcs_id = prcs.prcs_id
              and aerr.dgrm_id = dgrm.dgrm_id
              and aerr.diagram_level =  prdg.prdg_diagram_level
         ) as all_errors
       , usta.user_task_urls
       , to_clob(null) as iteration_data
       , prov.prov_var_vc2 as prcs_business_ref
    from flow_processes prcs
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = prcs.prcs_id
    join flow_diagrams dgrm
      on prdg.prdg_dgrm_id = dgrm.dgrm_id
    left join flow_process_variables prov
      on prov.prov_prcs_id  = prcs.prcs_id
     and prov.prov_var_name = 'BUSINESS_REF'
     and prov.prov_var_type = 'VARCHAR2'
     and prov.prov_scope    = 0
    left join user_tasks usta
      on prcs.prcs_id = usta.prcs_id
with read only;

create or replace view flow_instance_variables_vw
as
  select prov.prov_prcs_id
       , prov.prov_var_name
       , prov.prov_scope
       , prov.prov_var_type
       , prov.prov_var_vc2
       , prov.prov_var_num
       , prov.prov_var_date
       , prov.prov_var_tstz
       , prov.prov_var_clob
       , prov.prov_var_json
       , prcs.prcs_name
       , prcs.prcs_status
    from flow_process_variables prov
    join flow_processes prcs
      on prcs.prcs_id = prov.prov_prcs_id
with read only;

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
        , sbfl_step_key
        , sbfl_scope
        , case sbfl_current_tag_name
            when 'bpmn:userTask' then
              flow_usertask_pkg.get_url
              (
                pi_prcs_id  => sbfl_prcs_id
              , pi_sbfl_id  => sbfl_id
              , pi_objt_id  => sbfl_current_objt_id
              , pi_step_key => sbfl_step_key
              , pi_scope    => sbfl_scope
              )
            else null
          end link_text
        , sbfl_current_tag_name
        , sbfl_became_current
        , sbfl_last_update
        , sbfl_last_update_by
        , sbfl_status
        , sbfl_current_lane
        , sbfl_current_lane_name
        , sbfl_potential_users
        , sbfl_potential_groups
        , sbfl_excluded_users        
        , sbfl_reservation
        , sbfl.sbfl_priority
        , sbfl.sbfl_due_on
        , prov.prov_var_vc2 as sbfl_business_ref
     from flow_subflows_vw sbfl
     left join flow_process_variables prov
        on prov.prov_prcs_id = sbfl.sbfl_prcs_id
       and prov.prov_var_name = 'BUSINESS_REF'
       and prov.prov_var_type = 'VARCHAR2' 
       and prov.prov_scope = 0
    where sbfl_status = 'running'
with read only
;

create or replace view flow_instance_connections_lov
as
  select cn.conn_bpmn_id
       , coalesce(cn.conn_name,conn_bpmn_id) conn_name
       , cn.conn_src_objt_id
       , objt.objt_bpmn_id as src_objt_bpmn_id
       , ins.prcs_id
       , prdg.prdg_id
    from flow_instances_vw ins
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = ins.prcs_id
    join flow_connections cn 
      on cn.conn_dgrm_id = prdg.prdg_dgrm_id
     and cn.conn_tag_name = 'bpmn:sequenceFlow'
    join flow_objects objt
      on objt.objt_id = cn.conn_src_objt_id
with read only;

create or replace view flow_instance_gateways_lov
as
  select obj.objt_id
       , obj.objt_bpmn_id
       , case when callobj.objt_id is null then 'Main Diagram' else callobj.objt_name end calling_object
       , case when obj.objt_name is null then obj.objt_bpmn_id else obj.objt_name || ' (' || obj.objt_bpmn_id ||')' end objt_name
       , case obj.objt_tag_name
           when 'bpmn:exclusiveGateway' then 'single'
           when 'bpmn:inclusiveGateway' then 'multi'
           else null
         end as select_option
       , ins.prcs_id
       , prdg.prdg_diagram_level
       , prdg.prdg_dgrm_id
       , prdg.prdg_prdg_id
       , prdg.prdg_id
    from flow_instances_vw ins
    join flow_instance_diagrams prdg
      on prdg.prdg_prcs_id = ins.prcs_id
     and prdg.prdg_diagram_level is not null
    join flow_objects obj
      on obj.objt_dgrm_id = prdg.prdg_dgrm_id
    left join flow_objects callobj
      on callobj.objt_dgrm_id = prdg.prdg_calling_dgrm
      and callobj.objt_bpmn_id = prdg.prdg_calling_objt
   where obj.objt_tag_name in ('bpmn:exclusiveGateway', 'bpmn:inclusiveGateway')
     and ( select count(*) 
           from flow_connections conn 
           where conn.conn_src_objt_id = obj.objt_id 
           and conn.conn_tag_name = 'bpmn:sequenceFlow') > 1
with read only;

create or replace view flow_instance_scopes_vw
as
  select prdg_prcs_id         iscp_prcs_id
       , prdg_diagram_level   iscp_valid_scope
    from flow_instance_diagrams
   where prdg_diagram_level is not null
  union
  select distinct iter_prcs_id iscp_prcs_id
       , iter_scope            iscp_valid_scope
    from flow_iterations
with read only;

create or replace view flow_diagrams_vw
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
       , dgrm.dgrm_last_update
       , dgrm.dgrm_content
  from flow_diagrams dgrm
with read only;

create or replace view flow_instance_diagrams_lov
as
  select distinct
    case when callobj.objt_id is null then 'Main Diagram' else callobj.objt_name end as calling_diagram,
    prdg.prdg_id,
    prdg.prdg_prcs_id
  from flow_instance_diagrams prdg
  join flow_objects obj
        on obj.objt_dgrm_id = prdg.prdg_dgrm_id
  left join flow_objects callobj 
    on callobj.objt_dgrm_id = prdg.prdg_calling_dgrm
        and callobj.objt_bpmn_id = prdg.prdg_calling_objt
  where obj.objt_tag_name in ('bpmn:exclusiveGateway', 'bpmn:inclusiveGateway')
  and ( select count(*) from flow_connections conn where conn.conn_src_objt_id = obj.objt_id ) > 1
with read only;

create or replace view flow_diagrams_instanciated_lov
as
  select dgrm.dgrm_id
       , dgrm.dgrm_name
       , dgrm.dgrm_version
       , dgrm.dgrm_status
       , dgrm.dgrm_category
    from flow_diagrams dgrm
   where exists 
         ( select null
             from flow_objects objt
            where objt.objt_dgrm_id = dgrm.dgrm_id
         )
    and exists (
      select 1
      from flow_instance_diagrams prdg
      where prdg.prdg_dgrm_id = dgrm.dgrm_id
    )
  with read only
  ;

/* 
-- Flows for APEX - flow_instance_timeline_vw.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    01-Feb-2023  Richard Allen (Oracle)
-- Edited     05-Jun-2023  Louis Moreaux, Insum
--
-- This view shows timeline of all logged events for a process
--
--
*/
create or replace view flow_instance_timeline_vw as
select 'created' operation
     , 'Instance Created' description
     , null as objt
     , null as subflow
     , 0 as process_level
     , null as proc_var
     , prcs.prcs_name as value
     , null as event_comment
     , prcs_init_ts performed_on
     , prcs_init_by performed_by
     , prcs_id 
  from flow_processes prcs
union
select 'started' operation
     , 'Instance Started' description
     , null as objt
     , null as subflow
     , 0 as process_level
     , null as proc_var 
     , prcs.prcs_name as value
     , null as event_comment
     , prcs_start_ts performed_on
     , null
     , prcs_id 
  from flow_processes prcs
union
select 'completed' operation
     , 'Instance completed' description
     , null as objt
     , null as subflow
     , 0 as process_level
     , null as proc_var
     , null as value
     , null as event_comment
     , prcs_start_ts performed_on
     , null
     , prcs_id 
  from flow_processes prcs
 where prcs.prcs_complete_ts is not null
union
select lgpr_prcs_event operation
     , lgpr_prcs_event 
     , lgpr_objt_id
     , null as subflow
     , null as process_level
     , null as proc_var
     , null as value
     , lgpr_comment as event_comment
     , lgpr_timestamp performed_on
     , lgpr_user
     , lgpr_prcs_id as prcs_id
  from    flow_instance_event_log lgpr
union 
select 'step current' as operation
     , 'Became Current after' as description
     , lgsf_objt_id as objt
     , lgsf_sbfl_id as subflow
     , lgsf_sbfl_process_level as process_level
     , null as proc_var
     , lgsf_last_completed as value
     , lgsf_comment as event_comment
     , lgsf_was_current as performed_on
     , null as performed_by
     , lgsf_prcs_id as prcs_id 
  from flow_step_event_log
union
select 'step started' as operation
     , 'Work Started on Step' description
     , lgsf_objt_id as objt
     , lgsf_sbfl_id as subflow
     , lgsf_sbfl_process_level as process_level
     , null as proc_var
     , null as value
     , lgsf_comment as event_comment
     , lgsf_started as performed_on
     , null as performed_by
     , lgsf_prcs_id as prcs_id 
  from flow_step_event_log
 where lgsf_started is not null
union 
select 'step completed' as operation
     , 'Step completed' description
     , lgsf_objt_id as objt
     , lgsf_sbfl_id as subflow
     , lgsf_sbfl_process_level as process_level
     , null as proc_var
     , null as value
     , lgsf_comment as event_comment
     , lgsf_completed as performed_on
     , lgsf_user as performed_by
     , lgsf_prcs_id as prcs_id 
  from flow_step_event_log   
union 
select 'variable set' as operation
     , 'Variable set' as description
     , lgvr_objt_id as objt
     , lgvr_sbfl_id as subflow
     , null as process_level
     , lgvr_var_name as proc_var
     , case lgvr_var_type 
          when 'VARCHAR2' then lgvr_var_vc2
          when 'NUMBER' then to_char(lgvr_var_num)
          when 'DATE' then to_char (lgvr_var_date, 'DD-MON-YY HH24:MI:SS')
          when 'TIMESTAMP WITH TIME ZONE' then to_char (lgvr_var_tstz, 'DD-MON-YY HH24:MI:SS TZR')
          when 'CLOB' then 'CLOB Value'
          end as value
     , lgvr_expr_set as event_comment
     , lgvr_timestamp as performed_on
     , null as performed_by
     , lgvr_prcs_id as prcs_id 
  from    flow_variable_event_log
order by performed_on
with read only;

/* 
-- Flows for APEX - flow_startable_diagrams_vw.sql
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created    05-Apr-2023  Richard Allen (Oracle)
-- Edited     05-Jun-2023  Louis Moreaux, Insum
-- Edited     07-Oct-2024  Dennis Amthor, Hyand Solutions GmbH
--
-- This view shows any process diagrams that are marked as startable, along with users and groups that can start them
-- and excluded uses who cannot start them (takes precedence over positive grants in potentialStartingGroups).
--
--  -- Note this View can only be queried inside an APEX session
--
*/
create or replace view flow_startable_diagrams_vw
as 
select dgrm.dgrm_id
     , dgrm.dgrm_name
     , dgrm.dgrm_version
     , dgrm.dgrm_status
     , objt.objt_name process_name
     , objt.objt_bpmn_id process_bpmn_id
     , nvl2(objt.objt_attributes."apex"."potentialStartingUsers", flow_settings.get_vc2_expression(pi_expr=> objt.objt_attributes."apex"."potentialStartingUsers"),null) potential_starting_users
     , nvl2(objt.objt_attributes."apex"."potentialStartingGroups", flow_settings.get_vc2_expression(pi_expr=> objt.objt_attributes."apex"."potentialStartingGroups"),null) potential_starting_groups
     , nvl2(objt.objt_attributes."apex"."excludedStartingUsers", flow_settings.get_vc2_expression(pi_expr=> objt.objt_attributes."apex"."excludedStartingUsers"),null) excluded_starting_users
  from flow_diagrams dgrm
  join flow_objects objt
    on dgrm.dgrm_id = objt.objt_dgrm_id
   and objt.objt_attributes."apex"."isStartable" = 'true'
  with read only;


create or replace view flow_message_subscriptions_vw
as
   select mes.msub_id,
          mes.msub_message_name,
          mes.msub_key_name,
          mes.msub_key_value,
          mes.msub_prcs_id,
          mes.msub_sbfl_id,
          mes.msub_step_key,
          mes.msub_dgrm_id,
          mes.msub_callback,
          mes.msub_callback_par,
          mes.msub_payload_var,
          mes.msub_created
     from flow_message_subscriptions mes
with read only;
create or replace view flow_rest_diagrams_vw
      (
          dgrm_id
        , name 
        , version
        , status 
        , category 
        , links
      )
  as
  select  d.dgrm_id
        , d.dgrm_name     as name
        , d.dgrm_version  as version
        , d.dgrm_status   as status
        , d.dgrm_category as category
        , json_array(
            flow_rest_api_v1.get_links_string_http_GET('diagram',d.dgrm_id) format json
          ) links
    from flow_diagrams d;
create or replace view flow_rest_message_subscriptions_vw
      (
         msub_id
       , name
       , key
       , value
       , prcs_id
       , sbfl_id
       , step_key    
      )
  as
  select ms.msub_id
       , ms.msub_message_name as name
       , ms.msub_key_name     as key
       , ms.msub_key_value    as value
       , ms.msub_prcs_id      as prcs_id
       , ms.msub_sbfl_id      as sbfl_id
       , ms.msub_step_key     as step_key
  from flow_message_subscriptions ms;
create or replace view flow_rest_process_vars_vw
      (
          prcs_id
        , scope 
        , name 
        , type 
        , value
      )
  as
  select  pv.prov_prcs_id  as prcs_id
        , pv.prov_scope    as scope
        , pv.prov_var_name as name
        , pv.prov_var_type as type
        , decode( lower(pv.prov_var_type) 
              , 'varchar2', pv.prov_var_vc2
              , 'number',   pv.prov_var_num
              , 'date',     pv.prov_var_date
              , 'clob',     pv.prov_var_clob
              , 'timestamp with time zone', pv.prov_var_tstz
              , 'json', pv.prov_var_json
              , null ) as value
  from flow_process_variables pv
/

create or replace view flow_rest_processes_vw
      (
          dgrm_id
        , prcs_id
        , name
        , status
        , init_ts
        , init_by
        , process_vars
        , links
      )
  as
  SELECT  
          d.dgrm_id
        , p.prcs_id
        , p.prcs_name     as name
        , p.prcs_status   as status
        , p.prcs_init_ts  as init_ts
        , p.prcs_init_by  as init_by
        , json_array( 
            listagg( 
                json_object (
                  'scope' value pv.prov_scope
                 , 'name' value pv.prov_var_name
                 , 'type' value pv.prov_var_type
                 , 'value' value decode( lower(pv.prov_var_type) 
                                      , 'varchar2', pv.prov_var_vc2
                                      , 'number',   pv.prov_var_num
                                      , 'date',     pv.prov_var_num
                                      , 'clob',     pv.prov_var_num
                                      , null )
                )     
            ,',') format json
          ) process_vars
        , json_array(
            flow_rest_api_v1.get_links_string_http_GET('process',p.prcs_id) format json
          ) links
  from flow_diagrams d
  join flow_processes p on d.dgrm_id = p.prcs_dgrm_id
  left join flow_process_variables pv on p.prcs_id = pv.prov_prcs_id
  group by  d.dgrm_id
          , p.prcs_id
          , p.prcs_name
          , p.prcs_status
          , p.prcs_init_ts
          , p.prcs_init_by
/

create or replace view flow_rest_subflows_vw
      (
         prcs_id
       , sbfl_id
       , sbfl_sbfl_id
       , process_level
       , diagram_level
       , calling_sbfl
       , scope
       , "current"
       , step_key
       , status
       , became_current
       , reservation
       , links
      )
  as
  select p.prcs_id
       , s.sbfl_id
       , s.sbfl_sbfl_id
       , s.sbfl_process_level   as process_level
       , s.sbfl_diagram_level   as diagram_level
       , s.sbfl_calling_sbfl    as calling_sbfl
       , s.sbfl_scope           as scope
       , s.sbfl_current         as "current"
       , s.sbfl_step_key        as step_key
       , s.sbfl_status          as status
       , s.sbfl_became_current  as became_current
       , s.sbfl_reservation     as reservation
       , json_array(
           flow_rest_api_v1.get_links_string_http_GET('step',s.sbfl_id) format json
         ) links
  from flow_processes p
  join flow_subflows s on p.prcs_id = s.sbfl_prcs_id;

create or replace view flow_p0002_diagrams_vw
as
  with instance_numbers as
  (
    select prdg_dgrm_id as dgrm_id
         , created_cnt
         , running_cnt
         , completed_cnt
         , terminated_cnt
         , error_cnt
         , created_cnt + running_cnt + completed_cnt + terminated_cnt + error_cnt as total_cnt 
      from (
             select prdg.prdg_dgrm_id
                  , prcs.prcs_status
               from flow_processes prcs
               join flow_instance_diagrams prdg
                 on prdg.prdg_prcs_id = prcs.prcs_id
           group by prcs.prcs_id, prdg.prdg_dgrm_id, prcs.prcs_status
           )
     pivot (
             count(*) for
               prcs_status in ( 'created' created_cnt, 'running' running_cnt, 'completed' completed_cnt
                              , 'terminated' terminated_cnt, 'error' as error_cnt
                              )
           )
  )
    select d.dgrm_id
         , d.dgrm_name
         , d.dgrm_version
         , d.dgrm_status
         , d.dgrm_category
         , d.dgrm_last_update at time zone sessiontimezone as dgrm_last_update
         , null as btn
         , apex_page.get_url(p_page => 7, p_items => 'P7_DGRM_ID', p_values => d.dgrm_id) as edit_link
         , apex_page.get_url(p_page => 11, p_items => 'P11_DGRM_ID', p_values => d.dgrm_id) as create_instance_link
         , decode(inst_nums.total_cnt, 0, null, inst_nums.total_cnt) as instances 
         , case when not exists( select null from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id ) then 'No' else 'Yes' end as diagram_parsed
         , case when not exists( select null from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id ) then 'fa-times-circle-o fa-lg u-danger-text' else 'fa-check-circle-o fa-lg u-success-text' end as diagram_parsed_icon
         , case dgrm_status
             when 'draft'      then 'fa fa-wrench'
             when 'released'   then 'fa fa-check'
             when 'deprecated' then 'fa fa-ban'
             when 'archived'   then 'fa fa-archive'
           end as dgrm_status_icon
         , nullif(inst_nums.created_cnt, 0) as instance_created
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',created', p_clear_cache => 'RP,RIR') as instance_created_link
         , nullif(inst_nums.running_cnt, 0) as instance_running
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',running', p_clear_cache => 'RP,RIR') as instance_running_link
         , nullif(inst_nums.completed_cnt, 0) as instance_completed
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',completed', p_clear_cache => 'RP,RIR') as instance_completed_link
         , nullif(inst_nums.terminated_cnt, 0) as instance_terminated
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',terminated', p_clear_cache => 'RP,RIR') as instance_terminated_link
         , nullif(inst_nums.error_cnt, 0) as instance_error
         , apex_page.get_url(p_page => 10, p_items => 'P10_FILTER_DGRM_ID,IR_PRCS_STATUS', p_values => d.dgrm_id||',error', p_clear_cache => 'RP,RIR') as instance_error_link
         , apex_item.checkbox2(p_idx => 1, p_value => d.dgrm_id, p_attributes => 'data-name = "' || dgrm_name || '" data-version = "' || dgrm_version || '"') as checkbox
      from flow_diagrams_vw d
 left join instance_numbers inst_nums
        on inst_nums.dgrm_id = d.dgrm_id
with read only
;

create or replace view flow_p0007_vw
as
  select 
      dgrm.dgrm_content
    , dgrm.dgrm_id
  from flow_diagrams dgrm
with read only;

create or replace view flow_p0007_diagrams_var_vw
as
   select 
      objt_dgrm_id,
      'In' as var_direction,
      jt.var_name,
      jt.var_type,
      jt.var_desc
   from flow_objects objt,
   json_table( objt.objt_attributes, '$.apex.inVariables[*]'
      columns
           var_name varchar2(4000) path '$.varName'
         , var_type varchar2(4000) path '$.varDataType'
         , var_desc varchar2(4000) path '$.varDescription'
   ) jt
   where objt_attributes is not null
     and objt_tag_name = 'bpmn:process'
   union
   select 
      objt_dgrm_id,
      'Out' as var_direction,
      jt.var_name,
      jt.var_type,
      jt.var_desc
   from flow_objects objt,
   json_table( objt.objt_attributes, '$.apex.outVariables[*]'
      columns
           var_name varchar2(4000) path '$.varName'
         , var_type varchar2(4000) path '$.varDataType'
         , var_desc varchar2(4000) path '$.varDescription'
   ) jt
      where objt_attributes is not null
      and objt_tag_name = 'bpmn:process'
with read only;

create or replace view flow_p0007_diagrams_attributes_vw
as
   select 
   objt_dgrm_id,
   jt.application_id,
   jt.page_id,
   jt.username,
   jt.is_callable
from flow_objects objt,
json_table( objt.objt_attributes, '$.apex'
   columns
        application_id     varchar2(4000) path '$.applicationId'
      , page_id            varchar2(4000) path '$.pageId'
      , username           varchar2(4000) path '$.username'
      , is_callable        varchar2(4000) path '$.isCallable'
   ) jt
   where objt_attributes is not null
   and objt_tag_name = 'bpmn:process'
with read only;

create or replace view flow_p0007_called_diagrams_vw
as
  with diagrams as
      (
         select dgrm.dgrm_id,
                null    as calling_dgrm,
                null    as calling_objt,
                dgrm.dgrm_name,
                dgrm.dgrm_version
           from flow_diagrams dgrm
         union all
         select dgrm.dgrm_id,
                objt.objt_dgrm_id as calling_dgrm,
                objt.objt_bpmn_id as calling_objt,
                dgrm.dgrm_name,
                dgrm.dgrm_version
           from flow_objects  objt
           join flow_diagrams dgrm
             on objt.objt_tag_name = 'bpmn:callActivity'
            and dgrm_id = flow_engine_app_api.get_current_diagram(
                   pi_dgrm_name           => objt.objt_attributes."apex"."calledDiagram",
                   pi_dgrm_calling_method => objt.objt_attributes."apex"."calledDiagramVersionSelection",
                   pi_dgrm_version        => objt.objt_attributes."apex"."calledDiagramVersion"
                )
      )
   select dgrm.dgrm_id,
          dgrm.calling_dgrm,
          dgrm.calling_objt,
          dgrm.dgrm_name,
          dgrm_version,
          connect_by_root(dgrm.dgrm_id) as root_dgrm,
          connect_by_iscycle as has_recursion,
          case when connect_by_iscycle = 1 then
            'fa fa-exclamation-triangle-o fa-lg u-warning-text'
          end has_recursion_icon
     from diagrams dgrm
    start with dgrm.calling_dgrm is null
  connect by nocycle dgrm.calling_dgrm = prior dgrm.dgrm_id
with read only;

create or replace view flow_p0007_calling_diagrams_vw
as
  select 
    dgrm.dgrm_id,
    dgrm.dgrm_name,
    dgrm.dgrm_version,
    objt.objt_name,
    objt.objt_attributes."apex"."calledDiagram" as called_diagram,
    objt.objt_attributes."apex"."calledDiagramVersionSelection" as called_diagram_version_selection,
    objt.objt_attributes."apex"."calledDiagramVersion" as called_diagram_version
  from flow_objects  objt
  join flow_diagrams dgrm
    on objt.objt_tag_name = 'bpmn:callActivity'
  and objt.objt_dgrm_id = dgrm.dgrm_id
with read only;

create or replace view flow_p0008_instance_details_vw
as
  select 
       prcs_id,
       prcs_name,
       dgrm_name,
       dgrm_version,
       prcs_status as status,
       prcs_priority as priority,
       prcs_init_ts at time zone sessiontimezone as initialized_on,
       prcs_last_update at time zone sessiontimezone as last_update_on,
       prcs_due_on at time zone sessiontimezone as due_on,
       prcs_business_ref as business_reference
  from flow_instances_vw
with read only;

create or replace view flow_p0008_instance_log_vw
as
  select lgpr.lgpr_prcs_id
       , lgpr.lgpr_prcs_name
       , lgpr.lgpr_business_id
       , lgpr.lgpr_prcs_event
       , case lgpr.lgpr_prcs_event
           when 'started' then 'fa-play-circle-o'
           when 'running' then 'fa-play-circle-o'
           when 'created' then 'fa-plus-circle-o'
           when 'completed' then 'fa-check-circle-o'
           when 'terminated' then 'fa-stop-circle-o'
           when 'error' then 'fa-exclamation-circle-o'
           when 'reset' then 'fa-undo'
           when 'restart step' then 'fa-undo'
           when 'rescheduled' then 'fa-clock-o'
         end as lgpr_prcs_event_icon
       , lgpr.lgpr_timestamp at time zone sessiontimezone as lgpr_timestamp
       , lgpr.lgpr_user
       , lgpr.lgpr_comment
       , lgpr_error_info
       , case when lgpr_error_info is not null then '<pre><code class="language-log">' end as pretag
       , case when lgpr_error_info is not null then '</code></pre>' end as posttag
       , lgpr.lgpr_objt_id
    from flow_instance_event_log lgpr
with read only;

create or replace view flow_p0008_subflows_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_prcs_id
       , sbfl.sbfl_current_name as sbfl_current
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
             when 'waiting for approval' then 'fa fa-question-square-o'
             when 'waiting for message' then 'fa fa-envelope-o'
             when 'waiting iterations' then 'fa fa-align-justify fa-rotate-90'
             when 'iterating' then 'fa fa-align-justify fa-rotate-90'
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

create or replace view flow_p0008_variables_vw
as
  select apex_item.checkbox( p_idx => 3, p_value => prov_var_name, p_attributes => 'data-prcs="'|| prov_prcs_id || '"') as checkbox,
       null as action,
       prov_prcs_id,
       prov_var_name,
       prov_var_type,
       prov_scope, 
       ( select nvl(objt.objt_name, 'Main Diagram')
           from flow_instance_diagrams prdg 
         left join flow_objects objt
             on prdg.prdg_calling_objt = objt.objt_bpmn_id
            and prdg.prdg_calling_dgrm = objt.objt_dgrm_id
          where prdg.prdg_diagram_level = prov_scope 
            and prdg.prdg_prcs_id =prov_prcs_id) as Calling_object,
       case
            when prov_var_vc2  is not null then prov_var_vc2
            when prov_var_num  is not null then cast(prov_var_num as varchar2(4000))
            when prov_var_date is not null then to_char(prov_var_date, v('APP_DATE_TIME_FORMAT'))
            when prov_var_clob is not null then cast(dbms_lob.substr(prov_var_clob, 4000) as  varchar2(4000))
            when prov_var_tstz is not null then to_char(prov_var_tstz, 'YYYY-MM-DD HH24:MI:SS TZR')
            when prov_var_json is not null then to_char(prov_var_json)
        end as prov_var_value,
        case when instr(prov_var_name, ':route') > 0 then 'true' else 'false' end is_gateway_route
    from flow_instance_variables_vw
with read only;

create or replace view flow_p0008_message_subscriptions_vw
as
   select mes.msub_id,
          mes.msub_message_name,
          mes.msub_key_name,
          mes.msub_key_value,
          mes.msub_prcs_id,
          mes.msub_payload_var,
          mes.msub_created,
          null as action
     from flow_message_subscriptions_vw mes
with read only;
create or replace view flow_p0008_vw
as
  select dgrm_content
       , prcs_id
       , all_completed
       , all_errors
       , all_current
       , dgrm_id
       , calling_dgrm
       , calling_objt
       , breadcrumb
       , drilldown_allowed
       , iteration_data
       , prdg_id
       , prdg_prdg_id
       , user_task_urls
    from flow_instance_details_vw
with read only;

create or replace view flow_p0010_instances_vw
as
   select prcs_id
        , prcs_name
        , prcs_dgrm_id
        , prcs_dgrm_name
        , prcs_dgrm_version
        , prcs_dgrm_status
        , prcs_dgrm_category
        , prcs_status
        , prcs_dgrm_status_icon
        , prcs_priority
        , prcs_status_icon
        , prcs_due_on
        , prcs_init_date
        , prcs_last_update
        , prcs_business_ref
        , null as btn
        , apex_item.checkbox2(p_idx => 1, p_value => prcs_id, p_attributes => 'data-prcs = "' || prcs_id || '" data-status = "' || prcs_status ||'"') as checkbox
        , null as quick_action
     from ( select prcs_id
                 , prcs_name
                 , dgrm_id as prcs_dgrm_id
                 , dgrm_name as prcs_dgrm_name
                 , dgrm_version as prcs_dgrm_version
                 , dgrm_status as prcs_dgrm_status
                 , case dgrm_status
                  when 'draft' then 'fa fa-wrench'
                  when 'released' then 'fa fa-check'
                  when 'deprecated' then 'fa fa-ban'
                  when 'archived' then 'fa fa-archive'
                end as prcs_dgrm_status_icon
                 , prcs_priority
                 , dgrm_category as prcs_dgrm_category
                 , prcs_status
                 , prcs_due_on at time zone sessiontimezone as prcs_due_on
                 , prcs_init_ts at time zone sessiontimezone as prcs_init_date
                 , prcs_last_update at time zone sessiontimezone as prcs_last_update
                 , prcs_business_ref
                 , case prcs_status
                     when 'running' then 'fa-play-circle-o'
                     when 'created' then 'fa-plus-circle-o'
                     when 'completed' then 'fa-check-circle-o'
                     when 'terminated' then 'fa-stop-circle-o'
                     when 'error' then 'fa-exclamation-circle-o'
                   end as prcs_status_icon
              from flow_instances_vw
          )
with read only
;

create or replace view flow_p0010_vw
as
  select dgrm_content
       , prcs_id
       , all_completed
       , all_errors
       , all_current
       , dgrm_id
       , calling_dgrm
       , calling_objt
       , breadcrumb
       , drilldown_allowed
       , prdg_id
       , prdg_prdg_id
       , user_task_urls
       , iteration_data
    from flow_instance_details_vw
with read only;

create or replace view flow_p0013_attributes_vw
as
   with datas as (
      select 
         objt_attributes as attributes,
         objt_dgrm_id as dgrm_id,
         objt_bpmn_id as bpmn_id
      from flow_objects
      where objt_attributes is not null
      union all
      select 
         conn_attributes as attributes,
         conn_dgrm_id as dgrm_id,
         conn_bpmn_id as bpmn_id
      from flow_connections
      where conn_attributes is not null
   )
   select 
      json_query(attributes, '$' returning clob pretty) as json_attributes,
      dgrm_id,
      bpmn_id 
   from datas
with read only;

create or replace view flow_p0013_expressions_vw
as
  select objt.objt_bpmn_id
       , expr.expr_set
       , expr.expr_var_name
       , expr.expr_var_type
       , expr.expr_type
       , expr.expr_expression
       , objt.objt_dgrm_id
       , case when instr(expr.expr_type, 'sql') > 0 then '<pre><code class="language-' || case when instr(expr.expr_type, 'plsql') > 0 then 'plsql' else 'sql' end ||'">' end as pretag
       , case when instr(expr.expr_type, 'sql') > 0 then '</code></pre>' end as posttag
    from flow_object_expressions expr
    join flow_objects objt
      on expr.expr_objt_id = objt.objt_id
with read only;

create or replace view flow_p0013_instance_log_vw
as
  select lgpr.lgpr_prcs_id
       , lgpr.lgpr_objt_id
       , lgpr.lgpr_prcs_name
       , lgpr.lgpr_business_id
       , lgpr.lgpr_prcs_event
       , case lgpr.lgpr_prcs_event
           when 'started' then 'fa-play-circle-o'
           when 'running' then 'fa-play-circle-o'
           when 'created' then 'fa-plus-circle-o'
           when 'completed' then 'fa-check-circle-o'
           when 'terminated' then 'fa-stop-circle-o'
           when 'error' then 'fa-exclamation-circle-o'
           when 'reset' then 'fa-undo'
           when 'restart step' then 'fa-undo'
         end as lgpr_prcs_event_icon
       , lgpr.lgpr_timestamp at time zone sessiontimezone as lgpr_timestamp
       , lgpr.lgpr_user
       , lgpr.lgpr_comment
       , lgpr_error_info
       , case when lgpr_error_info is not null then '<pre><code class="language-log">' end as pretag
       , case when lgpr_error_info is not null then '</code></pre>' end as posttag
    from flow_instance_event_log lgpr
with read only;

create or replace view flow_p0013_step_log_vw
as
  select lgsf.lgsf_prcs_id
       , lgsf.lgsf_objt_id
       , lgsf.lgsf_sbfl_id
       , lgsf.lgsf_sbfl_process_level
       , lgsf.lgsf_last_completed
       , lgsf.lgsf_status_when_complete
       , lgsf.lgsf_was_current at time zone sessiontimezone as lgsf_was_current
       , lgsf.lgsf_started at time zone sessiontimezone as lgsf_started
       , lgsf.lgsf_completed at time zone sessiontimezone as lgsf_completed
       , lgsf.lgsf_reservation
       , lgsf.lgsf_user
       , lgsf.lgsf_comment
    from flow_step_event_log lgsf
with read only;

create or replace view flow_p0013_subflows_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_prcs_id
       , sbfl.sbfl_step_key
       , sbfl.sbfl_process_level
       , sbfl.sbfl_diagram_level
       , sbfl.sbfl_scope
       , sbfl.sbfl_last_completed
       , sbfl.sbfl_current
       , sbfl.sbfl_status
       , sbfl.sbfl_became_current at time zone sessiontimezone as sbfl_became_current
       , sbfl.sbfl_work_started at time zone sessiontimezone as sbfl_work_started
       , sbfl.sbfl_reservation
       , sbfl.sbfl_last_update at time zone sessiontimezone as sbfl_last_update
    from flow_subflows sbfl
with read only;

create or replace view flow_p0013_variable_log_vw
as
  select lgvr_prcs_id
       , lgvr_objt_id
       , lgvr_var_name
       , lgvr_scope
       , lgvr_expr_set
       , lgvr_timestamp at time zone sessiontimezone as lgvr_timestamp
       , lgvr_var_type
       , case
           when lgvr_var_vc2 is not null then lgvr_var_vc2
           when lgvr_var_num is not null then cast (lgvr_var_num as varchar2(4000))
           when lgvr_var_date is not null then to_char(lgvr_var_date, v('APP_DATE_TIME_FORMAT'))
           when lgvr_var_tstz is not null then to_char(lgvr_var_tstz, v('NLS_TIMESTAMP_TZ_FORMAT'))
           when lgvr_var_clob is not null then '[clob]'
           when lgvr_var_json is not null then cast(dbms_lob.substr(lgvr_var_json, 4000) as  varchar2(4000))
         end as lgvr_value
    from flow_variable_event_log
with read only;


create or replace view flow_p0013_called_diagrams_vw
as
   select 
      prdg.prdg_prdg_id,
      prdg.prdg_calling_dgrm,
      prdg.prdg_calling_objt,
      prdg.prdg_diagram_level,
      dgrm.dgrm_name,
      dgrm.dgrm_version,
      dgrm.dgrm_status,
      prdg.prdg_diagram_level as scope
   from flow_instance_diagrams prdg
   join flow_diagrams dgrm on dgrm.dgrm_id = prdg.prdg_dgrm_id
with read only;

create or replace view flow_p0014_instance_log_vw
as
  select lgpr.lgpr_prcs_id
       , lgpr.lgpr_objt_id
       , lgpr.lgpr_prcs_name
       , lgpr.lgpr_business_id
       , lgpr.lgpr_prcs_event
       , case lgpr.lgpr_prcs_event
           when 'started' then 'fa-play-circle-o'
           when 'running' then 'fa-play-circle-o'
           when 'created' then 'fa-plus-circle-o'
           when 'completed' then 'fa-check-circle-o'
           when 'terminated' then 'fa-stop-circle-o'
           when 'error' then 'fa-exclamation-circle-o'
           when 'reset' then 'fa-undo'
           when 'restart step' then 'fa-undo'
           when 'rescheduled' then 'fa-clock-o'
         end as lgpr_prcs_event_icon
       , lgpr.lgpr_timestamp at time zone sessiontimezone as lgpr_timestamp
       , lgpr.lgpr_user
       , lgpr.lgpr_comment
       , lgpr_error_info
       , case when lgpr_error_info is not null then '<pre><code class="language-log">' end as pretag
       , case when lgpr_error_info is not null then '</code></pre>' end as posttag
    from flow_instance_event_log lgpr
with read only;

create or replace view flow_p0014_step_log_vw
as
  select distinct lgsf.lgsf_prcs_id
                , coalesce(objt.objt_name, lgsf.lgsf_objt_id) as completed_object
                , lgsf.lgsf_sbfl_id
                , lgsf.lgsf_sbfl_process_level
                , lgsf.lgsf_last_completed
                , lgsf.lgsf_status_when_complete
                , lgsf.lgsf_was_current at time zone sessiontimezone as lgsf_was_current
                , lgsf.lgsf_started at time zone sessiontimezone as lgsf_started
                , lgsf.lgsf_completed at time zone sessiontimezone as lgsf_completed
                , lgsf.lgsf_reservation
                , lgsf.lgsf_user
                , lgsf.lgsf_comment
             from flow_step_event_log lgsf
             join flow_objects objt
               on lgsf.lgsf_objt_id = objt.objt_bpmn_id
              and lgsf.lgsf_sbfl_dgrm_id = objt.objt_dgrm_id
with read only;

create or replace view flow_p0014_subflows_vw
as
  select distinct sbfl.sbfl_id
                , sbfl.sbfl_prcs_id
                , sbfl.sbfl_step_key
                , sbfl.sbfl_process_level
                , sbfl.sbfl_diagram_level
                , sbfl.sbfl_scope
                , sbfl.sbfl_last_completed
                , coalesce(objt.objt_name, sbfl.sbfl_current) as current_object
                , sbfl.sbfl_status
                , sbfl.sbfl_became_current at time zone sessiontimezone as sbfl_became_current
                , sbfl.sbfl_work_started at time zone sessiontimezone as sbfl_work_started
                , sbfl.sbfl_reservation
                , sbfl.sbfl_last_update at time zone sessiontimezone as sbfl_last_update
             from flow_subflows sbfl
             join flow_objects objt
               on sbfl.sbfl_current = objt.objt_bpmn_id
              and sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
with read only;

create or replace view flow_p0014_variable_log_vw
as
  select lgvr_prcs_id
       , lgvr_sbfl_id
       , lgvr_objt_id
       , lgvr_var_name
       , lgvr_scope
       , lgvr_expr_set
       , lgvr_timestamp at time zone sessiontimezone as lgvr_timestamp
       , lgvr_var_type
       , case
           when lgvr_var_vc2 is not null then lgvr_var_vc2
           when lgvr_var_num is not null then cast(lgvr_var_num as varchar2(4000))
           when lgvr_var_date is not null then cast(lgvr_var_date as varchar2(4000))
           when lgvr_var_clob is not null then '[clob]'
           when lgvr_var_json is not null then cast(dbms_lob.substr(lgvr_var_json, 4000) as  varchar2(4000))
         end as lgvr_value
    from flow_variable_event_log
with read only;

create or replace view flow_p0020_instance_timeline_vw as
select prcs_id
     , to_char(performed_on, 'YYYY-MM-DD HH24:MI:SSXFF TZR') event_date
     , lower(performed_by) user_name
     , case operation
        when 'variable set' then 'Variable "'||proc_var||'" set to "'||value||'".'
        when 'step current' then 'Step '||objt||' became Current'
        when 'step started' then 'Step '||objt||' started work'
        when 'step completed' then 'Step '||objt||' completed'
        when 'created' then 'Process Instance Created'
        when 'started' then 'Process Instance Started'
        else description
       end as event_title
     , operation as event_type
     , case operation
        when 'step current' then 'is-new'
        when 'step started' then 'is-updated'
        when 'step completed' then 'is-new'
        when 'completed' then 'is-removed'
        when 'started' then 'is-new'
        when 'created' then 'is-new'
        when 'reset' then 'is-removed'
        when 'error' then 'is-removed'
        when 'variable set' then 'is-updated'
        when 'Gateway Processed' then 'is-updated'
        when 'start called model' then 'is-new'
        when 'finish called model' then 'is-new'
       end as event_status
     , case operation
        when 'step current' then 'subflow '||subflow|| ' • process level '||process_level||nvl2(value,' • previous step  '||value,'')
        when 'step started' then 'subflow '||subflow|| nvl2(value,' • reserved by '||value,' • not reserved')
        when 'step completed' then null
        when 'created' then 'process '||prcs_id||nvl2(value,' • name '||value,'')
        when 'started' then 'process '||prcs_id||nvl2(value,' • name '||value,'')    
        when 'variable set' then 
                  nvl2(objt,'step '||objt||' ','')
                ||nvl2(subflow,'• subflow '||subflow||' ','')
                ||nvl2(event_comment,'• expression set '||event_comment,'')
        when 'Gateway Processed' then 'subflow '||subflow||' • forward paths - '||event_comment
        when 'start called model' then event_comment
        when 'finish called model' then event_comment
        else 'Object '||objt||'  subflow ' ||subflow||' • variable '||proc_var||' • value '||value        
       end as event_desc
     , 'u-color-44 fa fa-clock-o' as USER_COLOR
     , case operation
        when 'step current' then 'fa fa-circle-o'
        when 'step started' then 'fa fa-play-circle-o'
        when 'step completed' then 'fa fa-check-circle-o'
        when 'completed' then 'fa fa-dot-circle-o'
        when 'started' then 'fa fa-circle-o'
        when 'created' then 'fa fa-server-new'
        when 'reset' then 'fa fa-fast-backward'
        when 'error' then 'fa fa-exclamation-circle'
        when 'variable set' then 'fa fa-window-terminal'
        when 'Gateway Processed' then 'fa fa-index'   
        when 'start called model' then 'fa fa-box-arrow-in-south'
        when 'finish called model' then 'fa fa-box-arrow-out-north'
       end as event_icon
     , operation
     , objt
     , proc_var
     , value
     , subflow
     , process_level
     , performed_by
from flow_instance_timeline_vw;
