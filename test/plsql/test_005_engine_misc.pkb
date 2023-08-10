create or replace package body test_005_engine_misc as
/* 
-- Flows for APEX - test_005_engine_misc.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 31-Mar-2023   Richard Allen - Oracle
--
*/

  -- uses models 5a-
  g_model_a05a constant varchar2(100) := 'A05a - Engine - Terminations';
  g_model_a05b constant varchar2(100) := 'A05b - Engine - Bad Links';
  g_model_a05c constant varchar2(100) := 'A05c - Engine - ICE Types';
  g_model_a05d constant varchar2(100) := 'A05d - Engine - Repeating Timer BE';
  g_model_a05e constant varchar2(100) := 'A05e - Engine -';
  g_model_a05f constant varchar2(100) := 'A05f - Engine -';
  g_model_a05g constant varchar2(100) := 'A05g - Engine -';

  g_test_prcs_name_a1 constant varchar2(100) := 'test - engine misc a1';
  g_test_prcs_name_a2 constant varchar2(100) := 'test - engine misc a2';
  g_test_prcs_name_b1 constant varchar2(100) := 'test - engine misc b1';
  g_test_prcs_name_b2 constant varchar2(100) := 'test - engine misc b2';
  g_test_prcs_name_b3 constant varchar2(100) := 'test - engine misc b3';
  g_test_prcs_name_c  constant varchar2(100) := 'test - engine misc c';
  g_test_prcs_name_d  constant varchar2(100) := 'test - engine misc d';
  g_test_prcs_name_e  constant varchar2(100) := 'test - engine misc e';
  g_test_prcs_name_f  constant varchar2(100) := 'test - engine misc f';
  g_test_prcs_name_g  constant varchar2(100) := 'test - engine misc g';

  g_prcs_id_a1      flow_processes.prcs_id%type;
  g_prcs_id_a2      flow_processes.prcs_id%type;
  g_prcs_id_b1      flow_processes.prcs_id%type;
  g_prcs_id_b2      flow_processes.prcs_id%type;
  g_prcs_id_b3      flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a05a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a05b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a05c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a05d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a05e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a05f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a05g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a05a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a05a );
    g_dgrm_a05b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a05b );
    g_dgrm_a05c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a05c );
    g_dgrm_a05d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a05d );
