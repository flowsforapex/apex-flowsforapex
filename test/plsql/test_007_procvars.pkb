set define off
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

  g_date_a        date := to_date('01-MAY-2023 14:00:34',g_mask_date);
  g_date_b        date := to_date('01-JUN-2023 16:00:34',g_mask_date);
  g_date_c        date := to_date('01-JUL-2023 18:00:34',g_mask_date);

  g_tstz_a        timestamp with time zone := to_timestamp_tz('01-MAY-2023 14:00:34 GMT',g_mask_tstz);
  g_tstz_b        timestamp with time zone := to_timestamp_tz('01-JUN-2023 16:00:34 GMT',g_mask_tstz);
  g_tstz_c        timestamp with time zone := to_timestamp_tz('01-JUL-2023 18:00:34 GMT',g_mask_tstz);

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
    l_input_vc2       varchar2(500);
    l_input_clob      clob;
    l_test_step_key   flow_subflows.sbfl_step_key%type := 'ABCDEF12';
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

    -- test substitutions on varchar2

    case p_type
    when 'VARCHAR2' then
      l_input_vc2    := 'Test String &F4A$process_id.-&F4A$subflow_id.-&F4A$step_key.-&F4A$'||p_name||'.-&F4A$nonExistantVar.'||'-'
                         ||'&F4A$PROCESS_PRIORITY.'||'.';
      l_expected_vc2 := 'Test String '||p_prcs_id||'-'||p_sbfl_id||'-'||l_test_step_key||'-'||p_vc2||'-&F4A$nonExistantVar.-2.';

      l_input_clob   := 'Test CLOB &F4A$process_id.-&F4A$subflow_id.-&F4A$step_key.-&F4A$'||p_name||'.-&F4A$nonExistantVar.'||'-'
                         ||'&F4A$PROCESS_PRIORITY.'||'.';
      l_expected_clob:= 'Test CLOB '||p_prcs_id||'-'||p_sbfl_id||'-'||l_test_step_key||'-'||p_vc2||'-&F4A$nonExistantVar.-2.';

      flow_proc_vars_int.do_substitution(pi_prcs_id  => p_prcs_id,
                                         pi_sbfl_id  => p_sbfl_id,
                                         pi_scope  => p_scope,
                                         pi_step_key  => l_test_step_key,
                                         pio_string  => l_input_vc2);

      ut.expect(l_input_vc2).to_equal(l_expected_vc2);


      flow_proc_vars_int.do_substitution(pi_prcs_id  => p_prcs_id,
                                         pi_sbfl_id  => p_sbfl_id,
                                         pi_scope  => p_scope,
                                         pi_step_key  => l_test_step_key,
                                         pio_string  => l_input_clob);

      ut.expect(l_input_clob).to_equal(l_expected_clob);      
    else
      null;
    end case;


  end test_procvars;

-------------------------------------------------------------------------------------
--
-- VARCHARS
--
-------------------------------------------------------------------------------------

  -- test(V-A1 - VC2 no scope Set Insert)
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

  -- test(V-A2 - VC2 in Scope0 Set Update)
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

  -- test(V-B1 - VC2 in Scope0 Set Insert)
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

  -- test(V-B2 - VC2 in Scope0 Set Update)
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

  -- test(V-C1 - VC2 in Scope0 Set Insert)
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

  -- test(V-C2 - VC2 in Scope0 Set Update)
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

  -- test(V-D1 - VC2 in Scope0 Set Insert) -- uses sub process sbfl_id, still in scope 0
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

  -- test(V-D2 - VC2 in Scope0 Set Update)  -- uses sub process sbfl_id, still in scope 0
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

  -- test(V-E1 - VC2 in Call Activity Scope Set Insert)
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

  -- test(V-E2 - VC2 in Call Activity Scope Set Update)
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

  -- test(V-F1 - VC2 in Scope0 Set Insert)
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

  -- test(V-F2 - VC2 in Scope0 Set Update)
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

  -- test(V-G1 - VC2 call by sbfl_id with bad sbfl id - set insert)
  procedure varchar2_call_by_bad_sbfl_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
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

  -- test(V-G2 - VC2 in Scope0 Set Update)
  procedure varchar2_call_by_bad_sbfl_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
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


  -- test(V-H1 - VC2 call by sbfl_id with bad scope - set insert)
  procedure varchar2_call_by_bad_scope_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH1'
                              , pi_vc2_value  => 'TestH1'
                              , pi_scope      => 99999999
                              );

    test_procvars ( p_name          => 'VarH1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => 99999999
                  , p_vc2           => 'TestH1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end varchar2_call_by_bad_scope_set_insert;              

  -- test(V-H2 -VC2 call by sbfl_id with bad scope Set Update)
  procedure varchar2_call_by_bad_scope_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid scope
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_vc2_value  => 'TestH2'
                              , pi_scope    => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestH2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_vc2_value  => 'TestH2B'
                              , pi_scope    => 99999999
                              );   

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => 99999999
                  , p_vc2           => 'TestH2B'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end varchar2_call_by_bad_scope_set_update;  

