create or replace view flow_rest_subflows_vw
      (
         prcs_id
       , sbfl_id
       , sbfl_sbfl_id
       , process_level
       , diagram_level
       , calling_sbfl
       , scope
       , "current"
       , step_key
       , status
       , became_current
       , reservation
       , links
      )
  as
  select p.prcs_id
       , s.sbfl_id
       , s.sbfl_sbfl_id
       , s.sbfl_process_level   as process_level
       , s.sbfl_diagram_level   as diagram_level
       , s.sbfl_calling_sbfl    as calling_sbfl
       , s.sbfl_scope           as scope
       , s.sbfl_current         as "current"
       , s.sbfl_step_key        as step_key
       , s.sbfl_status          as status
       , s.sbfl_became_current  as became_current
       , s.sbfl_reservation     as reservation
       , json_array(
           flow_rest_api_v1.get_links_string_http_GET('step',s.sbfl_id) format json
         ) links
  from flow_processes p
  join flow_subflows s on p.prcs_id = s.sbfl_prcs_id;

-- ---------------------------------------------------------------------------
-- Schema annotations (Oracle 19.28+ or 23ai; idempotent - safe to re-run)
-- ---------------------------------------------------------------------------
whenever sqlerror continue

alter view flow_rest_subflows_vw annotations
  ( add app     'Flows for APEX'
  , add type    'runtime'
  , add content 'Subflow instances with execution status and reservation data formatted for REST API with HATEOAS links'
  );

alter view flow_rest_subflows_vw modify (prcs_id        annotations (add content 'Parent process instance identifier'));
alter view flow_rest_subflows_vw modify (sbfl_id        annotations (add content 'Subflow instance identifier'));
alter view flow_rest_subflows_vw modify (sbfl_sbfl_id   annotations (add content 'Parent subflow identifier (FK: flow_subflows)'));
alter view flow_rest_subflows_vw modify (process_level  annotations (add content 'Process nesting level'));
alter view flow_rest_subflows_vw modify (diagram_level  annotations (add content 'Diagram nesting level'));
alter view flow_rest_subflows_vw modify (calling_sbfl   annotations (add content 'Subflow that created this one via a call activity'));
alter view flow_rest_subflows_vw modify (scope          annotations (add content 'Variable scope number for this subflow'));
alter view flow_rest_subflows_vw modify ("current"      annotations (add content 'BPMN ID of the current object on this subflow'));
alter view flow_rest_subflows_vw modify (step_key       annotations (add content 'Step key identifying the current execution position'));
alter view flow_rest_subflows_vw modify (status         annotations (add content 'Current execution status of this subflow'));
alter view flow_rest_subflows_vw modify (became_current annotations (add content 'Timestamp when the current object was reached'));
alter view flow_rest_subflows_vw modify (reservation    annotations (add content 'User who has reserved this user task'));
alter view flow_rest_subflows_vw modify (links          annotations (add content 'HATEOAS links JSON for this subflow resource'));

whenever sqlerror exit failure
