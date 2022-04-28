create or replace view flow_p0014_subflows_vw
as
  select distinct sbfl.sbfl_id
                , sbfl.sbfl_prcs_id
                , sbfl.sbfl_step_key
                , sbfl.sbfl_process_level
                , sbfl.sbfl_diagram_level
                , sbfl.sbfl_scope
                , sbfl.sbfl_last_completed
                , coalesce(objt.objt_name, sbfl.sbfl_current) as current_object
                , sbfl.sbfl_status
                , sbfl.sbfl_became_current at time zone sessiontimezone as sbfl_became_current
                , sbfl.sbfl_work_started at time zone sessiontimezone as sbfl_work_started
                , sbfl.sbfl_reservation
                , sbfl.sbfl_last_update at time zone sessiontimezone as sbfl_last_update
             from flow_subflows sbfl
             join flow_objects objt
               on sbfl.sbfl_current = objt.objt_bpmn_id
              and sbfl.sbfl_dgrm_id = objt.objt_dgrm_id
with read only;
