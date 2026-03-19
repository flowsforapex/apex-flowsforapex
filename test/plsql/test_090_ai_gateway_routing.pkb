create or replace package body test_090_ai_gateway_routing as
/* 
-- Flows for APEX - test_090_ai_gateway_routing.pkb
-- 
-- AI Generated test suite for BPMN gateway routing with process variables
-- Tests both inclusive and exclusive gateway behavior
--
*/

  -- Model constants
  g_model_name constant varchar2(100) := 'A90c - AI Gateway Routing Model';
  g_test_prcs_name constant varchar2(100) := 'test-90c-gateway-routing';
  
  -- Test framework variables
  g_dgrm_id flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is
  begin
    -- Get diagram ID for the model
    g_dgrm_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_name );
    
    -- Parse the model
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_id );
  end set_up_tests;

  procedure test_variables_set
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-variables'
    );
    
    -- Start the process - will automatically execute Start Event and reach SetVariables task
    -- The beforeTask variables will be executed when arriving at SetVariables
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    
    -- Check that process variables were created with correct values
    open l_actual for
      select prov_var_name, prov_var_vc2, prov_var_num
      from flow_process_variables
      where prov_prcs_id = l_prcs_id
      order by prov_var_name;
      
    open l_expected for
      select 'priority_level' as prov_var_name, null as prov_var_vc2, 5 as prov_var_num from dual
      union all
      select 'region' as prov_var_name, 'NORTH' as prov_var_vc2, null as prov_var_num from dual
      union all  
      select 'timestamp_var' as prov_var_name, '2026-03-13 10:00:00' as prov_var_vc2, null as prov_var_num from dual
      union all
      select 'user_type' as prov_var_name, 'ADMIN' as prov_var_vc2, null as prov_var_num from dual
      order by prov_var_name;
      
    ut.expect( l_actual ).to_equal( l_expected ).unordered();
  end test_variables_set;

  procedure test_inclusive_admin_path
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-admin'
    );
    
    -- Start the process and step through SetVariables task - InclusiveGateway will auto-step
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    
    -- Verify AdminTask is running (user_type = 'ADMIN' should be true)
    open l_actual for
      select sbfl_current, sbfl_status
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current = 'AdminTask'
        and sbfl_status = 'running';
        
    ut.expect( l_actual ).to_have_count( 1 );
  end test_inclusive_admin_path;

  procedure test_inclusive_priority_path  
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-priority'
    );
    
    -- Start the process and step through SetVariables task - InclusiveGateway will auto-step
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    
    -- Verify PriorityTask is running (priority_level = 5 >= 3 should be true)
    open l_actual for
      select sbfl_current, sbfl_status
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current = 'PriorityTask'
        and sbfl_status = 'running';
        
    ut.expect( l_actual ).to_have_count( 1 );
  end test_inclusive_priority_path;

  procedure test_inclusive_north_path
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-north'
    );
    
    -- Start the process and step through SetVariables task - InclusiveGateway will auto-step
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    
    -- Verify NorthTask is running (region = 'NORTH' like '%NORTH%' should be true)
    open l_actual for
      select sbfl_current, sbfl_status
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current = 'NorthTask'
        and sbfl_status = 'running';
        
    ut.expect( l_actual ).to_have_count( 1 );
  end test_inclusive_north_path;

  procedure test_inclusive_multiple_paths
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-multiple'
    );
    
    -- Start the process and step through SetVariables task - InclusiveGateway will auto-step
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    
    -- Verify all three tasks are running (inclusive gateway allows multiple paths)
    open l_actual for
      select sbfl_current
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current in ('AdminTask', 'PriorityTask', 'NorthTask')
        and sbfl_status = 'running'
      order by sbfl_current;
      
    open l_expected for
      select 'AdminTask' as sbfl_current from dual
      union all
      select 'NorthTask' as sbfl_current from dual  
      union all
      select 'PriorityTask' as sbfl_current from dual
      order by sbfl_current;
        
    ut.expect( l_actual ).to_equal( l_expected );
  end test_inclusive_multiple_paths;

  procedure test_exclusive_approve_path
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-approve'
    );
    
    -- Start the process and step through the full process - gateways will auto-step
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    
    -- Complete all parallel tasks from inclusive gateway
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'AdminTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'PriorityTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'NorthTask' );
    
    -- Step through SetRouting task - gateways will auto-step
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRouting' );
    
    -- Verify only ApproveTask is running (routing_decision = 'APPROVE')
    open l_actual for
      select sbfl_current, sbfl_status
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current = 'ApproveTask'
        and sbfl_status = 'running';
        
    ut.expect( l_actual ).to_have_count( 1 );
    
    -- Verify RejectTask and DefaultTask are NOT running
    declare
      l_actual_count number;
    begin
      select count(*)
      into l_actual_count
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current in ('RejectTask', 'DefaultTask')
        and sbfl_status = 'running';
        
      ut.expect( l_actual_count ).to_equal( 0 );
    end;
  end test_exclusive_approve_path;

  procedure test_exclusive_reject_path
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-reject'
    );
    
    -- Start the process and step through to SetRouting and modify the routing variable to 'REJECT'
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'AdminTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'PriorityTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'NorthTask' );
    
    -- Update routing_decision to REJECT before continuing
    flow_process_vars.set_var( pi_prcs_id => l_prcs_id, pi_var_name => 'routing_decision', pi_vc2_value => 'REJECT' );
    
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRouting' );
    
    -- Verify only RejectTask is running
    open l_actual for
      select sbfl_current, sbfl_status
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current = 'RejectTask'
        and sbfl_status = 'running';
        
    ut.expect( l_actual ).to_have_count( 1 );
  end test_exclusive_reject_path;

  procedure test_exclusive_default_path
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-default'
    );
    
    -- Start the process and step through to SetRouting and modify routing variable to something else
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'AdminTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'PriorityTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'NorthTask' );
    
    -- Update routing_decision to something that doesn't match conditions
    flow_process_vars.set_var( pi_prcs_id => l_prcs_id, pi_var_name => 'routing_decision', pi_vc2_value => 'UNKNOWN' );
    
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRouting' );
    
    -- Verify only DefaultTask is running (default path)
    open l_actual for
      select sbfl_current, sbfl_status
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
        and sbfl_current = 'DefaultTask'
        and sbfl_status = 'running';
        
    ut.expect( l_actual ).to_have_count( 1 );
  end test_exclusive_default_path;

  procedure test_complete_workflow
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-complete'
    );
    
    -- Start the process and execute complete workflow - gateways auto-step
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'AdminTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'PriorityTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'NorthTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRouting' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'ApproveTask' );
    
    -- Process should now be completed after reaching End event
    -- Verify process completed successfully
    open l_actual for
      select prcs_status
      from flow_processes
      where prcs_id = l_prcs_id;
      
    open l_expected for
      select 'completed' as prcs_status from dual;
      
    ut.expect( l_actual ).to_equal( l_expected );
  end test_complete_workflow;

  procedure test_variable_persistence
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_prcs_id     flow_processes.prcs_id%type;
  begin
    -- Create new process instance for this test
    l_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_dgrm_id
     , pi_prcs_name => g_test_prcs_name||'-persistence'
    );
    
    -- Start the process and step through to after SetRouting task - gateways auto-step
    flow_api_pkg.flow_start( p_process_id => l_prcs_id );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetVariables' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'AdminTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'PriorityTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'NorthTask' );
    test_helper.step_forward( pi_prcs_id => l_prcs_id, pi_current => 'SetRouting' );
    
    -- Verify all original variables still exist plus routing_decision
    declare
      l_variable_count number;
    begin
      select count(*)
      into l_variable_count
      from flow_process_variables 
      where prov_prcs_id = l_prcs_id
        and prov_var_name in ('user_type', 'priority_level', 'region', 'timestamp_var', 'routing_decision');
      
      ut.expect( l_variable_count ).to_equal( 5 );
    end;
    
    -- Verify specific values are maintained
    open l_actual for
      select prov_var_name, prov_var_vc2, prov_var_num 
      from flow_process_variables
      where prov_prcs_id = l_prcs_id
        and prov_var_name in ('user_type', 'priority_level', 'routing_decision')
      order by prov_var_name;
      
    open l_expected for
      select 'priority_level' as prov_var_name, null as prov_var_vc2, 5 as prov_var_num from dual
      union all
      select 'routing_decision' as prov_var_name, 'APPROVE' as prov_var_vc2, null as prov_var_num from dual
      union all
      select 'user_type' as prov_var_name, 'ADMIN' as prov_var_vc2, null as prov_var_num from dual
      order by prov_var_name;
      
    ut.expect( l_actual ).to_equal( l_expected );
  end test_variable_persistence;

end test_090_ai_gateway_routing;