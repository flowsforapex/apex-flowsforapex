create or replace package body test_028_task_parameters
/* 
-- Flows for APEX - test_028_task_parameters.pkb
-- 
-- (c) Copyright Flowquest Limited and / or its affiliates, 2026.
--
-- Created 19-Jun-2026   GitHub Copilot
--
*/
is
  g_model_a25c constant varchar2(100) := 'A25c - Script Task Parameters API Coverage';

  g_dgrm_a25c_id  flow_diagrams.dgrm_id%type;
  g_prcs_id_a     flow_processes.prcs_id%type;
  g_prcs_id_b     flow_processes.prcs_id%type;
  g_prcs_id_c     flow_processes.prcs_id%type;
  g_prcs_id_d     flow_processes.prcs_id%type;

  function get_script_task_objt_id
    return flow_objects.objt_id%type
  is
    l_objt_id flow_objects.objt_id%type;
  begin
    select objt_id
      into l_objt_id
      from flow_objects
     where objt_dgrm_id = g_dgrm_a25c_id
       and objt_bpmn_id = 'Activity_Params';

    return l_objt_id;
  end get_script_task_objt_id;

  -- beforeall
  procedure set_up_tests
  is
  begin
    g_dgrm_a25c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a25c );
    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a25c_id );
  end set_up_tests;

  -- test('1 - Script task input parameter definitions can be read')
  procedure get_script_task_input_parameter_defs
  is
    l_param_defs  clob;
    l_objt_id     flow_objects.objt_id%type;
  begin
    l_objt_id := get_script_task_objt_id;

    l_param_defs := flow_parameters.get_input_parameter_definitions(
                      pi_objt_id => l_objt_id
                    );

    ut.expect( l_param_defs ).to_be_like( '%"name":"customer_name"%' );
    ut.expect( l_param_defs ).to_be_like( '%"name":"ticket_ref"%' );
    ut.expect( l_param_defs ).to_be_like( '%"expressionType":"userInput"%' );
    ut.expect( l_param_defs ).to_be_like( '%"expressionType":"processVariable"%' );
    ut.expect( l_param_defs ).to_be_like( '%"expressionType":"static"%' );
  end get_script_task_input_parameter_defs;

  -- test('2 - Script task output parameter definitions can be read')
  procedure get_script_task_output_parameter_defs
  is
    l_param_defs  clob;
    l_objt_id     flow_objects.objt_id%type;
  begin
    l_objt_id := get_script_task_objt_id;

    l_param_defs := flow_parameters.get_output_parameter_definitions(
                      pi_objt_id => l_objt_id
                    );

    ut.expect( l_param_defs ).to_be_like( '%"name":"result_code"%' );
    ut.expect( l_param_defs ).to_be_like( '%"name":"result_message"%' );
    ut.expect( l_param_defs ).to_be_like( '%"expression":"SCRIPT_RESULT"%' );
  end get_script_task_output_parameter_defs;

  -- test('3 - process_input_parameters merges user, static and process variable values')
  procedure process_script_task_input_parameters
  is
    l_param_defs      clob;
    l_user_input      clob;
    l_processed       clob;
    l_objt_id         flow_objects.objt_id%type;
  begin
    g_prcs_id_a := flow_api_pkg.flow_create
                   ( pi_dgrm_id   => g_dgrm_a25c_id
                   , pi_prcs_name => 'test 028 - process inputs'
                   );

    flow_process_vars.set_var
    ( pi_prcs_id   => g_prcs_id_a
    , pi_var_name  => 'ticket_id'
    , pi_vc2_value => 'T-200'
    );

    l_objt_id := get_script_task_objt_id;
    l_param_defs := flow_parameters.get_input_parameter_definitions( pi_objt_id => l_objt_id );

    l_user_input := '{"customer_name":"Alice","customer_tier":"GOLD"}';

    l_processed := flow_parameters.process_input_parameters
                   ( pi_parameter_definitions => l_param_defs
                   , pi_user_input_data       => l_user_input
                   , pi_process_id            => g_prcs_id_a
                   , pi_scope                 => 0
                   );

    ut.expect( l_processed ).to_be_like( '%"customer_name":"Alice"%' );
    ut.expect( l_processed ).to_be_like( '%"customer_tier":"GOLD"%' );
    ut.expect( l_processed ).to_be_like( '%"ticket_ref":"T-200"%' );
    ut.expect( l_processed ).to_be_like( '%"default_priority":"HIGH"%' );
  end process_script_task_input_parameters;

  -- test('4 - Input schema includes enum values for user input parameters')
  procedure input_schema_includes_enum_values
  is
    l_param_defs  clob;
    l_schema      clob;
    l_objt_id     flow_objects.objt_id%type;
  begin
    l_objt_id := get_script_task_objt_id;

    l_param_defs := flow_parameters.get_input_parameter_definitions(
                      pi_objt_id => l_objt_id
                    );

    l_schema := flow_parameters.get_user_input_schema(
                  pi_parameter_definitions => l_param_defs
                );

    ut.expect( l_schema ).to_be_like( '%"customer_tier"%' );
    ut.expect( l_schema ).to_be_like( '%"enum"%' );
    ut.expect( l_schema ).to_be_like( '%"GOLD"%' );
    ut.expect( l_schema ).to_be_like( '%"SILVER"%' );
    ut.expect( l_schema ).not_to_be_like( '%"ticket_ref"%' );
  end input_schema_includes_enum_values;

  -- test('5 - Script task execution path remains valid with task parameters present')
  procedure script_task_executes_with_parameters
  is
    l_actual    sys_refcursor;
    l_expected  sys_refcursor;
  begin
    g_prcs_id_b := flow_api_pkg.flow_create
                   ( pi_dgrm_id   => g_dgrm_a25c_id
                   , pi_prcs_name => 'test 028 - script run'
                   );

    flow_api_pkg.flow_start( p_process_id => g_prcs_id_b );
    test_helper.step_forward( pi_prcs_id => g_prcs_id_b, pi_current => 'Activity_Pre' );

    open l_expected for
      select 'OK' as script_result
        from dual;

    open l_actual for
      select flow_process_vars.get_var_vc2
             ( pi_prcs_id  => g_prcs_id_b
             , pi_var_name => 'SCRIPT_RESULT'
             ) as script_result
        from dual;

    ut.expect( l_actual ).to_equal( l_expected );
  end script_task_executes_with_parameters;

  -- test('6 - validate_parameters returns true when required values are present')
  procedure validate_parameters_success
  is
    l_param_defs  clob;
    l_values      clob;
    l_valid       boolean;
  begin
    l_param_defs := '[{"name":"customer_name","type":"string","required":true},{"name":"customer_tier","type":"string","required":true},{"name":"note","type":"string","required":false}]';
    l_values := '{"customer_name":"Alice","customer_tier":"GOLD"}';

    l_valid := flow_parameters.validate_parameters
               ( pi_parameter_definitions => l_param_defs
               , pi_parameter_values      => l_values
               );

    ut.expect( l_valid ).to_equal( true );
  end validate_parameters_success;

  -- test('7 - validate_parameters returns false when required values are missing')
  procedure validate_parameters_missing_required
  is
    l_param_defs  clob;
    l_values      clob;
    l_valid       boolean;
  begin
    l_param_defs := '[{"name":"customer_name","type":"string","required":true},{"name":"customer_tier","type":"string","required":true}]';
    l_values := '{"customer_name":"Alice"}';

    l_valid := flow_parameters.validate_parameters
               ( pi_parameter_definitions => l_param_defs
               , pi_parameter_values      => l_values
               );

    ut.expect( l_valid ).to_equal( false );
  end validate_parameters_missing_required;

  -- test('8 - process_input_parameters handles non-varchar2 process variable types')
  procedure process_input_parameters_all_proc_var_types
  is
    l_param_defs       clob;
    l_processed        clob;
    l_expected_date    varchar2(64);
    l_expected_tstz    varchar2(128);
  begin
    g_prcs_id_c := flow_api_pkg.flow_create
                   ( pi_dgrm_id   => g_dgrm_a25c_id
                   , pi_prcs_name => 'test 028 - process typed vars'
                   );

    flow_process_vars.set_var
    ( pi_prcs_id   => g_prcs_id_c
    , pi_var_name  => 'pv_num'
    , pi_num_value => 42
    );

    flow_process_vars.set_var
    ( pi_prcs_id    => g_prcs_id_c
    , pi_var_name   => 'pv_date'
    , pi_date_value => to_date('2026-06-19 12:34:56','YYYY-MM-DD HH24:MI:SS')
    );

    flow_process_vars.set_var
    ( pi_prcs_id    => g_prcs_id_c
    , pi_var_name   => 'pv_clob'
    , pi_clob_value => 'very-long-text'
    );

    flow_process_vars.set_var
    ( pi_prcs_id    => g_prcs_id_c
    , pi_var_name   => 'pv_tstz'
    , pi_tstz_value => to_timestamp_tz('2026-06-19 12:34:56.123456 +02:00','YYYY-MM-DD HH24:MI:SS.FF TZH:TZM')
    );

    l_param_defs := '[' ||
                    '{"name":"num_param","type":"number","required":true,"source":{"expressionType":"processVariable","expression":"pv_num"}},' ||
                    '{"name":"date_param","type":"string","required":true,"source":{"expressionType":"processVariable","expression":"pv_date"}},' ||
                    '{"name":"clob_param","type":"string","required":true,"source":{"expressionType":"processVariable","expression":"pv_clob"}},' ||
                    '{"name":"tstz_param","type":"string","required":true,"source":{"expressionType":"processVariable","expression":"pv_tstz"}}' ||
                    ']';

    l_processed := flow_parameters.process_input_parameters
                   ( pi_parameter_definitions => l_param_defs
                   , pi_user_input_data       => '{}'
                   , pi_process_id            => g_prcs_id_c
                   , pi_scope                 => 0
                   );

    l_expected_date := to_char(to_date('2026-06-19 12:34:56','YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD"T"HH24:MI:SS');
    l_expected_tstz := to_char(to_timestamp_tz('2026-06-19 12:34:56.123456 +02:00','YYYY-MM-DD HH24:MI:SS.FF TZH:TZM'),'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM');

    ut.expect( l_processed ).to_be_like( '%"num_param":42%' );
    ut.expect( l_processed ).to_be_like( '%"date_param":"' || l_expected_date || '"%' );
    ut.expect( l_processed ).to_be_like( '%"clob_param":"very-long-text"%' );
    ut.expect( l_processed ).to_be_like( '%"tstz_param":"' || l_expected_tstz || '"%' );
  end process_input_parameters_all_proc_var_types;

  -- test('9 - flow_globals.input_parameter is callable from script context')
  procedure flow_globals_input_parameter_from_script
  is
    l_from_script varchar2(4000);
  begin
    flow_globals.set_context
    ( pi_prcs_id          => 0
    , pi_input_parameters => '{"alpha":"A","beta":"B"}'
    );

    execute immediate q'[begin :x := flow_globals.input_parameter('alpha'); end;]'
      using out l_from_script;

    ut.expect( l_from_script ).to_equal( 'A' );
  end flow_globals_input_parameter_from_script;

  -- test('10 - flow_globals output parameter setters are callable from script context')
  procedure flow_globals_set_output_parameter_from_script
  is
    l_output_json clob;
  begin
    flow_globals.set_context
    ( pi_prcs_id          => 0
    , pi_input_parameters => '{}'
    );

    execute immediate q'[begin
      flow_globals.set_output_parameter('status','OK');
      flow_globals.set_output_parameter_object
      ( pi_parameter_name => 'details'
      , pi_key1           => 'code'
      , pi_value1         => '200'
      , pi_key2           => 'message'
      , pi_value2         => 'done'
      );
    end;]';

    l_output_json := flow_globals.get_output_parameters;

    ut.expect( l_output_json ).to_be_like( '%"status":"OK"%' );
    ut.expect( l_output_json ).to_be_like( '%"details"%' );
    ut.expect( l_output_json ).to_be_like( '%"code":"200"%' );
    ut.expect( l_output_json ).to_be_like( '%"message":"done"%' );
  end flow_globals_set_output_parameter_from_script;

  -- test('11 - flow_globals.business_ref supports lookup by subflow id')
  procedure flow_globals_business_ref_by_sbfl_id
  is
    l_sbfl_id       flow_subflows.sbfl_id%type;
    l_business_ref  flow_process_variables.prov_var_vc2%type;
  begin
    g_prcs_id_d := flow_api_pkg.flow_create
                   ( pi_dgrm_id   => g_dgrm_a25c_id
                   , pi_prcs_name => 'test 028 - business ref by sbfl'
                   );

    flow_api_pkg.flow_start( p_process_id => g_prcs_id_d );

    select sbfl_id
      into l_sbfl_id
      from flow_subflows
     where sbfl_prcs_id = g_prcs_id_d
       and sbfl_current = 'Activity_Pre';

    flow_process_vars.set_business_ref
    ( pi_prcs_id   => g_prcs_id_d
    , pi_sbfl_id   => l_sbfl_id
    , pi_vc2_value => 'BR-SBFL-001'
    );

    flow_globals.set_context( pi_prcs_id => g_prcs_id_d );

    l_business_ref := flow_globals.business_ref( pi_sbfl_id => l_sbfl_id );

    ut.expect( l_business_ref ).to_equal( 'BR-SBFL-001' );
  end flow_globals_business_ref_by_sbfl_id;

  -- afterall
  procedure tear_down_tests
  is
  begin
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_a );
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_b );
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_c );
    flow_api_pkg.flow_delete( p_process_id => g_prcs_id_d );
  end tear_down_tests;

end test_028_task_parameters;
/
