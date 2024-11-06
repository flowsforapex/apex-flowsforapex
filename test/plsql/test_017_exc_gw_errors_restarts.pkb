create or replace package body test_017_exc_gw_errors_restarts as
/* 
-- Flows for APEX - test_017_exc_gw_errors_restarts.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 30-Jun-2022   Richard Allen - Oracle
--
*/

  -- uses models 17a
  g_model_a17a constant varchar2(100) := 'A17a - Exc GW Errors and Restarts';

  g_test_prcs_name constant varchar2(100) := 'test017 - Exc GW Errors and Restarts';

  g_prcs_id       flow_processes.prcs_id%type;
  g_prcs_dgrm_id  flow_diagrams.dgrm_id%type; -- process level diagram id
  g_dgrm_a17a_id  flow_diagrams.dgrm_id%type;

  --beforeall
  procedure set_up_tests
  is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
  begin

    -- get dgrm_ids to use for comparison
    g_dgrm_a17a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a17a );
    g_prcs_dgrm_id := g_dgrm_a17a_id;

    -- parse the diagrams
    flow_bpmn_parser_pkg.parse(pi_dgrm_id => g_dgrm_a17a_id);

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
     
    -- check 1st parallel pair of subflow running
   
      open l_expected for
         select
            g_prcs_id           as sbfl_prcs_id,
            g_prcs_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreA'  as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual
         union
         select
            g_prcs_id           as sbfl_prcs_id,
            g_prcs_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreB'  as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running sbfl_status  
          from dual   
          union
          select
            g_prcs_id           as sbfl_prcs_id,
            g_prcs_dgrm_id      as sbfl_dgrm_id,
            'Activity_PreC'  as sbfl_current,
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

    test_helper.step_forward(pi_prcs_id => g_prcs_id, pi_current => 'Activity_PreA');   

    -- all running and ready for tests 

  end set_up_tests;

  --test(A1 - Default Routing)

  procedure default_routing
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test A2 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreA1' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA1');   

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A1B' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A1B');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A1End')).to_be_true();

  end default_routing;

  --test(A2 - Good Routing Variable)

  procedure good_routing_variable
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test A1 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreA2' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA2');   

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A2A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A2A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A2End')).to_be_true();

  end good_routing_variable;

  --test(A3 - Routing Variable - Too Many routes)

  procedure too_many_routing_variable_routes 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test A3 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreA3' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA3');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);

    -- reset gateway route & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Gateway_A3Split:route'
                                , pi_vc2_value => 'Flow_A3A'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_A3Split'
                                  );

    -- check process is back in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A3A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A3A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A3End')).to_be_true();

  end too_many_routing_variable_routes;

  --test(A4 - No Routing Supplied)

  procedure no_routing 
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test A4 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreA4' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA4');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);

    -- reset gateway route & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Gateway_A4Split:route'
                                , pi_vc2_value => 'Flow_A4A'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_A4Split'
                                  );

    -- check process is back in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A4A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A4A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A4End')).to_be_true();

  end no_routing;

  --test(A5 - Bad Routing Variable)
  
  procedure bad_routing
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
    -- step model forward into test A5 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreA5' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreA5');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);

    -- reset gateway route & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Gateway_A5Split:route'
                                , pi_vc2_value => 'Flow_A5A'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_A5Split'
                                  );

    -- check process is back in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_A5A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_A5A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_A5End')).to_be_true();

  end bad_routing;

  --test(B1 - Good Pre-split Routing Variable)
  
  procedure good_pre_split_var_exp
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
  
    -- step model forward into test set B 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB');   

    -- step model forward into test B1 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreB1' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB1');   

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B1A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B1A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_B1End')).to_be_true();

  end good_pre_split_var_exp;

  --test(B2 - only 1 forward path)
  
  procedure single_path
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
  
    -- step model forward into test B2 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreB2' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB2');   

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_B2A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_B2A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_B2End')).to_be_true();

  end single_path;

  --test(B3 - single path, autorun)
  
  procedure single_path_autorun
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
  
    -- step model forward into test B3

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreB3' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreB3');   

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_B2End')).to_be_true();

  end single_path_autorun;

  --test(C1 - error in following pre-task)
  
  procedure following_pre_task_error
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin
  
    -- step model forward into test set C 

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreC');   

    -- step model forward into test C1 

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreC1' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreC1');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);

    -- reset gateway route & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_C1'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Activity_C1A'
                                  );

    -- check process is back in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_C1A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C1A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_C1End')).to_be_true();

  end following_pre_task_error;

  --test(C2 - error in pre-task variable expression)
  
  procedure pre_task_var_exp_error
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test C2

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreC2' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreC2');   

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);

    -- reset gateway route & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_C2'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_C2Split'
                                  );

    -- check process is back in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_C2A' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C2A');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_C2End')).to_be_true();

  end pre_task_var_exp_error;

  --test(C3 - error in post-merge variable expression)
  
  procedure post_merge_var_exp_error
  is
    l_actual      sys_refcursor;
    l_expected    sys_refcursor;
    l_actual_vc2    varchar2(200);
    l_actual_number number;
    test_dgrm_id  flow_diagrams.dgrm_id%type := g_prcs_dgrm_id;
    test_prcs_id  flow_processes.prcs_id%type := g_prcs_id;
    test_sbfl_id  flow_subflows.sbfl_id%type;
    test_prcs_name flow_processes.prcs_name%type := g_test_prcs_name;
  begin

    -- step model forward into test C3

    test_sbfl_id := test_helper.get_sbfl_id(pi_prcs_id  => test_prcs_id /*in number*/,
                                            pi_current  => 'Activity_PreC3' /*in varchar2*/);
    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_PreC3');   

    -- check process is in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- attempt to step forward from C3A, triggering post merge error in GatewayC3Split

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C3A');     

    -- check process is in error state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_error);

    -- check subflow is in error state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_error);

    -- reset variable & restart

      flow_process_vars.set_var ( pi_prcs_id => test_prcs_id
                                , pi_var_name => 'Copy_to_C3'
                                , pi_vc2_value => '9'
                                , pi_scope => 0
                                );

      test_helper.restart_forward ( pi_prcs_id  => test_prcs_id
                                  , pi_current  => 'Gateway_C3Merge'
                                  );

    -- check process is back in running state

      select prcs_status
        into l_actual_vc2
        from flow_processes
       where prcs_id = test_prcs_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_prcs_status_running);

    -- check subflow is in running state

      select sbfl_status
        into l_actual_vc2
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
        and  sbfl_id = test_sbfl_id;
    ut.expect(l_actual_vc2 ).to_equal(flow_constants_pkg.gc_sbfl_status_running);

    -- with 1 forward running subflows...

      open l_expected for
        select test_sbfl_id as sbfl_id
             , flow_constants_pkg.gc_sbfl_status_running as sbfl_status
             , 'Activity_C3C' as sbfl_current
          from dual;

      open l_actual for
        select sbfl_id, sbfl_status, sbfl_current
          from flow_subflows
         where sbfl_prcs_id = test_prcs_id
           and sbfl_status != flow_constants_pkg.gc_sbfl_status_split
           and sbfl_id = test_sbfl_id;
    ut.expect(l_expected).to_equal(l_actual).unordered;         

    -- complete forward subflows

    test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_C3C');     

    -- check parent subflow completed
    ut.expect (test_helper.has_step_completed(pi_prcs_id => test_prcs_id, pi_objt_bpmn_id => 'Event_C3End')).to_be_true();

  end post_merge_var_exp_error;

  --test(Suite - Process completed successfully)
  
  procedure check_process_completed
    is
      l_actual   sys_refcursor;
      l_expected sys_refcursor;    
    begin
        -- if all of the tests have completed correctly, the process should also have completed.
        -- final test is to check that all subflows, and hence the process, completed correctly.
        open l_expected for
            select
            g_prcs_dgrm_id                                  as prcs_dgrm_id,
            g_test_prcs_name                                as prcs_name,
            flow_constants_pkg.gc_prcs_status_completed     as prcs_status
            from dual;

        open l_actual for
            select prcs_dgrm_id, prcs_name, prcs_status 
              from flow_processes p
             where p.prcs_id = g_prcs_id;

        ut.expect( l_actual ).to_equal( l_expected );
  end check_process_completed;

  -- afterall
  procedure tear_down_tests 
  is
  begin
    flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id,
                             p_comment  => 'Ran by utPLSQL as Test Suite 017');

    ut.expect( v('APP_SESSION')).to_be_null;
           
  end tear_down_tests;

end test_017_exc_gw_errors_restarts;
/
