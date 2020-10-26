create or replace package flow_constants_pkg
  authid definer
as

  gc_nsmap                            constant varchar2(200 char) := 'xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"';

  gc_bpmn_terminate_event_definition  constant flow_types_pkg.t_bpmn_id := 'bpmn:terminateEventDefinition';
  gc_bpmn_timer_event_definition      constant flow_types_pkg.t_bpmn_id := 'bpmn:timerEventDefinition';

  gc_bpmn_object_documentation        constant flow_types_pkg.t_bpmn_id := 'bpmn:documentation';

  gc_bpmn_usertask_apex_application   constant flow_types_pkg.t_bpmn_id := 'apex:apex-application';
  gc_bpmn_usertask_apex_page          constant flow_types_pkg.t_bpmn_id := 'apex:apex-page';
  gc_bpmn_usertask_apex_request       constant flow_types_pkg.t_bpmn_id := 'apex:apex-request';
  gc_bpmn_usertask_apex_cache         constant flow_types_pkg.t_bpmn_id := 'apex:apex-cache';
  gc_bpmn_usertask_apex_item          constant flow_types_pkg.t_bpmn_id := 'apex:apex-item';
  gc_bpmn_usertask_apex_value         constant flow_types_pkg.t_bpmn_id := 'apex:apex-value';
  gc_bpmn_usertask_apex_inserturl     constant flow_types_pkg.t_bpmn_id := 'apex:apex-insertUrl';

  gc_bpmn_servicetask_insertemail     constant flow_types_pkg.t_bpmn_id := 'apex:insertEmail';

  gc_bpmn_scripttask_insertscript     constant flow_types_pkg.t_bpmn_id := 'apex:insertScript';

  gc_timer_type_key                   constant flow_types_pkg.t_bpmn_id := 'timerType';
  gc_timer_def_key                    constant flow_types_pkg.t_bpmn_id := 'timerDefinition';

  gc_timer_type_date                  constant flow_types_pkg.t_bpmn_id := 'bpmn:timeDate';
  gc_timer_type_duration              constant flow_types_pkg.t_bpmn_id := 'bpmn:timeDuration';
  gc_timer_type_cycle                 constant flow_types_pkg.t_bpmn_id := 'bpmn:timeCycle';

end flow_constants_pkg;
/
