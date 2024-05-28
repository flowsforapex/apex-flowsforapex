create or replace package body test_027_var_exp_errors
/* 
-- Flows for APEX - test_027_var_exp_errors.pkb
-- 
-- (c) Copyright Flowquest Consulting Limited and / or its affiliates, 2024.
--
-- Created 26-May-2024   Richard Allen - Flowquest Consulting Limited
--
*/
is 
  -- suite(27 Variable Expression Errors)
  -- tag
  -- rollback(manual)

  -- uses models 19a-g
  g_model_a27a constant varchar2(100) := 'A27a - Variable Expression Errors';

  g_test_prcs_name_a constant varchar2(100) := 'test 027 - variable expression errors a';
  g_test_prcs_name_b constant varchar2(100) := 'test 027 - variable expression errors b';
  g_test_prcs_name_c constant varchar2(100) := 'test 027 - variable expression errors c';
  g_test_prcs_name_d constant varchar2(100) := 'test 027 - variable expression errors d';
  g_test_prcs_name_e constant varchar2(100) := 'test 027 - variable expression errors e';
  g_test_prcs_name_f constant varchar2(100) := 'test 027 - variable expression errors f';
  g_test_prcs_name_g constant varchar2(100) := 'test 027 - variable expression errors g';
  g_test_prcs_name_h constant varchar2(100) := 'test 027 - variable expression errors h';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;
  g_prcs_id_h       flow_processes.prcs_id%type;

  g_dgrm_a27a_id  flow_diagrams.dgrm_id%type;

  -- beforeall
  procedure set_up_tests
  is
  begin
    -- get dgrm_ids to use for comparison
    g_dgrm_a27a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a27a );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a27a_id);
  end set_up_tests;

  -- test('1 - Bad Static Date Format')
  procedure bad_static_date
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre1';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_a;
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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );

  end bad_static_date;

  -- test('2 - Bad Static TSTZ Format')
  procedure bad_static_tstz
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre2';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_a;
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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end bad_static_tstz;

  -- test('3 - Bad Static Num Format')
  procedure bad_static_num
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre3';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_c;
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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end bad_static_num;

  -- test('4 - Bad Static JSON Format')
  procedure bad_static_json
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre4';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_d;
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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end bad_static_json;

  -- test('5 - Bad Single SQL')
  procedure bad_single_sql
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre5';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_e;
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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end bad_single_sql;

  -- test('6 - Bad Multi SQL')
  procedure bad_multi_sql
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre6';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_f;
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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end bad_multi_sql;

  -- test('7 - Bad PLSQL Expression')
  procedure bad_plsql_expression
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre7';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_g;
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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end bad_plsql_expression;

  -- test('8 - Bad PLSQL Function Body')
  procedure bad_plsql_func_body
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_name       flow_objects.objt_bpmn_id%type := 'Activity_pre8';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a27a_id;
    l_prcs_name   := g_test_prcs_name_h;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_h := l_prcs_id;

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

    -- step forward on relevant path 

    l_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id => l_prcs_id, pi_current => l_step_name); 
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => l_step_name);   

    -- check prcs error status   
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

    -- check subflow error status

    open l_expected for
        select
        flow_constants_pkg.gc_sbfl_status_error     as sbfl_status
        from dual;
    open l_actual for
        select sbfl_status 
          from flow_subflows s
         where s.sbfl_prcs_id = l_prcs_id
           and s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end bad_plsql_func_body;

  -- afterall
  procedure tear_down_tests
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 027');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,  p_comment  => 'Ran by utPLSQL as Test Suite 027');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,  p_comment  => 'Ran by utPLSQL as Test Suite 027');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,  p_comment  => 'Ran by utPLSQL as Test Suite 027');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,  p_comment  => 'Ran by utPLSQL as Test Suite 027');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,  p_comment  => 'Ran by utPLSQL as Test Suite 027');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,  p_comment  => 'Ran by utPLSQL as Test Suite 027');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_h,  p_comment  => 'Ran by utPLSQL as Test Suite 027');

  end tear_down_tests;

end test_027_var_exp_errors;
/
