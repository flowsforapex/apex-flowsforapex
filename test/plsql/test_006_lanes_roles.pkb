create or replace package body test_006_lanes_roles as
/* 
-- Flows for APEX - test_006_lanes_roles.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 13-Apr-2023   Richard Allen - Oracle
--
*/

  -- uses models 06a-?
  g_model_a06a constant varchar2(100) := 'A06a - Lanes and Assignment - Child Lanesets';
  g_model_a06b constant varchar2(100) := 'A06b - Lanes and Assignment - Roles from Lanes';
  g_model_a06c constant varchar2(100) := 'A06c - ';
  g_model_a06d constant varchar2(100) := 'A06d - ';
  g_model_a06e constant varchar2(100) := 'A06e - ';
  g_model_a06f constant varchar2(100) := 'A06f - ';
  g_model_a06g constant varchar2(100) := 'A06g - ';

  g_test_prcs_name_a constant varchar2(100) := 'test - Lanes and roles a';
  g_test_prcs_name_b constant varchar2(100) := 'test - Lanes and roles b';
  g_test_prcs_name_c constant varchar2(100) := 'test - Lanes and roles c';
  g_test_prcs_name_d constant varchar2(100) := 'test - Lanes and roles d';
  g_test_prcs_name_e constant varchar2(100) := 'test - Lanes and roles e';
  g_test_prcs_name_f constant varchar2(100) := 'test - Lanes and roles f';
  g_test_prcs_name_g constant varchar2(100) := 'test - Lanes and roles g';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a06a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a06b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a06c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a06d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a06e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a06f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a06g_id  flow_diagrams.dgrm_id%type;

  -- suite(06 Lanes and Roles)
  -- rollback(manual)

  -- beforeall
  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a06a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06a );
    g_dgrm_a06b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06b );
    --g_dgrm_a06c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06c );
    --g_dgrm_a06d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06d );
    --g_dgrm_a06e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06e );
    --g_dgrm_a06f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06f );
    --g_dgrm_a06g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06g_id);

  end set_up_tests; 

  -- test(A1 - Child Lanesets)
  procedure child_lanesets
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;

  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a06a_id;
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

    -- check  subflow running and correct lane shown

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA1' as sbfl_current,
          'LaneA1' as sbfl_lane_name,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA1');        

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA2a' as sbfl_current,
          'LaneA2a' as sbfl_lane_name,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA2a');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA2b' as sbfl_current,
          'LaneA2b' as sbfl_lane_name,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA2b');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskB' as sbfl_current,
          'LaneB' as sbfl_lane_name,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;


    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskB');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskC' as sbfl_current,
          'LaneC' as sbfl_lane_name,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskC');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA2b-again' as sbfl_current,
          'LaneA2b' as sbfl_lane_name,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;


    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA2b-again');  

  end child_lanesets;

  procedure lane_roles_with_child_lanesets
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;

  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a06b_id;
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

    -- check  subflow running and correct lane shown

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA1' as sbfl_current,
          'LaneA1' as sbfl_lane_name,
          'false' as sbfl_lane_isRole,
          null as sbfl_lane_role,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_lane_isRole, sbfl_lane_role, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA1');        

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA2a' as sbfl_current,
          'LaneA2a' as sbfl_lane_name,
          'true' as sbfl_lane_isRole,
          'ROLE_A2a' as sbfl_lane_role,
           flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_lane_isRole, sbfl_lane_role, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA2a');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA2b' as sbfl_current,
          'LaneA2b' as sbfl_lane_name,
          'true' as sbfl_lane_isRole,
          'ROLE_A2b' as sbfl_lane_role,
           flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_lane_isRole, sbfl_lane_role, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA2b');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskB' as sbfl_current,
          'LaneB' as sbfl_lane_name,
          'true' as sbfl_lane_isRole,
          'ROLE_B' as sbfl_lane_role,
           flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_lane_isRole, sbfl_lane_role, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;


    -- step forward to next task and check correct lane shown - note LaneC is defined with a NULL role

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskB');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskC' as sbfl_current,
          'LaneC' as sbfl_lane_name,
          'true' as sbfl_lane_isRole,
          null as sbfl_lane_role,
           flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_lane_isRole, sbfl_lane_role, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskC');     

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_TaskA2b-again' as sbfl_current,
          'LaneA2b' as sbfl_lane_name,
          'true' as sbfl_lane_isRole,
          'ROLE_A2b' as sbfl_lane_role,
           flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_lane_name, sbfl_lane_isRole, sbfl_lane_role, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;


    -- step forward to next task and check correct lane shown

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_TaskA2b-again');  

  end lane_roles_with_child_lanesets;

  --afterall
  procedure tear_down_tests  
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');                             
    --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,
    --                         p_comment  => 'Ran by utPLSQL as Test Suite 006');
    --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,
    --                         p_comment  => 'Ran by utPLSQL as Test Suite 006');   
    --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d2,
    --                         p_comment  => 'Ran by utPLSQL as Test Suite 006');   
    --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,
    --                         p_comment  => 'Ran by utPLSQL as Test Suite 006');
    --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,
    --                         p_comment  => 'Ran by utPLSQL as Test Suite 006'); 
    --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,
    --                         p_comment  => 'Ran by utPLSQL as Test Suite 006'); 

    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_006_lanes_roles;
/