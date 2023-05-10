create or replace package test_007_procvars as
/* 
-- Flows for APEX - test_007_procvars.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 09-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 07a-b-

  --%suite(07 Process Variables API)
  --%rollback(manual)

  --%beforeall
  procedure set_up_tests;

  --%beforeeach
  procedure before_each_test;

  --%test(A1 - VC2 no Scope Set Insert)
  procedure varchar2_no_scope_set_insert;

  --%test(A2 - VC2 no Scope Set Update)
  procedure varchar2_no_scope_set_update;

  --%test(B1 - VC2 call by Scope 0 Set Insert)
  procedure varchar2_in_scope0_set_insert;

  --%test(B2 - VC2 call by Scope 0 Set Update)
  procedure varchar2_in_scope0_set_update;

  --%test(C1 - VC2 call by sbfl_id Scope0 Set Insert)
  procedure varchar2_in_scope0_sbfl_set_insert;

  --%test(C2 - VC2 call by sbfl_id Scope0 Set Update)
  procedure varchar2_in_scope0_sbfl_set_update;

  --%test(D1 - VC2 call by subprocess sbfl_id Scope0 Set Insert)
  procedure varchar2_in_scope0_sbfl_sub_set_insert;

  --%test(D2 - VC2 call by subprocess sbfl_id Scope0 Set Update)
  procedure varchar2_in_scope0_sbfl_sub_set_update;

  --%test(E1 - VC2 call by Scope inside CallActivity Set Insert)
  procedure varchar2_in_scope_call_set_insert;

  --%test(E2 - VC2 call by Scope inside CallActivity Set Update)
  procedure varchar2_in_scope_call_set_update;

  --%test(F1 - VC2 call by sbfl_id inside callactivity Set Insert)
  procedure varchar2_in_scope_call_sbfl_set_insert;

  --%test(F2 - VC2 call by sbfl_id inside callactivity Set Update)
  procedure varchar2_in_scope_call_sbfl_set_update;  

  --%test(G1 - VC2 call by sbfl_id with bad sbfl id - set insert)
  --%throws(-20987)
  procedure varchar2_call_by_bad_sbfl_set_insert;

  --%test(G2 - VC2 call by sbfl_id with bad sbfl_id - set update)
  --%throws(-20987)
  procedure varchar2_call_by_bad_sbfl_set_update;  

  --%test(H1 - VC2 call by scope with bad scope - set insert)
  --%throws(-20987)
  procedure varchar2_call_by_bad_scope_set_insert;

  --%test(H2 - VC2 call by scope with bad scope - set update)
  --%throws(-20987)
  procedure varchar2_call_by_bad_scope_set_update;  


  --%aftereach
  procedure tear_down_tests;

end test_007_procvars;