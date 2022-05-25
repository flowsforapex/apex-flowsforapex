create or replace package body test_lanes_parse_execute
as

  g_model_a15a constant varchar2(100) := 'A15a - Single Diagram Lanes with SubProcs';
  g_model_a15b constant varchar2(100) := 'A15b - Single Diagram with No Lanes';
  g_model_a15c constant varchar2(100) := 'A15c - Calling Diagram noLanes calls Diagram with Lanes';
  g_model_a15d constant varchar2(100) := 'A15d - Calling Diagram with Lanes';

  g_test_prcs_name constant varchar2(100) := 'test - Lane parsing & execution';

  g_prcs_id       flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a15a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a15b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a15c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a15d_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a15a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a15a );
    g_dgrm_a15b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a15b );
    g_dgrm_a15c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a15c );
    g_dgrm_a15d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a15d );
 

  end set_up_tests; 

  --Test 1: lane parsing on diagrams with lanes)
  procedure parse_diagram_with_lanes1
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a15a_id;
    -- verify no of object parsed from diagram
      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id;
      ut.expect( l_actual ).to_have_count( 22 );

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
      ut.expect( l_actual ).to_have_count( 3 );

    -- verify non-lane objects have expected lanes
      open l_expected for 
        select 'Activity_A' as objt, 'LaneA' as lane from dual
        union
        select 'Activity_AfterCall' as objt, 'LaneC' as lane from dual
        union
        select 'Activity_B1' as objt, 'LaneB' as lane from dual
        union  
        select 'Activity_B2' as objt, 'LaneB' as lane from dual
        union  
        select 'Activity_C' as objt, 'LaneC' as lane from dual
        union  
        select 'Activity_CallA15b' as objt, 'LaneC' as lane from dual
        union  
        select 'Event_Start' as objt, 'LaneA' as lane from dual
        union  
        select 'Event_End' as objt, 'LaneC' as lane from dual
        union  
        select 'Gateway_CallCallActivity' as objt, 'LaneC' as lane from dual
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

  --Test 2: lane parsing on diagrams with lanes2)

  procedure parse_diagram_with_lanes2
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a15d_id;
    -- verify no of object parsed from diagram
      open l_actual for
        select * 
        from   flow_objects
        where  objt_dgrm_id = test_dgrm_id;
      ut.expect( l_actual ).to_have_count( 17 );

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

  --Test 3: lane parsing on diagrams without lanes1
  procedure parse_diagram_without_lanes1
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a15b_id;
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

  --Test 3b: lane parsing on model without lanes2
  procedure parse_diagram_without_lanes2
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
  begin
    test_dgrm_id := g_dgrm_a15c_id;
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

  -- Test 4: Lane execution on diagram with no lanes 
  -- Diagram A15b - should be fairly trivial case, but just in case!

  procedure exec_diagram_without_lanes
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := 'Lanes - Test 4';
  begin
    test_dgrm_id := g_dgrm_a15b_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
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
        null                       as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        null                       as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        null                       as lane_name
        from dual
        union
        select
        'B2B'                      as current_objt,
        null                       as lane_name
        from dual
        ;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;   

    -- Step forward in the Called diagram, completing both parallel paths - returning to end

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B');

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

    flow_api_pkg.flow_delete(p_process_id  =>  test_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test 4 for Lane Test');

  end exec_diagram_without_lanes;

  --Test 5 : (lane execution on model with lanes inc subProcesses)
  -- Model A15a with default routing on Gateway_CallCallActivity leading to no Call being made
  procedure exec_diagram_with_lanes 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := 'Lanes - Test 5';
  begin
    test_dgrm_id := g_dgrm_a15a_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
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
        'LaneA'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                      as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );


    -- accept default routing on gateway - step forward and check C on Lane C (checks reversion to specified lane after subproc)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B1');

    open l_expected for
        select
        'C'                      as current_objt,
        'LaneC'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- Step forward to end.   Check for Normal completion.

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C');

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

    flow_api_pkg.flow_delete(p_process_id  =>  test_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test 5 for Lane Test');

  end exec_diagram_with_lanes;


  --Test 6 : (lane execution on callActivity - both models have lanes)
  -- Model A15d calls Model A15a
  procedure exec_diagram_with_calls_both_have_lanes 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := 'Lanes - Test 6';
  begin
    test_dgrm_id := g_dgrm_a15d_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
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
        'LaneX'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 in Calling Diagram (tests inheritence from parent subProcess)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneY'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward into subProcess and into callActivity - check task A on LaneA in Called Diagram 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneA'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB in Called Diagram
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B  in Called Diagram (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                      as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );


    -- accept default routing on gateway - step forward and check C on Lane C in Called Diagram (checks reversion to specified lane after subproc)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B1');

    open l_expected for
        select
        'C'                      as current_objt,
        'LaneC'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward to reurn to calling Process - check Y on Lane B in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C');

    open l_expected for
        select
        'Y'                        as current_objt,
        'LaneY'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- Step forward to end.   Check for Normal completion.

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_Y');

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

    flow_api_pkg.flow_delete(p_process_id  =>  test_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test 5 for Lane Test');

  end exec_diagram_with_calls_both_have_lanes;

  --Test 7 : (lane execution on callActivity - only calling model has lanes)
  -- (model A15a calls model A15b with Gateway_CallCallActivity set to Flow_call)
  procedure exec_diagram_with_calls_calling_has_lanes 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := 'Lanes - Test 7';
  begin
    test_dgrm_id := g_dgrm_a15a_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
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
        'LaneA'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                      as current_objt,
        'LaneB'                     as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
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
        'LaneC'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- Step forward inside the Called diagram, opening subProcess B to Activity_B1 (tests further inheritence ino subProc of calledActivity)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                        as current_objt,
        'LaneC'                     as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

  
    -- Step forward inside the Called diagram, opening subProcess B2 and going parallel
    -- (tests further deep inheritence through parallel gateway inside subProc of calledActivity)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                       as current_objt,
        'LaneC'                     as lane_name
        from dual
        union
        select
        'B2B'                       as current_objt,
        'LaneC'                     as lane_name
        from dual
        ;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
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
        'LaneC'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );  

    -- Step forward to end.   Check for Normal completion.

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_AfterCall');

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

    flow_api_pkg.flow_delete(p_process_id  =>  test_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test 7 for Lane Test');

  end exec_diagram_with_calls_calling_has_lanes;

  --Test 8 : (lane execution on callActivity - only called model has lanes)
  -- model A15c calling Model A15a
  procedure exec_diagram_with_calls_called_has_lanes
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type;
    test_prcs_id  flow_processes.prcs_id%type;
    test_prcs_name flow_processes.prcs_name%type := 'Lanes - Test 8';
  begin
    test_dgrm_id := g_dgrm_a15c_id;
    
    -- start an instance - check 1 sbfl running

    test_prcs_id := flow_api_pkg.flow_create
                    ( pi_dgrm_id    => test_dgrm_id
                    , pi_prcs_name  => test_prcs_name
                    );
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
        null                       as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_X');

    open l_expected for
        select
        'A'                        as current_objt,
        'LaneA'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward - check task B1 on LaneB in Called Diagram
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A');

    open l_expected for
        select
        'B1'                       as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into subProcess - check B2A on Lane B  in Called Diagram (tests lane inheritance from parent)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1');

    open l_expected for
        select
        'B2A'                      as current_objt,
        'LaneB'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step into nested subProcess - check B2B1 on Lane B in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');

    open l_expected for
        select
        'B2B1'                      as current_objt,
        'LaneB'                     as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );


    -- accept default routing on gateway - step forward and check C on Lane C in Called Diagram (checks reversion to specified lane after subproc)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B1');

    open l_expected for
        select
        'C'                      as current_objt,
        'LaneC'                    as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
          from flow_subflows_vw
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;
    ut.expect( l_actual ).to_equal( l_expected );

    -- step forward to reurn to calling Process - check Z on no Lane in Called Diagram (tests lane inheritence when further nested)

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C');

    open l_expected for
        select
        'Z'                      as current_objt,
        null                     as lane_name
        from dual;
    open l_actual for
        select sbfl_current_name as current_objt, sbfl_current_lane_name as lane_name 
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

    flow_api_pkg.flow_delete(p_process_id  =>  test_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test 8 for Lane Test');

  end exec_diagram_with_calls_called_has_lanes;

  --%afterall
  procedure tear_down_tests
  is
  begin
    null;
  end tear_down_tests;

end test_lanes_parse_execute;