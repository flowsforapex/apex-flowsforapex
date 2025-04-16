create or replace view flow_p0014_step_log_vw
as
  select distinct lgsf.lgsf_prcs_id
                , coalesce(objt.objt_name, lgsf.lgsf_objt_id) as completed_object
                , lgsf.lgsf_step_key
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
