create or replace package body test_003_startEvents is
/* 
-- Flows for APEX - test_003_startEvents.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 07-July-2022   Richard Allen, Oracle   
-- 
*/
   -- uses models A03a-i

   -- tests  good and bad startEvent definitions

  g_model_a03a constant varchar2(100) := 'A03a - Model with No Start Event';
  g_model_a03b constant varchar2(100) := 'A03b - Model with multiple Start Events';
  g_model_a03c constant varchar2(100) := 'A03c - Model with one good Start Event';
  g_model_a03d constant varchar2(100) := 'A03d - Model with one start event of bad type';
  g_model_a03e constant varchar2(100) := 'A03e - Model with one start event with good timer';
  g_model_a03f constant varchar2(100) := 'A03f - Model with one start event with bad timer definition';
  g_model_a03g constant varchar2(100) := 'A03g - Model with one start event with bad on-event var exp';
  g_model_a03h constant varchar2(100) := 'A03h - Model with one start event with bad before-event var exp';

  g_test_prcs_name constant varchar2(100) := 'test 003 - start events';

  g_prcs_id       flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a03a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a03b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a03c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a03d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a03e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a03f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a03g_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a03h_id  flow_diagrams.dgrm_id%type;

  g_prcs_id_1    number;
  g_prcs_id_2    number;
  g_prcs_id_3    number;
  g_prcs_id_4    number;
  g_prcs_id_5    number;
  g_prcs_id_6    number;
  g_prcs_id_7    number;
  g_prcs_id_8    number;
  g_prcs_id_9    number;
  
   --beforeall
   procedure setup_tests
   is
   begin
     g_dgrm_a03a_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03a);
     g_dgrm_a03b_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03b);
     g_dgrm_a03c_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03c);
     g_dgrm_a03d_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03d);
     g_dgrm_a03e_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03e);
     g_dgrm_a03f_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03f);
     g_dgrm_a03g_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03g);
     g_dgrm_a03h_id := test_helper.set_dgrm_id (pi_dgrm_name => g_model_a03h);

     -- parse the diagrams
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03a_id);
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03b_id);
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03c_id);
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03d_id);
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03e_id);
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03f_id);
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03g_id);
     flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a03h_id);

   end setup_tests;

   --test(03a - no start event)
   
   procedure no_start_event
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03a_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03a - no_start'
      );
      g_prcs_id_1 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );
      

   end no_start_event;

   --test(03b - multiple start events)
   
   procedure multiple_start_events
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03b_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03b - many_starts'
      );
      g_prcs_id_2 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );
  
   end multiple_start_events;

   --test(03c - good start event)
   
   procedure good_start_event
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03c_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03c - good_start'
      );
      g_prcs_id_3 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        'test03c - good_start'                      as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check  subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'A'               as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual   
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_EndA')).to_be_true();
    
   end  good_start_event;

   --test(03d - incorrect start type)
   
   procedure incorrect_start_type
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03d_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03d - wrong_start_type'
      );
      g_prcs_id_4 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );
   end incorrect_start_type;

   --test(03e - good timer start event)
   
   procedure good_timer_start
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03e_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03e - good_timer_start'
      );
      g_prcs_id_5 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                      as prcs_dgrm_id,
        'test03e - good_timer_start'                      as prcs_name,
        flow_constants_pkg.gc_prcs_status_running         as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  

   -- wait 12sec (2 sec + 10 sec timer cycle time)
   dbms_session.sleep(12); 
  
    -- check  subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'A'               as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual   
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         ;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_EndA')).to_be_true();
    
   end good_timer_start;

   --test(03f - timer start event with bad timer definition)
   
   procedure bad_timer_definition
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03f_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03f - bad_timer_definition'
      );
      g_prcs_id_6 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );
   end  bad_timer_definition;

   --test(03g - startEvent with bad on-event var exp)
   
   procedure bad_on_event_var_exp
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03g_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03g - startEvent with bad on-event'
      );
      g_prcs_id_7 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );
   end bad_on_event_var_exp;

   --test(03h-a - timer startEvent with bad before-event var exp - throw )
   procedure bad_before_event_1
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03h_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03h - bad before-event'
      );
      g_prcs_id_8 := test_prcs_id;

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_Before'
                                , pi_scope => 0
                                , pi_vc2_value => 'rubbish'
                                );

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_On'
                                , pi_scope => 0
                                , pi_vc2_value => 'rubbish'
                                );                          

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );

      -- this should throw an exception trying to convert a string 'rubbish' to a number.
   end  bad_before_event_1;

   --test(03h-a - timer startEvent with bad before-event var exp - restart )
   procedure bad_before_event_2
   is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a03h_id;
    test_prcs_id  flow_processes.prcs_id%type;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := g_prcs_id_8;

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_Before'
                                , pi_scope => 0
                                , pi_vc2_value => '9'
                                );                         

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );

      -- this should now start - but then fail when the timer fires & the on-event throws...

    open l_expected for
        select
        test_dgrm_id                                      as prcs_dgrm_id,
        'test03h - bad before-event'                      as prcs_name,
        flow_constants_pkg.gc_prcs_status_running         as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  

        -- check  subflow waiting for timer
   
      open l_expected for
         select
            test_prcs_id                                    as sbfl_prcs_id,
            test_dgrm_id                                    as sbfl_dgrm_id,
            'Event_StartA'                                  as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_waiting_timer as sbfl_status
         from dual   
         ;
      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         ;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;


   -- wait 12sec (2 sec + 10 sec timer cycle time)
   dbms_session.sleep(12); 
  
  -- should now be in error status

    open l_expected for
        select
        test_dgrm_id                                      as prcs_dgrm_id,
        'test03h - bad before-event'                      as prcs_name,
        flow_constants_pkg.gc_prcs_status_error           as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  

      open l_expected for
         select
            test_prcs_id                                    as sbfl_prcs_id,
            test_dgrm_id                                    as sbfl_dgrm_id,
            'Event_StartA'                                  as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_error         as sbfl_status
         from dual   
         ;
      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         ;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- now the restart for the on-event...
      --- first fix the bad variable
      
      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_On'
                                , pi_scope => 0
                                , pi_vc2_value => '9'
                                );   
     test_helper.restart_forward(pi_prcs_id  => test_prcs_id,
                                  pi_current  => 'Event_StartA');
    -- this should reschedule it immediately, so wait ine timer cycle...                             
     dbms_session.sleep(11); 
    -- should now be in running status again if restarted

    open l_expected for
        select
        test_dgrm_id                                      as prcs_dgrm_id,
        'test03h - bad before-event'                      as prcs_name,
        flow_constants_pkg.gc_prcs_status_running         as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  

      open l_expected for
         select
            test_prcs_id                                    as sbfl_prcs_id,
            test_dgrm_id                                    as sbfl_dgrm_id,
            'A'                                             as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running       as sbfl_status
         from dual   
         ;
      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         ;
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_EndA')).to_be_true();
                                
   end  bad_before_event_2;

   --test(03i - attempt to start a running process)
   procedure start_running_process
   is
      l_actual          sys_refcursor;
      l_expected        sys_refcursor;
      l_actual_vc2      varchar2(200);
      l_actual_number   number;
      test_dgrm_id      flow_diagrams.dgrm_id%type := g_dgrm_a03c_id;
      test_prcs_id      flow_processes.prcs_id%type;
      test_sbfl_id      flow_subflows.sbfl_id%type;
      test_prcs_name    flow_processes.prcs_name%type := g_test_prcs_name;
  begin
      -- create a new instance
      test_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => test_dgrm_id
         , pi_prcs_name => 'test03c - good_start'
      );
      g_prcs_id_9 := test_prcs_id;

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    open l_expected for
        select
        test_dgrm_id                                as prcs_dgrm_id,
        'test03c - good_start'                      as prcs_name,
        flow_constants_pkg.gc_prcs_status_running   as prcs_status
        from dual;
    open l_actual for
        select prcs_dgrm_id, prcs_name, prcs_status 
          from flow_processes p
         where p.prcs_id = test_prcs_id;
    ut.expect( l_actual ).to_equal( l_expected );  
     
    -- check  subflow running
   
      open l_expected for
         select
            test_prcs_id      as sbfl_prcs_id,
            test_dgrm_id      as sbfl_dgrm_id,
            'A'               as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual   
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- try to start it a second time while it is already started

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );

    
   end start_running_process;

   --afterall
   
   procedure tear_down_tests
   is
   begin
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_1);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_2);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_3);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_4);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_5);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_6);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_7);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_8);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_9);
   end tear_down_tests;

end test_003_startEvents;
/
