create or replace package body test_090_ai_basic_model is
/* 
-- Flows for APEX - test_090_ai_basic_model.pkb
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created  13-Mar-2026   Claude Sonnet 4 AI (Generated)
--
-- Test Suite 90: Test Basic AI Model Creation
-- Tests basic sequential task execution through TaskA > TaskB > TaskC > TaskD
*/

   model_90a constant varchar2(100) := 'A90a - Basic AI Model';
   
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
     -- parse the diagram
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => get_dgrm_id(model_90a));
   end set_up_tests;

   procedure test_model_creation
   is
      l_dgrm_id     flow_diagrams.dgrm_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- get dgrm_id to use for comparison
      l_dgrm_id := get_dgrm_id( model_90a );

      -- Verify the model was created and parsed successfully
      open l_expected for
         select 
            model_90a as dgrm_name, 
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
      l_dgrm_id := get_dgrm_id( model_90a );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90a
         , pi_prcs_name => 'test - AI basic model start'
      );
      g_prcs_id_1 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Verify process is running and positioned at TaskA
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - AI basic model start' as prcs_name, 
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
      l_sbfl_id     flow_subflows.sbfl_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- create and start process
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90a
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

   procedure test_complete_task_b
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_sbfl_id     flow_subflows.sbfl_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- create and start process, complete TaskA
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90a
         , pi_prcs_name => 'test - complete TaskB'
      );
      g_prcs_id_3 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Complete TaskA using test helper
      test_helper.step_forward(
        pi_prcs_id => l_prcs_id,
        pi_current => 'TaskA'
      );

      -- Complete TaskB using test helper
      test_helper.step_forward(
        pi_prcs_id => l_prcs_id,
        pi_current => 'TaskB'
      );

      -- Verify we're now at TaskC
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

   end test_complete_task_b;

   procedure test_complete_task_c
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_sbfl_id     flow_subflows.sbfl_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- create and start process, progress to TaskC
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90a
         , pi_prcs_name => 'test - complete TaskC'
      );
      g_prcs_id_4 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Complete TaskA and TaskB to reach TaskC
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskB');

      -- Complete TaskC
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskC');
      
      -- Verify we're now at TaskD
      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            'TaskD' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id and sbfl_status = flow_constants_pkg.gc_sbfl_status_running;

      ut.expect( l_actual ).to_equal( l_expected );

   end test_complete_task_c;

   procedure test_complete_task_d
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_sbfl_id     flow_subflows.sbfl_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- create and start process, progress to TaskD
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90a
         , pi_prcs_name => 'test - complete TaskD'
      );
      g_prcs_id_5 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Complete TaskA, TaskB, and TaskC to reach TaskD
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskA');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskB');
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskC');

      -- Complete TaskD (final task)
      test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'TaskD');

      -- Verify process is completed
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

   end test_complete_task_d;

   procedure test_full_sequential_execution
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_sbfl_id     flow_subflows.sbfl_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
      l_task_count  number;
   begin
      -- create and start process
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90a
         , pi_prcs_name => 'test - full sequential execution'
      );
      g_prcs_id_6 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Complete all tasks sequentially using test helper
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

   end test_full_sequential_execution;

   procedure test_process_variable_persistence
   is
      l_prcs_id     flow_processes.prcs_id%type;
      l_sbfl_id     flow_subflows.sbfl_id%type;
      l_actual      sys_refcursor;
      l_expected    sys_refcursor;
   begin
      -- create and start process
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_90a
         , pi_prcs_name => 'test - variable persistence'
      );
      g_prcs_id_7 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- Set a process variable during TaskA
      flow_process_vars.set_var(
        pi_prcs_id => l_prcs_id,
        pi_var_name => 'test_var',
        pi_vc2_value => 'AI_Generated_Test_Value'
      );

      -- Complete TaskA using test helper
      test_helper.step_forward(
        pi_prcs_id => l_prcs_id,
        pi_current => 'TaskA'
      );

      -- Verify the variable persisted through task completion
      open l_expected for
         select 'AI_Generated_Test_Value' as var_value from dual;

      open l_actual for
         select flow_process_vars.get_var_vc2(
           pi_prcs_id => l_prcs_id,
           pi_var_name => 'test_var'
         ) as var_value from dual;

      ut.expect( l_actual ).to_equal( l_expected );

   end test_process_variable_persistence;

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

end test_090_ai_basic_model;
/