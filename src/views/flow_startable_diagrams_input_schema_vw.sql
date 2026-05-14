/* 
-- Flows for APEX - flow_startable_diagrams_input_schema_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created    06-May-2026  GitHub Copilot
--
-- This view extends startable diagram metadata with the main start event BPMN id and
-- an input parameter schema for dynamic start forms. The schema includes only
-- inputParameters with source.expressionType = 'userInput'.
--
-- Note: this view can only be queried inside an APEX session because it builds on
-- flow_startable_diagrams_vw.
--
*/
create or replace view flow_startable_diagrams_input_schema_vw
as
select  std.dgrm_id
      , std.dgrm_name
      , std.dgrm_short_description
      , std.dgrm_description
      , std.dgrm_icon
      , std.dgrm_category
      , std.dgrm_version
      , std.dgrm_status
      , std.process_name
      , std.process_bpmn_id
      , std.potential_starting_users
      , std.potential_starting_groups
      , std.excluded_starting_users
      , start_objt.objt_bpmn_id as start_event_bpmn_id
      , flow_parameters.parameters_to_json_schema
        ( pi_parameters       => start_objt.objt_attributes."apex"."inputParameters"
        , pi_user_data_only_yn => 'Y'
        ) as input_parameters_schema
  from flow_startable_diagrams_vw std
  left join flow_objects process_objt
    on process_objt.objt_dgrm_id = std.dgrm_id
   and process_objt.objt_bpmn_id = std.process_bpmn_id
  left join flow_objects start_objt
    on start_objt.objt_dgrm_id = process_objt.objt_dgrm_id
   and start_objt.objt_objt_id = process_objt.objt_id
   and start_objt.objt_tag_name = flow_constants_pkg.gc_bpmn_start_event
   and start_objt.objt_id = (
         select min(se.objt_id)
           from flow_objects se
          where se.objt_dgrm_id = process_objt.objt_dgrm_id
            and se.objt_objt_id = process_objt.objt_id
            and se.objt_tag_name = flow_constants_pkg.gc_bpmn_start_event
       )
with read only;
