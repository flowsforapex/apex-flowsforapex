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

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_subflows_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'All subflow execution instances with current and completed objects, assignments, lane data, and timer information'
  );

alter view flow_subflows_vw modify (sbfl_process_name annotations (add content 'Process instance name resolved from the process record'));
alter view flow_subflows_vw modify (sbfl_dgrm_id annotations (add content 'Diagram ID of the top-level process diagram'));
alter view flow_subflows_vw modify (sbfl_sbfl_dgrm_id annotations (add content 'Diagram ID at the subflow level for called diagrams'));
alter view flow_subflows_vw modify (sbfl_dgrm_name annotations (add content 'Name of the diagram this subflow is executing'));
alter view flow_subflows_vw modify (sbfl_dgrm_version annotations (add content 'Version of the diagram this subflow is executing'));
alter view flow_subflows_vw modify (sbfl_dgrm_status annotations (add content 'Status of the diagram this subflow is executing'));
alter view flow_subflows_vw modify (sbfl_dgrm_category annotations (add content 'Category of the diagram this subflow is executing'));
alter view flow_subflows_vw modify (sbfl_starting_object_name annotations (add content 'Display name of the subflow starting BPMN object'));
alter view flow_subflows_vw modify (sbfl_route_name annotations (add content 'Display name of the sequence flow route taken'));
alter view flow_subflows_vw modify (sbfl_last_completed_name annotations (add content 'Display name of the last completed BPMN object'));
alter view flow_subflows_vw modify (sbfl_current_name annotations (add content 'Display name of the current BPMN object, including loop counter'));
alter view flow_subflows_vw modify (sbfl_iteration_path annotations (add content 'Human-readable path of the current iteration for looping subflows'));
alter view flow_subflows_vw modify (sbfl_current_tag_name annotations (add content 'BPMN element type of the current object'));
alter view flow_subflows_vw modify (sbfl_current_lane annotations (add content 'Lane BPMN ID where the current step is executing'));
alter view flow_subflows_vw modify (sbfl_current_lane_name annotations (add content 'Display name of the lane where the current step is executing'));
alter view flow_subflows_vw modify (sbfl_current_objt_id annotations (add content 'Internal object ID of the current BPMN object'));
alter view flow_subflows_vw modify (sbfl_prcs_init_ts annotations (add content 'Timestamp when the parent process instance was created'));
alter view flow_subflows_vw modify (timr_start_on annotations (add content 'Scheduled start time for subflows waiting for a timer'));
whenever sqlerror exit failure
