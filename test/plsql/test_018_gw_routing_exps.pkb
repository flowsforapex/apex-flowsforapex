create or replace package body test_018_gw_routing_exps as
/* 
-- Flows for APEX - test_018_gw_routing_exps.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 12-Aug-2022   Richard Allen - Oracle
--
*/

  -- uses models 18a,b
  g_model_a18a constant varchar2(100) := 'A18a - GW Routing Exps - basic exprs';
  g_model_a18b constant varchar2(100) := 'A18b - GW Routing Exps - basic func bodies';
  g_model_a18c constant varchar2(100) := 'A18c - Inclusive GW AB C is Def no Condition';
  g_model_a18d constant varchar2(100) := 'A18d - Inclusive GW AB C is Def has Condition';
  g_model_a18e constant varchar2(100) := 'A18e - Inclusive GW AB C no Condition no def';
  g_model_a18f constant varchar2(100) := 'A18f - Inclusive GW ABC Condition no Def';
  g_model_a18g constant varchar2(100) := 'A18g - Inclusive GW ABC No Conds No Def';
  g_model_a18h constant varchar2(100) := 'A18h - Exclusive GW AB Cond C no Cond no def';
  g_model_a18i constant varchar2(100) := 'A18i - Exclusive GW AB C def has cond';
  g_model_a18j constant varchar2(100) := 'A18j - Exclusive GW AB C no cond no def';
  g_model_a18k constant varchar2(100) := 'A18k - Exclusive GW ABC Conds No def';
  g_model_a18l constant varchar2(100) := 'A18l - Exclusive GW ABC No Conds No Def';


  g_test_prcs_name constant varchar2(100) := 'test - GW Routing Expressions';

  g_prcs_id_a      flow_processes.prcs_id%type;
  g_prcs_id_b      flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a18a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18g_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18h_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18i_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18j_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18k_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18l_id  flow_diagrams.dgrm_id%type;


  procedure set_up_tests
  is 
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_a;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a18a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18a );
    g_dgrm_a18b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18b );
    g_dgrm_a18c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18c );
    g_dgrm_a18d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18d );
    g_dgrm_a18e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18e );
    g_dgrm_a18f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18f );
    g_dgrm_a18g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18g );
    g_dgrm_a18h_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18h );
    g_dgrm_a18i_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18i );
    g_dgrm_a18j_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18j );
    g_dgrm_a18k_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18k );
    g_dgrm_a18l_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a18l );
    test_dgrm_id := g_dgrm_a18a_id;

    -- create a new instance
    g_prcs_id_a := flow_api_pkg.flow_create(
       pi_dgrm_id   => test_dgrm_id
     , pi_prcs_name => g_test_prcs_name
    );
    test_prcs_id := g_prcs_id_a;

    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => g_prcs_id_a );

    open l_expected for
        select
        test_dgrm_id                               as prcs_dgrm_id,
        test_prcs_name                             as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st subflow running
   
      open l_expected for
         select
            test_prcs_id           as sbfl_prcs_id,
            test_dgrm_id           as sbfl_dgrm_id,
            'Activity_PreA'        as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

  end set_up_tests;

  --test(A1 - Expressions - Basic Logic)
  procedure exps_basic
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_a;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA');      

    -- check which paths were selected.. should be 1, 3 and 4
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskA1'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskA3'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual   
          union
          select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskA4'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskA1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskA3');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskA4');     

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreB'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

  end exps_basic;

  --test(A2 - Expressions - Substitutions)
  procedure exps_subs
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_a;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB');      

    -- check which paths were selected.. should be 1, 3 .  2 should fail.  4 and 5 fail as numbers and dates can't be substituted
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskB1'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskB3'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskB1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskB3');         

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreC'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;
  end exps_subs;

  --test(A3 - Expressions - Binds)
  procedure exps_binds 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_a;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreC');      

    -- check which paths were selected.. should be 1, 3, 4 and 5 .  2 should fail.
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC1'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC3'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC4'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual  
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC5'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual           
          ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC3');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC4');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC5');         

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreD'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;
  end exps_binds;

  --test(A4 - Expressions - Mixed Binds and Substitutions)
  procedure exps_mixed
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_a;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreD');      

    -- check which paths were selected.. should be 1, 3, 4 and 5 .  2 should fail.
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD1'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD3'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD4'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual  
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD5'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual           
          ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD3');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD4');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD5');         

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_AfterD'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;
  end exps_mixed;

  --test(A5 - Expressions - Completed)
  procedure exps_complete  
    is
      test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18a_id;
      test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_a;
      test_sbfl_id  flow_subflows.sbfl_id%type;
      test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;    
    begin
        test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_AfterD');     
        -- if all of the tests have completed correctly, the process should also have completed.
        -- final test is to check that all subflows, and hence the process, completed correctly.
        open l_expected for
            select
            test_dgrm_id                                  as prcs_dgrm_id,
            test_prcs_name                                as prcs_name,
            flow_constants_pkg.gc_prcs_status_completed     as prcs_status
            from dual;

        open l_actual for
            select prcs_dgrm_id, prcs_name, prcs_status 
              from flow_processes p
             where p.prcs_id = test_prcs_id;

        ut.expect( l_actual ).to_equal( l_expected );
  end exps_complete;

  --test(B1 - Function Bodies - Basic Logic)
  procedure func_bodies_basic  
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18b_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_b;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      test_dgrm_id := g_dgrm_a18b_id;

    -- create a new instance
    g_prcs_id_b := flow_api_pkg.flow_create(
       pi_dgrm_id   => test_dgrm_id
     , pi_prcs_name => g_test_prcs_name
    );
    test_prcs_id := g_prcs_id_b;

    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                               as prcs_dgrm_id,
        test_prcs_name                             as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st subflow running
   
      open l_expected for
         select
            test_prcs_id           as sbfl_prcs_id,
            test_dgrm_id           as sbfl_dgrm_id,
            'Activity_PreA'        as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA');      

    -- check which paths were selected.. should be 1, 3 and 4
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskA1'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskA3'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual   
          union
          select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskA4'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskA1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskA3');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskA4');     

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreB'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

  end func_bodies_basic ;

  --test(B2 - Function Bodies - Substitutions)
  procedure func_bodies_subs  
 is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18b_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_b;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB');      

    -- check which paths were selected.. should be 1, 3 .  2 should fail.  4 and 5 fail as numbers and dates can't be substituted
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskB1'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskB3'            as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskB1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskB3');         

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreC'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;
  end func_bodies_subs;

  --test(B3 - Expressions - Binds)
  procedure func_bodies_binds 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18b_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_b;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreC');      

    -- check which paths were selected.. should be 1, 3, 4 and 5 .  2 should fail.
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC1'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC3'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC4'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual  
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskC5'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual           
          ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC3');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC4');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskC5');         

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreD'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;
  end func_bodies_binds;

  --test(B4 - Expressions - Mixed Binds and Substitutions)
  procedure func_bodies_mixed
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18b_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_b;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreD');      

    -- check which paths were selected.. should be 1, 3, 4 and 5 .  2 should fail.
    -- first check no errors...

    open l_expected for
        select
        test_dgrm_id                              as prcs_dgrm_id,
        test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD1'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD3'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual     
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD4'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual  
         union
         select
            test_prcs_id        as sbfl_prcs_id,
            test_dgrm_id        as sbfl_dgrm_id,
            'Activity_TaskD5'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual           
          ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- move tasks forward to gateway

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD1');     
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD3');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD4');         
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskD5');         

    -- check process running state

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'Activity_AfterD'   as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;
  end func_bodies_mixed;

  --test(B5 - Expressions - Completed)
  procedure func_bodies_complete  
    is
      test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a18b_id;
      test_prcs_id  flow_processes.prcs_id%type := g_prcs_id_b;
      test_sbfl_id  flow_subflows.sbfl_id%type;
      test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;    
    begin
        test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_AfterD');     
        -- if all of the tests have completed correctly, the process should also have completed.
        -- final test is to check that all subflows, and hence the process, completed correctly.
        open l_expected for
            select
            test_dgrm_id                                  as prcs_dgrm_id,
            test_prcs_name                                as prcs_name,
            flow_constants_pkg.gc_prcs_status_completed     as prcs_status
            from dual;

        open l_actual for
            select prcs_dgrm_id, prcs_name, prcs_status 
              from flow_processes p
             where p.prcs_id = test_prcs_id;

        ut.expect( l_actual ).to_equal( l_expected );
  end func_bodies_complete;

  procedure IncGWTestRunner
  ( p_dgrm_id           flow_diagrams.dgrm_id%type
  , p_myVar_exists      boolean
  , p_myVar_value       varchar2 default null
  , p_expected_paths    varchar2 default null
  , p_error_expected    boolean
  )
  is
    l_actual            sys_refcursor;
    l_expected          sys_refcursor;
    l_actual_vc2        varchar2(200);
    l_actual_number     number;
    l_result_set_vc2    apex_t_varchar2;
    l_result            flow_process_variables.prov_var_vc2%type;
    test_dgrm_id        flow_diagrams.dgrm_id%type := p_dgrm_id;
    test_prcs_id        flow_processes.prcs_id%type;
    test_sbfl_id_main   flow_subflows.sbfl_id%type;
    test_prcs_name      flow_processes.prcs_name%type := g_test_prcs_name;  
  begin
    -- create new process
    test_prcs_id := flow_api_pkg.flow_create 
                     ( pi_dgrm_id   => test_dgrm_id
                     , pi_prcs_name => test_prcs_name
                     );

    -- start process

    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    -- check process and subflow are running
    open l_expected for
        select
        test_dgrm_id                               as prcs_dgrm_id,
        test_prcs_name                             as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st subflow running
   
    open l_expected for
       select
          test_prcs_id           as sbfl_prcs_id,
          test_dgrm_id           as sbfl_dgrm_id,
          'Activity_Pre'        as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running as sbfl_status
       from dual    
       ; 
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = test_prcs_id
       and sbfl_status not like 'split'; 
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- set myVar

    if p_myVar_exists then
      -- set myVar
      flow_process_vars.set_var
      ( pi_prcs_id   => test_prcs_id
      , pi_var_name  => 'myVar'
      , pi_vc2_value => p_myVar_value
      , pi_scope     => 0
      );
    end if;

    -- step forward into Inc GW

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_Pre');    

    if not p_error_expected then

      -- check which paths were chosen
      select sbfl_current
      bulk collect into  l_result_set_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
         and sbfl_status  = flow_constants_pkg.gc_sbfl_status_running
       order by sbfl_current
      ;   
      -- create delimited string output
      l_result := apex_string.join
        ( p_table => l_result_set_vc2
        , p_sep => ':'
        );
      ut.expect (l_result).to_equal(p_expected_paths);

    else

      -- error expected
      -- check process is in error status
      select prcs_status 
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;

      ut.expect( l_actual_vc2 ).to_equal( flow_constants_pkg.gc_prcs_status_error );

      -- check subflow is in error status
      select sbfl_current||':'||sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
       ;

      ut.expect( l_actual_vc2 ).to_equal( 'Gateway_Split:'||flow_constants_pkg.gc_sbfl_status_error );

      -- Note: this will give a too_many_rows error if the code fails to error on the Gateway!


    end if;
    -- delete process

    flow_api_pkg.flow_delete ( p_process_id => test_prcs_id);

    ut.expect (v('APP_SESSION')).to_be_null;

  end IncGWTestRunner; 





   --  test(C1 - Inc GW - Unconditional Default ABC - Case A)
   --
  procedure IncGWUnCondDefA
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18c_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     );
  end IncGWUnCondDefA;
  
   --  test(C2 - Inc GW - Unconditional Default ABC - Case B)
   --
  procedure IncGWUnCondDefB
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18c_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => 'Activity_B'
                     , p_error_expected   => false
                     );  
  end IncGWUnCondDefB;
  
   --  test(C3 - Inc GW - Unconditional Default ABC - Case D)
   --
  procedure IncGWUnCondDefD
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18c_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );  
  end IncGWUnCondDefD;
  
   --  test(C4 - Inc GW - Unconditional Default ABC - null case)
   --
  procedure IncGWUnCondDefNull
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18c_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => ''
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );  
  end IncGWUnCondDefNull;
  
   --  test(C5 - Inc GW - Unconditional Default ABC - missing case)
   --
  procedure IncGWUnCondDefMissing
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18c_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );  
  end IncGWUnCondDefMissing;
  

   --  test(D1 - Inc GW - Conditional Default ABC - Case A)
   --
  procedure IncGWCondDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18d_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     );  
  end;
  
   --  test(D2 - Inc GW - Conditional Default ABC - Case B)
   --
  procedure IncGWCondDefB
  is
  begin
    IncGWTestRunner  ( p_dgrm_id          => g_dgrm_a18d_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => 'Activity_B'
                     , p_error_expected   => false
                     );    
  end;
  
   --  test(D3 - Inc GW - Conditional Default ABC - Case C)
   --
  procedure IncGWCondDefC
  is
  begin
    IncGWTestRunner  ( p_dgrm_id          => g_dgrm_a18d_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'C'
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     ); 
  end;
  
   --  test(D4 - Inc GW - Conditional Default ABC - null case)
   --
  procedure IncGWCondDefNull
  is
  begin
    IncGWTestRunner  ( p_dgrm_id          => g_dgrm_a18d_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => ''
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     ); 
  end;
  
   --  test(D5 - Inc GW - Conditional Default ABC - missing case)
   --
  procedure IncGWCondDefMissing
  is
  begin
     IncGWTestRunner ( p_dgrm_id          => g_dgrm_a18d_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     ); 
  end;
  
   --  test(D6 - Inc GW - Conditional Default ABC - Case AC)
   --
  procedure IncGWCondDefAC
  is
  begin
     IncGWTestRunner ( p_dgrm_id          => g_dgrm_a18d_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'AC'
                     , p_expected_paths   => 'Activity_A:Activity_C'
                     , p_error_expected   => false
                     );   
  end;
  
   --  test(D7 - Inc GW - Conditional Default ABC - Case D)
   --
  procedure IncGWCondDefD
  is
  begin
     IncGWTestRunner ( p_dgrm_id          => g_dgrm_a18d_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );   
  end;
  

   --  test(E1 - Inc GW - No Default ABC C Uncond - Case A)
   --
  procedure IncGWNoDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18e_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(E2 - Inc GW - No Default ABC C Uncond - Case B)
   --
  procedure IncGWNoDefB
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18e_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(E3 - Inc GW - No Default ABC C Uncond - Case D)
   --
  procedure IncGWNoDefD
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18e_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(E4 - Inc GW - No Default ABC C Uncond - null case)
   --
  procedure IncGWNoDefNull
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18e_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => ''
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(E5 - Inc GW - No Default ABC C Uncond - missing case)
   --
  procedure IncGWNoDefABC
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18e_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  

  --%test(F1 - Inc GW - Conds ABC No Def - Case A)
  procedure IncGWAllCondCDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18f_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     ); 
  end;
  
  --%test(F2 - Inc GW - Conds ABC No Def - Case B)
  procedure IncGWAllCondCDefB
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18f_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => 'Activity_B'
                     , p_error_expected   => false
                     ); 
  end;

  --%test(F3 - Inc GW - Conds ABC No Def - Case D)
  procedure IncGWAllCondCDefD
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18f_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(F4 - Inc GW - Conds ABC No Def - null case)
  procedure IncGWAllCondCDefNull
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18f_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => ''
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(F5 - Inc GW - Conds ABC No Def - missing case)
  procedure IncGWAllCondCDefMissing
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18f_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(F6 - Inc GW - Conds ABC No Def - Case ABC)
  procedure IncGWAllCondCDefABC
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18f_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'ABC'
                     , p_expected_paths   => 'Activity_A:Activity_B:Activity_C'
                     , p_error_expected   => false
                     ); 
  end;
  
  --%test(G1 - Inc GW - No Conds ABC No Def - Case null)
  procedure IncGWNoCondNoDefNull
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18g_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => ''
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
  --%test(G2 - Inc GW - No Conds ABC No Def - Case A)
  procedure IncGWNoCondNoDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18g_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(G3 - Inc GW - No Conds ABC No Def - Case missing)
  procedure IncGWNoCondNoDefmissing
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18g_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;


   --  test(H1 - Exc GW - Unconditional Default ABC - Case A)
   --
  procedure ExcGWUnCondDefA
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18h_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     );
  end ExcGWUnCondDefA;
  
   --  test(H2 - Exc GW - Unconditional Default ABC - Case B)
   --
  procedure ExcGWUnCondDefB
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18h_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => 'Activity_B'
                     , p_error_expected   => false
                     );  
  end ExcGWUnCondDefB;
  
   --  test(H3 - Exc GW - Unconditional Default ABC - Case D)
   --
  procedure ExcGWUnCondDefD
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18h_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );  
  end ExcGWUnCondDefD;
  
   --  test(H4 - Exc GW - Unconditional Default ABC - null case)
   --
  procedure ExcGWUnCondDefNull
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18h_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => ''
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );  
  end ExcGWUnCondDefNull;
  
   --  test(H5 - Exc GW - Unconditional Default ABC - missing case)
   --
  procedure ExcGWUnCondDefMissing
  is
  begin
    IncGWTestRunner   ( p_dgrm_id         => g_dgrm_a18h_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );  
  end ExcGWUnCondDefMissing;

   --  test(I1 - Excl GW - Conditional Default ABC - Case A)
   --
  procedure ExcGWCondDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18i_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     );  
  end;
  
   --  test(I2 - Excl GW - Conditional Default ABC - Case B)
   --
  procedure ExcGWCondDefB
  is
  begin
    IncGWTestRunner  ( p_dgrm_id          => g_dgrm_a18i_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => 'Activity_B'
                     , p_error_expected   => false
                     );    
  end;
  
   --  test(I3 - Excl GW - Conditional Default ABC - Case C)
   --
  procedure ExcGWCondDefC
  is
  begin
    IncGWTestRunner  ( p_dgrm_id          => g_dgrm_a18i_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'C'
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     ); 
  end;
  
   --  test(I4 - Excl GW - Conditional Default ABC - null case)
   --
  procedure ExcGWCondDefNull
  is
  begin
    IncGWTestRunner  ( p_dgrm_id          => g_dgrm_a18i_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => ''
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     ); 
  end;
  
   --  test(I5 - Excl GW - Conditional Default ABC - missing case)
   --
  procedure ExcGWCondDefMissing
  is
  begin
     IncGWTestRunner ( p_dgrm_id          => g_dgrm_a18i_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     ); 
  end;
  
   --  test(I6 - Excl GW - Conditional Default ABC - Case AC)
   --
  procedure ExcGWCondDefAC
  is
  begin
     IncGWTestRunner ( p_dgrm_id          => g_dgrm_a18i_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'AC'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     );   
  end;
  
   --  test(I7 - Excl GW - Conditional Default ABC - Case D)
   --
  procedure ExcGWCondDefD
  is
  begin
     IncGWTestRunner ( p_dgrm_id          => g_dgrm_a18i_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => 'Activity_C'
                     , p_error_expected   => false
                     );   
  end;
  

   --  test(J1 - Excl GW - No Default ABC C Uncond - Case A)
   --
  procedure ExcGWNoDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18j_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(J2 - Excl GW - No Default ABC C Uncond - Case B)
   --
  procedure ExcGWNoDefB
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18j_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(J3 - Excl GW - No Default ABC C Uncond - Case D)
   --
  procedure ExcGWNoDefD
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18j_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(J4 - Excl GW - No Default ABC C Uncond - null case)
   --
  procedure ExcGWNoDefNull
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18j_id
                     , p_myVar_exists     => True
                     , p_myVar_value      => ''
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
   --  test(J5 - Excl GW - No Default ABC C Uncond - missing case)
   --
  procedure ExcGWNoDefABC
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18j_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  

  --%test(K1 - Excl GW - Conds ABC No Def - Case A)
  procedure ExcGWAllCondCDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18k_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     ); 
  end;
  
  --%test(K2 - Excl GW - Conds ABC No Def - Case B)
  procedure ExcGWAllCondCDefB
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18k_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'B'
                     , p_expected_paths   => 'Activity_B'
                     , p_error_expected   => false
                     ); 
  end;

  --%test(K3 - Excl GW - Conds ABC No Def - Case D)
  procedure ExcGWAllCondCDefD
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18k_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'D'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(K4 - Excl GW - Conds ABC No Def - null case)
  procedure ExcGWAllCondCDefNull
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18k_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => ''
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(K5 - Excl GW - Conds ABC No Def - missing case)
  procedure ExcGWAllCondCDefMissing
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18k_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(K6 - Excl GW - Conds ABC No Def - Case ABC)
  procedure ExcGWAllCondCDefABC
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18k_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'ABC'
                     , p_expected_paths   => 'Activity_A'
                     , p_error_expected   => false
                     ); 
  end;
  
  
  --%test(L1 - Excl GW - No Conds ABC No Def - Case null)
  procedure ExcGWNoCondNoDefNull
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18l_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => ''
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;
  
  --%test(L2 - Excl GW - No Conds ABC No Def - Case A)
  procedure ExcGWNoCondNoDefA
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18l_id
                     , p_myVar_exists     => true
                     , p_myVar_value      => 'A'
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  --%test(L3 - Excl GW - No Conds ABC No Def - Case missing)
  procedure ExcGWNoCondNoDefmissing
  is
  begin
   IncGWTestRunner   ( p_dgrm_id          => g_dgrm_a18l_id
                     , p_myVar_exists     => false
                     , p_myVar_value      => null
                     , p_expected_paths   => null
                     , p_error_expected   => true
                     ); 
  end;

  

  --afterall
  procedure tear_down_tests  
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,
                             p_comment  => 'Ran by utPLSQL as Test Suite 017');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,
                             p_comment  => 'Ran by utPLSQL as Test Suite 017');                             

    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_018_gw_routing_exps;