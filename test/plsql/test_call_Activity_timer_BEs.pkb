/* 
-- Flows for APEX - test_call_Activity_timer_BEs.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 16-May-2022   Richard Allen, Oracle   
-- 
*/

create or replace package body test_call_Activity_timer_BEs is

  g_model_a12a constant varchar2(100) := 'A12a - Boundary Events with Call Activities';
  g_model_a12b constant varchar2(100) := 'A12b - Called Activity with 20 Second Delay';
  g_model_a12c constant varchar2(100) := 'A12c - Called Activity with 2 Second Delay';

  g_test_prcs_name constant varchar2(100) := 'test - CallActivity Timer BEs';

  g_sbfl_path1_main             flow_subflows.sbfl_id%type;
  g_sbfl_path1_afterBE          flow_subflows.sbfl_id%type;
  g_sbfl_path2_main             flow_subflows.sbfl_id%type;
  g_sbfl_path2_afterBE          flow_subflows.sbfl_id%type;
  g_sbfl_path3_main             flow_subflows.sbfl_id%type;
  g_sbfl_path3_afterBE          flow_subflows.sbfl_id%type;
  g_sbfl_path4_main             flow_subflows.sbfl_id%type;
  g_sbfl_path4_afterBE          flow_subflows.sbfl_id%type;

  g_prcs_id       flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a12a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a12b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a12c_id  flow_diagrams.dgrm_id%type;

  procedure set_up_process
  is
    l_actual   sys_refcursor;
    l_expected sys_refcursor;
  begin

    -- get dgrm_ids to use for comparaison
    g_dgrm_a12a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a12a );
    g_dgrm_a12b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a12b );
    g_dgrm_a12c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a12c );

    g_prcs_dgrm_id := g_dgrm_a12a_id;

    -- create a new instance
    g_prcs_id := flow_api_pkg.flow_create(
       pi_dgrm_id   => g_prcs_dgrm_id
     , pi_prcs_name => g_test_prcs_name
    );
     
    -- check no existing process variables
    
    open l_actual for
      select *
      from flow_process_variables
      where prov_prcs_id = g_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
    -- start process and check running status
        
    flow_api_pkg.flow_start( p_process_id => g_prcs_id );

    open l_expected for
        select
        g_prcs_dgrm_id                              as prcs_dgrm_id,
        g_test_prcs_name                            as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = g_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );
    
    -- check all parallel subflows running
   
    open l_expected for
       select
          g_prcs_id as sbfl_prcs_id,
          g_prcs_dgrm_id as sbfl_dgrm_id,
          'Activity_Pre1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          g_prcs_id as sbfl_prcs_id,
          g_prcs_dgrm_id as sbfl_dgrm_id,
          'Activity_Pre2' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          g_prcs_id as sbfl_prcs_id,
          g_prcs_dgrm_id as sbfl_dgrm_id,
          'Activity_Pre3' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
       select
          g_prcs_id as sbfl_prcs_id,
          g_prcs_dgrm_id as sbfl_dgrm_id,
          'Activity_Pre4' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       ;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   select sbfl_id
     into g_sbfl_path1_main
     from flow_subflows
    where sbfl_prcs_id = g_prcs_id
      and sbfl_current = 'Activity_Pre1';
      
   select sbfl_id
     into g_sbfl_path2_main
     from flow_subflows
    where sbfl_prcs_id = g_prcs_id
      and sbfl_current = 'Activity_Pre2';         
      
   select sbfl_id
     into g_sbfl_path3_main
     from flow_subflows
    where sbfl_prcs_id = g_prcs_id
      and sbfl_current = 'Activity_Pre3';         
      
   select sbfl_id
     into g_sbfl_path4_main
     from flow_subflows
    where sbfl_prcs_id = g_prcs_id
      and sbfl_current = 'Activity_Pre4';         
      
      -- all running and ready for tests
  end set_up_process;
   

  -- Lanre 1: Non-Interrupting timer boundary events on CallActivity - smoke
  procedure test_callActivity_non_int_timer_BE_fires_smoke
  is
    l_actual   sys_refcursor;
    l_expected sys_refcursor;
    l_actual_vc2  varchar2(200);
    l_actual_boolean boolean;
  begin
    -- step into callActivity
    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path1_main);

   select sbfl_id
     into g_sbfl_path1_afterBE
     from flow_subflows
    where sbfl_prcs_id = g_prcs_id
      and sbfl_current = 'Event_BE1';  

   -- test status of main and afterBE subflows after becoming current
    open l_expected for
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_Call1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_in_callactivity sbfl_status
       from dual
       union
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Event_BE1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual
       union       
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12b_id as sbfl_dgrm_id,
          'Event_DelayTimer20s' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path2_main, g_sbfl_path3_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- wait 30sec (20 sec + 10 sec timer cycle time)
   dbms_session.sleep(35);

   -- test status of main and afterBE subflows after becoming current
    open l_expected for
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_After1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union       
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_AfterBE1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path2_main, g_sbfl_path3_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- check that Proc Var from Called Activity is returned to main

    l_actual_vc2 := flow_process_vars.get_var_vc2  
                   ( pi_prcs_id => g_prcs_id
                   , pi_var_name => 'ReturnedValue1'
                   , pi_scope => 0
                   );
    ut.expect (l_actual_vc2).to_equal ('SetInCalled');

   -- step forward on Main 1 and After BE 1 to completion

    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path1_main);
    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path1_afterBE);

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path2_main, g_sbfl_path3_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_be_empty;
   
  end test_callActivity_non_int_timer_BE_fires_smoke;


  -- Lane 2 : Non-Interrupting timer boundary events on CallActivity - smoke
  procedure test_callActivity_non_int_timer_BE_cancels_smoke
  is
    l_actual            sys_refcursor;
    l_expected          sys_refcursor;
    l_actual_vc2        varchar2(200);
    l_actual_boolean    boolean;
  begin
    -- step into callActivity
    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path2_main);

   select sbfl_id
     into g_sbfl_path2_afterBE
     from flow_subflows
    where sbfl_prcs_id = g_prcs_id
      and sbfl_current = 'Event_BE2';  

   -- test status of main and afterBE subflows after becoming current
    open l_expected for
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_Call2' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_in_callactivity sbfl_status
       from dual
       union
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Event_BE2' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual
       union       
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12c_id as sbfl_dgrm_id,
          'Event_DelayTimer2s' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path3_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- wait 30sec (20 sec + 10 sec timer cycle time)
   dbms_session.sleep(20);

   -- test status of main  subflows after becoming current
    open l_expected for
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_After2' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path3_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_equal( l_expected );


   -- check that Proc Var from Called Activity is returned to main

    l_actual_vc2 := flow_process_vars.get_var_vc2  
                   ( pi_prcs_id => g_prcs_id
                   , pi_var_name => 'ReturnedValue2'
                   , pi_scope => 0
                   );
    ut.expect (l_actual_vc2).to_equal ('SetInCalled');

   -- step forward on Main 2 to completion

    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path2_main);

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path3_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_be_empty;
   
  end test_callActivity_non_int_timer_BE_cancels_smoke;

  -- Lane 3 - Interrupting timer boundary events on CallActivity - fires - smoke
  procedure test_callActivity_int_timer_BE_fires_smoke
 is
    l_actual   sys_refcursor;
    l_expected sys_refcursor;
    l_actual_vc2  varchar2(200);
    l_actual_boolean boolean;
  begin
    -- step into callActivity
    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path3_main);

   -- test status of main and afterBE subflows after becoming current
    open l_expected for
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_Call3' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_in_callactivity sbfl_status
       from dual
       union   
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12b_id as sbfl_dgrm_id,
          'Event_DelayTimer20s' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path2_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- wait 30sec (10 sec + 10 sec timer cycle time)
   dbms_session.sleep(21);

   -- test status of main and afterBE subflows after becoming current
    open l_expected for     
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_AfterBE3' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path2_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- check that Proc Var from Called Activity is NOT returned to main

    l_actual_vc2 := flow_process_vars.get_var_vc2  
                   ( pi_prcs_id => g_prcs_id
                   , pi_var_name => 'ReturnedValue3'
                   , pi_scope => 0
                   );
    ut.expect (l_actual_vc2).to_be_null();

   -- check that the Called Activity did not complete

    l_actual_boolean := test_helper.has_step_completed
                 ( pi_prcs_id         => g_prcs_id
                 , pi_objt_bpmn_id    => 'Activity Call 3'
                 );

    ut.expect (l_actual_boolean).to_be_false();

   -- step forward on Main 3

    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path3_main);

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path2_main, g_sbfl_path4_main);
    ut.expect( l_actual ).to_be_empty;
   
  end test_callActivity_int_timer_BE_fires_smoke;

    -- Lane 4 - Interrupting timer boundary events on CallActivity - cancels - smoke
  procedure test_callActivity_int_timer_BE_cancels_smoke
 is
    l_actual   sys_refcursor;
    l_expected sys_refcursor;
    l_actual_vc2  varchar2(200);
    l_actual_boolean boolean;
  begin
    -- step into callActivity
    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path4_main);

   -- test status of main and afterBE subflows after becoming current
    open l_expected for
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_Call4' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_in_callactivity sbfl_status
       from dual
       union   
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12c_id as sbfl_dgrm_id,
          'Event_DelayTimer2s' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path2_main, g_sbfl_path3_main);
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- wait 30sec (2 sec + 10 sec timer cycle time)
   dbms_session.sleep(15);

   -- test status of main and afterBE subflows after becoming current
    open l_expected for     
       select
          g_prcs_id as sbfl_prcs_id,
          g_dgrm_a12a_id as sbfl_dgrm_id,
          'Activity_After4' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;
    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path2_main, g_sbfl_path3_main);
    ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- check that Proc Var from Called Activity is returned to main

    l_actual_vc2 := flow_process_vars.get_var_vc2  
                   ( pi_prcs_id => g_prcs_id
                   , pi_var_name => 'ReturnedValue4'
                   , pi_scope => 0
                   );
    ut.expect(l_actual_vc2).to_equal('SetInCalled');

   -- step forward on Main 4

    test_helper.step_forward ( pi_prcs_id => g_prcs_id, pi_sbfl_id => g_sbfl_path4_main);

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = g_prcs_id
       and sbfl_status not like 'split'
       and sbfl_id not in (g_sbfl_path1_main, g_sbfl_path2_main, g_sbfl_path3_main);
    ut.expect( l_actual ).to_be_empty;
   
  end test_callActivity_int_timer_BE_cancels_smoke;

  procedure tear_down_process
  is
  begin
    flow_api_pkg.flow_delete (p_process_id => g_prcs_id);
  end tear_down_process;

end test_call_Activity_timer_BEs;
/
