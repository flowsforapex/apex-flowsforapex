create or replace view flow_process_inbox_vw as 
select SBFL_ID,
       SBFL_SBFL_ID,
       SBFL_PRCS_ID,
       SBFL_PROCESS_NAME,
       SBFL_DGRM_ID,
       SBFL_DGRM_NAME,
       SBFL_REF_OBJ_TYPE,
       SBFL_REF_OBJ_ID,
       SBFL_STARTING_OBJECT,
       SBFL_STARTING_OBJECT_NAME,
       SBFL_ROUTE,
       SBFL_ROUTE_NAME,
       SBFL_LAST_COMPLETED,
       SBFL_LAST_COMPLETED_NAME,
       SBFL_CURRENT,
       SBFL_CURRENT_NAME,
       apex_page.get_url
           ( p_application => task.task_app_id
           , p_page => task.task_page_id
           , p_request => task.task_request
           , p_clear_cache => task.task_clear_cache
           , p_items => 'P0_PROCESS_ID,P0_SUBFLOW_ID,'||task.task_set_items
           , p_values => sbfl.sbfl_prcs_id||','||sbfl.sbfl_id||','||
                  nvl2(task.task_set_values,task.task_set_values||','||sbfl.sbfl_ref_obj_id,sbfl.sbfl_ref_obj_id)
           ) link_text,
       SBFL_CURRENT_TAG_NAME,
       SBFL_LAST_UPDATE,
       SBFL_STATUS,
       SBFL_NEXT_STEP_TYPE,
       SBFL_CURRENT_LANE,
       SBFL_CURRENT_LANE_NAME,
       SBFL_LINK
  from FLOW_SUBFLOWS_VW SBFL
  left join FLOW_TASKS TASK
    on task.task_objt_bpmn_id = sbfl.sbfl_current 
 where sbfl_status = 'running'
 ;
