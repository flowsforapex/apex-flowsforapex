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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_task_inbox_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Subflows currently at user tasks with assignment, priority, business reference, and rendered task link'
  );

alter view flow_task_inbox_vw modify (link_text annotations (add content 'Rendered HTML anchor linking to the current task APEX page'));

alter view flow_task_inbox_vw modify (sbfl_business_ref annotations (add content 'Business reference value from the BUSINESS_REF process variable'));
whenever sqlerror exit failure
