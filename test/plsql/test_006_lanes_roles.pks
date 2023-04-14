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

  --%beforeall
  procedure set_up_tests;

  --%test(A - Child Lanesets)
  procedure child_lanesets;

  --%test(B - Lane-Roles in Child Lanesets)
  procedure lane_roles_with_child_lanesets;


  --%afterall
  procedure tear_down_tests;

end test_006_lanes_roles;
/
