/* 
-- Flows for APEX - flow_p0022_adhoc_activities_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025-2026.
--
-- todo - should this be a materialized view?
--
-- Created    15-Nov-2025  Richard Allen,  Flowquest Limited
*/
create or replace view flow_p0022_adhoc_activities_vw as
  select  dgrm_id
        , subprocess_bpmn_id
        , activity_bpmn_id
        , activity_name
        , activity_description
        , activity_grouping
        , activity_display_order
        , activity_tag_name
        , activity_is_repeatable
        , task_list_visibility
        , null as actions
        --, apex_item.checkbox2(p_idx => 2, p_value => sbfl.sbfl_id, p_attributes => 'data-prcs="'|| sbfl.sbfl_prcs_id ||'" data-key="'|| sbfl.sbfl_step_key ||'" ') as checkbox
        , 'fa-play-circle-o' as quick_action_icon 
        , apex_lang.message('START-ADHOC-ACTIVITY') as quick_action_label 
        , 'start-adhoc-activity' as quick_action 
    from flow_adhoc_activities_vw
with read only;
