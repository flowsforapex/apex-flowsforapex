create or replace package flow_parameters
  authid definer
as 
/* 
-- Flows for APEX - flow_parameters.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates. 2026.
--
-- Created    07-Feb-2026  Richard Allen (Flowquest Limited)
--
-- Package for processing BPMN task input/output parameters
*/

  -- Process input parameters by combining user input with process variables, static values, etc.
  function process_input_parameters
  (
    pi_parameter_definitions  in clob -- JSON array from objt_attributes.inputParameters
  , pi_user_input_data        in clob -- JSON object with user-provided values  
  , pi_process_id             in flow_processes.prcs_id%type
  , pi_subflow_id             in flow_subflows.sbfl_id%type default null
  , pi_scope                  in flow_subflows.sbfl_scope%type default 0
  ) return clob; -- Complete JSON object with all parameter values

  -- Get JSON schema for user input fields only (for APEX UI generation)
  function get_user_input_schema
  (
    pi_parameter_definitions  in clob -- JSON array from objt_attributes.inputParameters
  ) return clob; -- JSON Schema for user input fields only

  -- Validate parameter values against their definitions
  function validate_parameters
  (
    pi_parameter_definitions  in clob -- JSON array from objt_attributes
  , pi_parameter_values       in clob -- JSON object with parameter values
  ) return boolean;

  -- Get parameter definition from object attributes
  function get_input_parameter_definitions
  (
    pi_objt_id                in flow_objects.objt_id%type
  ) return clob; -- JSON array of input parameter definitions

  function get_output_parameter_definitions  
  (
    pi_objt_id                in flow_objects.objt_id%type
  ) return clob; -- JSON array of output parameter definitions

  -- Convert parameter definitions to JSON Schema
  function parameters_to_json_schema
  (
    pi_parameters      in clob
  , pi_user_data_only  in boolean default false
  ) return clob;

  function parameters_to_json_schema
  (
    pi_parameters        in clob
  , pi_user_data_only_yn in varchar2 default 'N'
  ) return clob;

end flow_parameters;
/