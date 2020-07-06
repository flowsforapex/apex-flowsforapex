create or replace view flow_p0010_subflows_vw
as
  select i_sbfl.*
       , case 
           when i_sbfl.sbfl_status = 'split' then 'fa fa-share-alt'
           when i_sbfl.sbfl_status = 'in subprocess' then 'fa fa-share-alt'
           when i_sbfl.sbfl_status = 'waiting at gateway' then 'fa fa-hand-stop-o'
           when i_sbfl.sbfl_status = 'waiting for timer' then 'fa fa-clock-o'
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
                , sbfl.sbfl_starting_object
                , sbfl.sbfl_route
                , sbfl.sbfl_last_completed
                , sbfl.sbfl_current
                , sbfl.sbfl_last_update
                , sbfl.sbfl_status
                , null as next_step_link
                , flow_api_pkg.next_multistep_exists_yn(p_process_id => sbfl.sbfl_prcs_id, p_subflow_id => sbfl_id) as is_multistep
                , sbfl.sbfl_prcs_id
             from flow_subflows sbfl
         ) i_sbfl
;
