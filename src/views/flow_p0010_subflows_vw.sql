create or replace view flow_p0010_subflows_vw
as
  select i_sbfl.*
       , case 
           when i_sbfl.sbfl_status = 'split' then 'fa fa-share-alt'
           when i_sbfl.sbfl_status = 'in subprocess' then 'fa fa-share-alt'
           when i_sbfl.sbfl_status = 'waiting at gateway' then 'fa fa-hand-stop-o'
           when i_sbfl.is_multistep = 'n' then 'clickable-action next-subflow-step-link fa fa-sign-out'
           when i_sbfl.is_multistep = 'y' then 'clickable-action next-subflow-multistep-link fa fa-tasks'
         end as class_string
       , case i_sbfl.is_multistep
           when 'n' then 'next_step'
           when 'y' then 'choose_branch'
         end as data_action
       , case i_sbfl.is_multistep
           when 'n' then 'Go to next step'
           when 'y' then 'Choose branch'
         end as title
    from (
           select sbfl.sbfl_id
                , sbfl.sbfl_sbfl_id
                , coalesce( objt_start.objt_name, sbfl.sbfl_starting_object ) as sbfl_starting_object
                , coalesce( conn.conn_name, sbfl.sbfl_route ) as sbfl_route
                , coalesce( objt_last.objt_name, sbfl.sbfl_last_completed ) as sbfl_last_completed
                , coalesce( objt_curr.objt_name, sbfl.sbfl_current ) as sbfl_current
                , sbfl.sbfl_last_update
                , sbfl.sbfl_status
                , null as next_step_link
                , flow_api_pkg.next_multistep_exists_yn(p_process_id => sbfl.sbfl_prcs_id, p_subflow_id => sbfl_id) as is_multistep
                , sbfl.sbfl_prcs_id
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
         ) i_sbfl
;
