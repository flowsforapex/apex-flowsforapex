create or replace package body test_022_usertask_misc as
/* 
-- Flows for APEX - test_022_usertask_misc.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 09-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 22a-

  --  suite(22 Usertask Misc Features)
  g_model_a22a constant varchar2(100) := 'A22a - UserTask - Settings Substitution';
  g_model_a22b constant varchar2(100) := 'A22b - Other Task Types';
  g_model_a22c constant varchar2(100) := 'A22c -';
  g_model_a22d constant varchar2(100) := 'A22d -';
  g_model_a22e constant varchar2(100) := 'A22e -';
  g_model_a22f constant varchar2(100) := 'A22f -';
  g_model_a22g constant varchar2(100) := 'A22g -';

  g_test_prcs_name_a constant varchar2(100) := 'test 022 - usertask misc a';
  g_test_prcs_name_b constant varchar2(100) := 'test 022 - usertask misc b';
  g_test_prcs_name_c constant varchar2(100) := 'test 022 - usertask misc c';
  g_test_prcs_name_d constant varchar2(100) := 'test 022 - usertask misc d';
  g_test_prcs_name_e constant varchar2(100) := 'test 022 - usertask misc e';
  g_test_prcs_name_f constant varchar2(100) := 'test 022 - usertask misc f';
  g_test_prcs_name_g constant varchar2(100) := 'test 022 - usertask misc g';

  g_prcs_id_a1      flow_processes.prcs_id%type;
  g_prcs_id_a2      flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a22a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a22b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a22c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a22d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a22e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a22f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a22g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a22a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a22a );
    g_dgrm_a22b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a22b );
    --g_dgrm_a22c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a22c );
    --g_dgrm_a22d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a22d );
    --g_dgrm_a22e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a22e );
    --g_dgrm_a22f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a22f );
    --g_dgrm_a22g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a22g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a22a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a22b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a22c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a22d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a22e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a22f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a22g_id);

  end set_up_tests; 

------------------------------------------------------------------------------------------------
--
-- tests A - Usertask Page Task parameter substitutions
--
------------------------------------------------------------------------------------------------

  -- test_runner usertask pagetask substitution runner
  function pagetask_substitution_runner
  ( p_path    varchar2
  , p_app_id  varchar2
  , p_page_id varchar2
  , p_request varchar2
  , p_cache   varchar2
  , p_items   varchar2
  , p_values  varchar2
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
    l_dgrm_id     := g_dgrm_a22a_id;
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
       and sbfl_current = 'Activity_Pre_Test';

    -- set the path proc var

    flow_process_vars.set_var ( pi_prcs_id => l_prcs_id
                              , pi_var_name => 'App_to_Call'
                              , pi_vc2_value => p_path
                              );

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Pre_Test');  

    -- check process variables set correctly                       
    open l_expected for
      select 'app_id' as name
           , 'VARCHAR2' as type
           , p_app_id as val
      from dual
      union
      select 'page_id' as name
           , 'VARCHAR2' as type
           , p_page_id as val
      from dual
      union
      select 'request' as name
           , 'VARCHAR2' as type
           , p_request as val
      from dual
      union
      select 'clear_cache' as name
           , 'VARCHAR2' as type
           , p_cache as val
      from dual
      union
      select 'items' as name
           , 'VARCHAR2' as type
           , p_items as val
      from dual
      union
      select 'values' as name
           , 'VARCHAR2' as type
           , p_values as val
      from dual;

    open l_actual for 
      select prov.prov_var_name as name
           , prov.prov_var_type as type
           , prov.prov_var_vc2 as val
      from flow_process_variables prov
      where prov.prov_prcs_id = l_prcs_id
      and prov.prov_var_name != 'App_to_Call';
    ut.expect(l_actual).to_equal(l_expected).unordered;

    -- step forward to usertask

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Setup'||p_path );      

    -- check current task is the UserTask

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_chosen_usertask' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;    

    -- check page link in the task inbox

     l_expected_vc2 := apex_page.get_url(p_application  => p_app_id,
                               p_page  => p_page_id,
                               p_request  => p_request,
                               p_clear_cache  => p_cache,
                               p_items  => p_items,
                               p_values  => p_values);

      select link_text 
      into l_actual_vc2
      from flow_task_inbox_vw
      where sbfl_prcs_id = l_prcs_id;
    ut.expect(l_actual_vc2).to_equal(l_expected_vc2);

    return l_prcs_id;
  end pagetask_substitution_runner;


  -- test(A1 - Usertask Page Task parameter substitutions)
  procedure pagetask_substitutions_1
  is
  begin
    g_prcs_id_a1 := pagetask_substitution_runner ( p_path        => 'A'
                                                , p_app_id      => '100'
                                                , p_page_id     => '1'
                                                , p_request     => 'SUBMIT'
                                                , p_cache       => '1'
                                                , p_items       => 'item1'
                                                , p_values      => 'value1'
                                                );
  end pagetask_substitutions_1;

  -- test(A2 - Usertask Page Task parameter substitutions)
  procedure pagetask_substitutions_2
  is
  begin
    g_prcs_id_a2 := pagetask_substitution_runner ( p_path        => 'B'
                                                , p_app_id      => '200'
                                                , p_page_id     => '2'
                                                , p_request     => 'UPDATE'
                                                , p_cache       => '2'
                                                , p_items       => 'item2'
                                                , p_values      => 'value2'
                                                );
  end pagetask_substitutions_2;

  --------------------------------------------------------------------------------------------------------------
  --
  -- Other Task Basics
  --
  --------------------------------------------------------------------------------------------------------------

  procedure other_tasks_basic
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
    l_dgrm_id     := g_dgrm_a22b_id;
    l_prcs_name   := g_test_prcs_name_b;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_b  := l_prcs_id;
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

    -- check subflow status

    open l_expected for
       select
          l_prcs_id                   as sbfl_prcs_id,
          l_dgrm_id                   as sbfl_dgrm_id,
          'Activity_PreTest'          as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;        

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_PreTest');  

    -- Check Manual Task

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

    -- check subflow status

    open l_expected for
       select
          l_prcs_id                                 as sbfl_prcs_id,
          l_dgrm_id                                 as sbfl_dgrm_id,
          'Activity_Manual'                         as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;        

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Manual');      

    -- Check BRT - will run through to After_BRT    

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

    -- check subflow status

    open l_expected for
       select
          l_prcs_id                   as sbfl_prcs_id,
          l_dgrm_id                   as sbfl_dgrm_id,
          'Activity_After_BRT_PLSQL'  as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;        

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_After_BRT_PLSQL');    

    -- Check ServiceTask PLSQL - will run through to After_Service_PLSQL   

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

    -- check subflow status

    open l_expected for
       select
          l_prcs_id                   as sbfl_prcs_id,
          l_dgrm_id                   as sbfl_dgrm_id,
          'Activity_After_Service_PLSQL'  as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;        

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_After_Service_PLSQL');          

    -- Check ScriptTask - will run through to After_ScriptTask  

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

    -- check subflow status

    open l_expected for
       select
          l_prcs_id                   as sbfl_prcs_id,
          l_dgrm_id                   as sbfl_dgrm_id,
          'Activity_After_Script_PLSQL'  as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;        

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_After_Script_PLSQL');  

    -- complete the workflow  

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


  end other_tasks_basic;

  --afterall
  procedure tear_down_tests  
  is
  begin
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a1,  p_comment  => 'Ran by utPLSQL as Test Suite 022');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a2,  p_comment  => 'Ran by utPLSQL as Test Suite 022');
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,   p_comment  => 'Ran by utPLSQL as Test Suite 022');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,  p_comment  => 'Ran by utPLSQL as Test Suite 022');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,  p_comment  => 'Ran by utPLSQL as Test Suite 022');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,  p_comment  => 'Ran by utPLSQL as Test Suite 022');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,  p_comment  => 'Ran by utPLSQL as Test Suite 022');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,  p_comment  => 'Ran by utPLSQL as Test Suite 022');


    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_022_usertask_misc;
/
