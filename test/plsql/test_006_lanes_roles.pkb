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
  g_model_a06c constant varchar2(100) := 'A06c - Lanes and Assignment - Lanes with SubProcs';
  g_model_a06d constant varchar2(100) := 'A06d - Lanes and Assignment - No Lanes';
  g_model_a06e constant varchar2(100) := 'A06e - Lanes and Assignment - No Lanes calls Laned Dgrm';
  g_model_a06f constant varchar2(100) := 'A06f - Lanes and Assignment - Lanes calling Dgrm';
  g_model_a06g constant varchar2(100) := 'A06g - ';

  g_test_prcs_name_a constant varchar2(100) := 'test - Lanes and roles a';
  g_test_prcs_name_b constant varchar2(100) := 'test - Lanes and roles b';
  g_test_prcs_name_g constant varchar2(100) := 'test - Lanes and roles g';
  g_test_prcs_name_h constant varchar2(100) := 'test - Lanes and roles h';
  g_test_prcs_name_i constant varchar2(100) := 'test - Lanes and roles i';
  g_test_prcs_name_j constant varchar2(100) := 'test - Lanes and roles j';
  g_test_prcs_name_k constant varchar2(100) := 'test - Lanes and roles k';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;
  g_prcs_id_h       flow_processes.prcs_id%type;
  g_prcs_id_i       flow_processes.prcs_id%type;
  g_prcs_id_j       flow_processes.prcs_id%type;
  g_prcs_id_k       flow_processes.prcs_id%type;

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
    g_dgrm_a06c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06c );
    g_dgrm_a06d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06d );
    g_dgrm_a06e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06e );
    g_dgrm_a06f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06f );
    --g_dgrm_a06g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a06g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06b_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06c_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06d_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06e_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a06g_id);

  end set_up_tests; 

  -- test(A - Child Lanesets)
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

  --Test C: lane parsing on diagrams with lanes)
  procedure parse_diagram_with_lanes1
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a06c_id;

    -- verify no of object parsed from diagram
      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id;
      ut.expect( l_actual ).to_have_count( 26 );

    -- verify no of items with lanes
      open l_actual for
        select * 
          from   flow_objects
         where  objt_dgrm_id = test_dgrm_id
           and  objt_objt_lane_id is not null;
      ut.expect( l_actual ).to_have_count( 9 );


    -- verify no of lane objects parsed

      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id
          and  objt_tag_name = flow_constants_pkg.gc_bpmn_lane;
      ut.expect( l_actual ).to_have_count( 5 );

    -- verify no of childlaneset objects parsed

      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id
          and  objt_tag_name = flow_constants_pkg.gc_bpmn_child_lane_set;
      ut.expect( l_actual ).to_have_count( 1 );

    -- verify non-lane objects have expected lanes
      open l_expected for 
        select 'Activity_A' as objt, 'LaneA' as lane from dual
        union
        select 'Activity_AfterCall' as objt, 'LaneC2' as lane from dual
        union
        select 'Activity_B1' as objt, 'LaneB' as lane from dual
        union  
        select 'Activity_B2' as objt, 'LaneB' as lane from dual
        union  
        select 'Activity_C' as objt, 'LaneC1' as lane from dual
        union  
        select 'Activity_CallA06d' as objt, 'LaneC2' as lane from dual
        union  
        select 'Event_Start' as objt, 'LaneA' as lane from dual
        union  
        select 'Event_End' as objt, 'LaneC1' as lane from dual
        union  
        select 'Gateway_CallCallActivity' as objt, 'LaneC1' as lane from dual
        ;
      open l_actual for
        select objt.objt_bpmn_id as objt, lane.objt_name as lane
        from flow_objects objt
        join flow_objects lane
          on objt.objt_objt_lane_id = lane.objt_id
       where objt.objt_dgrm_id =  test_dgrm_id
         and objt.objt_objt_lane_id is not null;
      ut.expect (l_actual).to_equal(l_expected).unordered;

  end parse_diagram_with_lanes1;

  --Test D: lane parsing on diagrams with lanes2)

  procedure parse_diagram_with_lanes2
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a06f_id;
    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => test_dgrm_id);

    -- verify no of object parsed from diagram
      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id;
      ut.expect( l_actual ).to_have_count( 18 );

    -- verify no of items with lanes
      open l_actual for
        select * 
          from   flow_objects
         where  objt_dgrm_id = test_dgrm_id
           and  objt_objt_lane_id is not null;
      ut.expect( l_actual ).to_have_count( 5 );


    -- verify no of lane objects parsed

      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id
          and  objt_tag_name = flow_constants_pkg.gc_bpmn_lane;
      ut.expect( l_actual ).to_have_count( 2 );

    -- verify non-lane objects have expected lanes
      open l_expected for 
        select 'Activity_A' as objt, 'LaneX' as lane from dual
        union
        select 'Activity_B' as objt, 'LaneY' as lane from dual
        union
        select 'Activity_Y' as objt, 'LaneY' as lane from dual
        union    
        select 'Event_Start' as objt, 'LaneX' as lane from dual
        union  
        select 'Event_End' as objt, 'LaneY' as lane from dual
        ;
      open l_actual for
        select objt.objt_bpmn_id as objt, lane.objt_name as lane
        from flow_objects objt
        join flow_objects lane
          on objt.objt_objt_lane_id = lane.objt_id
       where objt.objt_dgrm_id =  test_dgrm_id
         and objt.objt_objt_lane_id is not null;
      ut.expect (l_actual).to_equal(l_expected).unordered;

  end parse_diagram_with_lanes2;

  --Test E: lane parsing on diagrams without lanes1
  procedure parse_diagram_without_lanes1
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a06d_id;
    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => test_dgrm_id);

    -- verify no of object parsed from diagram
      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id;
      ut.expect( l_actual ).to_have_count( 15 );

    -- verify no of items with lanes
      open l_actual for
        select * 
          from   flow_objects
         where  objt_dgrm_id = test_dgrm_id
           and  objt_objt_lane_id is not null;
      ut.expect( l_actual ).to_have_count( 0 );


    -- verify no of lane objects parsed

      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id
          and  objt_tag_name = flow_constants_pkg.gc_bpmn_lane;
      ut.expect( l_actual ).to_have_count( 0 );

    -- verify non-lane objects have expected lanes

      open l_actual for
        select objt.objt_bpmn_id as objt, lane.objt_name as lane
        from flow_objects objt
        join flow_objects lane
          on objt.objt_objt_lane_id = lane.objt_id
       where objt.objt_dgrm_id =  test_dgrm_id
         and objt.objt_objt_lane_id is not null;
      ut.expect (l_actual).to_be_empty;
  end parse_diagram_without_lanes1;

  --Test F: lane parsing on model without lanes2
  procedure parse_diagram_without_lanes2
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a06e_id;
    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => test_dgrm_id);

    -- verify no of object parsed from diagram
      open l_actual for
        select *
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id;
      ut.expect( l_actual ).to_have_count( 6 );

    -- verify no of items with lanes
      open l_actual for
        select * 
          from   flow_objects
         where  objt_dgrm_id = test_dgrm_id
           and  objt_objt_lane_id is not null;
      ut.expect( l_actual ).to_have_count( 0 );


    -- verify no of lane objects parsed

      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id
          and  objt_tag_name = flow_constants_pkg.gc_bpmn_lane;
      ut.expect( l_actual ).to_have_count( 0 );

    -- verify non-lane objects have expected lanes

      open l_actual for
        select objt.objt_bpmn_id as objt, lane.objt_name as lane
        from flow_objects objt
        join flow_objects lane
          on objt.objt_objt_lane_id = lane.objt_id
       where objt.objt_dgrm_id =  test_dgrm_id
         and objt.objt_objt_lane_id is not null;
      ut.expect (l_actual).to_be_empty;
  end parse_diagram_without_lanes2;

  -- Test G: Lane execution on diagram with no lanes 
  -- Diagram A06d - 

  procedure exec_diagram_without_lanes
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name_g;
  begin
    test_dgrm_id := g_dgrm_a06d_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
    g_prcs_id_g := test_prcs_id;
    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- check task A on LaneA

    open l_expected for
        select
        'A'                        as current_objt,
        null                       as lane_name,
        null                       as isRole,
        null                       as lane_role,
        null                       as potential_users,
        null                       as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        null                       as lane_name,
        null                       as isRole,
        null                       as lane_role,
        'FRED:BILL'                as potential_users,
        'SALES'                    as potential_groups,
        'FRANK'                    as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        null                       as lane_name,
        null                       as isRole,
        null                       as lane_role,
        null                       as potential_users,
        null                       as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual
        union
        select
        'B2B'                      as current_objt,
        null                       as lane_name,
        null                       as isRole,
        null                       as lane_role,
        'BLAKE:CLARK:JONES'        as potential_users,
        'PRESIDENT'                as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual
        ;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;   

    -- Step forward in the Called diagram, completing both parallel paths - returning to end

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B');

    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_be_empty;    

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end exec_diagram_without_lanes;

  --Test H : (lane execution on model with lanes inc subProcesses)
  -- Model A15a with default routing on Gateway_CallCallActivity leading to no Call being made
  procedure exec_diagram_with_lanes 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name_h;
  begin
    test_dgrm_id := g_dgrm_a06c_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
    g_prcs_id_h := test_prcs_id;
    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- check task A on LaneA

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneA'                    as lane_name,
        'true'                     as isRole,
        'ROLE_A'                   as lane_role,
        null                       as potential_users,
        'ROLE_A'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        'SMITH:JONES'              as potential_users,
        'SALES:MARKETING'          as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                     as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );


    -- accept default routing on gateway - step forward and check C on Lane C (checks reversion to specified lane after subproc)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B1');

    open l_expected for
        select
        'C'                        as current_objt,
        'LaneC1'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C1'                  as lane_role,
        null                       as potential_users,
        'ROLE_C1'                  as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- Step forward to end.   Check for Normal completion.

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C');

    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_be_empty;    

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end exec_diagram_with_lanes;


  --Test I : (lane execution on callActivity - both models have lanes)
  -- Model A15d calls Model A15a
  procedure exec_diagram_with_calls_both_have_lanes 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name_i;
  begin
    test_dgrm_id := g_dgrm_a06f_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
    g_prcs_id_i := test_prcs_id;
    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- check task A on LaneX in Calling Diagram

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneX'                    as lane_name,
        null                       as isRole,
        null                       as lane_role,
        null                       as potential_users,
        null                       as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 in Calling Diagram (tests inheritence from parent subProcess)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneY'                    as lane_name,
        'false'                    as isRole,
        null                       as lane_role,
        null                       as potential_users,
        'SALES:MARKETING'          as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward into subProcess and into callActivity - check task A on LaneA in Called Diagram 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneA'                    as lane_name,
        'true'                     as isRole,
        'ROLE_A'                   as lane_role,
        null                       as potential_users,
        'ROLE_A'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB in Called Diagram
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B  in Called Diagram (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        'SMITH:JONES'              as potential_users,
        'SALES:MARKETING'          as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                     as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );


    -- accept default routing on gateway - step forward and check C on Lane C in Called Diagram (checks reversion to specified lane after subproc)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B1');

    open l_expected for
        select
        'C'                        as current_objt,
        'LaneC1'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C1'                  as lane_role,
        null                       as potential_users,
        'ROLE_C1'                  as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward to reurn to calling Process - check Y on Lane B in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C');

    open l_expected for
        select
        'Y'                        as current_objt,
        'LaneY'                    as lane_name,
        'false'                    as isRole,
        null                       as lane_role,
        null                       as potential_users,
        null                       as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- Step forward to end.   Check for Normal completion.

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_Y');

    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_be_empty;    

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

    flow_api_pkg.flow_delete(p_process_id  =>  test_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test 5 for Lane Test');

  end exec_diagram_with_calls_both_have_lanes;

  --Test J : (lane execution on callActivity - only calling model has lanes)
  -- (model A15a calls model A15b with Gateway_CallCallActivity set to Flow_call)
  procedure exec_diagram_with_calls_calling_has_lanes 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name_j;
  begin
    test_dgrm_id := g_dgrm_a06c_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
    g_prcs_id_j := test_prcs_id;
    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- check task A on LaneA

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneA'                    as lane_name,
        'true'                     as isRole,
        'ROLE_A'                   as lane_role,
        null                       as potential_users,
        'ROLE_A'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        'SMITH:JONES'              as potential_users,
        'SALES:MARKETING'          as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                     as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );


    -- set non- default routing on gateway to go into callActivity and call model A15b 
    -- then step forward and check C on Lane C (checks reversion to specified lane after subproc)

    flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                              , pi_var_name => 'Gateway_CallCallActivity:route'
                              , pi_vc2_value => 'Flow_call'
                              , pi_scope => 0);
    
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B1');

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneC2'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C2'                  as lane_role,
        null                       as potential_users,
        'ROLE_C2'                  as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- Step forward inside the Called diagram, opening subProcess B to Activity_B1 (tests further inheritence ino subProc of calledActivity)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneC2'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C2'                  as lane_role,
        'FRED:BILL'                as potential_users,
        'SALES'                    as potential_groups,
        'FRANK'                    as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

  
    -- Step forward inside the Called diagram, opening subProcess B2 and going parallel
    -- (tests further deep inheritence through parallel gateway inside subProc of calledActivity)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneC2'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C2'                  as lane_role,
        null                       as potential_users,
        'ROLE_C2'                  as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual
        union
        select
        'B2B'                      as current_objt,
        'LaneC2'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C2'                  as lane_role,
        'BLAKE:CLARK:JONES'       as potential_users,
        'PRESIDENT'                as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual
        ;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- Step forward in the Called diagram, completing both parallel paths - returning to calling diagram
    -- (tests return to declared lane)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B');

    open l_expected for
        select
        'AfterCall'                as current_objt,
        'LaneC2'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C2'                  as lane_role,
        null                       as potential_users,
        'ROLE_C2'                  as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );  

    -- Step forward to end.   Check for Normal completion.

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_AfterCall');

    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_be_empty;    

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end exec_diagram_with_calls_calling_has_lanes;

  --Test K : (lane execution on callActivity - only called model has lanes)
  -- model A06e calling Model A15a
  procedure exec_diagram_with_calls_called_has_lanes
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name_k;
  begin
    test_dgrm_id := g_dgrm_a06e_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
    g_prcs_id_k := test_prcs_id;
    flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );

    -- check task X in Calling Diagram

    open l_expected for
        select
        'X'                        as current_objt,
        null                       as lane_name,
        null                       as isRole,
        null                       as lane_role,
        'BILL:TED'                 as potential_users,
        null                       as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_X');

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneA'                    as lane_name,
        'true'                     as isRole,
        'ROLE_A'                   as lane_role,
        null                       as potential_users,
        'ROLE_A'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB in Called Diagram
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B  in Called Diagram (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        'SMITH:JONES'              as potential_users,
        'SALES:MARKETING'          as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                     as current_objt,
        'LaneB'                    as lane_name,
        'true'                     as isRole,
        'ROLE_B'                   as lane_role,
        null                       as potential_users,
        'ROLE_B'                   as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );


    -- accept default routing on gateway - step forward and check C on Lane C in Called Diagram (checks reversion to specified lane after subproc)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B1');

    open l_expected for
        select
        'C'                        as current_objt,
        'LaneC1'                   as lane_name,
        'true'                     as isRole,
        'ROLE_C1'                  as lane_role,
        null                       as potential_users,
        'ROLE_C1'                  as potential_groups,
        null                       as excluded_users,
        null                       as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward to reurn to calling Process - check Z on no Lane in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C');

    open l_expected for
        select
        'Z'                      as current_objt,
        null                     as lane_name,
        null                       as isRole,
        null                       as lane_role,
        'REAPER'                   as potential_users,
        null                       as potential_groups,
        null                       as excluded_users,
        'REAPER'                   as reservation
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt
             , sbfl_current_lane_name as lane_name 
             , sbfl_lane_isrole as isRole
             , sbfl_lane_role as lane_role
             , sbfl_potential_users as potential_users 
             , sbfl_potential_groups as potential_groups 
             , sbfl_excluded_users as excluded_users 
             , sbfl_reservation as reservation 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- Step forward to end.   Check for Normal completion.

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_Z');

    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_be_empty;    

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        test_prcs_name                              as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ); 

  end exec_diagram_with_calls_called_has_lanes;




  --afterall
  procedure tear_down_tests  
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');                             
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_h,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');   
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_i,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');   
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_j,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006');
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_k,
                             p_comment  => 'Ran by utPLSQL as Test Suite 006'); 
    --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,
    --                         p_comment  => 'Ran by utPLSQL as Test Suite 006'); 

    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_006_lanes_roles;
/