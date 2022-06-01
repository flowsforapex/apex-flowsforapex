create or replace package test_lanes_parse_execute
as

  -- uses models 15a, 15b, 15c, 15d

  --%suite(Lane parsing and execution)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%test(lane parsing on diagrams with lanes 1)
  procedure parse_diagram_with_lanes1;

  --%test(lane parsing on diagrams with lanes 2)
  procedure parse_diagram_with_lanes2;

  --%test(lane parsing on diagrams without lanes 1)
  procedure parse_diagram_without_lanes1;

  --%test(lane parsing on diagrams without lanes 2)
  procedure parse_diagram_without_lanes2;

  --%test(lane execution on model without lanes)
  procedure exec_diagram_without_lanes;

  --%test(lane execution on model with lanes inc subProcesses)
  procedure exec_diagram_with_lanes;

  --%test(lane execution on callActivity - both models have lanes)
  procedure exec_diagram_with_calls_both_have_lanes;

  --%test(lane execution on callActivity - only calling model has lanes)
  procedure exec_diagram_with_calls_calling_has_lanes;

  --%test(lane execution on callActivity - only called model has lanes)
  procedure exec_diagram_with_calls_called_has_lanes;

  --%afterall
  procedure tear_down_tests;

end test_lanes_parse_execute;