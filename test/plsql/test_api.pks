create or replace package test_api is

   --%suite(test_api)
   --%rollback(manual)

   -- Need to add tests for by name, by name and version, by id
   -- Maybe need to test the versionning logic as well here?

   --%test
   procedure flow_create;

   --%test
   procedure flow_start;

   --%test
   procedure flow_reset;

   --%test
   procedure flow_terminate;

   --%test
   procedure flow_delete;

   --%test
   procedure flow_complete_step;

   --%test
   procedure flow_reserve_step;

   --%test
   procedure flow_release_step;

   --%test
   procedure flow_start_step;

   --%test
   procedure flow_variables;

end test_api;