create or replace package flow_constants_pkg
  authid definer
as

  gc_nsmap                            constant varchar2(200 char) := 'xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"';

  gc_bpmn_terminate_event_definition  constant flow_types_pkg.t_bpmn_id := 'bpmn:terminateEventDefinition';
  gc_bpmn_timer_event_definition      constant flow_types_pkg.t_bpmn_id := 'bpmn:timerEventDefinition';

  gc_bpmn_object_documentation        constant flow_types_pkg.t_bpmn_id := 'bpmn:documentation';

  gc_timer_type_key                   constant flow_types_pkg.t_bpmn_id := 'timerType';
  gc_timer_def_key                    constant flow_types_pkg.t_bpmn_id := 'timerDefinition';

  gc_timer_type_date                  constant flow_types_pkg.t_bpmn_id := 'bpmn:timeDate';
  gc_timer_type_duration              constant flow_types_pkg.t_bpmn_id := 'bpmn:timeDuration';
  gc_timer_type_cycle                 constant flow_types_pkg.t_bpmn_id := 'bpmn:timeCycle';

end flow_constants_pkg;
/
