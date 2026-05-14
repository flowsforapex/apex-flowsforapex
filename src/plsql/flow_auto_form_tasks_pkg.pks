create or replace package flow_auto_form_tasks_pkg
/* 
-- Flows for APEX - flow_auto_form_tasks_pkg.pks
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
-- Package Spec released under Flows for APEX Community Edition licence.
-- Package Body is an Enterprise Edition feature.
--
-- Created  06-May-2026  Richard Allen (Flowquest Limited)
--
*/
  authid definer
as

  -- Process an AutoForm UserTask (EE feature).
  -- Generates a JSON Schema from the task inputParameters (userInput sources only),
  -- stores it on the subflow, and sets the task into the waiting-on-user state.
  -- Requires Flows for APEX Enterprise Edition.
  procedure process_auto_form_task
  ( p_sbfl_info     in flow_subflows%rowtype
  , p_step_info     in flow_types_pkg.flow_step_info
  );

  -- Complete an AutoForm UserTask (EE feature).
  -- Validates and processes the submitted JSON payload against the task input parameters,
  -- writes values to process variables (Mode A), and advances the workflow.
  -- Requires Flows for APEX Enterprise Edition.
  procedure complete_auto_form_task
  ( p_process_id        in flow_processes.prcs_id%type
  , p_subflow_id        in flow_subflows.sbfl_id%type
  , p_step_key          in flow_subflows.sbfl_step_key%type
  , p_submitted_json    in clob
  );

end flow_auto_form_tasks_pkg;
/
