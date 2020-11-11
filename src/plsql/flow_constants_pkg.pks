create or replace package flow_constants_pkg
  authid definer
as

  gc_nsmap       constant varchar2(200 char) := 'xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"';
  gc_bpmn_prefix constant varchar2(10 char) := 'bpmn:';
  gc_apex_prefix constant varchar2(10 char) := 'apex:';

  -- BPMN Keys
  gc_bpmn_terminate_event_definition  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'terminateEventDefinition';
  gc_bpmn_error_event_definitition    constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'errorEventDefinition';
  gc_bpmn_escalation_event_definition constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'escalationEventDefinition';
  gc_bpmn_link_event_definition       constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'linkEventDefinition';

  gc_bpmn_timer_event_definition      constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timerEventDefinition';
  gc_timer_type_date                  constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeDate';
  gc_timer_type_duration              constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeDuration';
  gc_timer_type_cycle                 constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'timeCycle';

  gc_bpmn_object_documentation        constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'documentation';

  gc_bpmn_gateway_exclusive           constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'exclusiveGateway';
  gc_bpmn_gateway_inclusive           constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'inclusiveGateway';
  gc_bpmn_sequence_flow               constant flow_types_pkg.t_bpmn_id := gc_bpmn_prefix || 'sequenceFlow';

  -- APEX Extensions to BPMN
  gc_bpmn_usertask_apex_application   constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-application';
  gc_bpmn_usertask_apex_page          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-page';
  gc_bpmn_usertask_apex_request       constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-request';
  gc_bpmn_usertask_apex_cache         constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-cache';
  gc_bpmn_usertask_apex_item          constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-item';
  gc_bpmn_usertask_apex_value         constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-value';
  gc_bpmn_usertask_apex_inserturl     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'apex-insertUrl';

  gc_bpmn_servicetask_insertemail     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'insertEmail';

  gc_bpmn_scripttask_insertscript     constant flow_types_pkg.t_bpmn_id := gc_apex_prefix || 'insertScript';

  -- Special Keys from FLOW_OBJECT_ATTRIBUTES
  gc_timer_type_key                   constant flow_types_pkg.t_bpmn_id := 'timerType';
  gc_timer_def_key                    constant flow_types_pkg.t_bpmn_id := 'timerDefinition';

end flow_constants_pkg;
/
