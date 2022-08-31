create or replace package test_012_call_Activity_timer_BEs is
/* 
-- Flows for APEX - test_012_call_Activity_timer_BEs.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 16-May-2022   Richard Allen, Oracle   
-- 
*/

  --%suite(12 Call Activity Timer Boundary Events)
  --%rollback(manual)

  --%beforeall
  procedure set_up_process;

  --%test(Non-interrupting timer boundary events on CallActivity - Fires - smoke)
  procedure test_callActivity_non_int_timer_BE_fires_smoke;

  --%test(Non-interrupting timer boundary events on CallActivity - Cancels - smoke)
  procedure test_callActivity_non_int_timer_BE_cancels_smoke;

  --%test(Interrupting timer boundary events on CallActivity - smoke)
  procedure test_callActivity_int_timer_BE_fires_smoke;

  --%test(Interrupting timer boundary events on CallActivity - smoke)
  procedure test_callActivity_int_timer_BE_cancels_smoke;
        
  --%afterall
  procedure tear_down_process;


end test_012_call_Activity_timer_BEs;
/
