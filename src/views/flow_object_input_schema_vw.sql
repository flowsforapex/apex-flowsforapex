/* 
-- Flows for APEX - flow_object_input_schema_vw.sql
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created    05-Feb-2026  Richard Allen (Flowquest)
--
-- This view returns a json input schema for any Flow Object which has input parameters
-- defined in APEX extension properties. This is used to drive the dynamic input forms for ad-hoc activities
-- using the APEX JSON region plugin
-- This is intended to be used for a single object at a time, so we don't worry about performance of the view 
-- as it will be filtered by object name in the calling query.
*/
create or replace view flow_object_input_schema_vw as

select  objt.objt_dgrm_id,
        objt.objt_bpmn_id,
        objt.objt_name,
        objt.objt_tag_name,
        flow_parameters.parameters_to_json_schema ( pi_parameters => objt.objt_attributes."apex"."inputParameters"
                                                  , pi_user_data_only_yn => 'Y')  
        as  input_parameters_schema
  from  flow_objects objt
with read only;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 23+ only; skipped on 19c/21c; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
declare
  l_major pls_integer := dbms_db_version.version;
begin
  if l_major >= 23 then
    execute immediate q'[alter view flow_object_input_schema_vw annotations
  ( add app     'Flows for APEX'
  , add type    'definition'
  , add content 'JSON schema definitions for input parameters of APEX-configured flow objects'
  )]';
    execute immediate q'[alter view flow_object_input_schema_vw modify (objt_dgrm_id            annotations (add content 'Diagram containing this object (FK: flow_diagrams)'))]';
    execute immediate q'[alter view flow_object_input_schema_vw modify (objt_bpmn_id            annotations (add content 'BPMN identifier of the object from the diagram XML'))]';
    execute immediate q'[alter view flow_object_input_schema_vw modify (objt_name               annotations (add content 'Display name of the BPMN object'))]';
    execute immediate q'[alter view flow_object_input_schema_vw modify (objt_tag_name           annotations (add content 'BPMN element type, e.g. bpmn:userTask'))]';
    execute immediate q'[alter view flow_object_input_schema_vw modify (input_parameters_schema annotations (add content 'JSON schema for input parameters defined via APEX custom extension properties'))]';
  end if;
end;
/

whenever sqlerror exit failure
