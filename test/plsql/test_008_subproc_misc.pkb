create or replace package body test_008_subproc_misc as
/* 
-- Flows for APEX - test_008_subproc_misc.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 15-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 8a-c

  -- suite(08 SubProcesses Misc)
  -- rollback(manual)
  g_model_a08a constant varchar2(100) := 'A08a - SubProc - No Start';
  g_model_a08b constant varchar2(100) := 'A08b - SubProc - Two Starts';
  g_model_a08c constant varchar2(100) := 'A08c - SubProc - Two Int Timer BEs';
  g_model_a08d constant varchar2(100) := 'A08d - SubProc - Two Int Error BEs';
  g_model_a08e constant varchar2(100) := 'A08e - SubProc - Two Int Esc BEs';
  g_model_a08f constant varchar2(100) := 'A08f - SubProc - Int plus Non Int Esc BEs';
  g_model_a08g constant varchar2(100) := 'A08g - SubProc - Int Timer with nested SubProc';

  g_test_prcs_name_a  constant varchar2(100) := 'test - engine misc a';
  g_test_prcs_name_b  constant varchar2(100) := 'test - engine misc b';
  g_test_prcs_name_c  constant varchar2(100) := 'test - engine misc c';
  g_test_prcs_name_d  constant varchar2(100) := 'test - engine misc d';
  g_test_prcs_name_e  constant varchar2(100) := 'test - engine misc e';
  g_test_prcs_name_f  constant varchar2(100) := 'test - engine misc f';
  g_test_prcs_name_g  constant varchar2(100) := 'test - engine misc g';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a08a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a08b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a08c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a08d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a08e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a08f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a08g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
    -- get dgrm_ids to use for comparison
    g_dgrm_a08a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a08a );
    g_dgrm_a08b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a08b );
    g_dgrm_a08c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a08c );
    g_dgrm_a08d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a08d );
    g_dgrm_a08e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a08e );
    g_dgrm_a08f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a08f );
    g_dgrm_a08g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a08g ); 

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a08a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a08b_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a08c_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a08d_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a08e_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a08f_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a08g_id);

  end set_up_tests; 

  -- test(A - SubProcess with No Start Event)
  procedure subproc_no_start
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a08a_id;
    l_prcs_name  := g_test_prcs_name_a;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_a := l_prcs_id;

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
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step process forward into sub process with its error
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');   

    -- test for process being in error state
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_error   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

  end subproc_no_start;

  -- test(B - SubProcess with 2 Start Event)
  procedure subproc_two_starts
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a08b_id;
    l_prcs_name  := g_test_prcs_name_b;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_b := l_prcs_id;

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
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step process forward into sub process with its error
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

    -- check process status - should be error
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_error     as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 


  end subproc_two_starts;

  -- test(C - Subprocess with 2 Boundary Events)
  procedure subproc_two_int_timer_BEs
      is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a08c_id;
    l_prcs_name  := g_test_prcs_name_c;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_c := l_prcs_id;

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
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward into subprocess and expect error
    
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

    -- check error status
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_error   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end subproc_two_int_timer_BEs;

  -- test(D - Subprocess with 2 Error Boundary Events)
  procedure subproc_two_error_BEs
      is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a08d_id;
    l_prcs_name  := g_test_prcs_name_d;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_d := l_prcs_id;

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
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward into subprocess - should be OK
    
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

    -- check still running status

    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

    -- step forward to error end - should trigger an error

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_B1');  

    -- check error status
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_error   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end subproc_two_error_BEs;

  -- test(E - Subprocess with 2 Int Escalation Boundary Events)
  procedure subproc_two_int_esc_BEs
      is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a08e_id;
    l_prcs_name  := g_test_prcs_name_e;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_e := l_prcs_id;

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
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward into subprocess - should be OK
    
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

    -- check still running status

    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

    -- step forward to error end - should trigger an error

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_B1');  

    -- check error status
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_error   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end subproc_two_int_esc_BEs;

  -- test(F - Subprocess with NonInt and Int Esc Boundary Events)
  procedure subproc_int_plus_non_int_esc_BEs
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a08f_id;
    l_prcs_name  := g_test_prcs_name_f;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_f := l_prcs_id;

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
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward into subprocess - should be OK
    
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

    -- check still running status

    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

    -- step forward to error end - should trigger an error

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_B1');  

    -- check error status
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_error   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end subproc_int_plus_non_int_esc_BEs;

  procedure subproc_int_timer_fires_nested_subproc 
      is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a08g_id;
    l_prcs_name  := g_test_prcs_name_g;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_g := l_prcs_id;

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
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward into subprocess - should be OK
    
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

    -- check still running status

    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

    -- wait 16 sec for timer to fire (5 sec + 10 sec timer cycle +1)

    dbms_session.sleep(16);

    -- check error status
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

    -- check on correct subflow

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AfterTimer1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;


  end subproc_int_timer_fires_nested_subproc;

  -- afterall
  procedure tear_down_tests  
  is
  begin
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 008');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,  p_comment  => 'Ran by utPLSQL as Test Suite 008');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,  p_comment  => 'Ran by utPLSQL as Test Suite 008');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,  p_comment  => 'Ran by utPLSQL as Test Suite 008');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,  p_comment  => 'Ran by utPLSQL as Test Suite 008');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,  p_comment  => 'Ran by utPLSQL as Test Suite 008');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,  p_comment  => 'Ran by utPLSQL as Test Suite 008');

    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_008_subproc_misc;