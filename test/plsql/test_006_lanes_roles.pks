create or replace package test_006_lanes_roles as
/* 
-- Flows for APEX - test_006_lanes_roles.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 13-Apr-2023   Richard Allen - Oracle
--
*/

  -- uses models 06a-?

  --%suite(06 Lanes and Roles)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A - Child Lanesets)
  procedure child_lanesets;

  --%test(B - Lane-Roles in Child Lanesets)
  procedure lane_roles_with_child_lanesets;

  --%test(C - lane parsing on diagrams with lanes 1)
  procedure parse_diagram_with_lanes1;

  --%test(D - lane parsing on diagrams with lanes 2)
  procedure parse_diagram_with_lanes2;

  --%test(E - lane parsing on diagrams without lanes 1)
  procedure parse_diagram_without_lanes1;

  --%test(F - lane parsing on diagrams without lanes 2)
  procedure parse_diagram_without_lanes2;

  --%test(G - lane execution on model without lanes)
  procedure exec_diagram_without_lanes;

  --%test(H - lane execution on model with lanes inc subProcesses)
  procedure exec_diagram_with_lanes;

  --%test(I - lane execution on callActivity - both models have lanes)
  procedure exec_diagram_with_calls_both_have_lanes;

  --%test(J _ lane execution on callActivity - only calling model has lanes)
  procedure exec_diagram_with_calls_calling_has_lanes;

  --%test(K - lane execution on callActivity - only called model has lanes)
  procedure exec_diagram_with_calls_called_has_lanes;

  --%afterall
  procedure tear_down_tests;

end test_006_lanes_roles;
/
