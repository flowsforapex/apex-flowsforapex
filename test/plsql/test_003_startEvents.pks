create or replace package test_003_startEvents is
/* 
-- Flows for APEX - test_003_startEvents.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 07-July-2022   Richard Allen, Oracle   
-- 
*/
   -- uses models A03a-i

   -- tests  good and bad startEvent definitions

   --%suite(03 Start Events)
   --%rollback(manual)
   --%tags(short,ce,ee)

   --%beforeall
   procedure setup_tests;

   --%test(03a - no start event)
   --%throws(-20987)
   procedure no_start_event;

   --%test(03b - multiple start events)
   --%throws(-20987)
   procedure multiple_start_events;

   --%test(03c - good start event)
   procedure good_start_event;

   --%test(03d - incorrect start type)
   --%throws(-20987)
   procedure incorrect_start_type;

   --%test(03e - good timer start event)
   --%tags(timer)
   procedure good_timer_start;

   --%test(03f - timer start event with bad timer definition)
   --%throws(-20987)
   --%tags(timer)
   procedure bad_timer_definition;

   --%test(03g - startEvent with bad on-event var exp)
   --%throws(-20987)
   --%tags(timer)
   procedure bad_on_event_var_exp;

   --%test(03h-1 - timer startEvent with bad before-event var exp - throw)
   --%throws(-20987)
   --%tags(timer)
   procedure bad_before_event_1;

   --%test(03h-2 - timer startEvent with bad before-event var exp - restart)
   --%tags(timer)
   procedure bad_before_event_2;

   --%test(03i - attempt to start a running process)
   --%throws(-20987)
   procedure start_running_process;

   --%afterall
   procedure tear_down_tests;

end test_003_startEvents;
/
