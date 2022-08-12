create or replace package test_018_gw_routing_exps as
/* 
-- Flows for APEX - test_018_gw_routing_exps.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 12-Aug-2022   Richard Allen - Oracle
--
*/

  -- uses models 18a,b

  --%suite(Gateway Routing Expressions)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - Expressions - Basic Logic)
  procedure exps_basic;

  --%test(A2 - Expressions - Substitutions)
  procedure exps_subs;

  --%test(A3 - Expressions - Binds)
  procedure exps_binds;

  --%test(A4 - Expressions - Mixed Binds and Substitutions)
  procedure exps_mixed;

  --%test(A5 - Expressions - Completed)
  procedure exps_complete;

  --%test(B1 - Function Bodies - Basic Logic)
  procedure func_bodies_basic;

  --%test(B2 - Function Bodies - Substitutions)
  procedure func_bodies_subs;

  --%test(B3 - Function Bodies - Binds)
  procedure func_bodies_binds;

  --%test(B4 - Function Bodies - Mixed Binds and Substitutions)
  procedure func_bodies_mixed;

  --%test(B5 - Function Bodies - Completed)
  procedure func_bodies_complete;


  --%afterall
  procedure tear_down_tests;

end test_018_gw_routing_exps;