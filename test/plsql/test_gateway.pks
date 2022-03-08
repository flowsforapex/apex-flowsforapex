create or replace package test_gateway is

   --%suite(test_gateway)
   --%rollback(manual)

   --%test
   procedure exclusive_no_route;

   --%test
   --%disabled
   procedure exclusive_default;

   --%test
   --%disabled
   procedure exclusive_route_provided;

   --%test
   --%disabled
   procedure inclusive_no_route;

   --%test
   --%disabled
   procedure inclusive_default;

   --%test
   --%disabled
   procedure inclusive_route_a;

   --%test
   --%disabled
   procedure inclusive_route_b;

   --%test
   --%disabled
   procedure inclusive_route_c;

   --%test
   --%disabled
   procedure inclusive_route_ab;

   --%test
   --%disabled
   procedure inclusive_route_ac;

   --%test
   --%disabled
   procedure inclusive_route_bc;

   --%test
   --%disabled
   procedure parallel;
   
end test_gateway;