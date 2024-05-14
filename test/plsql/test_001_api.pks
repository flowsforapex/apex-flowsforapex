create or replace package test_001_api is

   -- uses model A01

   -- tests  basic flows API

   --%suite(01 Basic API Functionality)
   --%rollback(manual)

   -- Need to add tests for by name, by name and version, by id
   -- Maybe need to test the versionning logic as well here?

   --%test(flow_create)
   procedure flow_create;

   --%test(flow_start)
   procedure flow_start;

   --%test(flow_reset)
   procedure flow_reset;

   --%test(flow_terminate)
   procedure flow_terminate;

   --%test(flow_delete)
   procedure flow_delete;

   --%test(flow_complete_step)
   procedure flow_complete_step;

   --%test(flow_reserve_step)
   procedure flow_reserve_step;

   --%test(flow_release_step)
   procedure flow_release_step;

   --%test(flow_start_step)
   procedure flow_start_step;

   --%test(flow_variables)
   procedure flow_variables;

   --%afterall
   procedure tear_down_tests;

end test_001_api;
/
