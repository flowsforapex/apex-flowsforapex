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
        flow_parameters.parameters_to_json_schema (
          pi_parameters => objt.objt_attributes."apex"."customExtension"."inputParameters",
          pi_user_data_only_yn => 'Y')  
        as  input_parameters_schema
  from  flow_objects objt
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_object_input_schema_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'JSON schema definitions for input parameters of APEX-configured flow objects'
  );

alter view flow_object_input_schema_vw modify (objt_dgrm_id            annotations (add content 'Diagram containing this object (FK: flow_diagrams)'));
alter view flow_object_input_schema_vw modify (objt_bpmn_id            annotations (add content 'BPMN identifier of the object from the diagram XML'));
alter view flow_object_input_schema_vw modify (objt_name               annotations (add content 'Display name of the BPMN object'));
alter view flow_object_input_schema_vw modify (objt_tag_name           annotations (add content 'BPMN element type, e.g. bpmn:userTask'));
alter view flow_object_input_schema_vw modify (input_parameters_schema annotations (add content 'JSON schema for input parameters defined via APEX custom extension properties'));

whenever sqlerror exit failure
