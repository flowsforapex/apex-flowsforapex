create or replace package test_023_custom_extensions as
/* 
-- Flows for APEX - test_023_custom_extensions.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 16-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 23a-b

  --%suite(23 Custom Extensions)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%test(A - Parse and Access all objects - No Lanes)
  procedure custom_exts_no_lanes;

  --%test(B - Parse and Access all objects - In Collaboration)
  procedure custom_ext_lanes;

  --%afterall
  procedure tear_down_tests;

end test_023_custom_extensions;