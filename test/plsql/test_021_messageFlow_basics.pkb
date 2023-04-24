create or replace package body test_021_messageFlow_basics as
/* 
-- Flows for APEX - test_021_messageFlow_basics.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 17-Apr-2023   Richard Allen - Oracle
--
*/

  -- uses models A21a
  g_model_a21a constant varchar2(100) := 'A21a - Messageflow - basics';
  g_model_a21b constant varchar2(100) := 'A21b - Messageflow - basics - no payload';
  g_model_a21c constant varchar2(100) := 'A21c - Messageflow - bad endpoint';
  g_model_a21d constant varchar2(100) := 'A21d - Messageflow - basics - Collaboration';
  g_model_a21e constant varchar2(100) := 'A21e - MessageFlow basics - Subscription Cancellation';
  g_model_a21f constant varchar2(100) := 'A21f - Basic Messageflow - EBG';
  g_model_a21g constant varchar2(100) := 'A21g - Basic Messageflow - Timer BE on ReceiveTask';

  g_test_prcs_name_a1 constant varchar2(100) := 'test - MessageFlow basics - a1';
  g_test_prcs_name_a2 constant varchar2(100) := 'test - MessageFlow basics - a2';
  g_test_prcs_name_b1 constant varchar2(100) := 'test - MessageFlow basics - b1';
  g_test_prcs_name_b2 constant varchar2(100) := 'test - MessageFlow basics - b2';
  g_test_prcs_name_c1 constant varchar2(100) := 'test - MessageFlow basics - c1';
  g_test_prcs_name_c2 constant varchar2(100) := 'test - MessageFlow basics - c2';
  g_test_prcs_name_d1 constant varchar2(100) := 'test - MessageFlow basics - d1';
  g_test_prcs_name_d2 constant varchar2(100) := 'test - MessageFlow basics - d2';
  g_test_prcs_name_e1 constant varchar2(100) := 'test - MessageFlow basics - e1';
  g_test_prcs_name_e2 constant varchar2(100) := 'test - MessageFlow basics - e2';
  g_test_prcs_name_f1 constant varchar2(100) := 'test - MessageFlow basics - f1';
  g_test_prcs_name_f2 constant varchar2(100) := 'test - MessageFlow basics - f2';
  g_test_prcs_name_g1 constant varchar2(100) := 'test - MessageFlow basics - g1';
  g_test_prcs_name_g2 constant varchar2(100) := 'test - MessageFlow basics - g2';
  g_test_prcs_name_h  constant varchar2(100) := 'test - MessageFlow basics - h';
  g_test_prcs_name_i  constant varchar2(100) := 'test - MessageFlow basics - i';
  g_test_prcs_name_j  constant varchar2(100) := 'test - MessageFlow basics - j';

  g_prcs_id_a1       flow_processes.prcs_id%type;
  g_prcs_id_a2       flow_processes.prcs_id%type;
  g_prcs_id_b1       flow_processes.prcs_id%type;
  g_prcs_id_b2       flow_processes.prcs_id%type;
  g_prcs_id_c1       flow_processes.prcs_id%type;
  g_prcs_id_c2       flow_processes.prcs_id%type;
  g_prcs_id_d1       flow_processes.prcs_id%type;
  g_prcs_id_d2       flow_processes.prcs_id%type;
  g_prcs_id_e1       flow_processes.prcs_id%type;
  g_prcs_id_e2       flow_processes.prcs_id%type;
  g_prcs_id_f1       flow_processes.prcs_id%type;
  g_prcs_id_f2       flow_processes.prcs_id%type;
  g_prcs_id_g1       flow_processes.prcs_id%type;
  g_prcs_id_g2       flow_processes.prcs_id%type;
  g_prcs_id_h        flow_processes.prcs_id%type;
  g_prcs_id_i        flow_processes.prcs_id%type;
  g_prcs_id_ij       flow_processes.prcs_id%type;

  g_dgrm_a21a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a21b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a21c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a21d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a21e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a21f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a21g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a21a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a21a );
    g_dgrm_a21b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a21b );
    g_dgrm_a21c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a21c );
    g_dgrm_a21d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a21d );
    g_dgrm_a21e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a21e );
    g_dgrm_a21f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a21f );
    g_dgrm_a21g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a21g );

    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a21a_id);  -- REMOVE PARSE UNTIL 'NOT PARSING PAYLOADVARIABLE BUG" fixed
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a21b_id);  -- can parse nowbecause no payloadVariable defined
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a21c_id);
    -- flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a21d_id);  -- REMOVE PARSE UNTIL 'NOT PARSING PAYLOADVARIABLE BUG" fixed
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a21e_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a21f_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a21g_id);

  end set_up_tests; 


  function run_messageflow_model
  ( p_prcs_name   in flow_processes.prcs_name%type
  , p_dgrm_id     in flow_diagrams.dgrm_id%type default g_dgrm_a21a_id
  , p_path        in varchar2
  , p_role        in varchar2    -- 'send' or 'receive' (or 'send-manual' to skip after send tests)
  , p_has_payload in varchar2 default 'true'
  , p_endpoint    in varchar2 default 'local'
  , p_rx_prcs_id  in flow_processes.prcs_id%type default null -- used for the receiving prcs_id if this is a sending prcs (to check msg sub)
  ) return flow_processes.prcs_id%type
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := p_dgrm_id;
    l_prcs_name   := p_prcs_name;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
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

    -- check no existing process variables

    open l_expected for  
      select 'messageName' as name, 'VARCHAR2' as type, 'MyMessage' as vc2
      from dual
      union
      select 'messageKey' as name, 'VARCHAR2' as type, 'keya21a' as vc2
      from dual
      union
      select 'messageValue' as name, 'VARCHAR2' as type, 'a21a' as vc2
      from dual
      union
      select 'messagePayload' as name, 'VARCHAR2' as type, 'originalPayload' as vc2
      from dual
      where p_has_payload = 'true'
      ;
    
    open l_actual for
      select prov_var_name as name, prov_var_type as type, prov_var_vc2 as vc2
      from flow_process_variables
      where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected).unordered;    

    -- set up 'path' process variable based on the type of catcher or sender required

    flow_process_vars.set_var(pi_prcs_id  =>  l_prcs_id,
                              pi_var_name  => 'path',
                              pi_vc2_value  => p_path,
                              pi_scope  => 0);

    -- check subflow running

    open l_expected for
       select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Before' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- Step forward through gateway to sender/receiver

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_Before');    

    case p_role
    when 'receive' then

      -- check if message subscription has been created

      open l_expected for
        select l_prcs_id         as prcs_id
             , 'MyMessage'       as message_name
             , 'keya21a'         as message_key
             , 'a21a'            as message_value
             , case p_has_payload 
               when 'true' then 'returnPayload'  
               else ''  
               end as payload_var
        from dual;
      open l_actual for
        select msub_prcs_id      as prcs_id
             , msub_message_name as message_name
             , msub_key_name     as message_key
             , msub_key_value    as message_value
             , msub_payload_var  as payload_var   
          from flow_message_subscriptions
         where msub_prcs_id = l_prcs_id;
      ut.expect(l_actual).to_equal(l_expected).unordered;

      -- check that the process is still on the receive object         

      open l_expected for
         select
            l_prcs_id as sbfl_prcs_id,
            l_dgrm_id as sbfl_dgrm_id,
            p_path    as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    when 'send' then

      -- check if message subscription has been consumed

      open l_actual for
        select msub_prcs_id      as prcs_id
             , msub_message_name as message_name
             , msub_key_name     as message_key
             , msub_key_value    as message_value
             , msub_payload_var  as payload_var   
          from flow_message_subscriptions
         where msub_prcs_id = p_rx_prcs_id;
      ut.expect(l_actual).to_be_empty;

      -- check that the process has moved beyond the receive object         

      open l_expected for
         select
            l_prcs_id as sbfl_prcs_id,
            l_dgrm_id as sbfl_dgrm_id,
            'Activity_After'||p_path as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_running sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      when 'send-manual' then
        -- testing will be done in the calling routine.
        null;
    end case;

    return l_prcs_id;
  end run_messageflow_model;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests A: Basic Send to Waiting Catch - With Payload - All combinations of {send, Throw} to {receive, catch}
 -- 
 ---------------------------------------------------------------------------------------------------------------

  -- test(A1 - Send to Receive with Payload)
  procedure basic_receive_send_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_receive_send_payload;

  -- test(A2 - ITE to Receive with Payload)
  procedure basic_receive_ITE_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes                                       
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_receive_ITE_payload;

    -- test(A3 - Send to ICE with Payload)
  procedure basic_ICE_send_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ICE_send_payload;

    -- test(A4 - ITE to ICE with Payload)
  procedure basic_ICE_ITE_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_a2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes                                       
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ICE_ITE_payload;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests B: Basic Send to Waiting Catch - Without Payloads - All combinations of {send, Throw} to {receive, catch}
 -- 
 ---------------------------------------------------------------------------------------------------------------

  -- test(B1 - Send to Receive with no Payload)
  procedure basic_receive_send_no_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b1
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b2
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_receive_send_no_payload;

  -- test(B2 - ITE to Receive with Payload)
  procedure basic_receive_ITE_no_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b1
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b2
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes                                       
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_receive_ITE_no_payload;

    -- test(B3 - Send to ICE with No Payload)
  procedure basic_ICE_send_no_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b1
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b2
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ICE_send_no_payload;

    -- test(B4 - ITE to ICE with No Payload)
  procedure basic_ICE_ITE_no_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b1
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_b2
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes                                       
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ICE_ITE_no_payload;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests C: Throw to No Catch - All combinations of {send, Throw} to {receive, catch}
 -- 
 ---------------------------------------------------------------------------------------------------------------

  -- test(C1 - Send without Receive with  Payload)
  procedure basic_send_without_receive_payload
  is
    l_prcs_rx         flow_processes.prcs_id%type;
    l_prcs_tx         flow_processes.prcs_id%type;
    l_actual_clob     clob;
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
  begin

    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_c1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send-manual'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
      -- check that the send task subflow is now in error         

      open l_expected for
         select
            l_prcs_tx as sbfl_prcs_id,
            'Send'    as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_error sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check that the send process is now in error         

      open l_expected for
         select
            l_prcs_tx as prcs_id,
            flow_constants_pkg.gc_prcs_status_error prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_send_without_receive_payload;

  -- test(C2 - Throw without Receive with  Payload)
  procedure basic_ITE_without_receive_payload
  is
    l_prcs_rx         flow_processes.prcs_id%type;
    l_prcs_tx         flow_processes.prcs_id%type;
    l_actual_clob     clob;
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
  begin

    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_c1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send-manual'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
      -- check that the send task subflow is now in error         

      open l_expected for
         select
            l_prcs_tx as sbfl_prcs_id,
            'ITE'    as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_error sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check that the send process is now in error         

      open l_expected for
         select
            l_prcs_tx as prcs_id,
            flow_constants_pkg.gc_prcs_status_error prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;


    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ITE_without_receive_payload;



 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests D: Restarability of Send task after non-correlation error fixed
 -- 
 ---------------------------------------------------------------------------------------------------------------

  -- test(D1 - Error Restart after Send without Receive with  Payload)
  procedure basic_send_without_receive_payload_restart
  is
    l_prcs_rx         flow_processes.prcs_id%type;
    l_prcs_tx         flow_processes.prcs_id%type;
    l_actual_clob     clob;
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_sending_path    varchar2(20) := 'Send';
  begin

    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_d1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => l_sending_path
                                       , p_role         => 'send-manual'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
      -- check that the send task subflow is now in error         

      open l_expected for
         select
            l_prcs_tx         as sbfl_prcs_id,
            l_sending_path    as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_error sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check that the send process is now in error         

      open l_expected for
         select
            l_prcs_tx as prcs_id,
            flow_constants_pkg.gc_prcs_status_error prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- now start the receive task to create a subscription

    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_d2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- then restart the Sending process and it should proceed...

    test_helper.restart_forward(pi_prcs_id  => l_prcs_tx,
                                pi_current  => l_sending_path);

      -- check that the send task subflow is now on After step and running       

      open l_expected for
         select
            l_prcs_tx                                 as sbfl_prcs_id,
            'Activity_AfterSend'                      as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;                                


      -- check that the receiver task subflow is now on After step and running       

      open l_expected for
         select
            l_prcs_rx                                 as sbfl_prcs_id,
            'Activity_AfterReceive'                   as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_rx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;                                


    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_send_without_receive_payload_restart;



  -- test(D2 - Error Restart after Send without Receive with  Payload)
  procedure basic_ITE_without_receive_payload_restart
  is
    l_prcs_rx         flow_processes.prcs_id%type;
    l_prcs_tx         flow_processes.prcs_id%type;
    l_actual_clob     clob;
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_sending_path    varchar2(20) := 'ITE';
  begin

    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_d1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => l_sending_path
                                       , p_role         => 'send-manual'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
      -- check that the send task subflow is now in error         

      open l_expected for
         select
            l_prcs_tx         as sbfl_prcs_id,
            l_sending_path    as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_error sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check that the send process is now in error         

      open l_expected for
         select
            l_prcs_tx as prcs_id,
            flow_constants_pkg.gc_prcs_status_error prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- now start the receive task to create a subscription

    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_d2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- then restart the Sending process and it should proceed...

    test_helper.restart_forward(pi_prcs_id  => l_prcs_tx,
                                pi_current  => l_sending_path);

      -- check that the send task subflow is now on After step and running       

      open l_expected for
         select
            l_prcs_tx                                 as sbfl_prcs_id,
            'Activity_AfterITE'                      as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;                                


      -- check that the receiver task subflow is now on After step and running       

      open l_expected for
         select
            l_prcs_rx                                 as sbfl_prcs_id,
            'Activity_AfterReceive'                   as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_rx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;                                


    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ITE_without_receive_payload_restart;


 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests E: Bad Endpoint
 -- 
 ---------------------------------------------------------------------------------------------------------------  

 -- test(E1 - Send with bad endpoint)
  procedure bad_endpoint_send
  is
    l_prcs_rx         flow_processes.prcs_id%type;
    l_prcs_tx         flow_processes.prcs_id%type;
    l_actual_clob     clob;
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
  begin

    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_e1
                                       , p_dgrm_id      => g_dgrm_a21c_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send-manual'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
      -- check that the send task subflow is now in error         

      open l_expected for
         select
            l_prcs_tx as sbfl_prcs_id,
            'Send'    as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_error sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check that the send process is now in error         

      open l_expected for
         select
            l_prcs_tx as prcs_id,
            flow_constants_pkg.gc_prcs_status_error prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end bad_endpoint_send;


 -- test(E2 - Send with bad endpoint)
  procedure bad_endpoint_ITE
  is
    l_prcs_rx         flow_processes.prcs_id%type;
    l_prcs_tx         flow_processes.prcs_id%type;
    l_actual_clob     clob;
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
  begin

    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_e1
                                       , p_dgrm_id      => g_dgrm_a21c_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send-manual'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
      -- check that the send task subflow is now in error         

      open l_expected for
         select
            l_prcs_tx as sbfl_prcs_id,
            'ITE'    as sbfl_current,    
            flow_constants_pkg.gc_sbfl_status_error sbfl_status
         from dual;

      open l_actual for
         select sbfl_prcs_id,  sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check that the send process is now in error         

      open l_expected for
         select
            l_prcs_tx as prcs_id,
            flow_constants_pkg.gc_prcs_status_error prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_tx;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end bad_endpoint_ITE;

 
 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests F: Mismatched Payloads (send unexpected payload / missing expected payload)
 -- 
 ---------------------------------------------------------------------------------------------------------------
 
  -- test(F1 - Send to Receive with Unexpected Payload)
  procedure basic_receive_send_unexpected_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f1
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_receive_send_unexpected_payload;

  -- test(F2 - ITE to ICE with Unexpected Payload)
  procedure basic_ICE_ITE_unexpected_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f1
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f2
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ICE_ITE_unexpected_payload;

  -- test(F3 - Send to Receive with missing Payload)
  procedure basic_receive_send_missing_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f2
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_receive_send_missing_payload;

  -- test(F3 - ITE to ICE with missing Payload)
  procedure basic_ICE_ITE_missing_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f1
                                       , p_dgrm_id      => g_dgrm_a21a_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_f2
                                       , p_dgrm_id      => g_dgrm_a21b_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'false'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_be_null;

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end basic_ICE_ITE_missing_payload;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests G: Basic Send to Waiting Catch - With Payload - All combinations of {send, Throw} to {receive, catch}
 --   (reruns set A with a diagram including Lanes and an empty pool)
 -- 
 ---------------------------------------------------------------------------------------------------------------

   -- test(G1 - Send to Receive with Payload)
  procedure colab_receive_send_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g1
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g2
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end colab_receive_send_payload;

  -- test(G2 - ITE to Receive with Payload)
  procedure colab_receive_ITE_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g1
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'Receive'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g2
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes                                       
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end colab_receive_ITE_payload;

    -- test(G3 - Send to ICE with Payload)
  procedure colab_ICE_send_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g1
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g2
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'Send'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end colab_ICE_send_payload;

    -- test(G4 - ITE to ICE with Payload)
  procedure colab_ICE_ITE_payload
  is
    l_prcs_rx     flow_processes.prcs_id%type;
    l_prcs_tx     flow_processes.prcs_id%type;
    l_actual_clob clob;
  begin
    l_prcs_rx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g1
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'ICE'
                                       , p_role         => 'receive'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );
    l_prcs_tx := run_messageflow_model ( p_prcs_name    => g_test_prcs_name_g2
                                       , p_dgrm_id      => g_dgrm_a21d_id
                                       , p_path         => 'ITE'
                                       , p_role         => 'send'
                                       , p_has_payload  => 'true'
                                       , p_endpoint     => 'local'
                                       );

    -- check the receiving object received the payload

   
    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id  => l_prcs_rx
                                                    , pi_var_name  => 'returnPayload');                                                   
    ut.expect(l_actual_clob).to_equal(to_clob('originalPayload'));

    -- tear down processes                                       
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_rx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_tx,  p_comment  => 'Ran by utPLSQL as Test Suite 021');    
  end colab_ICE_ITE_payload;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests H: subscription Cancellation (check subscription gets cancelled when areceive Task gets cancelled)
 -- 
 ---------------------------------------------------------------------------------------------------------------

  -- test(H - Subscription Cancellation)
  procedure subscription_cancellation
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a21e_id;
    l_prcs_name   := g_test_prcs_name_h;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
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

    -- check all parallel subflows running

    open l_expected for       
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeTest' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward into test

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeTest');    

    -- check subflows

    open l_expected for       
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Receive' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
       from dual
       union
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeErrorEnd' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- check if message subscription has been created

    open l_expected for
      select l_prcs_id         as prcs_id
           , 'MyMessage'       as message_name
           , 'myKey'           as message_key
           , 'myValue'         as message_value
           , ''                as payload_var
      from dual;
    open l_actual for
      select msub_prcs_id      as prcs_id
           , msub_message_name as message_name
           , msub_key_name     as message_key
           , msub_key_value    as message_value
           , msub_payload_var  as payload_var   
        from flow_message_subscriptions
       where msub_prcs_id = l_prcs_id;
    ut.expect(l_actual).to_equal(l_expected).unordered;

    -- step forward on other subflow to cause subprocess to error-end

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeErrorEnd');    

    -- now check that the subprocess activities have gone and then that the message subscription was also removed

    open l_expected for       
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_AfterErrorBE' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess');
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- check the subscription

        open l_actual for
      select msub_prcs_id      as prcs_id
           , msub_message_name as message_name
           , msub_key_name     as message_key
           , msub_key_value    as message_value
           , msub_payload_var  as payload_var   
        from flow_message_subscriptions
       where msub_prcs_id = l_prcs_id;
    ut.expect(l_actual).to_be_empty;

    -- step forward on oher subflow to end

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterErrorBE');   

    -- check process completed successfully

    open l_expected for
        select
        l_dgrm_id                                     as prcs_dgrm_id,
        l_prcs_name                                   as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );    

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_id,  p_comment  => 'Ran by utPLSQL as Test Suite 021');

  end subscription_cancellation;

 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests I: MessageFlow ReceiveTask and ICE Following an Event Based Gateway
 -- 
 ---------------------------------------------------------------------------------------------------------------

  procedure after_ebg_tester
  ( p_winning_path   flow_objects.objt_bpmn_id%type
  , p_do_timeout     boolean
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a21f_id;
    l_prcs_name   := g_test_prcs_name_i;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
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

    -- check main subflows running

    open l_expected for       
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeGateway' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step forward into test

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeGateway');    

    -- check all paths running after EBG

    open l_expected for       
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Receive' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
       from dual
       union
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Event_ICEMessage1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
       from dual
       union
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Event_ICEMessage2' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
       from dual
       union
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Event_ICETimer' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- check all subscriptions created

    open l_expected for
      select l_prcs_id         as prcs_id
           , 'MyMessage'       as message_name
           , 'Processor'           as message_key
           , 'Receive'         as message_value
           , ''                as payload_var
      from dual
      union
      select l_prcs_id         as prcs_id
           , 'MyMessage'       as message_name
           , 'Processor'           as message_key
           , 'ICEMessage1'         as message_value
           , ''                as payload_var
      from dual
      union
      select l_prcs_id         as prcs_id
           , 'MyMessage'       as message_name
           , 'Processor'           as message_key
           , 'ICEMessage2'         as message_value
           , ''                as payload_var
      from dual;      
    open l_actual for
      select msub_prcs_id      as prcs_id
           , msub_message_name as message_name
           , msub_key_name     as message_key
           , msub_key_value    as message_value
           , msub_payload_var  as payload_var   
        from flow_message_subscriptions
       where msub_prcs_id = l_prcs_id;
    ut.expect(l_actual).to_equal(l_expected).unordered;

    -- send chosen message

    if p_do_timeout then
      -- let the timer win
      dbms_session.sleep(15);
    else
      flow_api_pkg.receive_message ( p_message_name => 'MyMessage' 
                                   , p_key_name => 'Processor' 
                                   , p_key_value => p_winning_path
                                   );
    end if;

    -- now check whether one 1 subflow  running

    open l_expected for   
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_After_'||p_winning_path as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- check no message subscriptions outstanding

    open l_actual for
      select msub_prcs_id      as prcs_id
           , msub_message_name as message_name
           , msub_key_name     as message_key
           , msub_key_value    as message_value
           , msub_payload_var  as payload_var   
        from flow_message_subscriptions
       where msub_prcs_id = l_prcs_id;
    ut.expect(l_actual).to_be_empty;

    -- step forward on other subflow to end

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_After_'||p_winning_path);   

    -- check process completed successfully

    open l_expected for
        select
        l_dgrm_id                                     as prcs_dgrm_id,
        l_prcs_name                                   as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );    

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_id,  p_comment  => 'Ran by utPLSQL as Test Suite 021');

  end after_ebg_tester;


  -- test(I1 - Messageflow after EBG - ReceiveTask wins)
  procedure afterEBG_receiveTask
  is
  begin
    after_ebg_tester ( p_winning_path => 'Receive', p_do_timeout => false);
  end afterEBG_receiveTask;

  -- test(I2 - Messageflow after EBG - MessageICE1 wins)
  procedure afterEBG_messageICE1
  is
  begin
    after_ebg_tester ( p_winning_path => 'ICEMessage1', p_do_timeout => false);
  end afterEBG_messageICE1;

  -- test(I3 - Messageflow after EBG - MessageICE2 wins)
  procedure afterEBG_messageICE2
  is
  begin
    after_ebg_tester ( p_winning_path => 'ICEMessage2', p_do_timeout => false);
  end afterEBG_messageICE2;

  -- test(I4 - Messageflow after EBG - Timer wins)
  procedure afterEBGtimer
  is
  begin
    after_ebg_tester ( p_winning_path => 'ICETimer', p_do_timeout => true);
  end afterEBGtimer;


 ---------------------------------------------------------------------------------------------------------------
 --
 --  Tests J: Timer Boundary Events on ReceiveTask
 -- 
 ---------------------------------------------------------------------------------------------------------------

  procedure receivetask_timer_be_runner
  ( p_BE1_fires  boolean
  , p_BE2_fires  boolean
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id     := g_dgrm_a21g_id;
    l_prcs_name   := g_test_prcs_name_j;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
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

    -- check main subflow running

    open l_expected for       
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_BeforeTest1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;


    -- step forward into test

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeTest1');   

    -- check expected subflows

    open l_expected for   
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Receive1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
       from dual
       union
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Event_BE1NITimer' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- test subscription created

    open l_expected for 
      select l_prcs_id         as prcs_id
           , 'MyMessage'       as message_name
           , 'MyKey'       as message_key
           , 'Receive1'        as message_value
           , ''                as payload_var
      from dual;      
    open l_actual for
      select msub_prcs_id      as prcs_id
           , msub_message_name as message_name
           , msub_key_name     as message_key
           , msub_key_value    as message_value
           , msub_payload_var  as payload_var   
        from flow_message_subscriptions
       where msub_prcs_id = l_prcs_id;
    ut.expect(l_actual).to_equal(l_expected).unordered;

    case p_BE1_fires
    when true then
      -- want timer to fire first so wait before sending message
      dbms_session.sleep(16);

      flow_api_pkg.receive_message ( p_message_name   => 'MyMessage'
                                   , p_key_name       => 'MyKey'
                                   , p_key_value      => 'Receive1'
                                   );

      -- check all subflows correct

      open l_expected for
         select
         l_prcs_id as sbfl_prcs_id,
         l_dgrm_id as sbfl_dgrm_id,
         'Activity_BeforeTest2' as sbfl_current,
         flow_constants_pkg.gc_sbfl_status_running sbfl_status
      from dual
      union
         select
         l_prcs_id as sbfl_prcs_id,
         l_dgrm_id as sbfl_dgrm_id,
         'Activity_AfterBE1' as sbfl_current,
         flow_constants_pkg.gc_sbfl_status_running sbfl_status
      from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id
         and sbfl_status not in ('split', 'in subprocess') ;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- step forward on BE path to clear subflow

      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterBE1');         

    when false then

      flow_api_pkg.receive_message ( p_message_name   => 'MyMessage'
                                   , p_key_name       => 'MyKey'
                                   , p_key_value      => 'Receive1'
                                   );

    end case;

    -- check all subflows correct
    open l_expected for
       select
       l_prcs_id as sbfl_prcs_id,
       l_dgrm_id as sbfl_dgrm_id,
       'Activity_BeforeTest2' as sbfl_current,
       flow_constants_pkg.gc_sbfl_status_running sbfl_status
    from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- ready for test 2

    -- step forward into Receive2 (with its interupting timer)

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeTest2');   

    -- check expected subflows

    open l_expected for   
          select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_Receive2' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_message sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ('split', 'in subprocess') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- test subscription created


    open l_expected for 
          select l_prcs_id     as prcs_id
           , 'MyMessage'       as message_name
           , 'MyKey'       as message_key
           , 'Receive2'        as message_value
           , ''                as payload_var
      from dual;      
    open l_actual for
      select msub_prcs_id      as prcs_id
           , msub_message_name as message_name
           , msub_key_name     as message_key
           , msub_key_value    as message_value
           , msub_payload_var  as payload_var   
        from flow_message_subscriptions
       where msub_prcs_id = l_prcs_id;
    ut.expect(l_actual).to_equal(l_expected).unordered;

    case p_BE2_fires
    when true then
      -- want timer to fire first so wait before sending message
      dbms_session.sleep(16);

      -- check all subflows correct

      open l_expected for
         select
         l_prcs_id as sbfl_prcs_id,
         l_dgrm_id as sbfl_dgrm_id,
         'Activity_AfterBE2' as sbfl_current,
         flow_constants_pkg.gc_sbfl_status_running sbfl_status
      from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id
         and sbfl_status not in ('split', 'in subprocess') ;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check no message subscriptions outstanding

      open l_actual for
        select msub_prcs_id      as prcs_id
             , msub_message_name as message_name
             , msub_key_name     as message_key
             , msub_key_value    as message_value
             , msub_payload_var  as payload_var   
          from flow_message_subscriptions
         where msub_prcs_id = l_prcs_id;
      ut.expect(l_actual).to_be_empty;    

      -- step forward on BE subflow to end

      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterBE2');   

    when false then
      -- send message before BE times out
      flow_api_pkg.receive_message ( p_message_name   => 'MyMessage'
                                   , p_key_name       => 'MyKey'
                                   , p_key_value      => 'Receive2'
                                   );      

      -- check subflows
      open l_expected for
         select
         l_prcs_id as sbfl_prcs_id,
         l_dgrm_id as sbfl_dgrm_id,
         'Activity_AfterTest' as sbfl_current,
         flow_constants_pkg.gc_sbfl_status_running sbfl_status
      from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id
         and sbfl_status not in ('split', 'in subprocess') ;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check no message subscriptions outstanding

      open l_actual for
        select msub_prcs_id      as prcs_id
             , msub_message_name as message_name
             , msub_key_name     as message_key
             , msub_key_value    as message_value
             , msub_payload_var  as payload_var   
          from flow_message_subscriptions
         where msub_prcs_id = l_prcs_id;
      ut.expect(l_actual).to_be_empty;    

      -- step forward on BE subflow to end

      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_AfterTest');  

    end case;

    -- check process completed successfully

    open l_expected for
        select
        l_dgrm_id                                     as prcs_dgrm_id,
        l_prcs_name                                   as prcs_name,
        flow_constants_pkg.gc_prcs_status_completed   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );    

    -- tear down processes

    flow_api_pkg.flow_delete(p_process_id  =>  l_prcs_id,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
  
  end receivetask_timer_be_runner;

  -- test(J1 - Timer BE on ReceiveTask)
  procedure receivetask_timer_be_no_timers
  is 
  begin
    receivetask_timer_be_runner ( p_be1_fires => false, p_be2_fires => false);
  end receivetask_timer_be_no_timers;

  -- test(J2 - Timer BE on ReceiveTask)
  procedure receivetask_timer_be_int_timers
  is 
  begin
    receivetask_timer_be_runner ( p_be1_fires => false, p_be2_fires => true);
  end receivetask_timer_be_int_timers;

  -- test(J3 - Timer BE on ReceiveTask)
  procedure receivetask_timer_be_nonint_timers
  is 
  begin
    receivetask_timer_be_runner ( p_be1_fires => true, p_be2_fires => false);
  end receivetask_timer_be_nonint_timers;

  -- test(J4 - Timer BE on ReceiveTask)
  procedure receivetask_timer_be_both_timers
  is 
  begin
    receivetask_timer_be_runner ( p_be1_fires => true, p_be2_fires => true);
  end receivetask_timer_be_both_timers;


  --afterall
  procedure tear_down_tests  
  is
  begin
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a1,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a2,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b1,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b2,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c2,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d1,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d2,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e1,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e2,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f1,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f2,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g1,  p_comment  => 'Ran by utPLSQL as Test Suite 021');
    -- flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g2,  p_comment  => 'Ran by utPLSQL as Test Suite 021');


    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_021_messageFlow_basics;
/