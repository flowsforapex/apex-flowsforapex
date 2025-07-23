create or replace package body test_025_script_tasks as
/* 
-- Flows for APEX - test_025_script_tasks.pkb
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
--
-- Created 23-May-2025   Richard Allen - Flowquest
--
*/

  -- uses models 25a and b-

  -- suite(25 Script Tasks)
  -- rollback(manual)
  -- tags(short,ce,ee)
  g_model_a25a constant varchar2(100) := 'A25a - Script Task Proc Var Binding and Substitution';
  g_model_a25b constant varchar2(100) := 'A25b - Script Task Exception handling';
  g_model_a25c constant varchar2(100) := 'A25c -';
  g_model_a25d constant varchar2(100) := 'A25d -';
  g_model_a25e constant varchar2(100) := 'A25e -';
  g_model_a25f constant varchar2(100) := 'A25f -';
  g_model_a25g constant varchar2(100) := 'A25g -';

  g_test_prcs_name_a constant varchar2(100) := 'test 025 - scriptTask a';
  g_test_prcs_name_b constant varchar2(100) := 'test 025 - scriptTask b';
  g_test_prcs_name_c constant varchar2(100) := 'test 025 - scriptTask c';
  g_test_prcs_name_d constant varchar2(100) := 'test 025 - scriptTask d';
  g_test_prcs_name_e constant varchar2(100) := 'test 025 - scriptTask e';
  g_test_prcs_name_f constant varchar2(100) := 'test 025 - scriptTask f';
  g_test_prcs_name_g constant varchar2(100) := 'test 025 - scriptTask g';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a25a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a25b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a25c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a25d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a25e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a25f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a25g_id  flow_diagrams.dgrm_id%type;

  -- beforeall
  procedure set_up_tests
  is
  begin
    -- get dgrm_ids to use for comparison
    g_dgrm_a25a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25a );
    g_dgrm_a25b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25b );
    --g_dgrm_a25c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25c );
    --g_dgrm_a25d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25d );
    --g_dgrm_a25e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25e );
    --g_dgrm_a25f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25f );
    --g_dgrm_a25g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25g_id);
  end set_up_tests;

  procedure test_runner_A
  ( p_path in varchar2 )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(2000);
    l_expected_vc2    varchar2(2000);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_key        flow_subflows.sbfl_step_key%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id     := g_dgrm_a25a_id;
    l_prcs_name   := g_test_prcs_name_a;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
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

    --get the subflow id

    select sbfl_id
      into l_sbfl_id
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_Pre';

    -- set the path proc var

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'Path'
                              , pi_vc2_value => p_path
                              );

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Pre');  

    -- check the process status
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status,
        'Activity_After'||p_path                    as sbfl_current
        from dual;
    open l_actual for
        select p.prcs_dgrm_id, p.prcs_name, p.prcs_status, s.sbfl_current
          from flow_processes p
          join flow_subflows s
            on s.sbfl_prcs_id = p.prcs_id 
         where s.sbfl_id = l_sbfl_id;
    ut.expect( l_actual ).to_equal( l_expected );
    -- check the process variables
    open l_expected for
        select
        'OK' as  test_result_1,
        'OK' as  test_result_2,
        'OK' as  test_result_3,
        'OK' as  test_result_4
        from dual;
    open l_actual for 
        select
        flow_process_vars.get_var_vc2( pi_prcs_id => l_prcs_id, pi_var_name => 'result_OK_1' ) as test_result_1,
        flow_process_vars.get_var_vc2( pi_prcs_id => l_prcs_id, pi_var_name => 'result_OK_2' ) as test_result_2,
        flow_process_vars.get_var_vc2( pi_prcs_id => l_prcs_id, pi_var_name => 'result_OK_3' ) as test_result_3,
        flow_process_vars.get_var_vc2( pi_prcs_id => l_prcs_id, pi_var_name => 'result_OK_4' ) as test_result_4
          from dual;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward and finish
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_After'||p_path);

    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );   
    --chean up the process
    flow_api_pkg.flow_delete( p_process_id => l_prcs_id );
  end test_runner_A;

  
  -- test(A1 - ScriptTask context substitutions)
  procedure script_task_substitutions_A1
  is
  begin
    test_runner_A( p_path => 'A' );
  end script_task_substitutions_A1;

  -- test(A2 -ScriptTask context binds)
  procedure script_task_substitutions_A2
  is
  begin
    test_runner_A( p_path => 'B' );
  end script_task_substitutions_A2;

  -- test(A3 - Legacy depracated ScriptTask context binds)
  procedure script_task_substitutions_A3
  is
  begin
    test_runner_A( p_path => 'C' );
  end script_task_substitutions_A3;

  -- test(A4 - ScriptTask process variable substitutions)
  procedure script_task_substitutions_A4
  is
  begin
    test_runner_A( p_path => 'D' );
  end script_task_substitutions_A4;

  -- test(A5 - ScriptTask process variable binds)
  procedure script_task_substitutions_A5
  is
  begin
    test_runner_A( p_path => 'E' );
  end script_task_substitutions_A5;

  function test_runner_B
  ( p_path               in varchar2 
  , p_script_should_fail in boolean default false
  , p_BE_should_fire     in boolean default false
  ) return flow_processes.prcs_id%type
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(2000);
    l_expected_vc2    varchar2(2000);
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_key        flow_subflows.sbfl_step_key%type;
  begin
    -- get dgrm_id to use for comparison
    l_dgrm_id     := g_dgrm_a25b_id;
    l_prcs_name   := g_test_prcs_name_b;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
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

    --get the subflow id

    select sbfl_id
      into l_sbfl_id
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_Pre';

    -- set the path proc var

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'Path'
                              , pi_vc2_value => p_path
                              );

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Pre');  

    -- check the process status
    -- Convert BOOLEAN to integers for SQL compatibility
    declare
        l_script_should_fail number := case when p_script_should_fail then 1 else 0 end;
        l_BE_should_fire     number := case when p_BE_should_fire then 1 else 0 end;
    begin

        -- check the process status
        open l_expected for
            select
            l_dgrm_id                                   as prcs_dgrm_id,
            l_prcs_name                                 as prcs_name,
            case 
              when (l_script_should_fail = 0 and l_BE_should_fire = 0) then
                   flow_constants_pkg.gc_prcs_status_running
              when (l_script_should_fail = 1 and l_BE_should_fire = 0) then
                   flow_constants_pkg.gc_prcs_status_error
              when (l_script_should_fail = 1 and l_BE_should_fire = 1) then
                   flow_constants_pkg.gc_prcs_status_running
            end                                        as prcs_status,
            case 
              when (l_script_should_fail = 0 and l_BE_should_fire = 0) then
                    'Activity_After'||p_path
              when (l_script_should_fail = 1 and l_BE_should_fire = 0) then
                    'Activity_'||p_path
              when (l_script_should_fail = 1 and l_BE_should_fire = 1) then
                    'Activity_AfterBE'||p_path
            end                                        as sbfl_current                                     
            from dual;
        open l_actual for
            select p.prcs_dgrm_id, p.prcs_name, p.prcs_status, s.sbfl_current
              from flow_processes p
              join flow_subflows s
                on s.sbfl_prcs_id = p.prcs_id 
             where s.sbfl_id = l_sbfl_id;
        ut.expect( l_actual ).to_equal( l_expected );

        if not p_script_should_fail then
            -- check the process variables
            open l_expected for
                select
                'OK' as  test_result_1,
                'OK' as  test_result_2
                from dual;
            open l_actual for 
                select
                flow_process_vars.get_var_vc2( pi_prcs_id => l_prcs_id, pi_var_name => 'result_OK_1' ) as test_result_1,
                flow_process_vars.get_var_vc2( pi_prcs_id => l_prcs_id, pi_var_name => 'result_OK_2' ) as test_result_2
                  from dual;
            ut.expect( l_actual ).to_equal( l_expected );

            -- step forward and finish
            test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_After'||p_path);

            open l_expected for
                select
                l_dgrm_id                                   as prcs_dgrm_id,
                l_prcs_name                                 as prcs_name,
                flow_constants_pkg.gc_prcs_status_completed   as prcs_status
                from dual;
            open l_actual for
                select prcs_dgrm_id, prcs_name, prcs_status 
                  from flow_processes p
                 where p.prcs_id = l_prcs_id;
            ut.expect( l_actual ).to_equal( l_expected );   
        elsif p_BE_should_fire then
            -- step forward and finish
            test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterBE'||p_path);

            open l_expected for
                select
                l_dgrm_id                                   as prcs_dgrm_id,
                l_prcs_name                                 as prcs_name,
                flow_constants_pkg.gc_prcs_status_completed   as prcs_status
                from dual;
            open l_actual for
                select prcs_dgrm_id, prcs_name, prcs_status 
                  from flow_processes p
                 where p.prcs_id = l_prcs_id;
            ut.expect( l_actual ).to_equal( l_expected );   
        else
          null;
        end if;

    end;
    return l_prcs_id;
  end test_runner_B;

  -- test(B1 - Successful Script Task execution)
  procedure script_task_exceptions_B1
  is
  begin
    g_prcs_id_a := test_runner_B( p_path => 'A' 
                                , p_script_should_fail => false
                                , p_BE_should_fire     => false
                                );
  end script_task_exceptions_B1;

  -- test(B2 - Script Task raises e_plsql_script_requested_stop exception)
  procedure script_task_exceptions_B2
  is
  begin
    g_prcs_id_b := test_runner_B( p_path => 'B' 
                                , p_script_should_fail => true
                                , p_BE_should_fire     => false
                                );
  end script_task_exceptions_B2;

  -- test(B3 - Script Task raises flow_globals.request_stop_engine exception)
  procedure script_task_exceptions_B3
  is
  begin
    g_prcs_id_c := test_runner_B( p_path => 'C'  
                                , p_script_should_fail => true
                                , p_BE_should_fire     => FALSE
                                );
  end script_task_exceptions_B3;

  -- test(B4 - Script Task raises other exception)
  procedure script_task_exceptions_B4
  is
  begin
    g_prcs_id_d := test_runner_B( p_path => 'D' 
                                , p_script_should_fail => true
                                , p_BE_should_fire     => false
                                );
  end script_task_exceptions_B4;  

  -- test(B5 - Script Task raises flow_globals.throw_bpmn_error_event exception)
  procedure script_task_exceptions_B5
  is
  begin
    g_prcs_id_e := test_runner_B( p_path => 'E' 
                                , p_script_should_fail => true
                                , p_BE_should_fire     => true
                                ); 
  end script_task_exceptions_B5;

  -- afterall
  procedure tear_down_tests
  is
  begin
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_a );
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_b );
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_c );
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_d );
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_e );
  end ;

end test_025_script_tasks;
/