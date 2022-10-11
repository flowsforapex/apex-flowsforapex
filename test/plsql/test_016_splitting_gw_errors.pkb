create or replace package body test_016_splitting_gw_errors as
/* 
-- Flows for APEX - test_016_splitting_gw_errors.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 20-Jun-2022   Richard Allen - Oracle
--
*/
  -- uses models 16a
  g_model_a16a constant varchar2(100) := 'A16a - Inc Gateway Tx Boundaries';

  g_test_prcs_name constant varchar2(100) := 'test16 - Spliting GW Errors';

  g_prcs_id       flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a16a_id  flow_diagrams.dgrm_id%type;

  --beforeall
  procedure set_up_tests
  is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
  begin

    -- get dgrm_ids to use for comparison
    g_dgrm_a16a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a16a );
    g_prcs_dgrm_id := g_dgrm_a16a_id;

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
    
    -- check initial subflow running
   
      open l_expected for
         select
            g_prcs_id                   as sbfl_prcs_id,
            g_prcs_dgrm_id              as sbfl_dgrm_id,
            'Activity_starter'          as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = g_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step model forward to set A and B

    test_helper.step_forward(pi_prcs_id => g_prcs_id, pi_current => 'Activity_starter');    
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            g_prcs_id           as sbfl_prcs_id,
            g_prcs_dgrm_id      as sbfl_dgrm_id,
            'Activity_AHeader'  as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            g_prcs_id           as sbfl_prcs_id,
            g_prcs_dgrm_id      as sbfl_dgrm_id,
            'Activity_BHeader'  as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual       
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = g_prcs_id
         and sbfl_status not like 'split';

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

    -- step model forward into set A 

    test_helper.step_forward(pi_prcs_id => g_prcs_id, pi_current => 'Activity_AHeader');   

    -- all running and ready for tests 

  end set_up_tests;

  --test(A1a - No Routing - fail and restart)
  procedure no_route_instruction
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test A1 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA1');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status, sbfl_id
        into l_actual_vc2, test_sbfl_id
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_current = 'Gateway_A1';
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);


    -- set gateway route & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Gateway_A1:route'
                                , pi_vc2_value => 'Flow_A1A:Flow_A1B'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_A1'
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check gateway subflow is in running state
      select sbfl_status, sbfl_id
        into l_actual_vc2, test_sbfl_id
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id      = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_split);

    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_A1' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A1A' as sbfl_current
          from dual
          union
        select 'Gateway_A1' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A1B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_A1';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A1A');   
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A1B');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A1A_End')).to_be_true();
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A1B_End')).to_be_true();

  end no_route_instruction;

  --test(A2 - Bad Route Instruction)
  procedure bad_route_instruction
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test A2 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA2');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status, sbfl_id
        into l_actual_vc2, test_sbfl_id
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_current = 'Gateway_A2';
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);


    -- set gateway route & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Gateway_A2:route'
                                , pi_vc2_value => 'Flow_A2A:Flow_A2B'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_A2'
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check gateway subflow is in running state
      select sbfl_status, sbfl_id
        into l_actual_vc2, test_sbfl_id
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id      = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_split);

    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_A2' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A2A' as sbfl_current
          from dual
          union
        select 'Gateway_A2' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A2B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_A2';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A2A');   
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A2B');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A2A_End')).to_be_true();
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A2B_End')).to_be_true();
 
  end bad_route_instruction;

  --test(A3 - Bad pre-split expression)
  procedure bad_pre_split_expression
 is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    /*
    This test works by causing an error in the pre-split variable expression for the gateway.
    It attempts to copy proc var Copy_to_A3 which is set up in the pre-step to contain 'rubbish', 
    into a numeric variable in the pre-split variable expression set of the gateway.  As 'rubbish'
    cannot be converted to a number, this fails.
    Restarting the test is done by changing the Copy-to_A3 variable to the string '9', 
    which does convert on the restart.
    */
    -- step model forward into test A3 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA3');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status, sbfl_id
        into l_actual_vc2, test_sbfl_id
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_current = 'Gateway_A3';
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);


    -- reset variable being copied & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_A3'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_A3'
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check gateway subflow is in running state
      select sbfl_status, sbfl_id
        into l_actual_vc2, test_sbfl_id
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id      = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_split);

    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_A3' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A3A' as sbfl_current
          from dual
          union
        select 'Gateway_A3' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A3B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_A3';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A3A');   
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A3B');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A3A_End')).to_be_true();
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A3B_End')).to_be_true();
  
  end bad_pre_split_expression;

  --test(A4 - Bad pre-step expression in following step)
  procedure bad_following_pre_step_expression
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    /*
    This test works by causing an error in the pre-split variable expression for the gateway.
    It attempts to copy proc var Copy_to_A4 which is set up in the pre-step to contain 'rubbish', 
    into a numeric variable in the pre-split variable expression set of the gateway.  As 'rubbish'
    cannot be converted to a number, this fails.
    Restarting the test is done by changing the Copy_to_A4 variable to the string '9', 
    which does convert on the restart.
    */
    -- step model forward into test A3 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA4');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_A4' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_error as sbfl_status
             , 'Activity_A4A' as sbfl_current
          from dual
          union
        select 'Gateway_A4' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A4B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_A4';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- reset variable being copied & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_A4'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Activity_A4A'
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_A4' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A4A' as sbfl_current
          from dual
          union
        select 'Gateway_A4' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A4B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_A4';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A4A');   
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A4B');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A4A_End')).to_be_true();
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A4B_End')).to_be_true();
  
  end bad_following_pre_step_expression;

  --test(B1 - bad post_phase expression)
  procedure bad_post_phase_expression_A
