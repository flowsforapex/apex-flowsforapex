create or replace package body test_025_iterations_loops_tasks.pkb
/* 
-- Flows for APEX - test_025_iterations_loops_tasks.pkb
-- 
-- (c) Copyright Flowquest Consulting Limited and / or its affiliates, 2024.
--
-- Created 20-June-2024   Richard Allen - Flowquest Consulting Limited
--
*/
is 
  -- suite(25 Task Iterations and Loops)
  -- tags(ee,short)
  -- rollback(manual)
  
  -- uses models 19a-g
  g_model_a25d constant varchar2(100) := 'A27d - Variable Expression Errors';

  g_test_prcs_name_a constant varchar2(100) := 'test 025 - iteration and loops for tasks a';
  g_test_prcs_name_b constant varchar2(100) := 'test 025 - iteration and loops for tasks b';
  g_test_prcs_name_c constant varchar2(100) := 'test 025 - iteration and loops for tasks c';
  g_test_prcs_name_d constant varchar2(100) := 'test 025 - iteration and loops for tasks d';
  g_test_prcs_name_e constant varchar2(100) := 'test 025 - iteration and loops for tasks e';
  g_test_prcs_name_f constant varchar2(100) := 'test 025 - iteration and loops for tasks f';
  g_test_prcs_name_g constant varchar2(100) := 'test 025 - iteration and loops for tasks g';
  g_test_prcs_name_h constant varchar2(100) := 'test 025 - iteration and loops for tasks h';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;
  g_prcs_id_h       flow_processes.prcs_id%type;

  g_dgrm_a25adid  flow_diagrams.dgrm_id%type;

  -- beforeall
  procedure set_up_tests
  is
  begin
    -- get dgrm_ids to use for comparison
    g_dgrm_a25d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25d );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25d_id);
  end;

  -- test('1 - Sequential Task Iteration to Completion - List')
  procedure task_seq_iteration_list
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
    l_dgrm_id     := g_dgrm_a25d_id;
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



    
  end task_seq_iteration_list;

  -- test('2 - Sequential Task Iteration with Completion Condition - List')
  procedure task_seq_iteration_list_w_condition
  is
  begin
    null;
  end task_seq_iteration_list_w_condition;

  -- test('3 - Parallel Task Iteration to Completion - Array')
  procedure task_par_iteration_array
  is
  begin
    null;
  end task_par_iteration_array;

  -- test('4 - Parallel Task Iteration with Completion Condition - Array')
  procedure task_par_iteration_array_w_condition
  is
  begin
    null;
  end task_par_iteration_array_w_condition;

  -- test('5 - Parallel Task Iteration to Completion - Query')
  procedure task_par_iteration_query
  is
  begin
    null;
  end task_par_iteration_query;

  -- test('6 - Parallel Task Iteration with Completion Condition - Query')
  procedure task_par_iteration_query_w_condition
  is
  begin
    null;
  end task_par_iteration_query_w_condition;

  -- test('7 - Sequential Task Loop with Completion Condition')
  procedure task_loop_w_condition
  is
  begin
    null;
  end task_loop_w_condition;

  -- afterall
  procedure tear_down_tests;

end test_025_iterations_loops_tasks;
/
