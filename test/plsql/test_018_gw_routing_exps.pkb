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


  g_test_prcs_name constant varchar2(100) := 'test - GW Routing Expressions';

  g_prcs_id_a      flow_processes.prcs_id%type;
  g_prcs_id_b      flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a18a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a18b_id  flow_diagrams.dgrm_id%type;


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