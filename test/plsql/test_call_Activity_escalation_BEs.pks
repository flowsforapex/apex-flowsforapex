/* 
-- Flows for APEX - test_call_Activity_escalation_BEs.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 18-May-2022   Richard Allen, Oracle   
-- 
*/

create or replace package test_call_Activity_escalation_BEs is

  --%suite(test_callActivity_escalation_boundary_Events)
  --%rollback(manual)

  --%beforeall
  procedure set_up_process;

  --%test(Non-interrupting escalation boundary events on CallActivity - from endEvent - smoke)
  procedure test_callActivity_non_int_escalation_from_endEvent_BE_smoke;

  --%test(Non-interrupting escalation boundary events on CallActivity - from ITE - smoke)
  procedure test_callActivity_non_int_escalation_from_ITE_BE_smoke;

  --%test(Interrupting escalation boundary events on CallActivity - from endEvent - smoke)
  procedure test_callActivity_int_escalation_from_endEvent_BE_smoke;

  --%test(Interrupting escalation boundary events on CallActivity - from ITE - smoke)
  procedure test_callActivity_int_escalation_from_ITE_BE_smoke;
        
  --%afterall
  procedure tear_down_process;


end test_call_Activity_escalation_BEs;
/
