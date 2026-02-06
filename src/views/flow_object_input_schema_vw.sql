/* 
-- Flows for APEX - flow_object_input_schema_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created    05-Feb-2026  Richard Allen (Flowquest)
--
-- This view returns a json input schema for any Flow Object which has input parameters 
-- defined in the APEX custom extension. This is used to drive the dynamic input forms for ad-hoc activities 
-- using the APEX JSON region plugin
-- This is intended to be used for a single object at a time, so we don't worry about performance of the view 
-- as it will be filtered by object name in the calling query.
*/
create or replace view flow_object_input_schema_vw as

select  objt.objt_dgrm_id,
        objt.objt_bpmn_id,
        objt.objt_name,
        objt.objt_tag_name,
        flow_engine_util.parameters_to_json_schema (objt.objt_attributes."apex"."customExtension"."inputParameters")  
        as  input_parameters_schema
  from  flow_objects objt
with read only;
