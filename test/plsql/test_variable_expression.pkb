/* 
-- Flows for APEX - test_variable_expressions.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 10-Mar-2022   Louis Moreaux - Insum
-- Edited  09-May-2022   Richard Allen - Oracle
--
*/

create or replace package body test_variable_expressions is

    g_model_a10 constant varchar2(100) := 'A10 - Variable Expressions Types';
    g_sbfl_static           flow_subflows.sbfl_id%type;
    g_sbfl_procvar          flow_subflows.sbfl_id%type;
    g_sbfl_sqlSingle        flow_subflows.sbfl_id%type;
    g_sbfl_sqlMulti         flow_subflows.sbfl_id%type;
    g_sbfl_expression       flow_subflows.sbfl_id%type;
    g_sbfl_funcBody         flow_subflows.sbfl_id%type;
    g_prcs_id  flow_processes.prcs_id%type;
    g_dgrm_id  flow_diagrams.dgrm_id%type;
      
   procedure set_dgrm_id( pi_dgrm_name in varchar2)
   is
   begin
      select dgrm_id
      into g_dgrm_id
      from flow_diagrams
      where dgrm_name = pi_dgrm_name;
   end set_dgrm_id;

   procedure set_up_process
   is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
   begin
        -- get dgrm_id to use for comparaison
        set_dgrm_id( g_model_a10 );

        -- create a new instance
        g_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => g_dgrm_id
         , pi_prcs_name => 'test - var_exp_all_types'
        );
         
        -- check no existing process variables
        
        open l_actual for
        select *
        from flow_process_variables
        where prov_prcs_id = g_prcs_id;

        ut.expect( l_actual ).to_have_count( 0 );
        
        -- start process and check running status
        
        flow_api_pkg.flow_start( p_process_id => g_prcs_id );

        open l_expected for
            select
            g_dgrm_id                                   as prcs_dgrm_id,
            'test - var_exp_all_types'                  as prcs_name,
            flow_constants_pkg.gc_prcs_status_running   as prcs_status
            from dual;

        open l_actual for
            select prcs_dgrm_id, prcs_name, prcs_status 
              from flow_processes p
             where p.prcs_id = g_prcs_id;

        ut.expect( l_actual ).to_equal( l_expected );
        
        -- check all parallel subflows running
   
      open l_expected for
         select
            g_prcs_id as sbfl_prcs_id,
            g_dgrm_id as sbfl_dgrm_id,
            'Static' as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual
         union
         select
            g_prcs_id as sbfl_prcs_id,
            g_dgrm_id as sbfl_dgrm_id,
            'ProcVar' as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual
         union
         select
            g_prcs_id as sbfl_prcs_id,
            g_dgrm_id as sbfl_dgrm_id,
            'SQLSingle' as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual
         union
         select
            g_prcs_id as sbfl_prcs_id,
            g_dgrm_id as sbfl_dgrm_id,
            'SQLMulti' as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual
         union
         select
            g_prcs_id as sbfl_prcs_id,
            g_dgrm_id as sbfl_dgrm_id,
            'Expression' as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual
         union
         select
            g_prcs_id as sbfl_prcs_id,
            g_dgrm_id as sbfl_dgrm_id,
            'FuncBody' as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = g_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;
      
      -- get the subflow ids
      select sbfl_id
        into g_sbfl_static
        from flow_subflows
       where sbfl_prcs_id = g_prcs_id
         and sbfl_current = 'Static';
         
      select sbfl_id
        into g_sbfl_procvar
        from flow_subflows
       where sbfl_prcs_id = g_prcs_id
         and sbfl_current = 'ProcVar';
         
      select sbfl_id
        into g_sbfl_sqlsingle
        from flow_subflows
       where sbfl_prcs_id = g_prcs_id
         and sbfl_current = 'SQLSingle';
         
      select sbfl_id
        into g_sbfl_sqlmulti
        from flow_subflows
       where sbfl_prcs_id = g_prcs_id
         and sbfl_current = 'SQLMulti';         
         
      select sbfl_id
        into g_sbfl_expression
        from flow_subflows
       where sbfl_prcs_id = g_prcs_id
         and sbfl_current = 'Expression';         
         
      select sbfl_id
        into g_sbfl_funcbody
        from flow_subflows
       where sbfl_prcs_id = g_prcs_id
         and sbfl_current = 'FuncBody';         
      
      -- all running and ready for tests
   end set_up_process;
   
   procedure tear_down_process
   is
   begin
     flow_api_pkg.flow_delete (p_process_id => g_prcs_id);
   end tear_down_process;
   
   
   procedure var_exp_static
   is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
   begin
        l_sbfl_id := g_sbfl_static;
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test VC2
        open l_expected for
            select
                'StaticVC2' as prov_var_name,
                'StaticVC2' as prov_var_vc2
            from dual;
         
        open l_actual for
            select prov_var_name, prov_var_vc2
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'VARCHAR2'
            and prov_var_name = 'StaticVC2'
            and prov_var_num   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'StaticNumber2' as prov_var_name,
                '2' as prov_var_num
            from dual
            union
            select
                'StaticNumber2dec1' as prov_var_name,
                '2.1' as prov_var_num
            from dual;
         
        open l_actual for
            select prov_var_name, to_char(prov_var_num) as prov_var_num
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'NUMBER'
            and prov_var_name like 'Static%'
            and prov_var_vc2   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'StaticDate' as prov_var_name,
                '2021-08-15 15:16:17' as prov_var_date
            from dual;

         
        open l_actual for
            select prov_var_name, to_char(prov_var_date,'YYYY-MM-DD HH24:MI:SS') as prov_var_date
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'DATE'
            and prov_var_name = 'StaticDate'
            and prov_var_num   is null
            and prov_var_vc2 is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );      
      
      
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow to complete subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);      
      
    end var_exp_static;  
      
    procedure var_exp_procvar
   is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
   begin
        l_sbfl_id := g_sbfl_procvar;
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test VC2
        open l_expected for
            select
                'CopyStaticVC2' as prov_var_name,
                'StaticVC2' as prov_var_vc2
            from dual;
         
        open l_actual for
            select prov_var_name, prov_var_vc2
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'VARCHAR2'
            and prov_var_name = 'CopyStaticVC2'
            and prov_var_num   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'CopyStaticNumber2' as prov_var_name,
                '2' as prov_var_num
            from dual
            union
            select
                'CopyStaticNumber2dec1' as prov_var_name,
                '2.1' as prov_var_num
            from dual;
         
        open l_actual for
            select prov_var_name, to_char(prov_var_num) as prov_var_num
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'NUMBER'
            and prov_var_name like 'CopyStatic%'
            and prov_var_vc2   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'CopyStaticDate' as prov_var_name,
                '2021-08-15 15:16:17' as prov_var_date
            from dual;

         
        open l_actual for
            select prov_var_name, to_char(prov_var_date,'YYYY-MM-DD HH24:MI:SS') as prov_var_date
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'DATE'
            and prov_var_name = 'CopyStaticDate'
            and prov_var_num   is null
            and prov_var_vc2 is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );  
      
      
        -- set up CLOB to copy
        flow_process_vars.set_var
        ( pi_prcs_id => g_prcs_id
        , pi_var_name => 'StaticCLOB'
        , pi_clob_value => 'This is a very short CLOB'
        );
        
        
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow to complete subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
      
        
        -- test CLOB
        open l_expected for
            select
                'CopyStaticCLOB' as prov_var_name,
                to_clob('This is a very short CLOB') as prov_var_clob
            from dual;

         
        open l_actual for
            select prov_var_name, prov_var_clob
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'CLOB'
            and prov_var_name = 'CopyStaticCLOB'
            and prov_var_num   is null
            and prov_var_vc2 is null
            and prov_var_date is null;

      ut.expect( l_actual ).to_equal( l_expected );  
      
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow to complete subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
      
    end var_exp_procvar;  
      
    procedure var_exp_sqlsingle
    is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
    begin
        l_sbfl_id := g_sbfl_sqlsingle;
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test VC2
        open l_expected for
            select
                'SQLSingleVC2' as prov_var_name,
                'SingleVC2' as prov_var_vc2
            from dual;
         
        open l_actual for
            select prov_var_name, prov_var_vc2
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'VARCHAR2'
            and prov_var_name = 'SQLSingleVC2'
            and prov_var_num   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'SQLSingleNumber' as prov_var_name,
                '1000' as prov_var_num
            from dual;
         
        open l_actual for
            select prov_var_name, to_char(prov_var_num) as prov_var_num
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'NUMBER'
            and prov_var_name = 'SQLSingleNumber'
            and prov_var_vc2   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'SQLSingleDate' as prov_var_name,
                '2022-01-01' as prov_var_date
            from dual;

         
        open l_actual for
            select prov_var_name, to_char(prov_var_date,'YYYY-MM-DD') as prov_var_date
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'DATE'
            and prov_var_name = 'SQLSingleDate'
            and prov_var_num   is null
            and prov_var_vc2 is null
            and prov_var_clob is null;

        ut.expect( l_actual ).to_equal( l_expected );   
      
      
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow to complete subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);      
      
    end var_exp_sqlsingle;  
    
    procedure var_exp_sqlmulti
    is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
    begin
        l_sbfl_id := g_sbfl_sqlmulti;
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test VC2
        open l_expected for
            select
                'SQLMultiVC2' as prov_var_name,
                'value1:value2:value3' as prov_var_vc2
            from dual;
         
        open l_actual for
            select prov_var_name, prov_var_vc2
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'VARCHAR2'
            and prov_var_name = 'SQLMultiVC2'
            and prov_var_num   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow to completion
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
    end  var_exp_sqlmulti;
    
    
    procedure var_exp_expression
    is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
    begin
        l_sbfl_id := g_sbfl_expression;
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test VC2
        open l_expected for
            select
                'ExpressionVC2' as prov_var_name,
                'KING is UPPERCASE' as prov_var_vc2
            from dual;
         
        open l_actual for
            select prov_var_name, prov_var_vc2
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'VARCHAR2'
            and prov_var_name = 'ExpressionVC2'
            and prov_var_num   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'ExpressionNumber' as prov_var_name,
                '42' as prov_var_num
            from dual;
         
        open l_actual for
            select prov_var_name, to_char(prov_var_num) as prov_var_num
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'NUMBER'
            and prov_var_name = 'ExpressionNumber'
            and prov_var_vc2   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'ExpressionDate' as prov_var_name,
                '2022-04-01 14:00:00' as prov_var_date
            from dual;

         
        open l_actual for
            select prov_var_name, to_char(prov_var_date,'YYYY-MM-DD HH24:MI:SS') as prov_var_date
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'DATE'
            and prov_var_name = 'ExpressionDate'
            and prov_var_num   is null
            and prov_var_vc2 is null
            and prov_var_clob is null;

        ut.expect( l_actual ).to_equal( l_expected );   
      
      
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow to complete subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);      
      
    end var_exp_expression;  


    procedure var_exp_funcbody
    is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
    begin
        l_sbfl_id := g_sbfl_funcbody;
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test VC2
        open l_expected for
            select
                'FuncBodyVC2' as prov_var_name,
                'September' as prov_var_vc2
            from dual;
         
        open l_actual for
            select prov_var_name, prov_var_vc2
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'VARCHAR2'
            and prov_var_name = 'FuncBodyVC2'
            and prov_var_num   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'FuncBodyNumber' as prov_var_name,
                '226.8' as prov_var_num
            from dual;
         
        open l_actual for
            select prov_var_name, to_char(prov_var_num) as prov_var_num
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'NUMBER'
            and prov_var_name = 'FuncBodyNumber'
            and prov_var_vc2   is null
            and prov_var_date is null
            and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);
        
        -- test Num
        open l_expected for
            select
                'FuncBodyDate' as prov_var_name,
                '2022-04-01 14:00:00' as prov_var_date
            from dual;

         
        open l_actual for
            select prov_var_name, to_char(prov_var_date,'YYYY-MM-DD HH24:MI:SS') as prov_var_date
            from flow_process_variables
            where prov_prcs_id = g_prcs_id
            and prov_var_type = 'DATE'
            and prov_var_name = 'FuncBodyDate'
            and prov_var_num   is null
            and prov_var_vc2 is null
            and prov_var_clob is null;

        ut.expect( l_actual ).to_equal( l_expected );   
      
      
        -- get step key
        select sbfl_step_key
        into l_step_key
        from flow_subflows
        where sbfl_id = l_sbfl_id;
        --step forward on subflow to complete subflow
        flow_api_pkg.flow_complete_step
        ( p_process_id => g_prcs_id
        , p_subflow_id => l_sbfl_id
        , p_step_key => l_step_key);      
      
    end var_exp_funcbody;  
    
    procedure var_exp_process_completed
    is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;    
    begin
        -- if all of the tests have completed correctly, the process should also have completed.
        -- final test is to check that all subflows, and hence the process, completed correctly.
        open l_expected for
            select
            g_dgrm_id                                       as prcs_dgrm_id,
            'test - var_exp_all_types'                      as prcs_name,
            flow_constants_pkg.gc_prcs_status_completed     as prcs_status
            from dual;

        open l_actual for
            select prcs_dgrm_id, prcs_name, prcs_status 
              from flow_processes p
             where p.prcs_id = g_prcs_id;

        ut.expect( l_actual ).to_equal( l_expected );
      
    end var_exp_process_completed;

end test_variable_expressions;