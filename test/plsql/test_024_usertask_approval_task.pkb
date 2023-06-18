create or replace package body test_024_usertask_approval_task as
/* 
-- Flows for APEX - test_024_usertask_approval_task.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 18-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 24a
  -- uses APEX App: FA Testing - Suite 024 - Apploval Component Integration

  -- suite(24 usertask - approval task)
  -- rollback(manual)

  g_model_a24a constant varchar2(100) := 'A24a - Approval Component - Basic Operation';
  g_model_a24b constant varchar2(100) := 'A24b - Approval Task - Task Cancelation';
  g_model_a24c constant varchar2(100) := 'A24c -';
  g_model_a24d constant varchar2(100) := 'A24d -';
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

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a24a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a24g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a24a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24a );
    g_dgrm_a24b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24b );
    --g_dgrm_a24c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24c );
    --g_dgrm_a24d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24d );
    --g_dgrm_a24e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24e );
    --g_dgrm_a24f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24f );
    --g_dgrm_a24g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24g_id);

  end set_up_tests;

  function apex_task_test_runner
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

        l_task_id :=      flow_process_vars.get_var_num ( pi_prcs_id => l_prcs_id
                                                        , pi_var_name => 'Activity_Approval_A24'||p_path||':task_id'
                                                        , pi_sbfl_id => l_sbfl_id
                                                        );
        ut.expect(l_task_id).to_be_not_null();

        -- change session to the approver
        begin
          apex_session.delete_session;
        exception
          when others then 
            null;
        end;
        apex_session.create_session ( p_app_id => 106
                                    , p_page_id => 3
                                    , p_username => 'BO'
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
        --apex_session.create_session ( p_app_id => 106
        --                            , p_page_id => 3
        --                            , p_username => 'FLOWSDEV2'
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
        ut.expect(l_task_id).to_be_not_null();

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


  --%test(G - Approval Task cancelation when Subflow deleted)
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
    l_task_id :=      flow_process_vars.get_var_num ( pi_prcs_id => l_prcs_id
                                                    , pi_var_name => 'Activity_Approval_A24'||l_path||':task_id'
                                                    );
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


    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_024_usertask_approval_task;
/
