create or replace package body test_007_procvars as
/* 
-- Flows for APEX - test_007_procvars.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created 09-May-2023   Richard Allen - Oracle
--
*/

  -- uses models 19a-g
  g_model_a07a constant varchar2(100) := 'A07a - Process Variable API - Main';
  g_model_a07b constant varchar2(100) := 'A07b - Process Variable API - Called Diagram';
  --g_model_a07c constant varchar2(100) := 'A07a - ';
  --g_model_a07d constant varchar2(100) := 'A07a - ';
  --g_model_a07e constant varchar2(100) := 'A07a - ';
  --g_model_a07f constant varchar2(100) := 'A07a - ';
  --g_model_a07g constant varchar2(100) := 'A07a - ';

  g_test_prcs_name_a constant varchar2(100) := 'test - process variable API a';
  g_test_prcs_name_b constant varchar2(100) := 'test - process variable API b';
  g_test_prcs_name_c constant varchar2(100) := 'test - process variable API c';
  g_test_prcs_name_d constant varchar2(100) := 'test - process variable API d';
  g_test_prcs_name_e constant varchar2(100) := 'test - process variable API e';
  g_test_prcs_name_f constant varchar2(100) := 'test - process variable API f';
  g_test_prcs_name_g constant varchar2(100) := 'test - process variable API g';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a07a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a07b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a07c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a07d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a07e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a07f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a07g_id  flow_diagrams.dgrm_id%type;

  g_mask_date     varchar2(50) := 'DD-MON-YYYY HH24:MI:SS';
  g_mask_tstz     varchar2(50) := 'DD-MON-YYYY HH24:MI:SS TZR';
  
  g_sbfl_main     flow_subflows.sbfl_id%type;
  g_sbfl_sub      flow_subflows.sbfl_id%type;
  g_sbfl_call1    flow_subflows.sbfl_id%type;
  g_sbfl_call2    flow_subflows.sbfl_id%type;
  g_scope_main    flow_subflows.sbfl_scope%type := 0;
  g_scope_sub     flow_subflows.sbfl_scope%type := 0;
  g_scope_call    flow_subflows.sbfl_scope%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a07a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a07a );
    g_dgrm_a07b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a07b );
    --g_dgrm_a07c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a07c );
    --g_dgrm_a07d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a07d );
    --g_dgrm_a07e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a07e );
    --g_dgrm_a07f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a07f );
    --g_dgrm_a07g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a07g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a07a_id);
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a07b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a07c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a07d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a07e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a07f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a07g_id);

  end set_up_tests; 

  procedure before_each_test
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_dgrm_id_call    flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;
  begin
    -- get dgrm_id to use for comparaison
    l_dgrm_id       := g_dgrm_a07a_id;
    l_dgrm_id_call  := g_dgrm_a07b_id;
    l_prcs_name     := g_test_prcs_name_a;
    -- create a new instance
    l_prcs_id := flow_api_pkg.flow_create
                  ( pi_dgrm_id   => l_dgrm_id
                  , pi_prcs_name => l_prcs_name
                  );
    g_prcs_id_a := l_prcs_id;

    -- check no existing process variables
    
    open l_actual for
    select *
    from flow_process_variables
    where prov_prcs_id = l_prcs_id;
    ut.expect( l_actual ).to_have_count( 0 );
    
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
          'Activity_BeforeTests' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not like 'split';
    ut.expect( l_actual ).to_equal( l_expected ).unordered;  

    -- get the subflow id
    select sbfl_id
      into g_sbfl_main
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_BeforeTests';

    -- step into the subprocess

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_BeforeTests' ); 

    -- check all parallel subflows running

    open l_expected for
         select
          l_prcs_id as sbfl_prcs_id,
          l_dgrm_id as sbfl_dgrm_id,
          'Activity_A1' as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ( 'split', 'in subprocess', 'in call activity') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;  

    -- get the subflow id
    select sbfl_id
      into g_sbfl_sub
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_A1';

    -- step into the call activity

    test_helper.step_forward(pi_prcs_id => l_prcs_id, pi_current => 'Activity_A1' ); 

    -- check all parallel subflows running

    open l_expected for
       select
          l_prcs_id       as sbfl_prcs_id,
          l_dgrm_id_call  as sbfl_dgrm_id,
          'Activity_B1'   as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual
       union
         select
          l_prcs_id       as sbfl_prcs_id,
          l_dgrm_id_call  as sbfl_dgrm_id,
          'Activity_B2'   as sbfl_current,
          flow_constants_pkg.gc_sbfl_status_running sbfl_status
       from dual;

    open l_actual for
       select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
       from flow_subflows 
       where sbfl_prcs_id = l_prcs_id
       and sbfl_status not in ( 'split', 'in subprocess', 'in call activity') ;
    ut.expect( l_actual ).to_equal( l_expected ).unordered;  

    -- get the subflow id and scope
    select sbfl_id
         , sbfl_scope
      into g_sbfl_call1
         , g_scope_call 
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_B1';

    select sbfl_id
      into g_sbfl_call2
      from flow_subflows
     where sbfl_prcs_id = l_prcs_id
       and sbfl_current = 'Activity_B2';


  end before_each_test;




  procedure test_procvars
  ( p_name      flow_process_variables.prov_var_name%type
  , p_type      flow_process_variables.prov_var_type%type    
  , p_prcs_id   flow_process_variables.prov_prcs_id%type
  , p_sbfl_id   flow_subflows.sbfl_id%type 
  , p_scope     flow_process_variables.prov_scope%type
  , p_vc2       flow_process_variables.prov_var_vc2%type 
  , p_number    flow_process_variables.prov_var_num%type      
  , p_date      flow_process_variables.prov_var_date%type      
  , p_tstz      flow_process_variables.prov_var_tstz%type  
  , p_clob      flow_process_variables.prov_var_clob%type    
  , p_error_on_null boolean default false
  )
  is
    l_actual          sys_refcursor;
    l_expected        sys_refcursor;
    l_actual_tstz     timestamp with time zone;
    l_expected_tstz   timestamp with time zone;
    l_actual_vc2      varchar2(2000);
    l_expected_vc2    varchar2(2000);
    l_actual_num      number;
    l_expected_num    number;
    l_actual_date     date;
    l_expected_date   date;
    l_actual_clob     clob;
    l_expected_clob   clob;
    l_dgrm_id         flow_diagrams.dgrm_id%type;
    l_prcs_name       flow_processes.prcs_name%type;
    l_prcs_id         flow_processes.prcs_id%type;  
    l_var_rec         flow_proc_vars_int.t_proc_var_value;
  begin
    -- test value in database table

    open l_expected for
      select p_prcs_id  as prcs_id
           , p_name     as var_name
           , p_scope    as scope
           , p_type     as var_type
           , p_vc2      as val_vc2
           , p_number   as val_num
           , p_date     as val_date
           , p_tstz     as val_tstz
           , p_clob     as val_clob
      from dual;

    open l_actual for
      select prov_prcs_id     as prcs_id
           , prov_var_name    as var_name
           , prov_scope       as scope
           , prov_var_type    as var_type
           , prov_var_vc2     as val_vc2
           , prov_var_num     as val_num
           , prov_var_date    as val_date 
           , prov_var_tstz    as val_tstz
           , prov_var_clob    as val_clob
      from flow_process_variables
      where prov_prcs_id = p_prcs_id
      and   prov_scope = p_scope 
      and   prov_var_name  = p_name;
    ut.expect(l_actual).to_equal(l_expected).unordered;

    -- test value in record type (internal package)
    
    l_var_rec := flow_proc_vars_int.get_var_value ( pi_prcs_id => p_prcs_id
                                                  , pi_var_name => p_name
                                                  , pi_scope => p_scope
                                                  , pi_exception_on_null => p_error_on_null
                                                  );
    ut.expect(l_var_rec.var_name).to_equal(p_name);
    ut.expect(l_var_rec.var_type).to_equal(p_type);
    ut.expect(l_var_rec.var_vc2 ).to_equal(p_vc2 );
    ut.expect(l_var_rec.var_num ).to_equal(p_number);
    ut.expect(to_char(l_var_rec.var_date,g_mask_date)).to_equal(to_char(p_date,g_mask_date));
    ut.expect(to_char(l_var_rec.var_tstz,g_mask_tstz)).to_equal(to_char(p_tstz,g_mask_tstz));
    ut.expect(l_var_rec.var_clob).to_equal(p_clob);

    -- test get_type sig1

    l_actual_vc2 := flow_process_vars.get_var_type ( pi_prcs_id => p_prcs_id
                                                   , pi_var_name => p_name
                                                   , pi_scope => p_scope
                                                   );
    ut.expect(l_actual_vc2).to_equal(p_type);

    l_actual_vc2 := null;

    -- test get_type sig 2

    l_actual_vc2 := flow_process_vars.get_var_type ( pi_prcs_id => p_prcs_id
                                                   , pi_var_name => p_name
                                                   , pi_sbfl_id => p_sbfl_id
                                                   );
    ut.expect(l_actual_vc2).to_equal(p_type);    

    l_actual_vc2 := null;

    -- test get_var_vc2 sig1

    l_actual_vc2 := flow_process_vars.get_var_vc2 ( pi_prcs_id => p_prcs_id
                                                  , pi_var_name => p_name
                                                  , pi_scope => p_scope
                                                  );
    ut.expect(l_actual_vc2).to_equal(p_vc2);

    l_actual_vc2 := null;

    -- test get_var_vc2 sig2

    l_actual_vc2 := flow_process_vars.get_var_vc2 ( pi_prcs_id => p_prcs_id
                                                  , pi_var_name => p_name
                                                  , pi_sbfl_id => p_sbfl_id
                                                  );
    ut.expect(l_actual_vc2).to_equal(p_vc2);

    l_actual_vc2 := null;

    -- test get_var_num sig1

    l_actual_num := flow_process_vars.get_var_num ( pi_prcs_id => p_prcs_id
                                                  , pi_var_name => p_name
                                                  , pi_scope => p_scope
                                                  );
    ut.expect(l_actual_num).to_equal(p_number);

    l_actual_num := null;

    -- test get_var_num sig2

    l_actual_num := flow_process_vars.get_var_num ( pi_prcs_id => p_prcs_id
                                                  , pi_var_name => p_name
                                                  , pi_sbfl_id => p_sbfl_id
                                                  );
    ut.expect(l_actual_num).to_equal(p_number);

    l_actual_num := null;

    -- test get_var_date sig1

    l_actual_date := flow_process_vars.get_var_date ( pi_prcs_id => p_prcs_id
                                                    , pi_var_name => p_name
                                                    , pi_scope => p_scope
                                                    );
    ut.expect(l_actual_date).to_equal(p_date);

    l_actual_date := null;

    -- test get_var_date sig2

    l_actual_date := flow_process_vars.get_var_date ( pi_prcs_id => p_prcs_id
                                                    , pi_var_name => p_name
                                                    , pi_sbfl_id => p_sbfl_id
                                                    );
    ut.expect(l_actual_date).to_equal(p_date);

    l_actual_date := null;

    -- test get_var_tstz sig1

    l_actual_tstz := flow_process_vars.get_var_tstz ( pi_prcs_id => p_prcs_id
                                                    , pi_var_name => p_name
                                                    , pi_scope => p_scope
                                                    );
    ut.expect(l_actual_tstz).to_equal(p_tstz);

    l_actual_tstz := null;

    -- test get_var_tstz sig2

    l_actual_tstz := flow_process_vars.get_var_tstz ( pi_prcs_id => p_prcs_id
                                                    , pi_var_name => p_name
                                                    , pi_sbfl_id => p_sbfl_id
                                                    );
    ut.expect(l_actual_tstz).to_equal(p_tstz);

    l_actual_tstz := null;

    -- test get_var_clob sig1

    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id => p_prcs_id
                                                    , pi_var_name => p_name
                                                    , pi_scope => p_scope
                                                    );
    ut.expect(l_actual_clob).to_equal(p_clob);

    l_actual_clob := null;

    -- test get_var_clob sig2

    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id => p_prcs_id
                                                    , pi_var_name => p_name
                                                    , pi_sbfl_id => p_sbfl_id
                                                    );
    ut.expect(l_actual_clob).to_equal(p_clob);

    l_actual_clob := null;



  end test_procvars;





  -- test(A1 - VC2 no scope Set Insert)
  procedure varchar2_no_scope_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA1'
                              , pi_vc2_value  => 'TestA1');

    test_procvars ( p_name          => 'VarA1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestA1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_no_scope_set_insert;              

  -- test(A2 - VC2 in Scope0 Set Update)
  procedure varchar2_no_scope_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_vc2_value  => 'TestA2');                      

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestA2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_vc2_value  => 'TestA2B');   

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestA2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_no_scope_set_update;   


  -- test(B1 - VC2 in Scope0 Set Insert)
  procedure varchar2_in_scope0_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_vc2_value  => 'TestB1'
                              , pi_scope      => 0
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestB1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_in_scope0_set_insert;              

  -- test(B2 - VC2 in Scope0 Set Update)
  procedure varchar2_in_scope0_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_vc2_value  => 'TestB2'
                              , pi_scope      => 0
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestB2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_vc2_value  => 'TestB2B'
                              , pi_scope      => 0
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestB2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_in_scope0_set_update;  

  -- test(C1 - VC2 in Scope0 Set Insert)
  procedure varchar2_in_scope0_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_vc2_value  => 'TestB1'
                              , pi_sbfl_id    => g_sbfl_main
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestB1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_in_scope0_sbfl_set_insert;              

  -- test(C2 - VC2 in Scope0 Set Update)
  procedure varchar2_in_scope0_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_vc2_value  => 'TestB2'
                              , pi_sbfl_id    => g_sbfl_main
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestB2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_vc2_value  => 'TestB2B'
                              , pi_sbfl_id    => g_sbfl_main
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => 'TestB2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_in_scope0_sbfl_set_update;  

  -- test(D1 - VC2 in Scope0 Set Insert) -- uses sub process sbfl_id, still in scope 0
  procedure varchar2_in_scope0_sbfl_sub_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_vc2_value  => 'TestB1'
                              , pi_sbfl_id    => g_sbfl_sub
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => 'TestB1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_in_scope0_sbfl_sub_set_insert;              

  -- test(D2 - VC2 in Scope0 Set Update)  -- uses sub process sbfl_id, still in scope 0
  procedure varchar2_in_scope0_sbfl_sub_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_vc2_value  => 'TestB2'
                              , pi_sbfl_id    => g_sbfl_sub
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => 'TestB2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_vc2_value  => 'TestB2B'
                              , pi_sbfl_id    => g_sbfl_sub
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => 'TestB2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_in_scope0_sbfl_sub_set_update;  

  -- test(E1 - VC2 in Call Activity Scope Set Insert)
  procedure varchar2_in_scope_call_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE1'
                              , pi_vc2_value  => 'TestE1'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarE1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestE1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_in_scope_call_set_insert;              

  -- test(E2 - VC2 in Call Activity Scope Set Update)
  procedure varchar2_in_scope_call_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_vc2_value  => 'TestE2'
                              , pi_scope      => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestE2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_vc2_value  => 'TestE2B'
                              , pi_scope      => g_scope_call
                              );   

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestE2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_in_scope_call_set_update;  

  -- test(F1 - VC2 in Scope0 Set Insert)
  procedure varchar2_in_scope_call_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF1'
                              , pi_vc2_value  => 'TestF1'
                              , pi_sbfl_id    => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarF1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestF1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_in_scope_call_sbfl_set_insert;              

  -- test(F2 - VC2 in Scope0 Set Update)
  procedure varchar2_in_scope_call_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_vc2_value  => 'TestF2'
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestF2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_vc2_value  => 'TestF2B'
                              , pi_sbfl_id    => g_sbfl_call1
                              );   

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestF2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_in_scope_call_sbfl_set_update;  

  -- test(G1 - VC2 call by sbfl_id with bad sbfl id - set insert)
  procedure varchar2_call_by_bad_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG1'
                              , pi_vc2_value  => 'TestG1'
                              , pi_sbfl_id    => 99999999
                              );

    test_procvars ( p_name          => 'VarG1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_main
                  , p_vc2           => 'TestG1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_call_by_bad_sbfl_set_insert;              

  -- test(G2 - VC2 in Scope0 Set Update)
  procedure varchar2_call_by_bad_sbfl_set_update
  is
  begin
    -- first set (insert) uses a valid sbfl_id
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_vc2_value  => 'TestG2'
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestG2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_vc2_value  => 'TestG2B'
                              , pi_sbfl_id    => 99999999
                              );   

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestG2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_call_by_bad_sbfl_set_update;  

  --aftereach
  procedure tear_down_tests  
  is
  begin
     flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 007');
     --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_a,  p_comment  => 'Ran by utPLSQL as Test Suite 007');
     --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_b,  p_comment  => 'Ran by utPLSQL as Test Suite 007');
     --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_c,  p_comment  => 'Ran by utPLSQL as Test Suite 007');
     --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_d,  p_comment  => 'Ran by utPLSQL as Test Suite 007');
     --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_e,  p_comment  => 'Ran by utPLSQL as Test Suite 007');
     --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_f,  p_comment  => 'Ran by utPLSQL as Test Suite 007');
     --flow_api_pkg.flow_delete(p_process_id  =>  g_prcs_id_g,  p_comment  => 'Ran by utPLSQL as Test Suite 007');

    ut.expect( v('APP_SESSION')).to_be_null;
  end tear_down_tests;

end test_007_procvars;