create or replace view flow_p0010_4_vw
as
  select sbfl.sbfl_id
       , sbfl.sbfl_sbfl_id
       , sbfl.sbfl_starting_object
       , sbfl.sbfl_route
       , sbfl.sbfl_last_completed
       , sbfl.sbfl_current
       , sbfl.sbfl_last_update
       , sbfl.sbfl_status
       , null as next_step_link
       , case 
           when sbfl.sbfl_status = 'split' then 'fa fa-share-alt'
           when sbfl.sbfl_status = 'in subprocess' then 'fa fa-share-alt'
           when sbfl.sbfl_status = 'waiting at gateway' then 'fa fa-hand-stop-o'
           when flow_api_pkg.next_multistep_exists_yn(p_process_id => sbfl.sbfl_prcs_id, p_subflow_id => sbfl_id) = 'n' 
             then 'next-subflow-step-link fa fa-sign-out'
           when flow_api_pkg.next_multistep_exists_yn(p_process_id => sbfl.sbfl_prcs_id, p_subflow_id => sbfl_id) = 'y' 
             then 'next-subflow-multistep-link fa fa-tasks'
         end as class_string
    from flow_subflows sbfl
order by sbfl_id
;
