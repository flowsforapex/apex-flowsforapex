create or replace package test_018_gw_routing_exps as
/* 
-- Flows for APEX - test_018_gw_routing_exps.pks
-- r490fv
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 12-Aug-2022   Richard Allen - Oracle
--
*/

  -- uses models 18a-l

  --%suite(18 Gateway Routing Expressions)
  --%rollback(manual)
  --%tags(short,ce,ee)

  --%beforeall
  procedure set_up_tests;

  --%test(A1 - Expressions - Basic Logic)
  procedure exps_basic;

  --%test(A2 - Expressions - Substitutions)
  procedure exps_subs;

  --%test(A3 - Expressions - Binds)
  procedure exps_binds;

  --%test(A4 - Expressions - Mixed Binds and Substitutions)
  procedure exps_mixed;

  --%test(A5 - Expressions - Completed)
  procedure exps_complete;

  --%test(B1 - Function Bodies - Basic Logic)
  procedure func_bodies_basic;

  --%test(B2 - Function Bodies - Substitutions)
  procedure func_bodies_subs;

  --%test(B3 - Function Bodies - Binds)
  procedure func_bodies_binds;

  --%test(B4 - Function Bodies - Mixed Binds and Substitutions)
  procedure func_bodies_mixed;

  --%test(B5 - Function Bodies - Completed)
  procedure func_bodies_complete;

  --%test(C1 - Inc GW - Unconditional Default ABC - Case A)
  procedure IncGWUnCondDefA;
  
  --%test(C2 - Inc GW - Unconditional Default ABC - Case B)
  procedure IncGWUnCondDefB;
  
  --%test(C3 - Inc GW - Unconditional Default ABC - Case D)
  procedure IncGWUnCondDefD;
  
  --%test(C4 - Inc GW - Unconditional Default ABC - null case)
  procedure IncGWUnCondDefNull;
  
  --%test(C5 - Inc GW - Unconditional Default ABC - missing case)
  procedure IncGWUnCondDefMissing;
  

  --%test(D1 - Inc GW - Conditional Default ABC - Case A)
  procedure IncGWCondDefA;
  
  --%test(D2 - Inc GW - Conditional Default ABC - Case B)
  procedure IncGWCondDefB;
  
  --%test(D3 - Inc GW - Conditional Default ABC - Case C)
  procedure IncGWCondDefC;
  
  --%test(D4 - Inc GW - Conditional Default ABC - null case)
  procedure IncGWCondDefNull;
  
  --%test(D5 - Inc GW - Conditional Default ABC - missing case)
  procedure IncGWCondDefMissing;
  
  --%test(D6 - Inc GW - Conditional Default ABC - Case AC)
  procedure IncGWCondDefAC;
  
  --%test(D7 - Inc GW - Conditional Default ABC - Case D)
  procedure IncGWCondDefD;
  

  --%test(E1 - Inc GW - No Default ABC C Undef - Case A)
  procedure IncGWNoDefA;
  
  --%test(E2 - Inc GW - No Default ABC C Undef - Case B)
  procedure IncGWNoDefB;
  
  --%test(E3 - Inc GW - No Default ABC C Undef - Case D)
  procedure IncGWNoDefD;
  
  --%test(E4 - Inc GW - No Default ABC C Undef - null case)
  procedure IncGWNoDefNull;
  
  --%test(E5 - Inc GW - No Default ABC C Undef - missing case)
  procedure IncGWNoDefABC;
  

  --%test(F1 - Inc GW - Conds ABC No Def - Case A)
  procedure IncGWAllCondCDefA;

  --%test(F2 - Inc GW - Conds ABC No Def - Case B)
  procedure IncGWAllCondCDefB;

  --%test(F3 - Inc GW - Conds ABC No Def - Case D)
  procedure IncGWAllCondCDefD;

  --%test(F4 - Inc GW - Conds ABC No Def - null case)
  procedure IncGWAllCondCDefNull;

  --%test(F5 - Inc GW - Conds ABC No Def - missing case)
  procedure IncGWAllCondCDefMissing;

  --%test(F6 - Inc GW - Conds ABC No Def - Case ABC)
  procedure IncGWAllCondCDefABC;
  
  --%test(G1 - Inc GW - No Conds ABC No Def - Case null)
  procedure IncGWNoCondNoDefNull;

  --%test(G2 - Inc GW - No Conds ABC No Def - Case A)
  procedure IncGWNoCondNoDefA;

  --%test(G3 - Inc GW - No Conds ABC No Def - Case missing)
  procedure IncGWNoCondNoDefmissing;


  --%test(H1 - Excl GW - Unconditional Default ABC - Case A)
  procedure ExcGWUnCondDefA;
  
  --%test(H2 - Excl GW - Unconditional Default ABC - Case B)
  procedure ExcGWUnCondDefB;
  
  --%test(H3 - Excl GW - Unconditional Default ABC - Case D)
  procedure ExcGWUnCondDefD;
  
  --%test(H4 - Excl GW - Unconditional Default ABC - null case)
  procedure ExcGWUnCondDefNull;
  
  --%test(H5 - Excl GW - Unconditional Default ABC - missing case)
  procedure ExcGWUnCondDefMissing;


  --%test(I1 - Excl GW - Conditional Default ABC - Case A)
  procedure ExcGWCondDefA;
  
  --%test(I2 - Excl GW - Conditional Default ABC - Case B)
  procedure ExcGWCondDefB;
  
  --%test(I3 - Excl GW - Conditional Default ABC - Case C)
  procedure ExcGWCondDefC;
  
  --%test(I4 - Excl GW - Conditional Default ABC - null case)
  procedure ExcGWCondDefNull;
  
  --%test(I5 - Excl GW - Conditional Default ABC - missing case)
  procedure ExcGWCondDefMissing;
  
  --%test(I6 - Excl GW - Conditional Default ABC - Case AC)
  procedure ExcGWCondDefAC;
  
  --%test(I7 - Excl GW - Conditional Default ABC - Case D)
  procedure ExcGWCondDefD;
  

  --%test(J1 - Excl GW - No Default ABC C Undef - Case A)
  procedure ExcGWNoDefA;
  
  --%test(J2 - Excl GW - No Default ABC C Undef - Case B)
  procedure ExcGWNoDefB;
  
  --%test(J3 - Excl GW - No Default ABC C Undef - Case D)
  procedure ExcGWNoDefD;
  
  --%test(J4 - Excl GW - No Default ABC C Undef - null case)
  procedure ExcGWNoDefNull;
  
  --%test(J5 - Excl GW - No Default ABC C Undef - missing case)
  procedure ExcGWNoDefABC;
  

  --%test(K1 - Excl GW - Conds ABC No Def - Case A)
  procedure ExcGWAllCondCDefA;

  --%test(K2 - Excl GW - Conds ABC No Def - Case B)
  procedure ExcGWAllCondCDefB;

  --%test(K3 - Excl GW - Conds ABC No Def - Case D)
  procedure ExcGWAllCondCDefD;

  --%test(K4 - Excl GW - Conds ABC No Def - null case)
  procedure ExcGWAllCondCDefNull;

  --%test(K5 - Excl GW - Conds ABC No Def - missing case)
  procedure ExcGWAllCondCDefMissing;

  --%test(K6 - Excl GW - Conds ABC No Def - Case ABC)
  procedure ExcGWAllCondCDefABC;
  
  
  --%test(L1 - Excl GW - No Conds ABC No Def - Case null)
  procedure ExcGWNoCondNoDefNull;

  --%test(L2 - Excl GW - No Conds ABC No Def - Case A)
  procedure ExcGWNoCondNoDefA;

  --%test(L3 - Excl GW - No Conds ABC No Def - Case missing)
  procedure ExcGWNoCondNoDefmissing;

  --%afterall
  procedure tear_down_tests;

end test_018_gw_routing_exps;
/
