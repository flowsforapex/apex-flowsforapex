create or replace package flow_constants_pkg
  authid definer
as

  gc_version constant varchar2(10 char) := '5.1.0';

  gc_vcbool_true   constant varchar2(10 char) := 'true';
  gc_vcbool_false  constant varchar2(10 char) := 'false';
  gc_numbool_true  constant number            := 1;
  gc_numbool_false constant number            := 0;

  gc_nsmap       constant varchar2(200 char) := 'xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"';
  gc_bpmn_prefix constant varchar2(10 char)  := 'bpmn:';
  gc_apex_prefix constant varchar2(10 char)  := 'apex:';

  -- BPMN Keys
  gc_bpmn_process                     constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'process';
  gc_bpmn_subprocess                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'subProcess';

  gc_bpmn_start_event                 constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'startEvent';
  gc_bpmn_end_event                   constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'endEvent';
  gc_bpmn_intermediate_throw_event    constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'intermediateThrowEvent';
  gc_bpmn_intermediate_catch_event    constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'intermediateCatchEvent';
  gc_bpmn_boundary_event              constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'boundaryEvent';

  gc_bpmn_terminate_event_definition  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'terminateEventDefinition';
  gc_bpmn_error_event_definition      constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'errorEventDefinition';
  gc_bpmn_escalation_event_definition constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'escalationEventDefinition';
  gc_bpmn_link_event_definition       constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'linkEventDefinition';

  gc_bpmn_timer_event_definition      constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timerEventDefinition';
  gc_timer_type_date                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeDate';
  gc_timer_type_duration              constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeDuration';
  gc_timer_type_cycle                 constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeCycle';

  gc_bpmn_object_documentation        constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'documentation';

  gc_bpmn_gateway_exclusive           constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'exclusiveGateway';
  gc_bpmn_gateway_inclusive           constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'inclusiveGateway';
  gc_bpmn_gateway_parallel            constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'parallelGateway';
  gc_bpmn_gateway_event_based         constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'eventBasedGateway';

  gc_bpmn_sequence_flow               constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'sequenceFlow';

  gc_bpmn_task                        constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'task';
  gc_bpmn_usertask                    constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'userTask';
  gc_bpmn_servicetask                 constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'serviceTask';
  gc_bpmn_manualtask                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'manualTask';
  gc_bpmn_scripttask                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'scriptTask';

  -- APEX Extensions to BPMN
  -- userTask
  gc_apex_usertask_application        constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-application';
  gc_apex_usertask_page               constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-page';
  gc_apex_usertask_request            constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-request';
  gc_apex_usertask_cache              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-cache';
  gc_apex_usertask_item               constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-item';
  gc_apex_usertask_value              constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-value';
  gc_apex_usertask_inserturl          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-insertUrl';

  --serviceTask
  --gc_apex_servicetask_insertemail     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'insertEmail';

  --scriptTask
  gc_apex_scripttask_engine           constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'engine';
  gc_apex_scripttask_plsql_code       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'plsqlCode';
  gc_apex_scripttask_auto_binds       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'autoBinds';

  -- Special Keys from FLOW_OBJECT_ATTRIBUTES
  gc_timer_type_key                   constant flow_types_pkg.t_bpmn_id := 'timerType';
  gc_timer_def_key                    constant flow_types_pkg.t_bpmn_id := 'timerDefinition';

  -- Flows 4 APEX Substitution Strings
  gc_substitution_flow_identifier     constant varchar2(10 char)                    := 'F4A$';
  gc_substitution_prefix              constant flow_types_pkg.t_single_vc2          := '&';
  gc_substitution_postfix             constant flow_types_pkg.t_single_vc2          := '.';
  gc_substitution_process_id          constant flow_types_pkg.t_bpmn_attributes_key := 'PROCESS_ID';
  gc_substitution_subflow_id          constant flow_types_pkg.t_bpmn_attributes_key := 'SUBFLOW_ID';
  gc_substitution_pattern             constant flow_types_pkg.t_bpmn_attributes_key := gc_substitution_prefix || 'F4A\$(\w*)\.';

  -- Diagram Versioning Status
  gc_dgrm_status_draft                constant  varchar2(10 char) := 'draft';
  gc_dgrm_status_released             constant  varchar2(10 char) := 'released';
  gc_dgrm_status_deprecated           constant  varchar2(10 char) := 'deprecated';
  gc_dgrm_status_archived             constant  varchar2(10 char) := 'archived';

  -- Subflow status
  gc_sbfl_status_running              constant  varchar2(20 char) := 'running';
  gc_sbfl_status_waiting_timer        constant  varchar2(20 char) := 'waiting for timer';
  gc_sbfl_status_waiting_gateway      constant  varchar2(20 char) := 'waiting at gateway';
  gc_sbfl_status_waiting_event        constant  varchar2(20 char) := 'waiting for event';
  gc_sbfl_status_proceed_gateway      constant  varchar2(20 char) := 'proceed from gateway';
  gc_sbfl_status_split                constant  varchar2(20 char) := 'split';
  gc_sbfl_status_in_subprocess        constant  varchar2(20 char) := 'in subprocess';

  -- Process Instance Status
  gc_prcs_status_created             constant  varchar2(20 char) := 'created';
  gc_prcs_status_running             constant  varchar2(20 char) := 'running';
  gc_prcs_status_completed           constant  varchar2(20 char) := 'completed';

  -- Default XML for new diagrams
  gc_default_xml constant varchar2(4000) := '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" id="Definitions_1wzb475" targetNamespace="http://bpmn.io/schema/b" exporter="Flows for APEX" exporterVersion="' || gc_version || '">
<bpmn:process id="Process_0rxermh" isExecutable="false" />
<bpmndi:BPMNDiagram id="BPMNDiagram_1">
<bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_0rxermh" />
</bpmndi:BPMNDiagram>
</bpmn:definitions>
';


end flow_constants_pkg;
/
