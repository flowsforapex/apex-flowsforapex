create view FLOW_P0010_4_VW
as
select sbfl_id
    , sbfl_parent_subflow
    , sbfl_starting_object
    , sbfl_route
    , sbfl_last_completed
    , sbfl_current
    , sbfl_last_update
    , sbfl_status
    , null as next_step_link
    , case 
        when sbfl_status = 'split' then 'fa fa-share-alt'
        when sbfl_status = 'in subprocess' then 'fa fa-share-alt'
        when sbfl_status = 'waiting at gateway' then 'fa fa-hand-stop-o'
        when flow_api_pkg.next_multistep_exists_yn(p_process_id => v('P10_ID'), p_subflow_id =>sbfl_id) = 'n' 
            then 'next-subflow-step-link fa fa-sign-out'
        when flow_api_pkg.next_multistep_exists_yn(p_process_id => v('P10_ID'), p_subflow_id =>sbfl_id) = 'y' 
            then 'next-subflow-multistep-link fa fa-tasks'
      end as class_string
from  flow_subflows sbfl
order by sbfl_id
/