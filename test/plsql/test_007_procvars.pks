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
  --%tag(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%beforeeach
  procedure before_each_test;

-------------------------------------------------------------------------------------
--
--  VARCHAR2
--
-------------------------------------------------------------------------------------

  --%test(V-A1 - VC2 no Scope Set Insert)
  procedure varchar2_no_scope_set_insert;

  --%test(V-A2 - VC2 no Scope Set Update)
  procedure varchar2_no_scope_set_update;

  --%test(V-B1 - VC2 call by Scope 0 Set Insert)
  procedure varchar2_in_scope0_set_insert;

  --%test(V-B2 - VC2 call by Scope 0 Set Update)
  procedure varchar2_in_scope0_set_update;

  --%test(V-C1 - VC2 call by sbfl_id Scope0 Set Insert)
  procedure varchar2_in_scope0_sbfl_set_insert;

  --%test(V-C2 - VC2 call by sbfl_id Scope0 Set Update)
  procedure varchar2_in_scope0_sbfl_set_update;

  --%test(V-D1 - VC2 call by subprocess sbfl_id Scope0 Set Insert)
  procedure varchar2_in_scope0_sbfl_sub_set_insert;

  --%test(V-D2 - VC2 call by subprocess sbfl_id Scope0 Set Update)
  procedure varchar2_in_scope0_sbfl_sub_set_update;

  --%test(V-E1 - VC2 call by Scope inside CallActivity Set Insert)
  procedure varchar2_in_scope_call_set_insert;

  --%test(V-E2 - VC2 call by Scope inside CallActivity Set Update)
  procedure varchar2_in_scope_call_set_update;

  --%test(V-F1 - VC2 call by sbfl_id inside callactivity Set Insert)
  procedure varchar2_in_scope_call_sbfl_set_insert;

  --%test(V-F2 - VC2 call by sbfl_id inside callactivity Set Update)
  procedure varchar2_in_scope_call_sbfl_set_update;  

  --%test(V-G1 - VC2 call by sbfl_id with bad sbfl id - set insert)
  --%throws(-20987)
  procedure varchar2_call_by_bad_sbfl_set_insert;

  --%test(V-G2 - VC2 call by sbfl_id with bad sbfl_id - set update)
  --%throws(-20987)
  procedure varchar2_call_by_bad_sbfl_set_update;  

  --%test(V-H1 - VC2 call by scope with bad scope - set insert)
  --%throws(-20987)
  procedure varchar2_call_by_bad_scope_set_insert;

  --%test(V-H2 - VC2 call by scope with bad scope - set update)
  --%throws(-20987)
  procedure varchar2_call_by_bad_scope_set_update;  

-------------------------------------------------------------------------------------
--
--  NUMBERS
--
-------------------------------------------------------------------------------------

  --%test(N-A1 - Number no Scope Set Insert)
  procedure num_no_scope_set_insert;

  --%test(N-A2 - Number no Scope Set Update)
  procedure num_no_scope_set_update;

  --%test(N-B1 - Number call by Scope 0 Set Insert)
  procedure num_in_scope0_set_insert;

  --%test(N-B2 - Number call by Scope 0 Set Update)
  procedure num_in_scope0_set_update;

  --%test(N-C1 - Number call by sbfl_id Scope0 Set Insert)
  procedure num_in_scope0_sbfl_set_insert;

  --%test(N-C2 - Number call by sbfl_id Scope0 Set Update)
  procedure num_in_scope0_sbfl_set_update;

  --%test(N-D1 - Number call by subprocess sbfl_id Scope0 Set Insert)
  procedure num_in_scope0_sbfl_sub_set_insert;

  --%test(N-D2 - Number call by subprocess sbfl_id Scope0 Set Update)
  procedure num_in_scope0_sbfl_sub_set_update;

  --%test(N-E1 - Number call by Scope inside CallActivity Set Insert)
  procedure num_in_scope_call_set_insert;

  --%test(N-E2 - Number call by Scope inside CallActivity Set Update)
  procedure num_in_scope_call_set_update;

  --%test(N-F1 - Number call by sbfl_id inside callactivity Set Insert)
  procedure num_in_scope_call_sbfl_set_insert;

  --%test(N-F2 - Number call by sbfl_id inside callactivity Set Update)
  procedure num_in_scope_call_sbfl_set_update;  

  --%test(N-G1 - Number call by sbfl_id with bad sbfl id - set insert)
  --%throws(-20987)
  procedure num_call_by_bad_sbfl_set_insert;

  --%test(N-G2 - Number call by sbfl_id with bad sbfl_id - set update)
  --%throws(-20987)
  procedure num_call_by_bad_sbfl_set_update;  

  --%test(N-H1 - Number call by scope with bad scope - set insert)
  --%throws(-20987)
  procedure num_call_by_bad_scope_set_insert;

  --%test(N-H2 - Number call by scope with bad scope - set update)
  --%throws(-20987)
  procedure num_call_by_bad_scope_set_update; 

-------------------------------------------------------------------------------------
--
--  DATES
--
-------------------------------------------------------------------------------------

  --%test(D-A1 - Date no Scope Set Insert)
  procedure date_no_scope_set_insert;

  --%test(D-A2 - Date no Scope Set Update)
  procedure date_no_scope_set_update;

  --%test(D-B1 - Date call by Scope 0 Set Insert)
  procedure date_in_scope0_set_insert;

  --%test(D-B2 - Date call by Scope 0 Set Update)
  procedure date_in_scope0_set_update;

  --%test(D-C1 - Date call by sbfl_id Scope0 Set Insert)
  procedure date_in_scope0_sbfl_set_insert;

  --%test(D-C2 - Date call by sbfl_id Scope0 Set Update)
  procedure date_in_scope0_sbfl_set_update;

  --%test(D-D1 - Date call by subprocess sbfl_id Scope0 Set Insert)
  procedure date_in_scope0_sbfl_sub_set_insert;

  --%test(D-D2 - Date call by subprocess sbfl_id Scope0 Set Update)
  procedure date_in_scope0_sbfl_sub_set_update;

  --%test(D-E1 - Date call by Scope inside CallActivity Set Insert)
  procedure date_in_scope_call_set_insert;

  --%test(D-E2 - Date call by Scope inside CallActivity Set Update)
  procedure date_in_scope_call_set_update;

  --%test(D-F1 - Date call by sbfl_id inside callactivity Set Insert)
  procedure date_in_scope_call_sbfl_set_insert;

  --%test(D-F2 - Date call by sbfl_id inside callactivity Set Update)
  procedure date_in_scope_call_sbfl_set_update;  

  --%test(D-G1 - Date call by sbfl_id with bad sbfl id - set insert)
  --%throws(-20987)
  procedure date_call_by_bad_sbfl_set_insert;

  --%test(D-G2 - Date call by sbfl_id with bad sbfl_id - set update)
  --%throws(-20987)
  procedure date_call_by_bad_sbfl_set_update;  

  --%test(D-H1 - Date call by scope with bad scope - set insert)
  --%throws(-20987)
  procedure date_call_by_bad_scope_set_insert;
  
  --%test(D-H2 - Date call by scope with bad scope - set update)
  --%throws(-20987)
  procedure date_call_by_bad_scope_set_update;  

-------------------------------------------------------------------------------------
--
--  CLOB
--
--------------------------------------------------------------------------------------
  --%test(C-A1 - CLOB no Scope Set Insert)
  procedure clob_no_scope_set_insert;

  --%test(C-A2 - CLOB no Scope Set Update)
  procedure clob_no_scope_set_update;

  --%test(C-B1 - CLOB call by Scope 0 Set Insert)
  procedure clob_in_scope0_set_insert;

  --%test(C-B2 - CLOB call by Scope 0 Set Update)
  procedure clob_in_scope0_set_update;

  --%test(C-C1 - CLOB call by sbfl_id Scope0 Set Insert)
  procedure clob_in_scope0_sbfl_set_insert;

  --%test(C-C2 - CLOB call by sbfl_id Scope0 Set Update)
  procedure clob_in_scope0_sbfl_set_update;

  --%test(C-D1 - CLOB call by subprocess sbfl_id Scope0 Set Insert)
  procedure clob_in_scope0_sbfl_sub_set_insert;

  --%test(C-D2 - CLOB call by subprocess sbfl_id Scope0 Set Update)
  procedure clob_in_scope0_sbfl_sub_set_update;

  --%test(C-E1 - CLOB call by Scope inside CallActivity Set Insert)
  procedure clob_in_scope_call_set_insert;

  --%test(C-E2 - CLOB call by Scope inside CallActivity Set Update)
  procedure clob_in_scope_call_set_update;

  --%test(C-F1 - CLOB call by sbfl_id inside callactivity Set Insert)
  procedure clob_in_scope_call_sbfl_set_insert;

  --%test(C-F2 - CLOB call by sbfl_id inside callactivity Set Update)
  procedure clob_in_scope_call_sbfl_set_update;  

  --%test(C-G1 - CLOB call by sbfl_id with bad sbfl id - set insert)
  --%throws(-20987)
  procedure clob_call_by_bad_sbfl_set_insert;

  --%test(C-G2 - CLOB call by sbfl_id with bad sbfl_id - set update)
  --%throws(-20987)
  procedure clob_call_by_bad_sbfl_set_update;  

  --%test(C-H1 - CLOB call by scope with bad scope - set insert)
  --%throws(-20987)
  procedure clob_call_by_bad_scope_set_insert;

  --%test(C-H2 - CLOB call by scope with bad scope - set update)
  --%throws(-20987)
  procedure clob_call_by_bad_scope_set_update;  

  -------------------------------------------------------------------------------------
--
--  TIMESTAMP WITH TIME ZONE (TSTZ)
--
-------------------------------------------------------------------------------------    

  --%test(T-A1 - TSTZ no Scope Set Insert)
  procedure tstz_no_scope_set_insert;

  --%test(T-A2 - TSTZ no Scope Set Update)
  procedure tstz_no_scope_set_update;

  --%test(T-B1 - TSTZ call by Scope 0 Set Insert)
  procedure tstz_in_scope0_set_insert;

  --%test(T-B2 - TSTZ call by Scope 0 Set Update)
  procedure tstz_in_scope0_set_update;

  --%test(T-C1 - TSTZ call by sbfl_id Scope0 Set Insert)
  procedure tstz_in_scope0_sbfl_set_insert;

  --%test(T-C2 - TSTZ call by sbfl_id Scope0 Set Update)
  procedure tstz_in_scope0_sbfl_set_update;

  --%test(T-D1 - TSTZ call by subprocess sbfl_id Scope0 Set Insert)
  procedure tstz_in_scope0_sbfl_sub_set_insert;

  --%test(T-D2 - TSTZ call by subprocess sbfl_id Scope0 Set Update)
  procedure tstz_in_scope0_sbfl_sub_set_update;

  --%test(T-E1 - TSTZ call by Scope inside CallActivity Set Insert)
  procedure tstz_in_scope_call_set_insert;

  --%test(T-E2 - TSTZ call by Scope inside CallActivity Set Update)
  procedure tstz_in_scope_call_set_update;

  --%test(T-F1 - TSTZ call by sbfl_id inside callactivity Set Insert)
  procedure tstz_in_scope_call_sbfl_set_insert;

  --%test(T-F2 - TSTZ call by sbfl_id inside callactivity Set Update)
  procedure tstz_in_scope_call_sbfl_set_update;  

  --%test(T-G1 - TSTZ call by sbfl_id with bad sbfl id - set insert)
  --%throws(-20987)
  procedure tstz_call_by_bad_sbfl_set_insert;

  --%test(T-G2 - TSTZ call by sbfl_id with bad sbfl_id - set update)
  --%throws(-20987)
  procedure tstz_call_by_bad_sbfl_set_update;  

  --%test(T-H1 - TSTZ call by scope with bad scope - set insert)
  --%throws(-20987)
  procedure tstz_call_by_bad_scope_set_insert;

  --%test(T-H2 - TSTZ call by scope with bad scope - set update)
  --%throws(-20987)
  procedure tstz_call_by_bad_scope_set_update;  

-------------------------------------------------------------------------------------
--
--  BUSINESS_REF
--
-------------------------------------------------------------------------------------

  --%test(BR-A1 - Set+Get Business Ref assumed scope 0 - set insert)
  procedure business_ref_set_assumed_scope0_insert;

  --%test(BR-A2 - Set+Get Business Ref assumed scope 0 - set update)
  procedure business_ref_set_assumed_scope0_update;

  --%test(BR-B1 - Set+Get Business Ref by Sbfl scope call - set insert)
  procedure business_ref_set_by_sbfl_insert;

  --%test(BR-B2 - Set+Get Business Ref by Sbfl scope call - set update)
  procedure business_ref_set_by_sbfl_update;

  --%test(BR-C1 - Set+Get Business Ref by scope call - set insert)
  procedure business_ref_set_by_scope_call_insert;

  --%test(BR-C2 - Set+Get Business Ref by scope call - set update)
  procedure business_ref_set_by_scope_call_update;

-------------------------------------------------------------------------------------
--
-- DELETION
--
-------------------------------------------------------------------------------------

  --%test(DEL-1 Delete by Scope)
  procedure delete_by_scope;

  --%test(DEL-2 Delete by sbfl)
  procedure delete_by_sbfl;
 
  --%test(DEL-3 Delete by Scope - non-existant variable)
  procedure delete_by_scope_not_existing_var;

  --%test(DEL-4 Delete by sbfl - non-existant variable)
  procedure delete_by_sbfl_not_existing_var; 

  --%test(DEL-5 Delete by Scope - non-existant scope)
  procedure delete_by_scope_not_existing_scope;

  --%test(DEL-6 Delete by sbfl - non-existant sbfl)
  procedure delete_by_sbfl_not_existing_sbfl; 

-------------------------------------------------------------------------------------
--
--  GET WITH EXCEPTION ON NULL
--
-------------------------------------------------------------------------------------

  --%test(NL-1 - Get VC2 with error on exception)
  --%throws(-1403)
  procedure get_null_vc2;

  --%test(NL-2 - Get num with error on exception)
  --%throws(-1403)
  procedure get_null_num;

  --%test(NL-3 - Get date with error on exception)
  --%throws(-1403)
  procedure get_null_date;

  --%test(NL-4 - Get TSTZ with error on exception)
  --%throws(-1403)
  procedure get_null_tstz;

  --%test(NL-5 - Get CLOB with error on exception)
  --%throws(-1403)
  procedure get_null_clob;

  --%test(NL-6 - Get Type with error on exception)
  --%throws(-1403)
  procedure get_null_type;

  --%test(NL-1B - Get VC2 with error on exception - call by sbfl)
  --%throws(-1403)
  procedure get_null_vc2_by_sbfl;

  --%test(NL-2B - Get num with error on exception - call by sbfl)
  --%throws(-1403)
  procedure get_null_num_by_sbfl;

  --%test(NL-3B - Get date with error on exception - call by sbfl)
  --%throws(-1403)
  procedure get_null_date_by_sbfl;

  --%test(NL-4B - Get TSTZ with error on exception - call by sbfl)
  --%throws(-1403)
  procedure get_null_tstz_by_sbfl;

  --%test(NL-5B - Get CLOB with error on exception - call by sbfl)
  --%throws(-1403)
  procedure get_null_clob_by_sbfl;

  --%test(NL-6B - Get Type with error on exception - call by sbfl)
  --%throws(-1403)
  procedure get_null_type_by_sbfl;

  --%aftereach
  procedure tear_down_tests;

end test_007_procvars;
/
