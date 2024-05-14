create or replace package body test_023_custom_extensions as
/* 
-- Flows for APEX - test_023_custom_extensions.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 16-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 23a-b

  -- suite(23 Custom Extensions)
  g_model_a23a constant varchar2(100) := 'A23a - Custom Extensions';
  g_model_a23b constant varchar2(100) := 'A23b - Custom Extensions - In Lanesets';
  g_model_a23c constant varchar2(100) := 'A23c -';
  g_model_a23d constant varchar2(100) := 'A23d -';
  g_model_a23e constant varchar2(100) := 'A23e -';
  g_model_a23f constant varchar2(100) := 'A23f -';
  g_model_a23g constant varchar2(100) := 'A23g -';

  g_test_prcs_name_a constant varchar2(100) := 'test 023 - custom extensions a';
  g_test_prcs_name_b constant varchar2(100) := 'test 023 - custom extensions b';
  g_test_prcs_name_c constant varchar2(100) := 'test 023 - custom extensions c';
  g_test_prcs_name_d constant varchar2(100) := 'test 023 - custom extensions d';
  g_test_prcs_name_e constant varchar2(100) := 'test 023 - custom extensions e';
  g_test_prcs_name_f constant varchar2(100) := 'test 023 - custom extensions f';
  g_test_prcs_name_g constant varchar2(100) := 'test 023 - custom extensions g';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a23a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a23b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a23c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a23d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a23e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a23f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a23g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a23a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a23a );
    g_dgrm_a23b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a23b );
    --g_dgrm_a23c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a23c );
    --g_dgrm_a23d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a23d );
    --g_dgrm_a23e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a23e );
    --g_dgrm_a23f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a23f );
    --g_dgrm_a23g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a23g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a23a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a23b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a23c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a23d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a23e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a23f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a23g_id);

  end set_up_tests;

  procedure attribute_tester
  ( p_dgrm_id    flow_diagrams.dgrm_id%type
  , p_objt_name  flow_objects.objt_bpmn_id%type
  , p_expected   varchar2
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2     varchar2(2000);
    l_actual_sql     varchar2(2000);
  begin
    open l_actual for 
      select objt.objt_attributes."apex"."customExtension"."object" as actual
        from flow_objects objt
       where objt.objt_name    = p_objt_name
         and objt.objt_dgrm_id = p_dgrm_id;
    open l_expected for
      select p_expected as actual
        from dual;
    ut.expect(l_actual).to_equal(l_expected);
  end attribute_tester;

  procedure attribute_tester
  ( p_dgrm_id         flow_diagrams.dgrm_id%type
  , p_objt_bpmn_name  flow_objects.objt_bpmn_id%type
  , p_expected        varchar2
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2     varchar2(2000);
    l_actual_sql     varchar2(2000);
  begin
    open l_actual for 
      select objt.objt_attributes."apex"."customExtension"."object" as actual
        from flow_objects objt
       where objt.objt_bpmn_id   = p_objt_bpmn_name
         and objt.objt_dgrm_id   = p_dgrm_id;
    open l_expected for
      select p_expected as actual
        from dual;
    ut.expect(l_actual).to_equal(l_expected);
  end attribute_tester;

  procedure attribute_tester
  ( p_dgrm_id         flow_diagrams.dgrm_id%type
  , p_conn_bpmn_name  flow_connections.conn_bpmn_id%type
  , p_expected        varchar2
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_vc2     varchar2(2000);
    l_actual_sql     varchar2(2000);
  begin
    open l_actual for 
      select conn.conn_attributes."apex"."customExtension"."object" as actual
        from flow_connections conn
       where conn.conn_bpmn_id   = p_conn_bpmn_name
         and conn.conn_dgrm_id   = p_dgrm_id;
    open l_expected for
      select p_expected as actual
        from dual;
    ut.expect(l_actual).to_equal(l_expected);
  end attribute_tester;


  -- test(A - Parse and Access all objects - No Lanes)
  procedure custom_exts_no_lanes
  is
      l_dgrm            flow_diagrams.dgrm_id%type   := g_dgrm_a23a_id;
  begin

    -- collaboration
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'A23a - Custom Extensions a', p_expected => 'Process A23a');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'Start',                      p_expected => 'Event_Start');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'Task_A',                     p_expected => 'Activity_Task_A');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'A',                          p_expected => 'Gateway_A');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'userTask_B',                 p_expected => 'Activity_userTask_B');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'ServiceTask_C',              p_expected => 'Activity_ServiceTask_C');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'EndB',                       p_expected => 'EndB');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'SubProcess_D',               p_expected => 'Activity_SubProcess_D');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'DSub',                       p_expected => 'DSub');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'CallActivity_E',             p_expected => 'Activity_CallActivityE');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'TermEndD',                   p_expected => 'TermEndD');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'DStart',                     p_expected => 'DStart');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'DEnd',                       p_expected => 'DEnd');

    attribute_tester (p_dgrm_id => l_dgrm, p_conn_bpmn_name => 'Flow_RouteB',                p_expected => 'Flow_RouteB');
    attribute_tester (p_dgrm_id => l_dgrm, p_conn_bpmn_name => 'Flow_RouteD',                p_expected => 'Flow_RouteD');

  end custom_exts_no_lanes;

  -- test(B - Parse and Access all objects - In Collaboration)
  procedure custom_ext_lanes
  is
        l_dgrm            flow_diagrams.dgrm_id%type   := g_dgrm_a23b_id;
  begin
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_bpmn_name => 'Collaboration_0ho7t0d', p_expected => 'collaboration');

    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'Process_A23b',               p_expected => 'process');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'Sales',                      p_expected => 'lane');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'AR',                         p_expected => 'lane');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'Start',                      p_expected => 'startEvent');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'task',                       p_expected => 'task');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'exclusiveGateway',           p_expected => 'exclusiveGateway');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'userTask',                   p_expected => 'userTask');    
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'timerBE',                    p_expected => 'timerBE');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'serviceTask',                p_expected => 'serviceTask');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'EndB',                       p_expected => 'endEvent');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'scriptTask',                 p_expected => 'scriptTask');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'subProcess',                 p_expected => 'subProcess');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'businessRuleTask',           p_expected => 'businessRuleTask');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'callActivity',               p_expected => 'callActivity');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'EndD',                       p_expected => 'endEvent');

    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'parallelGateway',            p_expected => 'parallelGateway');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'manualTask',                 p_expected => 'manualTask');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'inclusiveGateway',           p_expected => 'inclusiveGateway');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'ICE',                        p_expected => 'ICE');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'eventBasedGateway',          p_expected => 'eventBasedGateway');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'timerICE',                   p_expected => 'timerICE');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'messageCatch2',              p_expected => 'messageCatch2');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'messageCatch',               p_expected => 'messageCatch');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'sendTask',                   p_expected => 'sendTask');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'receiveTask',                p_expected => 'receiveTask');
    attribute_tester (p_dgrm_id => l_dgrm, p_objt_name => 'messageCatch',               p_expected => 'messageCatch');

    attribute_tester (p_dgrm_id => l_dgrm, p_conn_bpmn_name => 'Flow_B',                p_expected => 'flowB');
    attribute_tester (p_dgrm_id => l_dgrm, p_conn_bpmn_name => 'Flow_D',                p_expected => 'flowD');

  end custom_ext_lanes;

  --afterall
  procedure tear_down_tests  
  is
  begin
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 023');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 023');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,  p_comment  => 'Ran by utPLSQL as Test Suite 023');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,  p_comment  => 'Ran by utPLSQL as Test Suite 023');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,  p_comment  => 'Ran by utPLSQL as Test Suite 023');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,  p_comment  => 'Ran by utPLSQL as Test Suite 023');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,  p_comment  => 'Ran by utPLSQL as Test Suite 023');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,  p_comment  => 'Ran by utPLSQL as Test Suite 023');


    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_023_custom_extensions;
/
