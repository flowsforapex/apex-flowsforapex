create or replace package test_004_proc_vars is

   -- uses model A01

   -- tests  process variable functions

   --%suite(Process Variable operations)
   --%rollback(manual)

   -- Need to add tests for by name, by name and version, by id
   -- Maybe need to test the versionning logic as well here?

  --%beforeall
  procedure set_up_tests;


  --%test(1. Basic Process Variable Operations - duplicates test in suite 001)
  procedure basic_flow_variables;

  --%test(2. Case sensitivity of Proc Vars - vc2)
  procedure var_case_sensitivity_vc2;

  --%test(2. Case sensitivity of Proc Vars - date)
  procedure var_case_sensitivity_num;

    --%test(2. Case sensitivity of Proc Vars - number)
  procedure var_case_sensitivity_date;



  --%afterall
  procedure tear_down_tests;

end test_004_proc_vars;