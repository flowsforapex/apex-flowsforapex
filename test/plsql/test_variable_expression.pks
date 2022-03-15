create or replace package test_variable_expressions is

   --%suite(test_variable_expressions)
   --%rollback(manual)

   --%test
   procedure var_exp_all_types;

   
end test_variable_expressions;