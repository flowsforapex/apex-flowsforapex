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
  g_model_a24b constant varchar2(100) := 'A24b -';
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
    --g_dgrm_a24b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24b );
    --g_dgrm_a24c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24c );
    --g_dgrm_a24d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24d );
    --g_dgrm_a24e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24e );
    --g_dgrm_a24f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24f );
    --g_dgrm_a24g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a24g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24a_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a24g_id);

  end set_up_tests;

  function apex_task_test_runner
  ( p_path          varchar2
  , p_source_pk     varchar2 default null
  , p_diagram       flow_diagrams.dgrm_id%type
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

    -- step forward into APEX task

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_PreTest_'||p_path );      

    -- check for task Id returned

    l_task_id :=      flow_process_vars.get_var_num ( pi_prcs_id => l_prcs_id
                                                    , pi_var_name => 'Return_'||p_path
                                                    , pi_sbfl_id => l_sbfl_id
                                                    );
    ut.expect(l_task_id).to_be_not_null();
  

    -- make the approval

    apex_approval.complete_task ( p_task_id => l_task_id
                                , p_outcome => apex_approval.c_task_outcome_approved
                                , p_autoclaim => true
                                );


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
 

  --afterall
  procedure tear_down_tests  
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,  p_comment  => 'Ran by utPLSQL as Test Suite 024');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,  p_comment  => 'Ran by utPLSQL as Test Suite 024');


    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_024_usertask_approval_task;
/
