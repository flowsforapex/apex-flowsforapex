create or replace package test_gateway is

   --%suite(test_gateway)
   --%rollback(manual)

   --%test
   procedure exclusive_no_route;

   --%test
   procedure exclusive_default;

   --%test
   procedure exclusive_route_provided;

   --%test
   procedure inclusive_no_route;

   --%test
   procedure inclusive_default;

   --%test
   procedure inclusive_route_provided;

   --%test
   procedure parallel;
   
end test_gateway;