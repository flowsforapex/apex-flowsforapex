create or replace package body test_019_priorityDueDates as
/* 
-- Flows for APEX - test_019_priorityDueDates.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 28-Mar-2023   Richard Allen - Oracle
--
*/

  -- uses models 19a-g
  g_model_a19a constant varchar2(100) := 'A19a - Priority and Due Dates';
  g_model_a19b constant varchar2(100) := 'A19b - Priority and Due Dates - Scheduler';
  g_model_a19c constant varchar2(100) := 'A19c - Priority and Due Dates - Interval';
  g_model_a19d constant varchar2(100) := 'A19d - Priority and Due Dates - Proc Var';
  g_model_a19e constant varchar2(100) := 'A19e - Priority and Due Dates - SQL';
  g_model_a19f constant varchar2(100) := 'A19f - Priority and Due Dates - Expressions';
  g_model_a19g constant varchar2(100) := 'A19g - Priority and Due Dates - Func Bodies';

  g_test_prcs_name_a constant varchar2(100) := 'test - Lane parsing & execution a';
  g_test_prcs_name_b constant varchar2(100) := 'test - Lane parsing & execution b';
  g_test_prcs_name_c constant varchar2(100) := 'test - Lane parsing & execution c';
  g_test_prcs_name_d constant varchar2(100) := 'test - Lane parsing & execution d1';
  g_test_prcs_name_d2 constant varchar2(100) := 'test - Lane parsing & execution d2';
  g_test_prcs_name_e constant varchar2(100) := 'test - Lane parsing & execution e';
  g_test_prcs_name_f constant varchar2(100) := 'test - Lane parsing & execution f';
  g_test_prcs_name_g constant varchar2(100) := 'test - Lane parsing & execution g';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_d2      flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a19a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a19b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a19c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a19d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a19e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a19f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a19g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a19a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a19a );
    g_dgrm_a19b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a19b );
    g_dgrm_a19c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a19c );
    g_dgrm_a19d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a19d );
    g_dgrm_a19e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a19e );
    g_dgrm_a19f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a19f );
    g_dgrm_a19g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a19g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a19a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a19b_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a19c_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a19d_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a19e_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a19f_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a19g_id);

  end set_up_tests; 



  -- test(A1 - Process Priority and Due On - Static)
  procedure proc_static
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19a_id;
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
    
    -- check all parallel subflows running

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Proc' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Task' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_API' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;
    
    -- get the subflow ids
    select sbfl_id
      into l_sbfl_proc
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_Proc';
       
    select sbfl_id
      into l_sbfl_task
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_Task';
       
    select sbfl_id
      into l_sbfl_api
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_API';
    
    -- all running and ready for tests

    -- check process priority

    open l_expected for 
      select 5 as prcs_priority, '2023-05-23 14:00:23 EUROPE/PARIS' as due_on
        from dual;

    open l_actual for
      select prcs_priority, to_char( prcs_due_on, 'YYYY-MM-DD HH24:MI:SS TZR') as due_on
        from flow_processes 
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );

    -- check task priorities and due dates - all setting methods
    -- step model forward into Task path 

    -- task priority and due on - Static

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Task');      

    open l_expected for 
      select 4 as sbfl_priority, '2024-06-21 09:15:05 +00:00' as due_on
        from dual;

    open l_actual for
      select sbfl_priority, to_char( sys_extract_utc(sbfl_due_on), 'YYYY-MM-DD HH24:MI:SS TZR') as due_on
        from flow_subflows 
       where sbfl_id = l_sbfl_task;    
    ut.expect( l_actual ).to_equal( l_expected );


    -- task priority and due on - Interval

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Static');      

    open l_expected for 
      select 1 as sbfl_priority
        from dual;

    open l_actual for
      select sbfl_priority
        from flow_subflows
       where sbfl_id = l_sbfl_task;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := systimestamp + to_dsinterval('000 12:00:00');
      select sbfl_due_on
        into l_actual_tstz
        from flow_subflows
        where sbfl_id = l_sbfl_task;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);


    -- task priority and due on - Scheduler

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Interval');      

    open l_expected for 
      select 5 as sbfl_priority
        from dual;

    open l_actual for
      select sbfl_priority
        from flow_subflows
       where sbfl_id = l_sbfl_task;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := systimestamp + to_dsinterval('000 01:00:00');
      select sbfl_due_on
        into l_actual_tstz
        from flow_subflows
        where sbfl_id = l_sbfl_task;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);


    -- task priority and due on - Proc Var

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Scheduler');      

        open l_expected for 
      select 2 as sbfl_priority, '2032-06-21 23:59:59 +00:00' as due_on
        from dual;

    open l_actual for
      select sbfl_priority, to_char( sys_extract_utc(sbfl_due_on), 'YYYY-MM-DD HH24:MI:SS TZR') as due_on
        from flow_subflows 
       where sbfl_id = l_sbfl_task;    
    ut.expect( l_actual ).to_equal( l_expected );


    -- task priority and due on - SQL

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_ProcVar');      

    open l_expected for 
      select 4 as sbfl_priority
        from dual;

    open l_actual for
      select sbfl_priority
        from flow_subflows
       where sbfl_id = l_sbfl_task;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := systimestamp + to_dsinterval('000 06:00:00');
      select sbfl_due_on
        into l_actual_tstz
        from flow_subflows
        where sbfl_id = l_sbfl_task;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);


    -- task priority and due on - Expression

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_SQL');      

        open l_expected for 
      select 3 as sbfl_priority
        from dual;

    open l_actual for
      select sbfl_priority
        from flow_subflows
       where sbfl_id = l_sbfl_task;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := systimestamp + to_dsinterval('001 12:00:00');
      select sbfl_due_on
        into l_actual_tstz
        from flow_subflows
        where sbfl_id = l_sbfl_task;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);


    -- task priority and due on - Func Body

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Expr');      

    open l_expected for 
      select 4 as sbfl_priority
        from dual;

    open l_actual for
      select sbfl_priority
        from flow_subflows
       where sbfl_id = l_sbfl_task;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := systimestamp + to_dsinterval('000 06:00:00');
      select sbfl_due_on
        into l_actual_tstz
        from flow_subflows
        where sbfl_id = l_sbfl_task;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- step forward and complete the subflow

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_FuncBody');     

  end proc_static;


  -- test(A2 - Task Priority and Due On - All Setting Methods)
  procedure task_all
  is
  begin
    null;
  end task_all;

  -- test(A3 - API get and set process priority and due on)
  procedure proc_api
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
    l_priority_actual flow_processes.prcs_priority%type;
    l_priority_new    flow_processes.prcs_priority%type;
    l_due_on_actual   varchar2(50);
    l_due_on_new      flow_processes.prcs_due_on%type;
    l_due_on_new_actual    varchar2(50);
    l_expected_due_on      varchar2(50);
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19a_id;
    l_prcs_name   := g_test_prcs_name_a;
    l_prcs_id     := g_prcs_id_a;

    -- get API sbfl ID
    select sbfl_id
      into l_sbfl_api
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_API';

    -- test set & get process Priority

    select prcs_priority
      into l_priority_actual 
      from flow_processes
     where prcs_id = l_prcs_id;

    ut.expect(l_priority_actual).to_equal(5);

    -- set process priority to 2 & retest

    flow_api_pkg.flow_set_priority ( p_process_id  => l_prcs_id
                                   , p_priority  => 2
                                   );                              

    select prcs_priority
      into l_priority_new
      from flow_processes
     where prcs_id = l_prcs_id;

    ut.expect(l_priority_new).to_equal(2);            

    -- test set & get process Due On

    l_expected_due_on := '2023-05-23 14:00:23 EUROPE/PARIS';
    l_due_on_new := to_timestamp_tz ('2032-06-21 23:59:59 EUROPE/LONDON','YYYY-MM-DD HH24:MI:SS TZR');

    select to_char(prcs_due_on, 'YYYY-MM-DD HH24:MI:SS TZR')
      into l_due_on_actual 
      from flow_processes
     where prcs_id = l_prcs_id;

    ut.expect(l_due_on_actual).to_equal(l_expected_due_on);

    -- set process Due On to 2 & retest

    flow_api_pkg.flow_set_due_on ( p_process_id  => l_prcs_id
                                   , p_due_on  => l_due_on_new
                                   );                              

    select to_char(prcs_due_on, 'YYYY-MM-DD HH24:MI:SS TZR')
      into l_due_on_new_actual
      from flow_processes
     where prcs_id = l_prcs_id;

    ut.expect(l_due_on_new_actual).to_equal('2032-06-21 23:59:59 EUROPE/LONDON');            


    -- test process_priority in static do_substitution
    -- step forward and complete the subflow

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_API');    

    l_priority_actual := flow_process_vars.get_var_vc2(pi_prcs_id  => l_prcs_id,
                                                           pi_var_name  => 'Process_priority_copy',
                                                           pi_scope  => 0);

    ut.expect(l_priority_actual).to_equal(l_priority_new);


    -- test setting task priority using process_priority as a proc var
    -- first reset proc priority to different value then step forward and complete the subflow

    -- set process priority to 1 & retest

    flow_api_pkg.flow_set_priority ( p_process_id  => l_prcs_id
                                   , p_priority  => 1
                                   );                              

    select prcs_priority
      into l_priority_new
      from flow_processes
     where prcs_id = l_prcs_id;

    ut.expect(l_priority_new).to_equal(1);        


    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_priority_sub');    

    select sbfl_priority
      into l_priority_new
      from flow_subflows
     where sbfl_id = l_sbfl_api;

    ut.expect(l_priority_new).to_equal(1);   

    -- step forward to complete the subflow

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Proc_priority');      

  end proc_api;
  
  -- test(B - Process Priority and Due On - Scheduler)
  procedure proc_scheduler
    is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19b_id;
    l_prcs_name   := g_test_prcs_name_b;
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
    
    -- check process priority

    open l_expected for 
      select 3 as prcs_priority
        from dual;

    open l_actual for
      select prcs_priority
        from flow_processes
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := systimestamp + to_dsinterval('000 05:00:00');

      select prcs_due_on
        into l_actual_tstz
        from flow_processes
        where prcs_id = l_prcs_id;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- complete the diagram

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

  end proc_scheduler;

  -- test(C - Process Priority and Due On - Interval)
  procedure proc_interval
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19c_id;
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
    
    -- check process priority

    open l_expected for 
      select 5 as prcs_priority
        from dual;

    open l_actual for
      select prcs_priority
        from flow_processes
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := systimestamp + to_dsinterval('P1D');

      select prcs_due_on
        into l_actual_tstz
        from flow_processes
        where prcs_id = l_prcs_id;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- complete the diagram

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

  end proc_interval;

  -- test(D1 - Process Priority and Due On - Proc Var)
  procedure proc_procvar  -- set up my_priority and my_deadline between create and start!!
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19d_id;
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

    -- create proc vars to be copied in test

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'My_Priority'
                              , pi_num_value => 4);

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'My_Deadline'
                              , pi_tstz_value => to_timestamp_tz('2032-06-21 23:59:59 EUROPE/LONDON','YYYY-MM-DD HH24:MI:SS TZR')
                              );                          
    
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
    
    -- check process priority

    open l_expected for 
      select 4 as prcs_priority
        from dual;

    open l_actual for
      select prcs_priority
        from flow_processes
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := to_timestamp_tz('2032-06-21 23:59:59 EUROPE/LONDON','YYYY-MM-DD HH24:MI:SS TZR');

      select prcs_due_on
        into l_actual_tstz
        from flow_processes
        where prcs_id = l_prcs_id;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- complete the diagram

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

  end proc_procvar;

    -- test(D - Process Priority and Due On - Proc Var)
  procedure proc_procvar2  -- set up my_priority and my_deadline between create and start!!
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19d_id;
    l_prcs_name   := g_test_prcs_name_d2;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_d2 := l_prcs_id;

    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );

    -- create proc vars to be copied in test

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'My_Priority'
                              , pi_vc2_value => '2');

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'My_Deadline'
                              , pi_tstz_value => to_timestamp_tz('2032-06-21 23:59:59 EUROPE/LONDON','YYYY-MM-DD HH24:MI:SS TZR')
                              );                          
    
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
    
    -- check process priority

    open l_expected for 
      select 2 as prcs_priority
        from dual;

    open l_actual for
      select prcs_priority
        from flow_processes
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := to_timestamp_tz('2032-06-21 23:59:59 EUROPE/LONDON','YYYY-MM-DD HH24:MI:SS TZR');

      select prcs_due_on
        into l_actual_tstz
        from flow_processes
        where prcs_id = l_prcs_id;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- complete the diagram

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

  end proc_procvar2;

  -- test(E - Process Priority and Due On - SQL)
  procedure proc_sql
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19e_id;
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
    
    -- check process priority

    open l_expected for 
      select 4 as prcs_priority
        from dual;

    open l_actual for
      select prcs_priority
        from flow_processes
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := to_timestamp_tz('2023-06-21 23:59:59 AMERICA/LOS_ANGELES','YYYY-MM-DD HH24:MI:SS TZR');

      select prcs_due_on
        into l_actual_tstz
        from flow_processes
        where prcs_id = l_prcs_id;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- complete the diagram

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

  end proc_sql;



  -- test(F - Process Priority and Due On - Expression)
  procedure proc_expression
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19f_id;
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
    
    -- check process priority

    open l_expected for 
      select 3 as prcs_priority
        from dual;

    open l_actual for
      select prcs_priority
        from flow_processes
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := to_timestamp_tz('2023-06-21 23:59:59 AMERICA/LOS_ANGELES','YYYY-MM-DD HH24:MI:SS TZR')
                        + to_dsinterval('P10DT6H');

      select prcs_due_on
        into l_actual_tstz
        from flow_processes
        where prcs_id = l_prcs_id;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- complete the diagram

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

  end proc_expression;

  -- test(G - Process Priority and Due On - Func Body)
  procedure proc_funcbody
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_proc       flow_subflows.sbfl_id%type;
    l_sbfl_task       flow_subflows.sbfl_id%type;
    l_sbfl_api        flow_subflows.sbfl_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a19g_id;
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
    
    -- check process priority

    open l_expected for 
      select 5 as prcs_priority
        from dual;

    open l_actual for
      select prcs_priority
        from flow_processes
       where prcs_id = l_prcs_id;    
    ut.expect( l_actual ).to_equal( l_expected );  

    l_expected_tstz := to_timestamp_tz('2023-06-21 23:59:59 AMERICA/LOS_ANGELES','YYYY-MM-DD HH24:MI:SS TZR') + to_dsinterval('P10DT6H');

      select prcs_due_on
        into l_actual_tstz
        from flow_processes
        where prcs_id = l_prcs_id;
    ut.expect(l_actual_tstz).to_be_within(interval '1' minute).of_(l_expected_tstz);

    -- complete the diagram

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A');  

  end proc_funcbody;

  --afterall
  procedure tear_down_tests  
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019');                             
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019');   
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d2,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019');   
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019'); 
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,
                             p_comment  => 'Ran by utPLSQL as Test Suite 019'); 

    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;


end test_019_priorityDueDates;
/
