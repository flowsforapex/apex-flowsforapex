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
        , coalesce( objt_curr.objt_name, sbfl.sbfl_current ) as sbfl_current_name
        , sbfl.sbfl_step_key
        , objt_curr.objt_tag_name as sbfl_current_tag_name
        , sbfl.sbfl_last_update
        , sbfl.sbfl_status
        , sbfl.sbfl_lane as sbfl_current_lane
        , sbfl.sbfl_lane_name as sbfl_current_lane_name
        , sbfl.sbfl_process_level
        , sbfl.sbfl_diagram_level
        , sbfl.sbfl_scope
        , sbfl.sbfl_reservation
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
      and timr.timr_status != 'E'
with read only
;
