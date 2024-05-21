create or replace package test_002_gateway is
/* 
-- Flows for APEX - test_002_gateway.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created  08-Mar-2022   Louis Moreaux, Insum
-- Modified 28-Jun-2022   Richard Allen, Oracle   
-- 
*/
   --%suite(02 Basic Gateway Operation)
   --%rollback(manual)
   --%tag(short,ce,ee)

   -- Need to add tests for completing order
   
   --%beforeall
   procedure set_up_tests;

   --%test(a. exclusive gateway - no route provided)
   procedure exclusive_no_route;

   --%test(b. exclusive gateway - default routing)
   procedure exclusive_default;

   --%test(c1. exclusive gateway - GR var provided - matching case)
   procedure exclusive_route_provided_correct_case;

   --%test(c2. exclusive gateway - GR var provided - UPPER CASE)
   procedure exclusive_route_provided_upper_CASE;

   --%test(c3. exclusive gateway - GR var provided - lower CASE)
   procedure exclusive_route_provided_lower_case;

   --%test(d. inclusive gateway - no routing)
   procedure inclusive_no_route;

   --%test(e. inclusive gateway - default routing)
   procedure inclusive_default;

   --%test(f1. inclusive gateway - GR provided - matching case)
   procedure inclusive_route_provided_correct_case;

   --%test(f2. inclusive gateway - GR var provided - UPPER CASE)
   procedure inclusive_route_provided_upper_CASE;

   --%test(f3. inclusive gateway - GR var provided - lower CASE)
   procedure inclusive_route_provided_lower_case;

   --%test(f4. inclusive gateway - GR var provided - jumbled CASE)
   procedure inclusive_route_provided_jumbled_case;

   --%test(f5. inclusive gateway - merge and resplit - all paths)
   procedure inclusive_merge_resplit_f5;

   --%test(f6. inclusive gateway - merge and resplit - some paths a)
   procedure inclusive_merge_resplit_f6;

   --%test(f7. inclusive gateway - merge and resplit - some paths b)
   procedure inclusive_merge_resplit_f7;

   --%test(f8. inclusive gateway - merge and resplit - exprs - all paths)
   procedure inclusive_merge_resplit_f8;

   --%test(f9. inclusive gateway - merge and resplit - exprs - some paths a)
   procedure inclusive_merge_resplit_f9;

   --%test(f10. inclusive gateway - merge and resplit - exprs - some paths b)
   procedure inclusive_merge_resplit_f10;


   --%test(g1. parallel gateway)
   procedure parallel;

  --%test(g2. parallel gateway - merge and resplit)
   procedure parallel_merge_resplit;

   --%test (h. event based gateway - uses timer)
   --%tag(timer)
   procedure event_based;

   --%afterall
   procedure tear_down_tests;
   
end test_002_gateway;
/
