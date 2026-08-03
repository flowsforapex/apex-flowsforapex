create or replace package test_010_variable_expressions is
/* 
-- Flows for APEX - test_010_variable_expressions.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022-2023.
--
-- Created 10-Mar-2022   Louis Moreaux - Insum
-- Edited  09-May-2022   Richard Allen - Oracle
-- Edited  23 May 2024   Richard Allen - Flowquest Consulting Limited
--
*/
    --%suite(10 Variable Expressions)
    --%rollback(manual)
    --%tags(short,ce,ee)

    --%beforeall
    procedure set_up_process;

    --%test('A. check test can establish APEX session')
    procedure test_apex_session_creation;

    --%test('B. Static Process Variable type expressions')
    procedure var_exp_static;
    
    --%test('C. Copy Process Variable type expressions')
    procedure var_exp_procvar;
    
    --%test('D. SQL Single type expressions')
    procedure var_exp_sqlsingle;
    
    --%test('E. SQL Multi type expressions')
    procedure var_exp_sqlmulti;
    
    --%test('F. SQL JSON Array type expressions')
    procedure var_exp_sqlarray;

    --%test('G. PL/SQL Expression (legacy) type expressions')
    procedure var_exp_expression;
    
    --%test('H. PL/SQL Function Body (legacy) type expressions')
    procedure var_exp_funcbody;

    --%test('I. PL/SQL Expression (raw) type expressions')
    procedure var_exp_raw_expression;
    
    --%test('J. PL/SQL Function Body (raw) type expressions')
    procedure var_exp_raw_funcbody;

    --%test('L. JSONpath expressions')
    procedure var_exp_jsonpath;
        
    --%test('Z. Variable expressions process completed as expected')
    procedure var_exp_process_completed;

    --%afterall
    procedure tear_down_process;

end test_010_variable_expressions;
/