is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    /*
    This test works by causing an error in the pre-split variable expression for the gateway.
    It attempts to copy proc var Copy_to_A3 which is set up in the pre-step to contain 'rubbish', 
    into a numeric variable in the pre-split variable expression set of the gateway.  As 'rubbish'
    cannot be converted to a number, this fails.
    Restarting the test is done by changing the Copy-to_A3 variable to the string '9', 
    which does convert on the restart.
    Note that Test B1 causes an error in the CURRENT step (unlike tests A1-4, which cause errors in future steps, beyond the first --Drop a Procedure
    transaction boundary) and so this ttest returns an error message to the calling process.   The test is split into 2 parts
    firstly up to the error With a utexpect.error, and second part for the restart.

    */

    -- step model forward into set B 

    test_helper.step_forward(pi_prcs_id => g_prcs_id, pi_current => 'Activity_BHeader');   

    -- step model forward into test B1 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB1');   


    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_B1' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B1A' as sbfl_current
          from dual
          union
        select 'Gateway_B1' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B1B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_B1';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- step model forward on  B1A - should cause an error

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1A'); 

  end bad_post_phase_expression_A; 

  procedure bad_post_phase_expression_B
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- check process is in running state
    -- reason : error was on current step so pocess not marked as error status

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state
    -- reason : error was on current step so process not marked as error status

      select sbfl_status, sbfl_id
        into l_actual_vc2, test_sbfl_id
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_current = 'Activity_B1A';
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);


    -- reset variable being copied & try again

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_B1'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.step_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Activity_B1A'
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_B1' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_waiting_gateway as sbfl_status
             , 'Gateway_B1Merge' as sbfl_current
          from dual
          union
        select 'Gateway_B1' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B1B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_B1';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows
  
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1B');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_B1End')).to_be_true();
  
  end bad_post_phase_expression_B;

  --test(B2 - bad post-merge expression)
  procedure bad_post_merge_expression
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test B2 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB2');   


    -- with 2 forward running subflows...

      open l_expected for
        select 'Gateway_B2' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B2A' as sbfl_current
          from dual
          union
        select 'Gateway_B2' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B2B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_B2';
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- step model forward on  B1A - should be OK

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A'); 

    -- step model forward on  B2B - should cause an error in gateway Gateway-B2Merge

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2B'); 

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check 1 subflow at merging gateway (other is still waiting) is in error state

      open l_expected for
        select 'Gateway_B2' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_waiting_gateway as sbfl_status
             , 'Gateway_B2Merge' as sbfl_current
          from dual
          union
        select 'Gateway_B2' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_error as sbfl_status
             , 'Gateway_B2Merge' as sbfl_current
          from dual;        

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_B2';
    ut.expect(l_expected).to_equal(l_actual).unordered;  

    -- get subflow with the error

    select sbfl.sbfl_id
      into test_sbfl_id
      from flow_subflows sbfl
     where sbfl.sbfl_current = 'Gateway_B2Merge'
       and sbfl.sbfl_starting_object = 'Gateway_B2'
       and sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_error
       and sbfl.sbfl_prcs_id = test_prcs_id;

    -- reset variable being copied & try again

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_B2'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_sbfl_id  => test_sbfl_id
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select 'Gateway_BSplit' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B2C' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_BSplit'
           and sbfl_current not in ('Activity_PreB1', 'Activity_PreB3', 'Activity_PreB4');
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflow
  
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2C');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_B2End')).to_be_true();
   
  end bad_post_merge_expression;

  --test(B3 - bad post-phase in scripttask pre-merge)
  procedure bad_post_phase_before_merge
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test B3 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB3');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check 1 subflow at merging gateway (other is still waiting) is in error state

      open l_expected for
        select 'Gateway_B3' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_waiting_gateway as sbfl_status
             , 'Gateway_B3Merge' as sbfl_current
          from dual
          union
        select 'Gateway_B3' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_error as sbfl_status
             , 'Activity_B3A' as sbfl_current
          from dual;        

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_B3';
    ut.expect(l_expected).to_equal(l_actual).unordered;  

    -- reset variable being copied & try again

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_B3'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Activity_B3A'
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select 'Gateway_BSplit' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B3C' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_BSplit'
           and sbfl_current not in ('Activity_PreB1', 'Activity_PreB2', 'Activity_PreB4');
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflow
  
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B3C');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_B3End')).to_be_true();
   
  end bad_post_phase_before_merge;

  --test B4 - bad pre-phase in task after merge gw)
  procedure bad_pre_phase_after_merge
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_dgrm_a16a_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test B3 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB4');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check 1 subflow at merging gateway (other is still waiting) is in error state

      open l_expected for
        select 'Gateway_BSplit' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_error as sbfl_status
             , 'Activity_B4C' as sbfl_current
          from dual;        

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_BSplit'
           and sbfl_current not in ('Activity_PreB1', 'Activity_PreB2', 'Activity_PreB3');
    ut.expect(l_expected).to_equal(l_actual).unordered;  

    -- reset variable being copied & try again

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_B4'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Activity_B4C'
                                  );

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select 'Gateway_BSplit' as sbfl_starting_object
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B4C' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_starting_object, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_starting_object = 'Gateway_BSplit'
           and sbfl_current not in ('Activity_PreB1', 'Activity_PreB2', 'Activity_PreB3');
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflow
  
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B4C');   
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B4D');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_B4End')).to_be_true();
   
  end bad_pre_phase_after_merge;


  procedure tear_down_tests 
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test Suite 16');

           ut.expect( v('APP_SESSION')).to_be_null;
           
  end tear_down_tests;

end test_016_splitting_gw_errors;