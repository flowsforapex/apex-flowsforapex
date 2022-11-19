create or replace package body test_004_proc_vars is
/* 
-- Flows for APEX - test_004_proc_varss.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 08-Aug-2022   Richard Allen - Oracle
--
*/

  -- uses models 004
  g_model_a04a constant varchar2(100) := 'A04a - Basic Model';

  g_test_prcs_name constant varchar2(100) := 'test004 - Process Variables';

  g_prcs_id_1       flow_processes.prcs_id%type;
  g_prcs_id_2       flow_processes.prcs_id%type;
  g_prcs_id_3       flow_processes.prcs_id%type;
  g_prcs_id_4       flow_processes.prcs_id%type;
  g_prcs_id_5       flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a04a_id  flow_diagrams.dgrm_id%type;

  --beforeall
  procedure set_up_tests
  is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
  begin

    -- get dgrm_ids to use for comparison
    g_dgrm_a04a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a04a );
    g_prcs_dgrm_id := g_dgrm_a04a_id;

    -- all running and ready for tests 

  end set_up_tests;


   procedure basic_flow_variables
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_vc2_var_name varchar2(10) := 'vc2_var';
      l_num_var_name varchar2(10) := 'num_var';
      l_date_var_name varchar2(10) := 'date_var';
      l_clob_var_name varchar2(10) := 'clob_var';
      l_ts_var_name   varchar2(10)   := 'ts_var';
      l_expected_vc2  varchar2(4000) := 'TEST';
      l_expected_num  number := 1000;
      l_expected_date date := to_date('01/01/2022', 'DD/MM/YYYY');
      l_expected_ts   timestamp with time zone := to_timestamp_tz('01/01/2022 13:10:10 Pacific/Sydney',
                         'DD/MM/YYYY HH24:MI:SS TZR');
      l_expected_clob clob := to_clob('TEST');
      l_actual_vc2 varchar2(4000);
      l_actual_num number;
      l_actual_date date;
      l_actual_ts   timestamp with time zone;  
      l_actual_clob clob;
   
      l_rec flow_process_variables%rowtype;
   begin
    -- create a new instance
    g_prcs_id_1 := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_prcs_dgrm_id
     , pi_prcs_name => g_test_prcs_name
    );
    l_dgrm_id := g_dgrm_a04a_id;
    l_prcs_id := g_prcs_id_1;
    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );

    open l_expected for
        select
        g_prcs_dgrm_id                              as prcs_dgrm_id,
        g_test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            l_prcs_id           as sbfl_prcs_id,
            l_dgrm_id           as sbfl_dgrm_id,
            'A'                 as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- all running and ready for tests 

      open l_expected for
          select l_dgrm_id as prcs_dgrm_id
               , g_test_prcs_name as prcs_name
               , flow_constants_pkg.gc_prcs_status_running as prcs_status 
            from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      -- Set variables
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_vc2_var_name
         , pi_vc2_value   => l_expected_vc2
      );

      open l_expected for
         select 
            l_vc2_var_name  as prov_var_name, 
            'VARCHAR2'      as prov_var_type, 
            l_expected_vc2  as prov_var_vc2
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_vc2
          from flow_process_variables
         where prov_prcs_id = l_prcs_id
           and prov_var_name = l_vc2_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected );

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_vc2_var_name;

      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_num ).to_be_null();
      ut.expect( l_rec.prov_var_date ).to_be_null();
      ut.expect( l_rec.prov_var_clob ).to_be_null(); 
      ut.expect( l_rec.prov_var_ts ).to_be_null(); 


      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_num_var_name
         , pi_num_value => l_expected_num 
      );

      open l_expected for
         select 
            l_num_var_name as prov_var_name, 
            'NUMBER' as prov_var_type, 
            l_expected_num as prov_var_num
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_num
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_num_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected ); 

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_num_var_name;
      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_vc2 ).to_be_null();
      ut.expect( l_rec.prov_var_date ).to_be_null();
      ut.expect( l_rec.prov_var_clob ).to_be_null();
      ut.expect( l_rec.prov_var_ts ).to_be_null(); 
 

      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_date_var_name
         , pi_date_value => l_expected_date 
      );

      open l_expected for
         select 
            l_date_var_name as prov_var_name, 
            'DATE' as prov_var_type, 
            l_expected_date as prov_var_date
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_date 
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_date_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected ); 

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_date_var_name;
      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_vc2 ).to_be_null();
      ut.expect( l_rec.prov_var_num ).to_be_null();
      ut.expect( l_rec.prov_var_clob ).to_be_null(); 
      ut.expect( l_rec.prov_var_ts ).to_be_null(); 


      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_clob_var_name
         , pi_clob_value => l_expected_clob 
      );

      open l_expected for
         select 
            l_clob_var_name as prov_var_name, 
            'CLOB' as prov_var_type, 
            l_expected_clob as prov_var_clob
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_clob 
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_clob_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected ); 

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_clob_var_name;
      fetch l_actual into l_rec; 

      ut.expect( l_rec.prov_var_vc2 ).to_be_null();
      ut.expect( l_rec.prov_var_num ).to_be_null();
      ut.expect( l_rec.prov_var_date ).to_be_null(); 
      ut.expect( l_rec.prov_var_ts ).to_be_null(); 


      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_ts_var_name
         , pi_ts_value => l_expected_ts
      );

      open l_expected for
         select 
            l_ts_var_name              as prov_var_name, 
            'TIMESTAMP WITH TIME ZONE' as prov_var_type, 
            l_expected_ts              as prov_var_ts
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_ts 
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_ts_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected ); 

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_date_var_name;
      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_vc2 ).to_be_null();
      ut.expect( l_rec.prov_var_num ).to_be_null();
      ut.expect( l_rec.prov_var_clob ).to_be_null(); 
      ut.expect( l_rec.prov_var_date ).to_be_null(); 

      -- Get variables
      l_actual_vc2 := flow_process_vars.get_var_vc2(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_vc2_var_name
      );

      ut.expect( l_actual_vc2 ).to_equal( l_expected_vc2 );

      l_actual_num := flow_process_vars.get_var_num(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_num_var_name
      );

      ut.expect( l_actual_num ).to_equal( l_expected_num );

      l_actual_date := flow_process_vars.get_var_date(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_date_var_name
      );

      ut.expect( l_actual_date ).to_equal( l_expected_date );

      l_actual_clob := flow_process_vars.get_var_clob(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_clob_var_name
      );

      ut.expect( l_actual_clob ).to_equal( l_expected_clob );

           flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_date_var_name
         , pi_ts_value => l_expected_ts 
      );

      l_actual_ts := flow_process_vars.get_var_ts(
           pi_prcs_id  => l_prcs_id
         , pi_var_name => l_ts_var_name
      );

      ut.expect( l_actual_ts ).to_equal( l_expected_ts );


   end basic_flow_variables;

   procedure var_case_sensitivity_vc2
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_vc2_var_name_lc varchar2(10) := 'vc2_var';
      l_vc2_var_name_uc varchar2(10) := 'VC2_VAR';
      l_vc2_var_name_mc varchar2(10) := 'Vc2_vaR';
      l_vc2_lc_val      varchar2(10) := 'lc';
      l_vc2_uc_val      varchar2(10) := 'mC';
      l_vc2_mc_val      varchar2(10) := 'UC';
      l_actual_vc2 varchar2(4000);
      l_actual_num number;
      l_actual_date date;
      l_actual_clob clob;
   
      l_rec flow_process_variables%rowtype;
   begin
    -- create a new instance
    g_prcs_id_2 := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_prcs_dgrm_id
     , pi_prcs_name => g_test_prcs_name
    );
    l_dgrm_id := g_dgrm_a04a_id;
    l_prcs_id := g_prcs_id_2;
    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );

    open l_expected for
        select
        g_prcs_dgrm_id                              as prcs_dgrm_id,
        g_test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            l_prcs_id           as sbfl_prcs_id,
            l_dgrm_id           as sbfl_dgrm_id,
            'A'                 as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      open l_expected for
          select l_dgrm_id as prcs_dgrm_id
               , g_test_prcs_name as prcs_name
               , flow_constants_pkg.gc_prcs_status_running as prcs_status 
            from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      -- check no existing process variables

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 0 );

      -- ready to start test

      -- Set variable originally to lower case value
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_vc2_var_name_lc
         , pi_vc2_value   => l_vc2_lc_val
      );

      -- check now exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_vc2_var_name_lc  as prov_var_name, 
            'VARCHAR2'         as prov_var_type, 
            l_vc2_lc_val       as prov_var_vc2
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_vc2
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

      -- existing var from test 1 is 'vc2_var'
      -- now attempt to set with mixed case - should reset the original var with new content, not create a new var
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_vc2_var_name_mc
         , pi_vc2_value   => l_vc2_mc_val
      );

      -- check now still exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_vc2_var_name_lc  as prov_var_name,  -- should keep original name
            'VARCHAR2'         as prov_var_type, 
            l_vc2_mc_val       as prov_var_vc2    -- but reset the value
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_vc2
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

      -- now attempt to set with upper case - should reset the original var with new content, not create a new var
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_vc2_var_name_uc
         , pi_vc2_value   => l_vc2_uc_val
      );

      -- check now still exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_vc2_var_name_lc  as prov_var_name,  -- should keep original name
            'VARCHAR2'         as prov_var_type, 
            l_vc2_uc_val       as prov_var_vc2    -- but reset the value
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_vc2
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

   end var_case_sensitivity_vc2;

   procedure var_case_sensitivity_num
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_num_var_name_lc varchar2(10) := 'vc2_var';
      l_num_var_name_uc varchar2(10) := 'VC2_VAR';
      l_num_var_name_mc varchar2(10) := 'Vc2_vaR';
      l_num_lc_val      number := 10;
      l_num_uc_val      number := 20;
      l_num_mc_val      number := 30;
      l_actual_vc2 varchar2(4000);
      l_actual_num number;
      l_actual_date date;
      l_actual_clob clob;
   
      l_rec flow_process_variables%rowtype;
   begin
    -- create a new instance
    g_prcs_id_3 := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_prcs_dgrm_id
     , pi_prcs_name => g_test_prcs_name
    );
    l_dgrm_id := g_dgrm_a04a_id;
    l_prcs_id := g_prcs_id_3;
    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );

    open l_expected for
        select
        g_prcs_dgrm_id                              as prcs_dgrm_id,
        g_test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            l_prcs_id           as sbfl_prcs_id,
            l_dgrm_id           as sbfl_dgrm_id,
            'A'                 as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      open l_expected for
          select l_dgrm_id as prcs_dgrm_id
               , g_test_prcs_name as prcs_name
               , flow_constants_pkg.gc_prcs_status_running as prcs_status 
            from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      -- check no existing process variables

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 0 );

      -- ready to start test

      -- Set variable originally to lower case value
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_num_var_name_lc
         , pi_num_value   => l_num_lc_val
      );

      -- check now exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_num_var_name_lc  as prov_var_name, 
            'NUMBER'         as prov_var_type, 
            l_num_lc_val       as prov_var_num
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_num
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

      -- existing var from test 1 is 'vc2_var'
      -- now attempt to set with mixed case - should reset the original var with new content, not create a new var
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_num_var_name_mc
         , pi_num_value   => l_num_mc_val
      );

      -- check now still exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_num_var_name_lc  as prov_var_name,  -- should keep original name
            'NUMBER'         as prov_var_type, 
            l_num_mc_val       as prov_var_num    -- but reset the value
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_num
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

      -- now attempt to set with upper case - should reset the original var with new content, not create a new var
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_num_var_name_uc
         , pi_num_value   => l_num_uc_val
      );

      -- check now still exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_num_var_name_lc  as prov_var_name,  -- should keep original name
            'NUMBER'           as prov_var_type, 
            l_num_uc_val       as prov_var_num    -- but reset the value
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_num
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

   end var_case_sensitivity_num;


   procedure var_case_sensitivity_date
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_date_var_name_lc varchar2(10) := 'date_var';
      l_date_var_name_uc varchar2(10) := 'DATE_VAR';
      l_date_var_name_mc varchar2(10) := 'dAtE_vaR';
      l_date_lc_val      varchar2(20) := '01-JAN-2022';
      l_date_uc_val      varchar2(20) := '11-FEB-2022';
      l_date_mc_val      varchar2(20) := '22-MAR-2022';
      l_actual_vc2 varchar2(4000);
      l_actual_num number;
      l_actual_date date;
      l_actual_clob clob;
   
      l_rec flow_process_variables%rowtype;
   begin
    -- create a new instance
    g_prcs_id_4 := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_prcs_dgrm_id
     , pi_prcs_name => g_test_prcs_name
    );
    l_dgrm_id := g_dgrm_a04a_id;
    l_prcs_id := g_prcs_id_4;
    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );

    open l_expected for
        select
        g_prcs_dgrm_id                              as prcs_dgrm_id,
        g_test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            l_prcs_id           as sbfl_prcs_id,
            l_dgrm_id           as sbfl_dgrm_id,
            'A'                 as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      open l_expected for
          select l_dgrm_id as prcs_dgrm_id
               , g_test_prcs_name as prcs_name
               , flow_constants_pkg.gc_prcs_status_running as prcs_status 
            from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      -- check no existing process variables

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 0 );

      -- ready to start test

      -- Set variable originally to lower case value
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_date_var_name_lc
         , pi_date_value   => to_date(l_date_lc_val,'DD-MON-YYYY')
      );

      -- check now exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_date_var_name_lc                        as prov_var_name, 
            'DATE'                                    as prov_var_type, 
            to_date(l_date_lc_val,'DD-MON-YYYY')      as prov_var_date
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_date
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

      -- existing var from test 1 is 'vc2_var'
      -- now attempt to set with mixed case - should reset the original var with new content, not create a new var
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_date_var_name_mc
         , pi_date_value  => l_date_mc_val
      );

      -- check now still exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_date_var_name_lc                            as prov_var_name,  -- should keep original name
            'DATE'                                        as prov_var_type, 
            to_date( l_date_mc_val ,'DD-MON-YYYY')        as prov_var_date     -- but reset the value
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_date
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

      -- now attempt to set with upper case - should reset the original var with new content, not create a new var
      flow_process_vars.set_var(
           pi_prcs_id     => l_prcs_id
         , pi_var_name    => l_date_var_name_uc
         , pi_date_value  => l_date_uc_val
      );

      -- check now still exactly 1 process variable

      open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_have_count( 1 );

      open l_expected for
         select 
            l_date_var_name_lc                          as prov_var_name,  -- should keep original name
            'DATE'                                      as prov_var_type, 
            to_date(l_date_uc_val ,'DD-MON-YYYY')       as prov_var_date    -- but reset the value
         from dual;

      open l_actual for 
        select prov_var_name, prov_var_type, prov_var_date
          from flow_process_variables
         where prov_prcs_id = l_prcs_id;
   
      ut.expect( l_actual ).to_equal( l_expected );

   end var_case_sensitivity_date;

  -- afterall
  procedure tear_down_tests 
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_1,
                             p_comment  => 'Ran by utPLSQL as Test Suite 004');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_2,
                             p_comment  => 'Ran by utPLSQL as Test Suite 004');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_3,
                             p_comment  => 'Ran by utPLSQL as Test Suite 004');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_4,
                             p_comment  => 'Ran by utPLSQL as Test Suite 004');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_5,
                             p_comment  => 'Ran by utPLSQL as Test Suite 004');
    ut.expect( v('APP_SESSION')).to_be_null;
           
  end tear_down_tests;

end test_004_proc_vars;