-------------------------------------------------------------------------------------
--
--  NUMBERS
--
-------------------------------------------------------------------------------------

  -- test(N-A1 - VC2 no scope Set Insert)
  procedure num_no_scope_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA1'
                              , pi_num_value  => 101);

    test_procvars ( p_name          => 'VarA1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 101     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_no_scope_set_insert;              

  -- test(N-A2 - VC2 in Scope0 Set Update)
  procedure num_no_scope_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_num_value  => 102);                      

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 102    
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_num_value  => 202);   

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 202     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_no_scope_set_update;   


  -- test(N-B1 - VC2 in Scope0 Set Insert)
  procedure num_in_scope0_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_num_value  => 111
                              , pi_scope      => 0
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 111     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_in_scope0_set_insert;              

  -- test(N-B2 - VC2 in Scope0 Set Update)
  procedure num_in_scope0_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_num_value  => 112
                              , pi_scope      => 0
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 112     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_num_value  => 212
                              , pi_scope      => 0
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 212     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_in_scope0_set_update;  

  -- test(N-C1 - VC2 in Scope0 Set Insert)
  procedure num_in_scope0_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_num_value  => 131
                              , pi_sbfl_id    => g_sbfl_main
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 131     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_in_scope0_sbfl_set_insert;              

  -- test(N-C2 - VC2 in Scope0 Set Update)
  procedure num_in_scope0_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_num_value  => 132
                              , pi_sbfl_id    => g_sbfl_main
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 132     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_num_value  => 232
                              , pi_sbfl_id    => g_sbfl_main
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 232     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_in_scope0_sbfl_set_update;  

  -- test(N-D1 - VC2 in Scope0 Set Insert) -- uses sub process sbfl_id, still in scope 0
  procedure num_in_scope0_sbfl_sub_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_num_value  => 141
                              , pi_sbfl_id    => g_sbfl_sub
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 141     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_in_scope0_sbfl_sub_set_insert;              

  -- test(N-D2 - VC2 in Scope0 Set Update)  -- uses sub process sbfl_id, still in scope 0
  procedure num_in_scope0_sbfl_sub_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_num_value  => 142
                              , pi_sbfl_id    => g_sbfl_sub
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 142     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_num_value  => 242
                              , pi_sbfl_id    => g_sbfl_sub
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => 242     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_in_scope0_sbfl_sub_set_update;  

  -- test(N-E1 - VC2 in Call Activity Scope Set Insert)
  procedure num_in_scope_call_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE1'
                              , pi_num_value  => 151
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarE1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 151     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_in_scope_call_set_insert;              

  -- test(N-E2 - VC2 in Call Activity Scope Set Update)
  procedure num_in_scope_call_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_num_value  => 152
                              , pi_scope      => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 152     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_num_value  => 252
                              , pi_scope      => g_scope_call
                              );   

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 252    
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_in_scope_call_set_update;  

  -- test(N-F1 - VC2 in Scope0 Set Insert)
  procedure num_in_scope_call_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF1'
                              , pi_num_value  => 161
                              , pi_sbfl_id    => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarF1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 161     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_in_scope_call_sbfl_set_insert;              

  -- test(N-F2 - VC2 in Scope0 Set Update)
  procedure num_in_scope_call_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_num_value  => 162
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 162    
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_num_value  => 262
                              , pi_sbfl_id    => g_sbfl_call1
                              );   

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 262     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_in_scope_call_sbfl_set_update;  

  -- test(N-G1 - VC2 call by sbfl_id with bad sbfl id - set insert)
  procedure num_call_by_bad_sbfl_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG1'
                              , pi_num_value  => 171
                              , pi_sbfl_id    => 99999999
                              );

    test_procvars ( p_name          => 'VarG1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_main
                  , p_vc2           => null
                  , p_number        => 171     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_call_by_bad_sbfl_set_insert;              

  -- test(N-G2 - VC2 in Scope0 Set Update)
  procedure num_call_by_bad_sbfl_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid sbfl_id
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_num_value  => 172
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 172     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_num_value  => 272
                              , pi_sbfl_id    => 99999999
                              );   

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 272     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_call_by_bad_sbfl_set_update;  


  -- test(N-H1 - VC2 call by sbfl_id with bad scope - set insert)
  procedure num_call_by_bad_scope_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH1'
                              , pi_num_value  => 181
                              , pi_scope      => 99999999
                              );

    test_procvars ( p_name          => 'VarH1'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => 181     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end num_call_by_bad_scope_set_insert;              

  -- test(N-H2 -VC2 call by sbfl_id with bad scope Set Update)
  procedure num_call_by_bad_scope_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid scope
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_num_value  => 182
                              , pi_scope    => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 182     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_num_value  => 282
                              , pi_scope    => 99999999
                              );   

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => 282     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end num_call_by_bad_scope_set_update;  

