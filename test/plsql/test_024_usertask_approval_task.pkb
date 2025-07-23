create or replace package body test_024_usertask_approval_task as
/* 
-- Flows for APEX - test_024_usertask_approval_task.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
-- (c) Copyright Flowquest Limited and / or its affiliates, 2025.
--
-- Created 18-May-2023   Richard Allen - Oracle
-- Edited  10-Jun-2025   Richard Allen - Flowquest Limited (enhanced for 25.1 APEX Human Task enhs)
--
*/

  -- uses models 24a,b,c
  -- uses APEX App: FA Testing - Suite 024 - Approval Component Integration

  -- suite(24 usertask - approval task)
  -- rollback(manual)

  g_human_task_app_id  constant varchar2(6)  := test_constants.gc_Ste24_Test_App_ID ;
  g_approver_user      constant varchar2(40) := test_constants.gc_tester1;
  g_testing_user       constant varchar2(40) := test_constants.gc_tester2;
  g_approver_user3     constant varchar2(40) := test_constants.gc_tester3;
  g_approver_user4     constant varchar2(40) := test_constants.gc_tester4;

  g_model_a24a constant varchar2(100) := 'A24a - Approval Component - Basic Operation';
  g_model_a24b constant varchar2(100) := 'A24b - Approval Task - Task Cancelation';
  g_model_a24c constant varchar2(100) := 'A24c - APEX Human Task Ownership and Cancellation';
  g_model_a24d constant varchar2(100) := 'A24d - APEX Human Task - Cancellation - New Plugin';
  g_model_a24e constant varchar2(100) := 'A24e -';
  g_model_a24f constant varchar2(100) := 'A24f -';
  g_model_a24g constant varchar2(100) := 'A24g -';

  g_test_prcs_name_a constant varchar2(100) := 'test 024 - approval task a';
  g_test_prcs_name_b constant varchar2(100) := 'test 024 - approval task b';
  g_test_prcs_name_c constant varchar2(100) := 'test 024 - approval task c';
  g_test_prcs_name_d constant varchar2(100) := 'test 024 - approval task d';
  g_test_prcs_name_e constant varchar2(100) := 'test 024 - approval task e';
  g_test_prcs_name_f constant varchar2(100) := 'test 024 - approval task f';
  g_test_prcs_name_g constant varchar2(100) := 'test 024 - approval task g';
  g_test_prcs_name_h constant varchar2(100) := 'test 024 - approval task h';
  g_test_prcs_name_i constant varchar2(100) := 'test 024 - approval task i';
  g_test_prcs_name_j constant varchar2(100) := 'test 024 - approval task j';
  --g_test_prcs_name_k constant varchar2(100) := 'test 024 - approval task k';



  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;
  g_prcs_id_h       flow_processes.prcs_id%type;
  g_prcs_id_i       flow_processes.prcs_id%type;
  g_prcs_id_j       flow_processes.prcs_id%type;
  g_prcs_id_k       flow_processes.prcs_id%type;
  g_prcs_id_l       flow_processes.prcs_id%type;

  g_dgrm_a24a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24g_id  flow_diagrams.dgrm_id%type;

  function get_current_sbfl_list 
  ( p_prcs_id  in flow_processes.prcs_id%type)
  return sys.json_element_t
  is
    l_sbfl_list varchar2(4000);
  begin
    with sbfl_list as (
           select json_object
                   ( 'current'        value sf.sbfl_current
                   , 'iteration_type' value sf.sbfl_iteration_type
                   , 'iteration_path' value it.iter_display_name
                   , 'status'         value sf.sbfl_status
                   ) subflows
                 , sf.sbfl_prcs_id 
                 , sf.sbfl_current 
                 , it.iter_display_name sbfl_iteration_path     
           from flow_subflows sf
           left join flow_iterations it
             on sf.sbfl_iter_id = it.iter_id
           order by sbfl_current, it.iter_display_name
           )
    select json_arrayagg (sl.subflows order by sl.sbfl_current asc, sl.sbfl_iteration_path asc returning varchar2(4000)) sbfl_array
      into l_sbfl_list
    from sbfl_list sl
    join flow_processes p
      on p.prcs_id = sl.sbfl_prcs_id
    where p.prcs_id = p_prcs_id;
    return sys.json_element_t.parse(l_sbfl_list);
  end get_current_sbfl_list;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a24a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24a );
    g_dgrm_a24b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24b );
    g_dgrm_a24c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24c );
    g_dgrm_a24d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24d );
    --g_dgrm_a24e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24e );
    --g_dgrm_a24f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24f );
    --g_dgrm_a24g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24b_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24c_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24g_id);

  end set_up_tests;

  function apex_task_test_runner -- for legacy APEX Task tests (24.1 compatibility with old plugin)
  ( p_path              varchar2
  , p_source_pk         varchar2 default null
  , p_diagram           flow_diagrams.dgrm_id%type
  , p_add_bad_priority  boolean default false
  , p_expect_error      boolean default false
  ) return flow_processes.prcs_id%type
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(2000);
    l_expected_vc2    varchar2(2000);
    l_actual_num      number;
    l_expected_num    number;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_key        flow_subflows.sbfl_step_key%type;
    l_task_id         number;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := p_diagram;
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
       and sbfl_current = 'Activity_Setup';

    -- set the app_id (important for Approval Tasks)

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'Ste24_Test_App_ID'
                              , pi_vc2_value =>  g_human_task_app_id
                              );

    -- set the path proc var

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'path'
                              , pi_vc2_value => p_path
                              );

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Setup');  

    -- check on correct path

    open l_expected for
       select
          l_prcs_id                   as sbfl_prcs_id,
          l_dgrm_id                   as sbfl_dgrm_id,
          'Activity_PreTest_'||p_path as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- set the BUSINESS REF if a test requiring a PK

    if p_source_pk is not null then
      flow_process_vars.set_business_ref( pi_prcs_id    => l_prcs_id
                                        , pi_vc2_value  => p_source_pk
                                        , pi_scope      => 0
                                        );
    end if;

    if p_add_bad_priority then
      flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                                , pi_var_name => 'Default_test_priority'
                                , pi_vc2_value => '7' );
    end if;

    -- step forward into APEX task

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_PreTest_'||p_path );      

    -- if p_error_expected then

    if p_expect_error then 

        -- check subflow status

        open l_expected for
           select
              l_prcs_id                                           as sbfl_prcs_id,
              l_dgrm_id                                           as sbfl_dgrm_id,
              'Activity_Approval_A24'||p_path                     as sbfl_current,
              flow_constants_pkg.gc_sbfl_status_error             as sbfl_status
           from dual;

        open l_actual for
           select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
           from flow_subflows 
           where sbfl_prcs_id = l_prcs_id
           and sbfl_status not like 'split';
        ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    else 

        -- expect APEX Task to be created - check subflow status

        open l_expected for
           select
              l_prcs_id                                           as sbfl_prcs_id,
              l_dgrm_id                                           as sbfl_dgrm_id,
              'Activity_Approval_A24'||p_path                     as sbfl_current,
              flow_constants_pkg.gc_sbfl_status_waiting_approval  as sbfl_status
           from dual;

        open l_actual for
           select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
           from flow_subflows 
           where sbfl_prcs_id = l_prcs_id
           and sbfl_status not like 'split';
        ut.expect( l_actual ).to_equal( l_expected ).unordered;    

        -- check for task Id returned

        select sbfl_apex_task_id
          into l_task_id
          from flow_subflows
         where sbfl_prcs_id = l_prcs_id
           and sbfl_current = 'Activity_Approval_A24'||p_path;

        ut.expect(l_task_id).to_be_not_null();

        -- change session to the approver
        begin
          apex_session.delete_session;
        exception
          when others then 
            null;
        end;
        apex_session.create_session ( p_app_id => g_human_task_app_id 
                                    , p_page_id => 3
                                    , p_username => g_approver_user 
                                    );
        -- make the approval
        apex_approval.complete_task ( p_task_id => l_task_id
                                    , p_outcome => apex_approval.c_task_outcome_approved
                                    , p_autoclaim => true
                                    );
        -- return to new session as original user
        begin
          apex_session.delete_session;
        exception
          when others then 
            null;
        end;
        --apex_session.create_session ( p_app_id => g_human_task_app_id 
        --                            , p_page_id => 3
        --                            , p_username => g_testing_user 
        --                            );              
        -- check workflow has moved forwards

        open l_expected for
           select
              l_prcs_id                     as sbfl_prcs_id,
              l_dgrm_id                     as sbfl_dgrm_id,
              'Activity_AfterTest_'||p_path as sbfl_current,
              flow_constants_pkg.gc_sbfl_status_running sbfl_status
           from dual;

        open l_actual for
           select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
           from flow_subflows 
           where sbfl_prcs_id = l_prcs_id
           and sbfl_status not like 'split';
        ut.expect( l_actual ).to_equal( l_expected ).unordered;    

        -- check result was returned

        l_actual_vc2 :=   flow_process_vars.get_var_vc2 ( pi_prcs_id => l_prcs_id
                                                        , pi_var_name => 'Return_'||p_path
                                                        , pi_sbfl_id => l_sbfl_id
                                                        );
        ut.expect(l_actual_vc2).to_be_not_null();

        -- step forward to End

        test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterTest_'||p_path );    

        -- check workflow has completed

        open l_expected for
            select
            l_dgrm_id                                   as prcs_dgrm_id,
            l_prcs_name                                 as prcs_name,
            flow_constants_pkg.gc_prcs_status_completed as prcs_status
            from dual;
        open l_actual for
            select prcs_dgrm_id, prcs_name, prcs_status 
              from flow_processes p
             where p.prcs_id = l_prcs_id;
        ut.expect( l_actual ).to_equal( l_expected );    

    end if;

    return l_prcs_id;
  end apex_task_test_runner;

  -- test(A - Basic Approval Task - Action Source Table)
  procedure basic_approval_action_source_table
  is
    l_prcs_id   flow_processes.prcs_id%type;
  begin
    l_prcs_id := apex_task_test_runner  ( p_path       => 'A'
                                        , p_source_pk  => '7698'  -- BLAKE
                                        , p_diagram    => g_dgrm_a24a_id
                                        );
    g_prcs_id_a := l_prcs_id;
  end basic_approval_action_source_table;

  -- test(B - Basic Approval Task - Action Source Query)
  procedure basic_approval_action_source_query
  is
    l_prcs_id   flow_processes.prcs_id%type;
  begin
    l_prcs_id := apex_task_test_runner  ( p_path       => 'B'
                                        , p_source_pk  => '7698'  -- BLAKE
                                        , p_diagram    => g_dgrm_a24a_id
                                        );
    g_prcs_id_b := l_prcs_id;
  end basic_approval_action_source_query;

  -- test(C - Basic Approval Task - No Action Source )
  procedure basic_approval_no_action_source
  is
      l_prcs_id   flow_processes.prcs_id%type;
  begin
    l_prcs_id := apex_task_test_runner  ( p_path       => 'C'
                                        , p_source_pk  => null
                                        , p_diagram    => g_dgrm_a24a_id
                                        );
    g_prcs_id_c := l_prcs_id;
  end basic_approval_no_action_source;

    -- test(D - Basic Approval Task - Action Source Table - No PK Provided)
  procedure basic_approval_action_source_table_no_pk
  is
    l_prcs_id   flow_processes.prcs_id%type;
  begin
    l_prcs_id := apex_task_test_runner  ( p_path       => 'A'
                                        , p_source_pk  => null -- missing
                                        , p_diagram    => g_dgrm_a24a_id
                                        , p_expect_error => true
                                        );
    g_prcs_id_d := l_prcs_id;
  end basic_approval_action_source_table_no_pk;

  -- test(E - Basic Approval Task - Action Source Query - No PK Provided)
  procedure basic_approval_action_source_query_no_pk
  is
    l_prcs_id   flow_processes.prcs_id%type;
  begin
    l_prcs_id := apex_task_test_runner  ( p_path       => 'B'
                                        , p_source_pk  => null -- missing
                                        , p_diagram    => g_dgrm_a24a_id
                                        , p_expect_error => true
                                        );
    g_prcs_id_e := l_prcs_id;
  end basic_approval_action_source_query_no_pk;

  -- test(F - Basic Approval Task - Bad Priority Provided)
  procedure basic_approval_action_source_query_bad_priority
  is
    l_prcs_id   flow_processes.prcs_id%type;
  begin
    l_prcs_id := apex_task_test_runner  ( p_path       => 'A'
                                        , p_source_pk  => 7698 -- BLAKE
                                        , p_diagram    => g_dgrm_a24a_id
                                        , p_add_bad_priority => true
                                        , p_expect_error => true
                                        );
    g_prcs_id_f := l_prcs_id;
  end basic_approval_action_source_query_bad_priority;


  --%test(G - Approval Task cancelation when Subflow deleted - legacy <= F4A 24.1)
  procedure approval_task_cleanup_sbfl_deletion
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(2000);
    l_expected_vc2    varchar2(2000);
    l_actual_num      number;
    l_expected_num    number;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_key        flow_subflows.sbfl_step_key%type;
    l_task_id         number;
    l_path            varchar2(20) := 'A';
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a24b_id;
    l_prcs_name   := g_test_prcs_name_b;
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

    -- set the app_id (important for Approval Tasks)

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'Ste24_Test_App_ID'
                              , pi_vc2_value =>  g_human_task_app_id
                              );

    -- set the path proc var & business_ref

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'path'
                              , pi_vc2_value => l_path
                              );
    flow_process_vars.set_business_ref( pi_prcs_id    => l_prcs_id
                                        , pi_vc2_value  => 7839 -- king
                                        , pi_scope      => 0
                                        );                              
    -- check subflow statu
    open l_expected for
       select
          l_prcs_id                                           as sbfl_prcs_id,
          l_dgrm_id                                           as sbfl_dgrm_id,
          'Activity_Setup'                                    as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running            as sbfl_status
       from dual
       union
              select
          l_prcs_id                                           as sbfl_prcs_id,
          l_dgrm_id                                           as sbfl_dgrm_id,
          'Activity_Pre-terminate'                            as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running           as sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ( 'split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- step forward to the approval task

   test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Setup' );     
   test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_PreTest_'||l_path );   

    -- expect APEX Task to be created - check subflow statu
    open l_expected for
       select
          l_prcs_id                                           as sbfl_prcs_id,
          l_dgrm_id                                           as sbfl_dgrm_id,
          'Activity_Approval_A24'||l_path                     as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_approval  as sbfl_status
       from dual
       union
          select
          l_prcs_id                                           as sbfl_prcs_id,
          l_dgrm_id                                           as sbfl_dgrm_id,
          'Activity_Pre-terminate'                            as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running           as sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ( 'split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;   
    -- check for task Id returned

        select sbfl_apex_task_id
          into l_task_id
          from flow_subflows
         where sbfl_prcs_id = l_prcs_id
           and sbfl_current = 'Activity_Approval_A24'||l_path;

    ut.expect(l_task_id).to_be_not_null();     

    -- check task exists in apex


      select state_code
      into l_actual_vc2
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual_vc2).to_equal('UNASSIGNED');

    -- queue the subprocess deletion which should cleanup the approval task -- by terminating the sibling subprocess

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Pre-terminate' );     

    -- check process still running 
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
     
    -- check model is now on step 'AfterSub'
    open l_expected for
       select
          l_prcs_id                                           as sbfl_prcs_id,
          l_dgrm_id                                           as sbfl_dgrm_id,
          'Activity_AfterSub'                                 as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running           as sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ( 'split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;   

    -- check task exists in apex

      select state_code
      into l_actual_vc2
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual_vc2).to_equal('CANCELED');

  end approval_task_cleanup_sbfl_deletion;


  -- test(H - APEX Human Task - Setting Potential Owner and Business Admin
  procedure AHT_set_pot_owner_and_business_admin
  is
   l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_task_id         number;
    l_expected_sbfls  sys.json_element_t;
    l_actual_sbfls    sys.json_element_t;
  begin
    -- get dgrm_id for A25h
    l_dgrm_id := g_dgrm_a24c_id;
    l_prcs_name := g_test_prcs_name_h;
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

    -- set the app_id (important for Approval Tasks)
    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'Ste24_Test_App_ID'
                              , pi_vc2_value =>  g_human_task_app_id
                              );

    -- set the business_ref
    flow_process_vars.set_business_ref( pi_prcs_id    => l_prcs_id
                                        , pi_vc2_value  => '7839' -- king
                                        , pi_scope      => 0
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

    -- check initial subflows running

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Pre' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ( 'split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;
    -- step forward to the APEX Task
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Pre' );
    -- check subflow status
    l_expected_sbfls := sys.json_element_t.parse('
    [
      {"current":"Activity_Action_A","iteration_type":null,"iteration_path":null,"status":"waiting for approval"}
    ]
    ');
    l_actual_sbfls := get_current_sbfl_list(p_prcs_id => l_prcs_id);
    ut.expect( l_actual_sbfls ).to_equal( l_expected_sbfls );
    -- check for task Id returned

        select sbfl_apex_task_id
          into l_task_id
          from flow_subflows
         where sbfl_prcs_id = l_prcs_id
           and sbfl_id      = test_helper.get_sbfl_id (pi_prcs_id => l_prcs_id, pi_current => 'Activity_Action_A');

    ut.expect(l_task_id).to_be_not_null();     

    -- check the potential owner and business admin was set correctly on the apex task
    
    open l_expected for 
      select g_approver_user as participant
           , 'POTENTIAL_OWNER' as participant_type
           , 'USER' as identity_type
      from dual
      union all
      select g_testing_user as participant
           , 'BUSINESS_ADMIN' as participant_type
           , 'USER' as identity_type
      from dual;
    open l_actual for
      select participant, participant_type, identity_type
      from apex_task_participants
      where  task_id = l_task_id
      and    participant_type in ('POTENTIAL_OWNER', 'BUSINESS_ADMIN');
    ut.expect(l_actual).to_equal(l_expected).unordered;

    -- check the subject, priority and business ref were set correctly
    open l_expected for 
      select 'Task Subject Assigned from Flows - Task A1' as subject
           , 2 as priority
           , '7839' as detail_pk
      from dual;
    open l_actual for
      select subject, priority, detail_pk
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- check the task is in the correct state
    open l_expected for 
      select 'ASSIGNED' as state_code
           ,  g_approver_user as actual_owner
      from dual;
    open l_actual for
      select state_code, actual_owner
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- change session to the task owner
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
  --  exception
  --    when others then 
  --      null;
    end;
    apex_session.create_session ( p_app_id => g_human_task_app_id 
                                , p_page_id => 3
                                , p_username => g_approver_user 
                                );
    -- complete the task
    apex_human_task.complete_task ( p_task_id => l_task_id);
    -- return to new session as original user
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
    exception
      when others then 
        null;
    end;
    -- check subflow status
    l_expected_sbfls := sys.json_element_t.parse('
    [
      {"current":"Activity_ManagerSubProc","iteration_type":null,"iteration_path":null,"status":"in subprocess"},
      {"current":"Activity_fin_approval","iteration_type":null,"iteration_path":null,"status":"waiting for approval"}
    ]
    ');
    l_actual_sbfls := get_current_sbfl_list(p_prcs_id => l_prcs_id);
    ut.expect( l_actual_sbfls ).to_equal( l_expected_sbfls );
    -- check the task ID was returned
    select sbfl_apex_task_id
      into l_task_id
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_fin_approval';
    ut.expect(l_task_id).to_be_not_null();  
    -- check the task is in the correct state
    open l_expected for 
      select 'ASSIGNED' as state_code
      from dual;
    open l_actual for
      select state_code
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- check the potential owner and business admin was set correctly on the apex task
    open l_expected for 
      select g_approver_user3 as participant
           , 'POTENTIAL_OWNER' as participant_type
           , 'USER' as identity_type
      from dual
      union all
      select g_testing_user as participant
           , 'BUSINESS_ADMIN' as participant_type
           , 'USER' as identity_type
      from dual;
    open l_actual for
      select participant, participant_type, identity_type
      from apex_task_participants
      where  task_id = l_task_id
      and    participant_type in ('POTENTIAL_OWNER', 'BUSINESS_ADMIN');
    ut.expect(l_actual).to_equal(l_expected).unordered;
    -- check the subject, priority and business ref were set correctly
    open l_expected for 
      select 'FIN APPROVAL - TASK B' as subject
           , 4 as priority
           , '7839' as detail_pk
      from dual;
    open l_actual for
      select subject, priority, detail_pk
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- check the task is in the correct state
    open l_expected for 
      select 'ASSIGNED' as state_code
      from dual;
    open l_actual for
      select state_code
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- change session to the approver
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
    exception
      when others then 
        null;
    end;
    apex_session.create_session ( p_app_id => g_human_task_app_id 
                                , p_page_id => 3
                                , p_username => g_approver_user3
                                );
    -- make the approval
    apex_approval.complete_task ( p_task_id => l_task_id
                                , p_outcome => apex_approval.c_task_outcome_approved
                                );
    -- return to new session as original user
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
    exception
      when others then 
        null;
    end;

    -- check workflow has moved forwards
    l_expected_sbfls := sys.json_element_t.parse('
    [
      {"current":"Activity_ManagerSubProc","iteration_type":null,"iteration_path":null,"status":"in subprocess"},
      {"current":"Activity_MgrApprove","iteration_type":null,"iteration_path":null,"status":"waiting for approval"}
    ]
    ');
    l_actual_sbfls := get_current_sbfl_list(p_prcs_id => l_prcs_id);
    ut.expect( l_actual_sbfls ).to_equal( l_expected_sbfls );
    -- check the task ID was returned
    select sbfl_apex_task_id
      into l_task_id
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_MgrApprove';
    ut.expect(l_task_id).to_be_not_null();
    -- check the task is in the correct state
    open l_expected for 
      select 'ASSIGNED' as state_code
      from dual;
    open l_actual for
      select state_code
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- check the potential owner and business admin was set correctly on the apex task
    -- note approver and tester are reversed for this te
    open l_expected for 
      select g_approver_user4 as participant
           , 'POTENTIAL_OWNER' as participant_type
           , 'USER' as identity_type
      from dual
      union all
      select g_approver_user as participant
           , 'BUSINESS_ADMIN' as participant_type
           , 'USER' as identity_type
      from dual;  
    open l_actual for
      select participant, participant_type, identity_type
      from apex_task_participants
      where  task_id = l_task_id
      and    participant_type in ('POTENTIAL_OWNER', 'BUSINESS_ADMIN');
    ut.expect(l_actual).to_equal(l_expected).unordered;
    -- check the subject, priority and business ref were set correctly
    open l_expected for 
      select 'Manager Approval Subject from F4A' as subject
           , 1 as priority
           , '7839' as detail_pk
      from dual;
    open l_actual for
      select subject, priority, detail_pk
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- check the task is in the correct state
    open l_expected for 
      select 'ASSIGNED' as state_code
      from dual;
    open l_actual for
      select state_code
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- change session to the approver
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
    exception
      when others then 
        null;
    end;
    ut.expect( v('APP_SESSION')).to_be_null;

    apex_session.create_session ( p_app_id => g_human_task_app_id 
                                , p_page_id => 3
                                , p_username => g_approver_user4
                                );
    -- make the approval
    apex_approval.complete_task ( p_task_id => l_task_id
                                , p_outcome => apex_approval.c_task_outcome_approved
                                );
    -- return to new session as original user
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
    exception
      when others then 
        null;
    end;

    ut.expect( v('APP_SESSION')).to_be_null;
    -- check workflow has moved forwards
    l_expected_sbfls := sys.json_element_t.parse('
    [
      {"current":"Activity_VP_Approval","iteration_type":null,"iteration_path":null,"status":"waiting for approval"}
    ]
    ');
    l_actual_sbfls := get_current_sbfl_list(p_prcs_id => l_prcs_id);
    ut.expect( l_actual_sbfls ).to_equal( l_expected_sbfls );
    -- check the task ID was returned
    select sbfl_apex_task_id
      into l_task_id
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_VP_Approval';
    ut.expect(l_task_id).to_be_not_null();
    -- check the task is in the correct state
    open l_expected for 
      select 'ASSIGNED' as state_code
      from dual;
    open l_actual for
      select state_code
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- check the potential owner and business admin was set correctly on the apex task
    open l_expected for 
      select g_approver_user as participant
           , 'POTENTIAL_OWNER' as participant_type
           , 'USER' as identity_type
      from dual
      union all
      select g_testing_user as participant
           , 'BUSINESS_ADMIN' as participant_type
           , 'USER' as identity_type
      from dual;
    open l_actual for
      select participant, participant_type, identity_type
      from apex_task_participants
      where  task_id = l_task_id
      and    participant_type in ('POTENTIAL_OWNER', 'BUSINESS_ADMIN');
    ut.expect(l_actual).to_equal(l_expected).unordered;
    -- check the subject, priority (not set) and business ref were set correctly
    open l_expected for 
      select 'VP Approval' as subject
           , 3 as priority
           , '7839' as detail_pk
      from dual;
    open l_actual for
      select subject, priority, detail_pk
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- check the task is in the correct state
    open l_expected for 
      select 'ASSIGNED' as state_code
      from dual;
    open l_actual for
      select state_code
      from apex_tasks
      where  task_id = l_task_id;
    ut.expect(l_actual).to_equal(l_expected);
    -- change session to the approver
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
    exception
      when others then 
        null;
    end;    
    apex_session.create_session ( p_app_id => g_human_task_app_id 
                                , p_page_id => 3
                                , p_username => g_approver_user 
                                );
    -- make the approval
    apex_approval.complete_task ( p_task_id => l_task_id
                                , p_outcome => apex_approval.c_task_outcome_approved
                                );
    -- return to new session as original user
    begin
      IF v('APP_SESSION') IS NOT NULL THEN
        apex_session.delete_session;
      END IF;
    exception
      when others then 
        null;
    end;
    -- check workflow has moved forwards
    l_expected_sbfls := sys.json_element_t.parse('
    [
      {"current":"Activity_Order_Laptop","iteration_type":null,"iteration_path":null,"status":"running"}
    ]
    ');
    l_actual_sbfls := get_current_sbfl_list(p_prcs_id => l_prcs_id);
    ut.expect( l_actual_sbfls ).to_equal( l_expected_sbfls );
    -- step forward to the end
    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Order_Laptop' );
    -- check workflow has completed
    open l_expected for
        select
        l_dgrm_id                                   as prcs_dgrm_id,
        l_prcs_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );
  end AHT_set_pot_owner_and_business_admin;

  function apex_task_test_runner_251 -- forlegacy APEX Task tests 25.1+  with new plugin)
  ( p_path              varchar2
  , p_outer_path        varchar2
  , p_test              varchar2
  , p_source_pk         varchar2 default null
  , p_diagram           flow_diagrams.dgrm_id%type
  , p_add_bad_priority  boolean default false
  , p_expect_error      boolean default false
  , p_client_cancel     boolean default false
  , p_task_expires      boolean default false
  ) return flow_processes.prcs_id%type
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2      varchar2(2000);
    l_expected_vc2    varchar2(2000);
    l_actual_num      number;
    l_expected_num    number;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
    l_sbfl_id         flow_subflows.sbfl_id%type;
    l_step_key        flow_subflows.sbfl_step_key%type;
    l_task_id         number;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := p_diagram;
    l_prcs_name   := 'test 024 - approval task '|| p_test;
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

    -- set the app_id (important for Approval Tasks)

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'Ste24_Test_App_ID'
                              , pi_vc2_value =>  g_human_task_app_id
                              );

    -- set the path proc var

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'path'
                              , pi_vc2_value => p_path
                              );
    -- set the outer path proc var 
    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'OuterPath'
                              , pi_vc2_value => p_outer_path
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

    --get the subflow id

    select sbfl_id
      into l_sbfl_id
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_Setup';

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Setup');  

    -- check on correct path

    open l_expected for
       select
          l_prcs_id                   as sbfl_prcs_id,
          l_dgrm_id                   as sbfl_dgrm_id,
          'Activity_PreTest_'||p_path as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split' , 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- set the BUSINESS REF if a test requiring a PK

    if p_source_pk is not null then
      flow_process_vars.set_business_ref( pi_prcs_id    => l_prcs_id
                                        , pi_vc2_value  => p_source_pk
                                        , pi_scope      => 0
                                        );
    end if;

    if p_add_bad_priority then
      flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                                , pi_var_name => 'Default_test_priority'
                                , pi_vc2_value => '7' );
    end if;

    -- step forward into APEX task

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_PreTest_'||p_path );      

    -- if p_error_expected then

    if p_expect_error then 

        -- check subflow status

        open l_expected for
           select
              l_prcs_id                                           as sbfl_prcs_id,
              l_dgrm_id                                           as sbfl_dgrm_id,
              'Activity_Approval_A24'||p_path                     as sbfl_current,
              flow_constants_pkg.gc_sbfl_status_error             as sbfl_status
           from dual;

        open l_actual for
           select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
           from flow_subflows 
           where sbfl_prcs_id = l_prcs_id
           and sbfl_status not like 'split';
        ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    else 

        -- expect APEX Task to be created - check subflow status

        open l_expected for
           select
              l_prcs_id                                           as sbfl_prcs_id,
              l_dgrm_id                                           as sbfl_dgrm_id,
              'Activity_Approval_A24'||p_path                     as sbfl_current,
              flow_constants_pkg.gc_sbfl_status_waiting_approval  as sbfl_status
           from dual;

        open l_actual for
           select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
           from flow_subflows 
           where sbfl_prcs_id = l_prcs_id
           and sbfl_status not in( 'split', 'in subprocess');
        ut.expect( l_actual ).to_equal( l_expected ).unordered;    

        -- check for task Id returned

        select sbfl_apex_task_id
          into l_task_id
          from flow_subflows
         where sbfl_prcs_id = l_prcs_id
           and sbfl_current = 'Activity_Approval_A24'||p_path;

        ut.expect(l_task_id).to_be_not_null();
        -- check potential owner and busines admin were set correctly on the apex task
        open l_expected for 
          select g_approver_user as participant
               , 'POTENTIAL_OWNER' as participant_type
                , 'USER' as identity_type
          from dual
          union all
          select g_testing_user as participant
               , 'BUSINESS_ADMIN' as participant_type
                , 'USER' as identity_type
          from dual;
        open l_actual for
          select participant, participant_type, identity_type
          from apex_task_participants
          where  task_id = l_task_id
          and    participant_type in ('POTENTIAL_OWNER', 'BUSINESS_ADMIN');
        ut.expect(l_actual).to_equal(l_expected).unordered;

        -- test for client side Btask cancelation by the business admin
        if p_client_cancel then
          -- change session to the business admin
          begin
            if v('APP_SESSION') is not null then
              apex_session.delete_session;
            end if;
          exception
            when others then 
              null;
          end;
          apex_session.create_session ( p_app_id => g_human_task_app_id 
                                      , p_page_id => 3
                                      , p_username => g_testing_user 
                                      );
          -- cancel the task
          apex_human_task.cancel_task ( p_task_id => l_task_id );
          -- return to new session as original user
          begin
            if v('APP_SESSION') is not null then
              apex_session.delete_session;
            end if;
          exception
            when others then 
              null;
          end;
          -- check subflow status - did the workflow move forward?

          open l_expected for
             select
                l_prcs_id                     as sbfl_prcs_id,
                l_dgrm_id                     as sbfl_dgrm_id,
                'Activity_AfterSub' as sbfl_current,
                flow_constants_pkg.gc_sbfl_status_running sbfl_status
             from dual;
          open l_actual for
             select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
             from flow_subflows 
             where sbfl_prcs_id = l_prcs_id
             and sbfl_status not like 'split';
          ut.expect( l_actual ).to_equal( l_expected ).unordered;
        elsif p_task_expires then
          -- sleep for 10 seconds then force expiration
          -- note: task expires after PT5S, but setting this to sleep to less than 10s causes test to fail
          dbms_session.sleep(10);
          apex_human_task.handle_task_deadlines;
          dbms_session.sleep(3);
          -- check subflow status - did the workflow move forward?
          open l_expected for
             select
                l_prcs_id                     as sbfl_prcs_id,
                l_dgrm_id                     as sbfl_dgrm_id,
                'Activity_AfterSub' as sbfl_current,
                flow_constants_pkg.gc_sbfl_status_running sbfl_status
             from dual;
          open l_actual for
             select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
             from flow_subflows 
             where sbfl_prcs_id = l_prcs_id
             and sbfl_status not like 'split';    
          ut.expect( l_actual ).to_equal( l_expected ).unordered;
          -- check task was set to EXPIRED
          select state_code
            into l_actual_vc2
            from apex_tasks
           where  task_id = l_task_id;
          ut.expect(l_actual_vc2).to_equal('EXPIRED');
        else
          -- change session to the approver
          begin
            apex_session.delete_session;
          exception
            when others then 
              null;
          end;
          apex_session.create_session ( p_app_id => g_human_task_app_id 
                                      , p_page_id => 3
                                      , p_username => g_approver_user 
                                      );
          -- make the approval
          apex_approval.complete_task ( p_task_id => l_task_id
                                      , p_outcome => apex_approval.c_task_outcome_approved
                                      , p_autoclaim => true
                                      );
          -- return to new session as original user
          begin
            apex_session.delete_session;
          exception
            when others then 
              null;
          end;
          --apex_session.create_session ( p_app_id => g_human_task_app_id 
          --                            , p_page_id => 3
          --                            , p_username => g_testing_user 
          --                            );              
          -- check workflow has moved forwards

          open l_expected for
             select
                l_prcs_id                     as sbfl_prcs_id,
                l_dgrm_id                     as sbfl_dgrm_id,
                'Activity_AfterSub' as sbfl_current,
                flow_constants_pkg.gc_sbfl_status_running sbfl_status
             from dual;

          open l_actual for
             select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
             from flow_subflows 
             where sbfl_prcs_id = l_prcs_id
             and sbfl_status not like 'split';
          ut.expect( l_actual ).to_equal( l_expected ).unordered;    

          -- check result was returned

          l_actual_vc2 :=   flow_process_vars.get_var_vc2 ( pi_prcs_id => l_prcs_id
                                                          , pi_var_name => 'Return_'||p_path
                                                          , pi_sbfl_id => l_sbfl_id
                                                          );
          ut.expect(l_actual_vc2).to_be_not_null();
  
        end if; 
        -- step forward to End

        test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterSub' ); 
        -- check workflow has completed

        open l_expected for
            select
            l_dgrm_id                                   as prcs_dgrm_id,
            l_prcs_name                                 as prcs_name,
            flow_constants_pkg.gc_prcs_status_completed as prcs_status
            from dual;
        open l_actual for
            select prcs_dgrm_id, prcs_name, prcs_status 
              from flow_processes p
             where p.prcs_id = l_prcs_id;
        ut.expect( l_actual ).to_equal( l_expected );    

    end if;

    return l_prcs_id;
  end apex_task_test_runner_251;

  -- test(I - APEX Human Task - Client Side Task Cancelation)
  procedure AHT_client_side_task_cancelation
  is
    l_prcs_id   flow_processes.prcs_id%type;
    l_task_id   number; 
  begin
    l_prcs_id := apex_task_test_runner_251
                 ( p_path              => 'A'
                 , p_outer_path        => 'Tasks'
                 , p_test              => 'I'
                 , p_source_pk         => '7839' -- king
                 , p_diagram           => g_dgrm_a24d_id
                 , p_add_bad_priority  => false
                 , p_expect_error      => false
                 , p_client_cancel     => true
                 );
    g_prcs_id_i := l_prcs_id;
  end AHT_client_side_task_cancelation;


  -- test(J - APEX Human Task - Client Side Task Expiration)
  procedure AHT_client_side_task_expiration
  is
    l_prcs_id   flow_processes.prcs_id%type;
    l_task_id   number; 
  begin
    l_prcs_id := apex_task_test_runner_251
                 ( p_path              => 'B'
                 , p_outer_path        => 'Tasks'
                 , p_test              => 'I'
                 , p_source_pk         => '7839' -- king
                 , p_diagram           => g_dgrm_a24d_id
                 , p_add_bad_priority  => false
                 , p_expect_error      => false
                 , p_client_cancel     => false
                 , p_task_expires      => true
                 );
    g_prcs_id_i := l_prcs_id;
  end AHT_client_side_task_expiration;


  -- test(K - APEX Human Task - Client Side Task Error State)
  -- disabled
  procedure AHT_client_side_task_error_state   
  -- note:  error task action not currently implemented in APEX 24.1/24.2
  is
  begin
    null;
  end AHT_client_side_task_error_state;


  --afterall
  procedure tear_down_tests  
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_h,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_i,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_j,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_k,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
   
    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_024_usertask_approval_task;
/
