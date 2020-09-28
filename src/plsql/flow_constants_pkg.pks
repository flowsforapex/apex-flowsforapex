create or replace package flow_constants_pkg
  authid definer
as

  gc_timer_type_key constant flow_types_pkg.t_bpmn_id := 'timerType';
  gc_timer_def_key  constant flow_types_pkg.t_bpmn_id := 'timerDefinition';

  gc_timer_type_date     constant flow_types_pkg.t_bpmn_id := 'timeDate';
  gc_timer_type_duration constant flow_types_pkg.t_bpmn_id := 'timeDuration';
  gc_timer_type_cycle    constant flow_types_pkg.t_bpmn_id := 'timeCycle';

end flow_constants_pkg;
/
