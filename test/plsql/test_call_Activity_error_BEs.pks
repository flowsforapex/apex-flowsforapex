/* 
-- Flows for APEX - test_call_Activity_error_BEs.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 19-May-2022   Richard Allen, Oracle   
-- 
*/

create or replace package test_call_Activity_error_BEs is

  --%suite(test_callActivity_error_boundary_Events)
  --%rollback(manual)

  --%beforeall
  procedure set_up_process;

  --%test(Error boundary events on CallActivity - error occurs)
  procedure test_callActivity_error_BE;

  --%test(Error boundary events on CallActivity - no error occurs)
  procedure test_callActivity_error_BE_no_error;

  --%test(Error boundary events on CallActivity - error occurs - no error BE)
  procedure test_callActivity_error_BE_no_BE;

  --%test(Error boundary events on CallActivity - terminate end in Called)
  procedure test_callActivity_error_from_term_end;
        
  --%afterall
  procedure tear_down_process;


end test_call_Activity_error_BEs;
/
