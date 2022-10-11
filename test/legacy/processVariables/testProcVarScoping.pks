create or replace package testProcVarScoping
as

  --%suite(process variable setters and getters with scoping)
  --%rollback(manual)

  --%test(set a vc2 variable in scope 0 - happy case)
  procedure basic_vc2_in_scope_0;

  end;
  /
