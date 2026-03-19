create or replace package test_090_ai_gateway_routing as
/* 
-- Flows for APEX - test_090_ai_gateway_routing.pks
-- 
-- AI Generated test suite for BPMN gateway routing with process variables
-- Tests both inclusive and exclusive gateway behavior
--
*/

  --%suite(90C Gateway Routing AI Model)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(90C.1 - Process Variables Set Correctly)
  procedure test_variables_set;

  --%test(90C.2 - Inclusive Gateway Routing - Admin Path)  
  procedure test_inclusive_admin_path;

  --%test(90C.3 - Inclusive Gateway Routing - Priority Path)
  procedure test_inclusive_priority_path;

  --%test(90C.4 - Inclusive Gateway Routing - North Region Path)
  procedure test_inclusive_north_path;
  
  --%test(90C.5 - Inclusive Gateway Multiple Paths)
  procedure test_inclusive_multiple_paths;

  --%test(90C.6 - Exclusive Gateway Routing - Approve Path)
  procedure test_exclusive_approve_path;

  --%test(90C.7 - Exclusive Gateway Routing - Reject Path)  
  procedure test_exclusive_reject_path;

  --%test(90C.8 - Exclusive Gateway Default Path)
  procedure test_exclusive_default_path;

  --%test(90C.9 - Complete Workflow Execution)
  procedure test_complete_workflow;

  --%test(90C.10 - Variable Persistence Across Gateways)
  procedure test_variable_persistence;

end test_090_ai_gateway_routing;