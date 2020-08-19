create or replace view flow_p0010_subflows_vw
as
  select i_sbfl.*
       , case
          when i_sbfl.sbfl_status in ('split', 'in subprocess', 'waiting at gateway', 'waiting for event', 'waiting for timer') then
            '<span class="' ||
            case i_sbfl.sbfl_status
              when 'split' then 'fa fa-share-alt'
              when 'in subprocess' then 'fa fa-share-alt'
              when 'waiting at gateway' then 'fa fa-hand-stop-o'
              when 'waiting for timer' then 'fa fa-clock-o'
              when 'waiting for event' then 'fa fa-hand-stop-o'
            end ||
            '"></span>'
          else
            '<button type="button" class="clickable-action t-Button t-Button--noLabel t-Button--icon" title="' ||
            case 
              when i_sbfl.sbfl_next_step_type in ( 'single-choice', 'multi-choice' ) then ' next-subflow-multistep-link" title="Choose branch" aria-label="Choose branch"'
              when i_sbfl.sbfl_next_step_type = 'simple-step' then ' next-subflow-step-link" title="Go to next step" aria-label="Go to next step"'
            end || '" data-prcs="' || i_sbfl.sbfl_prcs_id || '" data-sbfl="' || i_sbfl.sbfl_id || '" data-action="' ||
            case i_sbfl.sbfl_next_step_type
              when 'single-choice' then 'choose_single'
              when 'multi-choice' then 'choose_multiple'
              when 'simple-step' then 'next_step'
            end || '"><span aria-hidden="true" class="' ||
            case
              when i_sbfl.sbfl_next_step_type in ( 'single-choice', 'multi-choice' ) then 'fa fa-tasks'
              when i_sbfl.sbfl_next_step_type = 'simple-step' then 'fa fa-sign-out'
            end || '"></span></button>'
         end as action_html
    from (
           select sbfl.sbfl_id
                , sbfl.sbfl_sbfl_id
                , coalesce( objt_start.objt_name, sbfl.sbfl_starting_object ) as sbfl_starting_object
                , coalesce( conn.conn_name, sbfl.sbfl_route ) as sbfl_route
                , coalesce( objt_last.objt_name, sbfl.sbfl_last_completed ) as sbfl_last_completed
                , coalesce( objt_curr.objt_name, sbfl.sbfl_current ) as sbfl_current
                , sbfl.sbfl_last_update
                , sbfl.sbfl_status
                , flow_api_pkg.next_step_type( p_sbfl_id => sbfl_id ) as sbfl_next_step_type
                , sbfl.sbfl_prcs_id
                , coalesce( lane.objt_name, lane.objt_bpmn_id) as sbfl_current_lane
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
               on objt_curr.objt_objt_lane_id = lane.objt_id
         ) i_sbfl
;
