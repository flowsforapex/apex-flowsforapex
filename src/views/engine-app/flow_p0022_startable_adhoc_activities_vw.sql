/* 
-- Flows for APEX - flow_p0022_startable_adhoc_activities_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025-2026.
--
--
-- Created    15-Nov-2025  Richard Allen,  Flowquest Limited
*/
create or replace view flow_p0022_startable_adhoc_activities_vw as
  select fsaa.dgrm_id                              as  dgrm_id
       , fsaa.subproc_sbfl_id                      as  subproc_sbfl_id
       , fsaa.prcs_id                              as  prcs_id  
       , fsaa.subproc_step_key                     as  subproc_step_key
       , fsaa.subproc_bpmn_id                      as  subproc_bpmn_id
       , fsaa.activity_bpmn_id                     as  activity_bpmn_id
       , fsaa.activity_name                        as  activity_name 
       , fsaa.activity_description                 as  activity_description
       , fsaa.activity_grouping                    as  activity_grouping
       , fsaa.activity_display_order               as  activity_display_order
       , fsaa.activity_tag_name                    as  activity_tag_name
       , (select bpmn_icon 
          from flow_bpmn_types 
          where bpmn_tag_name = fsaa.activity_tag_name 
          and rownum = 1)                          as  activity_icon
       , fsaa.activity_is_repeatable               as  activity_is_repeatable
              , case when fsaa.activity_is_repeatable = 'Y' 
              then apex_lang.message('IS-REPEATABLE')
         end                                       as  badge_label
       , case when fsaa.activity_is_repeatable = 'Y' 
              then 't-Badge t-Badge--simple t-Badge--sm t-Badge--info'
         end                                       as  badge_css_class
       , NULL                                      as  actions
       , 'fa-play-circle-o'                        as  quick_action_icon
       , apex_lang.message('START-ADHOC-ACTIVITY') as  quick_action_label
       , 'start-adhoc-activity'                    as  quick_action
    from flow_startable_adhoc_activities_vw fsaa
with read only;