-------------------------------------------------------------------------------------
--
-- DATES
--
-------------------------------------------------------------------------------------

  -- test(D-A1 - Date no scope Set Insert)
  procedure date_no_scope_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA1'
                              , pi_date_value  => g_date_a);

    test_procvars ( p_name          => 'VarA1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_no_scope_set_insert;              

  -- test(D-A2 - Date in Scope0 Set Update)
  procedure date_no_scope_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_date_value  => g_date_b);                      

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_date_value  => g_date_c);   

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c   
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_no_scope_set_update;   


  -- test(D-B1 - Date in Scope0 Set Insert)
  procedure date_in_scope0_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_date_value  => g_date_a
                              , pi_scope      => 0
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_in_scope0_set_insert;              

  -- test(D-B2 - Date in Scope0 Set Update)
  procedure date_in_scope0_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_date_value  => g_date_b
                              , pi_scope      => 0
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_date_value  => g_date_c
                              , pi_scope      => 0
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_in_scope0_set_update;  

  -- test(D-C1 - Date in Scope0 Set Insert)
  procedure date_in_scope0_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_date_value  => g_date_a
                              , pi_sbfl_id    => g_sbfl_main
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_in_scope0_sbfl_set_insert;              

  -- test(D-C2 - Date in Scope0 Set Update)
  procedure date_in_scope0_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_date_value  => g_date_b
                              , pi_sbfl_id    => g_sbfl_main
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_date_value  => g_date_c
                              , pi_sbfl_id    => g_sbfl_main
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c   
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_in_scope0_sbfl_set_update;  

  -- test(D-D1 - Date in Scope0 Set Insert) -- uses sub process sbfl_id, still in scope 0
  procedure date_in_scope0_sbfl_sub_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_date_value  => g_date_a
                              , pi_sbfl_id    => g_sbfl_sub
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_in_scope0_sbfl_sub_set_insert;              

  -- test(D-D2 - Date in Scope0 Set Update)  -- uses sub process sbfl_id, still in scope 0
  procedure date_in_scope0_sbfl_sub_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_date_value  => g_date_b
                              , pi_sbfl_id    => g_sbfl_sub
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_date_value  => g_date_c
                              , pi_sbfl_id    => g_sbfl_sub
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_in_scope0_sbfl_sub_set_update;  

  -- test(D-E1 - Date in Call Activity Scope Set Insert)
  procedure date_in_scope_call_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE1'
                              , pi_date_value  => g_date_a
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarE1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_in_scope_call_set_insert;              

  -- test(D-E2 - Date in Call Activity Scope Set Update)
  procedure date_in_scope_call_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_date_value  => g_date_b
                              , pi_scope      => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_date_value  => g_date_c
                              , pi_scope      => g_scope_call
                              );   

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_in_scope_call_set_update;  

  -- test(D-F1 - Date in Scope0 Set Insert)
  procedure date_in_scope_call_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF1'
                              , pi_date_value  => g_date_a
                              , pi_sbfl_id    => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarF1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_in_scope_call_sbfl_set_insert;              

  -- test(D-F2 - Date in Scope0 Set Update)
  procedure date_in_scope_call_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_date_value  => g_date_b
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_date_value  => g_date_c
                              , pi_sbfl_id    => g_sbfl_call1
                              );   

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_in_scope_call_sbfl_set_update;  

  -- test(D-G1 - Date call by sbfl_id with bad sbfl id - set insert)
  procedure date_call_by_bad_sbfl_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG1'
                              , pi_date_value  => g_date_a
                              , pi_sbfl_id    => 99999999
                              );

    test_procvars ( p_name          => 'VarG1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_main
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_call_by_bad_sbfl_set_insert;              

  -- test(D-G2 - Date in Scope0 Set Update)
  procedure date_call_by_bad_sbfl_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid sbfl_id
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_date_value  => g_date_b
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_date_value  => g_date_c
                              , pi_sbfl_id    => 99999999
                              );   

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_call_by_bad_sbfl_set_update;  


  -- test(D-H1 - Date call by sbfl_id with bad scope - set insert)
  procedure date_call_by_bad_scope_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH1'
                              , pi_date_value  => g_date_a
                              , pi_scope      => 99999999
                              );

    test_procvars ( p_name          => 'VarH1'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_a    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end date_call_by_bad_scope_set_insert;              

  -- test(D-H2 - Date call by sbfl_id with bad scope Set Update)
  procedure date_call_by_bad_scope_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid scope
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_date_value  => g_date_b
                              , pi_scope    => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_date_value  => g_date_c
                              , pi_scope    => 99999999
                              );   

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_c    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end date_call_by_bad_scope_set_update;  

