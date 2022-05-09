/* 
-- Flows for APEX - test_variable_expressions.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 10-Mar-2022   Louis Moreaux - Insum
-- Edited  09-May-2022   Richard Allen - Oracle
--
*/
create or replace package test_variable_expressions is

    --%suite(test_variable_expressions)
    --%rollback(manual)

    --%beforeall
    procedure set_up_process;


    --%test('Static Process Variable type expressions')
    procedure var_exp_static;
    
    --%test('Copy Process Variable type expressions')
    procedure var_exp_procvar;
    
    --%test('SQL Single type expressions')
    procedure var_exp_sqlsingle;
    
    --%test('SQL Multi type expressions')
    procedure var_exp_sqlmulti;
    
    --%test('PL/SQL Expression type expressions')
    procedure var_exp_expression;
    
    --%test('PL/SQL Function Body type expressions')
    procedure var_exp_funcbody;
        
    --%test('Variable expressions process completed as expected')
    procedure var_exp_process_completed;
        
    --%afterall
    procedure tear_down_process;

end test_variable_expressions;