/*    g_dgrm_a05e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a05e );
    g_dgrm_a05f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a05f );
    g_dgrm_a05g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a05g ); */

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a05a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a05b_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a05c_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a05d_id);
/*    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a05e_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a05f_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a05g_id);*/

  end set_up_tests; 


  -- test(A - Model driven terminations)
  procedure model_terminate_driver
  ( p_dgrm_id           in flow_diagrams.dgrm_id%type
  , p_prcs_name         in flow_processes.prcs_name%type
  , p_final_step        in flow_objects.objt_bpmn_id%type
  , p_reqd_prcs_status  in flow_processes.prcs_status%type
  , p_prcs_id          out flow_processes.prcs_id%type
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := p_dgrm_id;
    l_prcs_name  := p_prcs_name;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => p_prcs_name
                  );
    p_prcs_id := l_prcs_id;

    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Ready');   

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
    
    -- check all parallel subflows running

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_E' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_C' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA1BSub' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_B1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_A1A' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- all set up ready to test deep termination.  Step Forward A1A then check it terminates current level and sub-level

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A1A');   

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_E' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_C' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_B1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_A2' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- now test same level subprocess termination.  step forward on B1 and check it terminates sub proc A

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_B1');   

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_E' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_C' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_D' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- now test main level process termination.  step forward l_step and check process status

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => p_final_step);   


    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_be_empty;   

    select prcs_status
      into l_actual_vc2
      from flow_processes
     where prcs_id = l_prcs_id;
    ut.expect(l_actual_vc2).to_equal(p_reqd_prcs_status);


  end model_terminate_driver;

  procedure model_terminate_completed
  is
  begin
    model_terminate_driver ( p_dgrm_id          => g_dgrm_a05a_id
                           , p_prcs_name        => g_test_prcs_name_a1
                           , p_prcs_id          => g_prcs_id_a1
                           , p_final_step       => 'Activity_C'
                           , p_reqd_prcs_status => flow_constants_pkg.gc_prcs_status_completed
                           );
  end model_terminate_completed;

  procedure model_terminate_terminated
  is
  begin
    model_terminate_driver ( p_dgrm_id          => g_dgrm_a05a_id
                           , p_prcs_name        => g_test_prcs_name_a2
                           , p_prcs_id          => g_prcs_id_a2
                           , p_final_step       => 'Activity_E'
                           , p_reqd_prcs_status => flow_constants_pkg.gc_prcs_status_terminated
                           );
  end model_terminate_terminated;

  procedure model_link_driver
  ( p_dgrm_id           in flow_diagrams.dgrm_id%type
  , p_prcs_name         in flow_processes.prcs_name%type
  , p_path              in varchar2
  , p_expected_step     in flow_objects.objt_bpmn_id%type default null
  , p_prcs_id          out flow_processes.prcs_id%type
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := p_dgrm_id;
    l_prcs_name  := p_prcs_name;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => p_prcs_name
                  );
    p_prcs_id := l_prcs_id;

    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );

    -- set up path process variable

    flow_process_vars.set_var ( pi_prcs_id    => l_prcs_id
                              , pi_var_name   => 'path'
                              , pi_vc2_value  => p_path
                              );

    -- start process and check it is running

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

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Before'||p_path );        

    -- If link was successful, should have now traversed the link and be on p_expected_step

    if p_expected_step is not null then

      open l_expected for
         select
            l_prcs_id as sbfl_prcs_id,
            l_dgrm_id as sbfl_dgrm_id,
            p_expected_step as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    else

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

    end if;
  end model_link_driver;
    
  procedure model_link_good
  is
  begin
    model_link_driver      ( p_dgrm_id          => g_dgrm_a05b_id
                           , p_prcs_name        => g_test_prcs_name_b1
                           , p_prcs_id          => g_prcs_id_b1
                           , p_path             => 'A'
                           , p_expected_step    => 'Activity_AfterA'
                           );
  end model_link_good;

  procedure model_link_duplicate
  is
  begin
    model_link_driver      ( p_dgrm_id          => g_dgrm_a05b_id
                           , p_prcs_name        => g_test_prcs_name_b2
                           , p_prcs_id          => g_prcs_id_b2
                           , p_path             => 'B'
                           , p_expected_step    => ''
                           );
  end model_link_duplicate;

  procedure model_link_incorrect
  is
  begin
    model_link_driver      ( p_dgrm_id          => g_dgrm_a05b_id
                           , p_prcs_name        => g_test_prcs_name_b3
                           , p_prcs_id          => g_prcs_id_b3
                           , p_path             => 'C'
                           , p_expected_step    => ''
                           );
  end model_link_incorrect;

  procedure ICE_types
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a05c_id;
    l_prcs_name  := g_test_prcs_name_c;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_C := l_prcs_id;

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
    
    -- check all parallel subflows running

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeA' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeB' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeC' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeD' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- Test Timer ICE
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeA');  

    dbms_session.sleep(15);

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AfterA' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeB' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeC' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeD' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterA');   

    -- test Conditional ICE - not yet implemented so this should need a 'next step' to progress

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeB');  

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Event_B' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeC' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeD' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Event_B');       

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AfterB' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeC' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeD' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterB');   

    -- Signal ICE - Not implemented so model should stop and waoit at Signal ICE for next step


    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeC');  

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Event_C' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeD' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Event_C');       

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AfterC' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeD' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterC');   

    -- Message ICE - not yet parsed - s this will fail temporarily - fix before 23.1 reease!


    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeD');  

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Event_D' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- send the  expected message
    flow_api_pkg.receive_message
    ( p_message_name => 'InMessage'
    , p_key_name     => 'KEY'
    , p_key_value    => '1'
    , p_payload      => 'MyPayload'
    );

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AfterD' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterD');   

  end ICE_types;

  procedure repeating_TimerBE
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(200);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id    := g_dgrm_a05d_id;
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

    -- check  subflow running

    open l_expected for
           select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeA' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- Step into task with attached non interrupting timer.   4 cycles of 8 seconds
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeA');  

    dbms_session.sleep(52);

    -- check all parallel subflows running
    -- after 40 seconds (plus timer delay) should have just the main subflow + 4 reminder subflows.   No further BE subflow.

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_A' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union all
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AReminder' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union all
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AReminder' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union all
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AReminder' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union all
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AReminder' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

  end;

  --afterall
  procedure tear_down_tests  
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a1,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a2,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b1,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');                             
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b2,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');                             
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b3,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');                             
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');   
    /*flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d2,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');   
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005'); 
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,
                             p_comment  => 'Ran by utPLSQL as Test Suite 005'); */

    ut.expect( v('APP_SESSION')).to_be_null;

  end tear_down_tests;

end test_005_engine_misc;