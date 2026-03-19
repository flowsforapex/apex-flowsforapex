create or replace package body test_090_ai_basic_model_b is
/* 
-- Flows for APEX - test_090_ai_basic_model_b.pkb
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created  13-Mar-2026   Claude Sonnet 4 AI (Generated)
--
-- Test Suite 90B: Test Basic AI Model with Variable Expressions
-- Tests sequential task execution with beforeTask variable expressions
-- TaskA > TaskB (with variable setting) > TaskC (variable testing) > TaskD
*/

   model_90b constant varchar2(100) := 'A90b - Basic AI Model with Variables';
   
   g_prcs_id_1    number;
   g_prcs_id_2    number;
   g_prcs_id_3    number;
   g_prcs_id_4    number;
   g_prcs_id_5    number;
   g_prcs_id_6    number;
   g_prcs_id_7    number;
   g_prcs_id_8    number;

   function get_dgrm_id( pi_dgrm_name in varchar2)
   return flow_diagrams.dgrm_id%type
   is
      l_dgrm_id flow_diagrams.dgrm_id%type;
   begin
      select dgrm_id
      into l_dgrm_id
      from flow_diagrams
      where dgrm_name = pi_dgrm_name;

      return l_dgrm_id;
   end get_dgrm_id;

   procedure set_up_tests
   is
   begin
     -- parse the diagram with variable expressions
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => get_dgrm_id(model_90b));
   end set_up_tests;

   procedure test_model_creation
   is
      l_dgrm_id     flow_diagrams.dgrm_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- get dgrm_id to use for comparison
      l_dgrm_id := get_dgrm_id( model_90b );

      -- Verify the model was created and parsed successfully
      open l_expected for
         select 
            model_90b as dgrm_name, 
            '0' as dgrm_version, 
            'Testing' as dgrm_category, 
            'Yes' as diagram_parsed 
         from dual;

      open l_actual for
         select 
            d.dgrm_name, 
            d.dgrm_version, 
            d.dgrm_category,
            case when not exists( select null from flow_objects objt where objt.objt_dgrm_id = d.dgrm_id ) then 'No' else 'Yes' end as diagram_parsed
         from flow_diagrams d
         where d.dgrm_id = l_dgrm_id;

      ut.expect( l_actual ).to_equal( l_expected );

   end test_model_creation;

   procedure test_process_start
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_dgrm_id     flow_diagrams.dgrm_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- get dgrm_id to use for comparison
      l_dgrm_id := get_dgrm_id( model_90b );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90b
         , pi_prcs_name => 'test - AI model B start'
      );
      g_prcs_id_1 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Verify process is running and positioned at TaskA
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - AI model B start' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      -- Verify we're at TaskA
      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            'TaskA' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;

      ut.expect( l_actual ).to_equal( l_expected );

   end test_process_start;

   procedure test_complete_task_a
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- create and start process
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90b
         , pi_prcs_name => 'test - complete TaskA'
      );
      g_prcs_id_2 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Complete TaskA using test helper
      test_helper.step_forward(
        pi_prcs_id => l_prcs_id,
        pi_current => 'TaskA'
      );

      -- Verify we're now at TaskB
      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            'TaskB' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;

      ut.expect( l_actual ).to_equal( l_expected );

   end test_complete_task_a;

   procedure test_task_b_variable_expressions
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
      l_var_exists  number;
   begin
      -- create and start process, step to TaskB
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90b
         , pi_prcs_name => 'test - TaskB variables'
      );
      g_prcs_id_3 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Step forward to TaskB - this should trigger beforeTask variable expressions
      test_helper.step_forward(
        pi_prcs_id => l_prcs_id,
        pi_current => 'TaskA'
      );

      -- At TaskB, variables should now be set by beforeTask expressions
      -- Test the static variable was set
      open l_expected for
         select 'Task B Variable Set' as var_value from dual;

      open l_actual for
         select flow_process_vars.get_var_vc2(
           pi_prcs_id => l_prcs_id,
           pi_var_name => 'task_b_started'
         ) as var_value from dual;

      ut.expect( l_actual ).to_equal( l_expected );

      -- Test the PL/SQL expression variable was set (timestamp should exist and be reasonable)
      select count(*) into l_var_exists
      from flow_process_variables  
      where prov_prcs_id = l_prcs_id
        and prov_var_name = 'task_b_timestamp'
        and prov_var_vc2 is not null
        and length(prov_var_vc2) >= 20;  -- timestamp format should be at least 20 chars

      ut.expect( l_var_exists ).to_equal( 1 );

   end test_task_b_variable_expressions;

   procedure test_variables_at_task_c
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
      l_timestamp   varchar2(100);
   begin
      -- create and start process, progress to TaskC
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90b
         , pi_prcs_name => 'test - variables at TaskC'
      );
      g_prcs_id_4 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Step through TaskA and TaskB to reach TaskC
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskB');

      -- Verify we're at TaskC
      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            'TaskC' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;

      ut.expect( l_actual ).to_equal( l_expected );

      -- Test that variables set by TaskB beforeTask expressions persisted
      open l_expected for
         select 'Task B Variable Set' as static_var from dual;

      open l_actual for
         select flow_process_vars.get_var_vc2(
           pi_prcs_id => l_prcs_id,
           pi_var_name => 'task_b_started'
         ) as static_var from dual;

      ut.expect( l_actual ).to_equal( l_expected );

      -- Test timestamp variable is still accessible and valid
      l_timestamp := flow_process_vars.get_var_vc2(
        pi_prcs_id => l_prcs_id,
        pi_var_name => 'task_b_timestamp'
      );

      ut.expect( l_timestamp ).to_be_not_null();
      ut.expect( length(l_timestamp) ).to_be_greater_than( 19 );  -- Valid timestamp format

   end test_variables_at_task_c;

   procedure test_complete_remaining_tasks
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- create and start process, progress through all tasks
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90b
         , pi_prcs_name => 'test - complete remaining tasks'
      );
      g_prcs_id_5 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Complete TaskA, TaskB, TaskC, TaskD
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskB');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskC');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskD');

      -- Verify process completed
      open l_expected for
         select 
            l_prcs_id as prcs_id,
            flow_constants_pkg.gc_prcs_status_completed as prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      -- Verify variables are still accessible even after process completion
      ut.expect( flow_process_vars.get_var_vc2(
        pi_prcs_id => l_prcs_id,
        pi_var_name => 'task_b_started'
      ) ).to_equal( 'Task B Variable Set' );

   end test_complete_remaining_tasks;

   procedure test_full_execution_with_variables  
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
      l_task_count  number;
      l_var_count   number;
   begin
      -- create and start process
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90b
         , pi_prcs_name => 'test - full execution with variables'
      );
      g_prcs_id_6 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Execute complete workflow
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskB');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskC');  
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskD');

      -- Verify process completed successfully
      open l_expected for
         select 
            l_prcs_id as prcs_id,
            flow_constants_pkg.gc_prcs_status_completed as prcs_status
         from dual;

      open l_actual for
         select prcs_id, prcs_status 
         from flow_processes 
         where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      -- Verify we have 4 completed tasks in the process history
      select count(*) into l_task_count
      from flow_subflow_log
      where sflg_prcs_id = l_prcs_id 
        and sflg_objt_id in ('TaskA', 'TaskB', 'TaskC', 'TaskD');

      ut.expect( l_task_count ).to_equal( 4 );

      -- Verify we have the expected variables from beforeTask expressions
      select count(*) into l_var_count
      from flow_process_variables
      where prov_prcs_id = l_prcs_id
        and prov_var_name in ('task_b_started', 'task_b_timestamp')
        and prov_var_vc2 is not null;

      ut.expect( l_var_count ).to_equal( 2 );

   end test_full_execution_with_variables;

   procedure tear_down_tests
   is
   begin
      -- Clean up test processes
      for i in 1..8 loop
        case i
          when 1 then if g_prcs_id_1 is not null then flow_api_pkg.flow_delete(g_prcs_id_1); end if;
          when 2 then if g_prcs_id_2 is not null then flow_api_pkg.flow_delete(g_prcs_id_2); end if;
          when 3 then if g_prcs_id_3 is not null then flow_api_pkg.flow_delete(g_prcs_id_3); end if;
          when 4 then if g_prcs_id_4 is not null then flow_api_pkg.flow_delete(g_prcs_id_4); end if;
          when 5 then if g_prcs_id_5 is not null then flow_api_pkg.flow_delete(g_prcs_id_5); end if;
          when 6 then if g_prcs_id_6 is not null then flow_api_pkg.flow_delete(g_prcs_id_6); end if;
          when 7 then if g_prcs_id_7 is not null then flow_api_pkg.flow_delete(g_prcs_id_7); end if;
          when 8 then if g_prcs_id_8 is not null then flow_api_pkg.flow_delete(g_prcs_id_8); end if;
        end case;
      end loop;
   end tear_down_tests;

end test_090_ai_basic_model_b;
/