-------------------------------------------------------------------------------------
--
--  CLOBS
--
-------------------------------------------------------------------------------------

  -- test(C-A1 - CLOB no scope Set Insert)
  procedure clob_no_scope_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA1'
                              , pi_clob_value  => 'TestA1');

    test_procvars ( p_name          => 'VarA1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestA1'   
                  , p_error_on_null => false
                  );

    end clob_no_scope_set_insert;              

  -- test(C-A2 - CLOB in Scope0 Set Update)
  procedure clob_no_scope_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_clob_value  => 'TestA2');                      

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestA2'  
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_clob_value  => 'TestA2B');   

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestA2B'   
                  , p_error_on_null => false
                  );
    end clob_no_scope_set_update;   


  -- test(C-B1 - CLOB in Scope0 Set Insert)
  procedure clob_in_scope0_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_clob_value  => 'TestB1'
                              , pi_scope      => 0
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB1'   
                  , p_error_on_null => false
                  );

    end clob_in_scope0_set_insert;              

  -- test(C-B2 - CLOB in Scope0 Set Update)
  procedure clob_in_scope0_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_clob_value  => 'TestB2'
                              , pi_scope      => 0
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB2'   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_clob_value  => 'TestB2B'
                              , pi_scope      => 0
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB2B'   
                  , p_error_on_null => false
                  );
    end clob_in_scope0_set_update;  

  -- test(C-C1 - CLOB in Scope0 Set Insert)
  procedure clob_in_scope0_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_clob_value  => 'TestB1'
                              , pi_sbfl_id    => g_sbfl_main
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB1'   
                  , p_error_on_null => false
                  );

    end clob_in_scope0_sbfl_set_insert;              

  -- test(C-C2 - CLOB in Scope0 Set Update)
  procedure clob_in_scope0_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_clob_value  => 'TestB2'
                              , pi_sbfl_id    => g_sbfl_main
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB2'   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_clob_value  => 'TestB2B'
                              , pi_sbfl_id    => g_sbfl_main
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB2B'   
                  , p_error_on_null => false
                  );
    end clob_in_scope0_sbfl_set_update;  

  -- test(C-D1 - CLOB in Scope0 Set Insert) -- uses sub process sbfl_id, still in scope 0
  procedure clob_in_scope0_sbfl_sub_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_clob_value  => 'TestB1'
                              , pi_sbfl_id    => g_sbfl_sub
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB1'   
                  , p_error_on_null => false
                  );

    end clob_in_scope0_sbfl_sub_set_insert;              

  -- test(C-D2 - CLOB in Scope0 Set Update)  -- uses sub process sbfl_id, still in scope 0
  procedure clob_in_scope0_sbfl_sub_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_clob_value  => 'TestB2'
                              , pi_sbfl_id    => g_sbfl_sub
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB2'   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_clob_value  => 'TestB2B'
                              , pi_sbfl_id    => g_sbfl_sub
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestB2B' 
                  , p_error_on_null => false
                  );
    end clob_in_scope0_sbfl_sub_set_update;  

  -- test(C-E1 - CLOB in Call Activity Scope Set Insert)
  procedure clob_in_scope_call_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE1'
                              , pi_clob_value  => 'TestE1'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarE1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestE1'   
                  , p_error_on_null => false
                  );

    end clob_in_scope_call_set_insert;              

  -- test(C-E2 - CLOB in Call Activity Scope Set Update)
  procedure clob_in_scope_call_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_clob_value  => 'TestE2'
                              , pi_scope      => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestE2'   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_clob_value  => 'TestE2B'
                              , pi_scope      => g_scope_call
                              );   

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestE2B'   
                  , p_error_on_null => false
                  );
    end clob_in_scope_call_set_update;  

  -- test(C-F1 - CLOB in Scope0 Set Insert)
  procedure clob_in_scope_call_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF1'
                              , pi_clob_value  => 'TestF1'
                              , pi_sbfl_id    => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarF1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestF1'   
                  , p_error_on_null => false
                  );

    end clob_in_scope_call_sbfl_set_insert;              

  -- test(C-F2 - CLOB in Scope0 Set Update)
  procedure clob_in_scope_call_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_clob_value  => 'TestF2'
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestF2'   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_clob_value  => 'TestF2B'
                              , pi_sbfl_id    => g_sbfl_call1
                              );   

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestF2B'   
                  , p_error_on_null => false
                  );
    end clob_in_scope_call_sbfl_set_update;  

  -- test(C-G1 - CLOB call by sbfl_id with bad sbfl id - set insert)
  procedure clob_call_by_bad_sbfl_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG1'
                              , pi_clob_value  => 'TestG1'
                              , pi_sbfl_id    => 99999999
                              );

    test_procvars ( p_name          => 'VarG1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_main
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestG1'   
                  , p_error_on_null => false
                  );

    end clob_call_by_bad_sbfl_set_insert;              

  -- test(C-G2 - CLOB in Scope0 Set Update)
  procedure clob_call_by_bad_sbfl_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid sbfl_id
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_clob_value  => 'TestG2'
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestG2'   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_clob_value  => 'TestG2B'
                              , pi_sbfl_id    => 99999999
                              );   

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestG2B'   
                  , p_error_on_null => false
                  );
    end clob_call_by_bad_sbfl_set_update;  


  -- test(C-H1 - CLOB call by sbfl_id with bad scope - set insert)
  procedure clob_call_by_bad_scope_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH1'
                              , pi_clob_value  => 'TestH1'
                              , pi_scope      => 99999999
                              );

    test_procvars ( p_name          => 'VarH1'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestH1'   
                  , p_error_on_null => false
                  );

    end clob_call_by_bad_scope_set_insert;              

  -- test(C-H2 -VC2 call by sbfl_id with bad scope Set Update)
  procedure clob_call_by_bad_scope_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid scope
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_clob_value  => 'TestH2'
                              , pi_scope    => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestH2'   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_clob_value  => 'TestH2B'
                              , pi_scope    => 99999999
                              );   

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'TestH2B'   
                  , p_error_on_null => false
                  );
    end clob_call_by_bad_scope_set_update;  

