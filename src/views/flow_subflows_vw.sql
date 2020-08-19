  create or replace view FLOW_SUBFLOWS_VW as (
           select sbfl.sbfl_id
                , sbfl.sbfl_sbfl_id
                , sbfl.sbfl_prcs_id
                , coalesce( prcs.prcs_name, to_char(sbfl.sbfl_prcs_id)) as sbfl_process_name
                , sbfl.sbfl_starting_object
                , coalesce( objt_start.objt_name, sbfl.sbfl_starting_object ) as sbfl_starting_object_name
                , sbfl.sbfl_route
                , coalesce( conn.conn_name, sbfl.sbfl_route ) as sbfl_route_name
                , sbfl.sbfl_last_completed
                , coalesce( objt_last.objt_name, sbfl.sbfl_last_completed ) as sbfl_last_completed_name
                , sbfl.sbfl_current
                , coalesce( objt_curr.objt_name, sbfl.sbfl_current ) as sbfl_current_name
                , sbfl.sbfl_last_update
                , sbfl.sbfl_status
                , flow_api_pkg.next_step_type( p_sbfl_id => sbfl_id ) as sbfl_next_step_type
                , lane.objt_bpmn_id as sbfl_current_lane
                , coalesce( lane.objt_name, lane.objt_bpmn_id) as sbfl_current_lane_name
             from flow_subflows sbfl
             join flow_processes prcs
               on prcs.prcs_id = sbfl.sbfl_prcs_id
        left join flow_objects objt_start
               on objt_start.objt_bpmn_id = sbfl.sbfl_starting_object
              and objt_start.objt_dgrm_id = prcs.prcs_dgrm_id
        left join flow_objects objt_curr
               on objt_curr.objt_bpmn_id = sbfl.sbfl_current
              and objt_curr.objt_dgrm_id = prcs.prcs_dgrm_id
        left join flow_objects objt_last
               on objt_last.objt_bpmn_id = sbfl.sbfl_last_completed
              and objt_last.objt_dgrm_id = prcs.prcs_dgrm_id
        left join flow_connections conn
               on conn.conn_bpmn_id = sbfl.sbfl_route
              and conn.conn_dgrm_id = prcs.prcs_dgrm_id
        left join flow_objects lane
               on objt_curr.objt_objt_lane_id = lane.objt_id)
               ;