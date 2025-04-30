create or replace package test_constants
as
/* 
-- Flows for APEX - test_constants.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
-- (c) Copyright Flowquest Limited and / or its affiliates.  2025.
--
-- Created 01-Oct-2023 Richard Allen (Oracle)
-- Edited  20-Jan-2025 Richard Allen (Flowquest)
--
--   This file contains constants that can be tailored to a test environment
--    These constants are used by the test suites 
--
*/

  -- APEX AppIDs of Apps used in Tests
  gc_Ste24_Test_App_ID                  constant varchar2(5) := '101';

  -- APEX UserIDs used for Test Suite 24 (APEX Human Tasks)
  gc_tester1                            constant varchar2(20) := 'FLOWSTESTER1';
  gc_tester2                            constant varchar2(20) := 'FLOWSTESTER2';


end test_constants;
/