-------------------------------------------------------------------------------------
--
--  TIMESTAMP WITH TIME ZONE (TSTZ)
--
-------------------------------------------------------------------------------------    

  -- test(T-A1 - TSTZ no scope Set Insert)
  procedure tstz_no_scope_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA1'
                              , pi_tstz_value  => g_tstz_a);

    test_procvars ( p_name          => 'VarA1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_no_scope_set_insert;              

  -- test(T-A2 - TSTZ in Scope0 Set Update)
  procedure tstz_no_scope_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_tstz_value  => g_tstz_b);                      

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarA2'
                              , pi_tstz_value  => g_tstz_c);   

    test_procvars ( p_name          => 'VarA2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null  
                  , p_tstz          => g_tstz_c 
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_no_scope_set_update;   


  -- test(T-B1 - TSTZ in Scope0 Set Insert)
  procedure tstz_in_scope0_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_tstz_value  => g_tstz_a
                              , pi_scope      => 0
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_in_scope0_set_insert;              

  -- test(T-B2 - TSTZ in Scope0 Set Update)
  procedure tstz_in_scope0_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_tstz_value  => g_tstz_b
                              , pi_scope      => 0
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_tstz_value  => g_tstz_c
                              , pi_scope      => 0
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_c
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_in_scope0_set_update;  

  -- test(T-C1 - TSTZ in Scope0 Set Insert)
  procedure tstz_in_scope0_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_tstz_value  => g_tstz_a
                              , pi_sbfl_id    => g_sbfl_main
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_in_scope0_sbfl_set_insert;              

  -- test(T-C2 - TSTZ in Scope0 Set Update)
  procedure tstz_in_scope0_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_tstz_value  => g_tstz_b
                              , pi_sbfl_id    => g_sbfl_main
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_tstz_value  => g_tstz_c
                              , pi_sbfl_id    => g_sbfl_main
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null   
                  , p_tstz          => g_tstz_c
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_in_scope0_sbfl_set_update;  

  -- test(T-D1 - TSTZ in Scope0 Set Insert) -- uses sub process sbfl_id, still in scope 0
  procedure tstz_in_scope0_sbfl_sub_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB1'
                              , pi_tstz_value  => g_tstz_a
                              , pi_sbfl_id    => g_sbfl_sub
                              );

    test_procvars ( p_name          => 'VarB1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_in_scope0_sbfl_sub_set_insert;              

  -- test(T-D2 - TSTZ in Scope0 Set Update)  -- uses sub process sbfl_id, still in scope 0
  procedure tstz_in_scope0_sbfl_sub_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_tstz_value  => g_tstz_b
                              , pi_sbfl_id    => g_sbfl_sub
                              );                      

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarB2'
                              , pi_tstz_value  => g_tstz_c
                              , pi_sbfl_id    => g_sbfl_sub
                              );   

    test_procvars ( p_name          => 'VarB2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_sub
                  , p_scope         => 0
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_c
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_in_scope0_sbfl_sub_set_update;  

  -- test(T-E1 - TSTZ in Call Activity Scope Set Insert)
  procedure tstz_in_scope_call_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE1'
                              , pi_tstz_value  => g_tstz_a
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarE1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_in_scope_call_set_insert;              

  -- test(T-E2 - TSTZ in Call Activity Scope Set Update)
  procedure tstz_in_scope_call_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_tstz_value  => g_tstz_b
                              , pi_scope      => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarE2'
                              , pi_tstz_value  => g_tstz_c
                              , pi_scope      => g_scope_call
                              );   

    test_procvars ( p_name          => 'VarE2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_c
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_in_scope_call_set_update;  

  -- test(T-F1 - TSTZ in Scope0 Set Insert)
  procedure tstz_in_scope_call_sbfl_set_insert
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF1'
                              , pi_tstz_value  => g_tstz_a
                              , pi_sbfl_id    => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarF1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_in_scope_call_sbfl_set_insert;              

  -- test(T-F2 - TSTZ in Scope0 Set Update)
  procedure tstz_in_scope_call_sbfl_set_update
  is
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_tstz_value  => g_tstz_b
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarF2'
                              , pi_tstz_value  => g_tstz_c
                              , pi_sbfl_id    => g_sbfl_call1
                              );   

    test_procvars ( p_name          => 'VarF2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_c
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_in_scope_call_sbfl_set_update;  

  -- test(T-G1 - TSTZ call by sbfl_id with bad sbfl id - set insert)
  procedure tstz_call_by_bad_sbfl_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG1'
                              , pi_tstz_value  => g_tstz_a
                              , pi_sbfl_id    => 99999999
                              );

    test_procvars ( p_name          => 'VarG1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_main
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null   
                  , p_tstz          => g_tstz_a 
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_call_by_bad_sbfl_set_insert;              

  -- test(T-G2 - TSTZ in Scope0 Set Update)
  procedure tstz_call_by_bad_sbfl_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid sbfl_id
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_tstz_value  => g_tstz_b
                              , pi_sbfl_id    => g_sbfl_call2
                              );                      

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarG2'
                              , pi_tstz_value  => g_tstz_c
                              , pi_sbfl_id    => 99999999
                              );   

    test_procvars ( p_name          => 'VarG2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => 99999999
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_c
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_call_by_bad_sbfl_set_update;  


  -- test(T-H1 - TSTZ call by sbfl_id with bad scope - set insert)
  procedure tstz_call_by_bad_scope_set_insert
  is
  begin
    flow_globals.set_is_recursive_step (false);
    
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH1'
                              , pi_tstz_value  => g_tstz_a
                              , pi_scope      => 99999999
                              );

    test_procvars ( p_name          => 'VarH1'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    end tstz_call_by_bad_scope_set_insert;              

  -- test(T-H2 - TSTZ call by sbfl_id with bad scope Set Update)
  procedure tstz_call_by_bad_scope_set_update
  is
  begin
    flow_globals.set_is_recursive_step (false);
    -- first set (insert) uses a valid scope
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_tstz_value  => g_tstz_b
                              , pi_scope    => g_scope_call
                              );                      

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_b
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    -- do another set to test the update path with bad sbfl_id

    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarH2'
                              , pi_tstz_value  => g_tstz_c
                              , pi_scope    => 99999999
                              );   

    test_procvars ( p_name          => 'VarH2'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => 99999999
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => g_tstz_c
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
    end tstz_call_by_bad_scope_set_update; 

-------------------------------------------------------------------------------------
--
--  BUSINESS_REF
--
-------------------------------------------------------------------------------------


  -- test(BR-A1 - Set+Get Business Ref assumed scope 0 - set insert)
  procedure business_ref_set_assumed_scope0_insert
  is
    l_actual_vc2   varchar2(50);
  begin
    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE100'
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => g_scope_main
                  , p_vc2           => 'EMPLOYEE100'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE100');

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_main
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE100');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_main
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE100');   

  end business_ref_set_assumed_scope0_insert;

  -- test(BR-A2 - Set+Get Business Ref assumed scope 0 - set update)
  procedure business_ref_set_assumed_scope0_update
  is
    l_actual_vc2   varchar2(50);
  begin
    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE200'
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => g_scope_main
                  , p_vc2           => 'EMPLOYEE200'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE200');

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_main
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE200');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_main
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE200'); 

    -- now SET again to trigger the 'update' action

    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE300'
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_main
                  , p_scope         => g_scope_main
                  , p_vc2           => 'EMPLOYEE300'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE300');

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_main
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE300');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_main
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE300'); 

  end business_ref_set_assumed_scope0_update;

  -- test(BR-B1 - Set+Get Business Ref by Sbfl scope call - set insert)
  procedure business_ref_set_by_sbfl_insert
  is
    l_actual_vc2   varchar2(50);
  begin
    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE100'
                                       , pi_sbfl_id  => g_sbfl_call2
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => 'EMPLOYEE100'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_be_null;

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_call
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE100');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_call1
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE100');   
  end business_ref_set_by_sbfl_insert;

  -- test(BR-B2 - Set+Get Business Ref by Sbfl scope call - set update)
  procedure business_ref_set_by_sbfl_update
  is
    l_actual_vc2   varchar2(50);
  begin
    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE200'
                                       , pi_sbfl_id  => g_sbfl_call2
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'EMPLOYEE200'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_be_null;

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_call
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE200');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_call1
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE200'); 

    -- now SET again to trigger the 'update' action

    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE300'
                                       , pi_sbfl_id  => g_sbfl_call2
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'EMPLOYEE300'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_be_null;

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_call
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE300');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_call1
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE300'); 
  end business_ref_set_by_sbfl_update;

  -- test(BR-C1 - Set+Get Business Ref by scope call - set insert)
  procedure business_ref_set_by_scope_call_insert
  is
    l_actual_vc2   varchar2(50);
  begin
    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE100'
                                       , pi_scope  => g_scope_call
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'EMPLOYEE100'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_be_null;

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_call
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE100');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_call2
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE100');   
  end business_ref_set_by_scope_call_insert;

  -- test(BR-C2 - Set+Get Business Ref by scope call - set update)
  procedure business_ref_set_by_scope_call_update
  is
    l_actual_vc2   varchar2(50);
  begin
    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE200'
                                       , pi_scope => g_scope_call
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call2
                  , p_scope         => g_scope_call
                  , p_vc2           => 'EMPLOYEE200'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_be_null;

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_call
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE200');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_call1
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE200'); 

    -- now SET again to trigger the 'update' action

    flow_process_vars.set_business_ref ( pi_prcs_id  => g_prcs_id_a
                                       , pi_vc2_value  => 'EMPLOYEE300'
                                       , pi_scope   => g_scope_call
                                       );                      

    test_procvars ( p_name          => 'BUSINESS_REF'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'EMPLOYEE300'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a);
    ut.expect(l_actual_vc2).to_be_null;

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_scope => g_scope_call
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE300');                                                       

    l_actual_vc2 := null;
    l_actual_vc2 := flow_process_vars.get_business_ref ( pi_prcs_id => g_prcs_id_a
                                                       , pi_sbfl_id => g_sbfl_call2
                                                       );
    ut.expect(l_actual_vc2).to_equal('EMPLOYEE300'); 
  end business_ref_set_by_scope_call_update;

-------------------------------------------------------------------------------------
--
-- DELETION
--
-------------------------------------------------------------------------------------


  -- test(DEL-1 Delete by Scope)
  procedure delete_by_scope
  is
    l_actual          sys_refcursor;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarD1'
                              , pi_vc2_value  => 'TestDEL1'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarD1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestDEL1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
  
    flow_process_vars.delete_var( pi_prcs_id  =>  g_prcs_id_a
                                , pi_var_name  => 'VarD1'
                                , pi_scope  => g_scope_call
                                );

    open l_actual for
      select * 
        from flow_process_variables
       where prov_prcs_id = g_prcs_id_a
         and prov_var_name = 'TestDEL1'
         and prov_scope = g_scope_call;
    ut.expect(l_actual).to_be_empty;
    
  end delete_by_scope;

  -- test(DEL-2 Delete by sbfl)
  procedure delete_by_sbfl
  is
    l_actual          sys_refcursor;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarD2'
                              , pi_vc2_value  => 'TestDEL2'
                              , pi_sbfl_id      => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarD2'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestDEL2'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
  
    flow_process_vars.delete_var( pi_prcs_id  =>  g_prcs_id_a
                                , pi_var_name  => 'VarD2'
                                , pi_sbfl_id  => g_sbfl_call1
                                );

    open l_actual for
      select * 
        from flow_process_variables
       where prov_prcs_id = g_prcs_id_a
         and prov_var_name = 'TestDEL2'
         and prov_scope = g_scope_call;
    ut.expect(l_actual).to_be_empty;

  end delete_by_sbfl;
 
  -- test(DEL-3 Delete by Scope - non-existant var)
  procedure delete_by_scope_not_existing_var
  is
    l_actual          sys_refcursor;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarD3'
                              , pi_vc2_value  => 'TestDEL3'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarD3'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestDEL3'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
  
    flow_process_vars.delete_var( pi_prcs_id  =>  g_prcs_id_a
                                , pi_var_name  => 'SomeOtherVar'
                                , pi_scope  => g_scope_call
                                );

    open l_actual for
      select * 
        from flow_process_variables
       where prov_prcs_id = g_prcs_id_a
         and prov_var_name = 'VarD3'
         and prov_scope = g_scope_call;
    ut.expect(l_actual).to_have_count(1);

  end delete_by_scope_not_existing_var;

  -- test(DEL-4 Delete by sbfl - non-existant var) 
  procedure delete_by_sbfl_not_existing_var
  is
    l_actual          sys_refcursor;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarD4'
                              , pi_vc2_value  => 'TestDEL4'
                              , pi_sbfl_id      => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarD4'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestDEL4'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
  
    flow_process_vars.delete_var( pi_prcs_id  =>  g_prcs_id_a
                                , pi_var_name  => 'SomeOtherVar'
                                , pi_sbfl_id  => g_sbfl_call1
                                );

    open l_actual for
      select * 
        from flow_process_variables
       where prov_prcs_id = g_prcs_id_a
         and prov_var_name = 'VarD4'
         and prov_scope = g_scope_call;
    ut.expect(l_actual).to_have_count(1);

  end delete_by_sbfl_not_existing_var; 

  -- test(DEL-5 Delete by Scope - non-existant var)
  -- throws(-20987)
  procedure delete_by_scope_not_existing_scope
  is
    l_actual          sys_refcursor;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarD5'
                              , pi_vc2_value  => 'TestDEL5'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'VarD5'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestDEL5'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
  
    flow_process_vars.delete_var( pi_prcs_id  =>  g_prcs_id_a
                                , pi_var_name  => 'SomeOtherVar'
                                , pi_scope  => 999999999
                                );

    open l_actual for
      select * 
        from flow_process_variables
       where prov_prcs_id = g_prcs_id_a
         and prov_var_name = 'VarD5'
         and prov_scope = g_scope_call;
    ut.expect(l_actual).to_have_count(1);

  end delete_by_scope_not_existing_scope;

  -- test(DEL-6 Delete by sbfl - non-existant sbfl)
  -- throws(-20987)  
  procedure delete_by_sbfl_not_existing_sbfl
  is
    l_actual          sys_refcursor;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'VarD6'
                              , pi_vc2_value  => 'TestDEL6'
                              , pi_sbfl_id      => g_sbfl_call1
                              );

    test_procvars ( p_name          => 'VarD6'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestDEL6'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );
  
    flow_process_vars.delete_var( pi_prcs_id  =>  g_prcs_id_a
                                , pi_var_name  => 'VarD6'
                                , pi_sbfl_id  => 99999999
                                );

    open l_actual for
      select * 
        from flow_process_variables
       where prov_prcs_id = g_prcs_id_a
         and prov_var_name = 'VarD6'
         and prov_scope = g_scope_call;
    ut.expect(l_actual).to_have_count(1);
  end delete_by_sbfl_not_existing_sbfl; 


-------------------------------------------------------------------------------------
--
--  GET WITH EXCEPTION ON NULL
--
-------------------------------------------------------------------------------------
  -- test(NL-1 - Get VC2 with error on exception)
  -- throws(-20987)
  procedure get_null_vc2
  is
    l_actual          sys_refcursor;
    l_actual_vc2      varchar2(2000);
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var1'
                              , pi_vc2_value  => 'TestNULL1'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestNULL1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => true
                  );

    l_actual_vc2 := flow_process_vars.get_var_vc2 ( pi_prcs_id => g_prcs_id_a
                                                  , pi_var_name => 'SomethingElse'
                                                  , pi_scope  => g_scope_call
                                                  , pi_exception_on_null => true
                                                  );
    
  end get_null_vc2;

  -- test(NL-2 - Get num with error on exception)
  -- throws(-20987)
  procedure get_null_num
  is
    l_actual          sys_refcursor;
    l_actual_num      number;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var2'
                              , pi_num_value  => 100
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 100     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_num := flow_process_vars.get_var_num ( pi_prcs_id => g_prcs_id_a
                                                  , pi_var_name => 'SomethingElse'
                                                  , pi_scope  => g_scope_call
                                                  , pi_exception_on_null => true
                                                  );
    
  end get_null_num;

  -- test(NL-3 - Get date with error on exception)
  -- throws(-20987)
  procedure get_null_date
  is
    l_actual          sys_refcursor;
    l_actual_date     date;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var3'
                              , pi_date_value  => g_date_b
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var3'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_date := flow_process_vars.get_var_date ( pi_prcs_id => g_prcs_id_a
                                                    , pi_var_name => 'SomethingElse'
                                                    , pi_scope  => g_scope_call
                                                    , pi_exception_on_null => true
                                                    );
    
  end get_null_date;

  -- test(NL-4 - Get TSTZ with error on exception)
  -- throws(-20987)
  procedure get_null_tstz
  is
    l_actual          sys_refcursor;
    l_actual_tstz     timestamp with time zone;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var4'
                              , pi_tstz_value  => g_tstz_a
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var4'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null   
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_tstz := flow_process_vars.get_var_tstz ( pi_prcs_id => g_prcs_id_a
                                                    , pi_var_name => 'SomethingElse'
                                                    , pi_scope  => g_scope_call
                                                    , pi_exception_on_null => true
                                                    );
  end get_null_tstz;

  -- test(NL-5 - Get CLOB with error on exception)
  -- throws(-20987)
  procedure get_null_clob
  is
    l_actual          sys_refcursor;
    l_actual_clob     clob;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var5'
                              , pi_clob_value  => 'Some text in a CLOB'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var5'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'Some text in a CLOB'  
                  , p_error_on_null => false
                  );

    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id => g_prcs_id_a
                                                    , pi_var_name => 'SomethingElse'
                                                    , pi_scope  => g_scope_call
                                                    , pi_exception_on_null => true
                                                    );
    

  end get_null_clob;

  -- test(NL-6 - Get type with error on exception)
  -- throws(-20987)
  procedure get_null_type
  is
    l_actual          sys_refcursor;
    l_actual_vc2      varchar2(2000);
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var6'
                              , pi_vc2_value  => 'TestNULL6'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var6'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestNULL6'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => true
                  );

    l_actual_vc2 := flow_process_vars.get_var_type ( pi_prcs_id => g_prcs_id_a
                                                  , pi_var_name => 'SomethingElse'
                                                  , pi_sbfl_id => 99999999
                                                  , pi_exception_on_null => true
                                                  );
    
  end get_null_type;

  -- test(NL-1B - Get VC2 with error on exception)
  -- throws(-20987)
  procedure get_null_vc2_by_sbfl
  is
    l_actual          sys_refcursor;
    l_actual_vc2      varchar2(2000);
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var1'
                              , pi_vc2_value  => 'TestNULL1'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var1'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestNULL1'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => true
                  );

    l_actual_vc2 := flow_process_vars.get_var_vc2 ( pi_prcs_id => g_prcs_id_a
                                                  , pi_var_name => 'SomethingElse'
                                                  , pi_sbfl_id => 99999999
                                                  , pi_exception_on_null => true
                                                  );
    
  end get_null_vc2_by_sbfl;

  -- test(NL-2B - Get num with error on exception by sbfl)
  -- throws(-20987)
  procedure get_null_num_by_sbfl
  is
    l_actual          sys_refcursor;
    l_actual_num      number;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var2'
                              , pi_num_value  => 100
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var2'
                  , p_type          => 'NUMBER'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => 100     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_num := flow_process_vars.get_var_num ( pi_prcs_id => g_prcs_id_a
                                                  , pi_var_name => 'SomethingElse'
                                                  , pi_sbfl_id => 99999999
                                                  , pi_exception_on_null => true
                                                  );
    
  end get_null_num_by_sbfl;

  -- test(NL-3B - Get date with error on exception)
  -- throws(-20987)
  procedure get_null_date_by_sbfl
  is
    l_actual          sys_refcursor;
    l_actual_date     date;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var3'
                              , pi_date_value  => g_date_b
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var3'
                  , p_type          => 'DATE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => g_date_b    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_date := flow_process_vars.get_var_date ( pi_prcs_id => g_prcs_id_a
                                                    , pi_var_name => 'SomethingElse'
                                                    , pi_sbfl_id => 99999999
                                                    , pi_exception_on_null => true
                                                    );
    
  end get_null_date_by_sbfl;

  -- test(NL-4B - Get TSTZ with error on exception)
  -- throws(-20987)
  procedure get_null_tstz_by_sbfl
  is
    l_actual          sys_refcursor;
    l_actual_tstz     timestamp with time zone;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var4'
                              , pi_tstz_value  => g_tstz_a
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var4'
                  , p_type          => 'TIMESTAMP WITH TIME ZONE'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null   
                  , p_tstz          => g_tstz_a
                  , p_clob          => null   
                  , p_error_on_null => false
                  );

    l_actual_tstz := flow_process_vars.get_var_tstz ( pi_prcs_id => g_prcs_id_a
                                                    , pi_var_name => 'SomethingElse'
                                                    , pi_sbfl_id => 99999999
                                                    , pi_exception_on_null => true
                                                    );
  end get_null_tstz_by_sbfl;

  -- test(NL-5B - Get CLOB with error on exception)
  -- throws(-20987)
  procedure get_null_clob_by_sbfl
  is
    l_actual          sys_refcursor;
    l_actual_clob     clob;
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var5'
                              , pi_clob_value  => 'Some text in a CLOB'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var5'
                  , p_type          => 'CLOB'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => null
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => 'Some text in a CLOB'  
                  , p_error_on_null => false
                  );

    l_actual_clob := flow_process_vars.get_var_clob ( pi_prcs_id => g_prcs_id_a
                                                    , pi_var_name => 'SomethingElse'
                                                    , pi_sbfl_id => 99999999
                                                    , pi_exception_on_null => true
                                                    );
    

  end get_null_clob_by_sbfl;

  -- test(NL-6B - Get type with error on exception)
  -- throws(-20987)
  procedure get_null_type_by_sbfl
  is
    l_actual          sys_refcursor;
    l_actual_vc2      varchar2(2000);
  begin
    flow_process_vars.set_var ( pi_prcs_id  => g_prcs_id_a
                              , pi_var_name  => 'Var6'
                              , pi_vc2_value  => 'TestNULL6'
                              , pi_scope      => g_scope_call
                              );

    test_procvars ( p_name          => 'Var6'
                  , p_type          => 'VARCHAR2'    
                  , p_prcs_id       => g_prcs_id_a
                  , p_sbfl_id       => g_sbfl_call1
                  , p_scope         => g_scope_call
                  , p_vc2           => 'TestNULL6'
                  , p_number        => null     
                  , p_date          => null    
                  , p_tstz          => null
                  , p_clob          => null   
                  , p_error_on_null => true
                  );

    l_actual_vc2 := flow_process_vars.get_var_type ( pi_prcs_id => g_prcs_id_a
                                                  , pi_var_name => 'SomethingElse'
                                                  , pi_sbfl_id => 99999999
                                                  , pi_exception_on_null => true
                                                  );
    
  end get_null_type_by_sbfl;


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
/
