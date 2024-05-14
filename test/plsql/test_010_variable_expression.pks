create or replace package test_010_variable_expressions is
/* 
-- Flows for APEX - test_010_variable_expressions.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
--
-- Created 10-Mar-2022   Louis Moreaux - Insum
-- Edited  09-May-2022   Richard Allen - Oracle
--
*/
    --%suite(10 Variable Expressions)
    --%rollback(manual)

    --%beforeall
    procedure set_up_process;

    --%test('check test can establish APEX session')
    procedure test_apex_session_creation;

    --%test('Static Process Variable type expressions')
    procedure var_exp_static;
    
    --%test('Copy Process Variable type expressions')
    procedure var_exp_procvar;
    
    --%test('SQL Single type expressions')
    procedure var_exp_sqlsingle;
    
    --%test('SQL Multi type expressions')
    procedure var_exp_sqlmulti;
    
    --%test('PL/SQL Expression (legacy) type expressions')
    procedure var_exp_expression;
    
    --%test('PL/SQL Function Body (legacy) type expressions')
    procedure var_exp_funcbody;

    --%test('PL/SQL Expression (raw) type expressions')
    procedure var_exp_raw_expression;
    
    --%test('PL/SQL Function Body (raw) type expressions')
    procedure var_exp_raw_funcbody;
        
    --%test('Variable expressions process completed as expected')
    procedure var_exp_process_completed;
        
    --afterall
    procedure tear_down_process;

end test_010_variable_expressions;
/
