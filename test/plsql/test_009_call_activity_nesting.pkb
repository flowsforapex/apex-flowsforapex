create or replace package body test_009_call_Activity_nesting as
/* 
-- Flows for APEX - test_009_call_Activity_nesting.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 23-Aug-2022   Richard Allen - Oracle
--
*/

  -- uses models 09a-w (eventually)

  -- suite(Call Activity Nesting)
  -- rollback(manual)

  -- beforeall
  procedure set_up_tests as
  begin
    null;
  end set_up_tests;

  -- test(1. deeply nested call ends)
  procedure deep_standard_ends  as
  begin
    null;
  end deep_standard_ends;


  -- test(2. deeply nested parallel gateway merges)
  procedure deep_parallel_gw_merges as
  begin
    null;
  end deep_parallel_gw_merges;


  -- test(3. deeply nested subprocess ends)
  procedure deep_subproc_ends as
  begin
    null;
  end deep_subproc_ends;


  -- test(4. deeply nested callActivity ends)
  procedure deep_callActivity_end as
  begin
    null;
  end deep_callActivity_end;


  -- test(5. consequtive deep calls)
  procedure conseq_deep_ends as
  begin
    null;
  end conseq_deep_ends;


  -- test(6. direct recursive call)
  procedure direct_recursion as
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    l_test_name flow_processes.prcs_name%type;
    l_dgrm_id_w    flow_diagrams.dgrm_id%type;
    test_dgrm_id_name_w  flow_diagrams.dgrm_name%type;
  begin
    
    -- set up test
    test_dgrm_id_name_w  := 'A09w - Self Calling';

    l_dgrm_id_w := test_helper.set_dgrm_id( pi_dgrm_name => test_dgrm_id_name_w );

    l_test_name := 'Test 09 w Self Calling';

    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => l_dgrm_id_w);

    -- create instance

    test_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => l_dgrm_id_w
     , pi_prcs_name => l_test_name
    );

    -- Should result in an error if called diagram is set to 'not Callable'
   
  end direct_recursion;


  -- test(7a. indirect recursion a)
  procedure indirect_recursion_a as
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    l_test_name flow_processes.prcs_name%type;
    l_dgrm_id_p    flow_diagrams.dgrm_id%type;
    test_dgrm_id_name_p  flow_diagrams.dgrm_name%type;
  begin
    
    -- set up test
    test_dgrm_id_name_p  := 'A09p - Recursive Chain PQP Top';

    l_dgrm_id_p := test_helper.set_dgrm_id( pi_dgrm_name => test_dgrm_id_name_p );

    l_test_name := 'Test 09 pq Indirect Recursion a';

    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => l_dgrm_id_p);

    -- create instance

    test_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => l_dgrm_id_p
     , pi_prcs_name => l_test_name
    );

    -- Should result in an error if called diagram is set to 'not Callable'
  end indirect_recursion_a;


  -- test(7b. indirect recursion b)
  procedure indirect_recursion_b as
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    l_test_name flow_processes.prcs_name%type;
    l_dgrm_id_r    flow_diagrams.dgrm_id%type;
    test_dgrm_id_name_r  flow_diagrams.dgrm_name%type;
  begin
    
    -- set up test
    test_dgrm_id_name_r  := 'A09r - Recursive Chain RSTR Top';

    l_dgrm_id_r := test_helper.set_dgrm_id( pi_dgrm_name => test_dgrm_id_name_r );

    l_test_name := 'Test 09 rstr Indirect Recursion b';

    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => l_dgrm_id_r);

    -- create instance

    test_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => l_dgrm_id_r
     , pi_prcs_name => l_test_name
    );

  end indirect_recursion_b;


  -- test(8. call non-callable diagram)
  procedure call_non_callable 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    l_test_name flow_processes.prcs_name%type;
    l_dgrm_id_u    flow_diagrams.dgrm_id%type;
    l_dgrm_id_v    flow_diagrams.dgrm_id%type;
    test_dgrm_id_name_u  flow_diagrams.dgrm_name%type;
    test_dgrm_id_name_v  flow_diagrams.dgrm_name%type;
  begin
    
    -- set up test
    test_dgrm_id_name_u  := 'A09u - Calling non-callable diagram';
    test_dgrm_id_name_v  := 'A09v - Called Non-Callable Model';

    l_dgrm_id_u := test_helper.set_dgrm_id( pi_dgrm_name => test_dgrm_id_name_u );
    l_dgrm_id_v := test_helper.set_dgrm_id( pi_dgrm_name => test_dgrm_id_name_v );

    l_test_name := 'Test 09 uv Non-Callable Diagram';

    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => l_dgrm_id_u);
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => l_dgrm_id_v);

    -- create instance

    test_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => l_dgrm_id_u
     , pi_prcs_name => l_test_name
    );

    -- start process and check running status
    
    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        l_dgrm_id_u                                 as prcs_dgrm_id,
        l_test_name                                 as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check 1st subflow running
   
      open l_expected for
         select
            test_prcs_id           as sbfl_prcs_id,
            l_dgrm_id_u            as sbfl_dgrm_id,
            'Activity_TaskA'       as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual  
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step model forward into set A 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_TaskA');   

    -- Should result in an error if called diagram is set to 'not Callable'
   


  end call_non_callable;


  -- should probably add tests on versions, non-existant diagrams, etc.

  -- afterall
  procedure tear_down_tests as
  begin
    null;
  end tear_down_tests;


end test_009_call_Activity_nesting;
/
