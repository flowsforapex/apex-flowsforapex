create or replace package body test_028_task_error_boundary_events as
/* 
-- Flows for APEX - test_028_task_error_boundary_events.pkb
-- 
-- (c) Copyright Flowquest Ltd and / or its affiliates, 2025.
--
-- Created 03-Apr-2025   Richard Allen - Flowquest
--
*/

  -- uses models 28a-b

  -- suite(23 Custom Extensions)
  g_model_a28a constant varchar2(100) := 'A28a - Task Error Boundary Event (with bind)';
  g_model_a28b constant varchar2(100) := 'A28a - Task Error Boundary Event (without bind)';
  g_model_a28c constant varchar2(100) := 'A28c -';
  g_model_a28d constant varchar2(100) := 'A28d -';
  g_model_a28e constant varchar2(100) := 'A28e -';
  g_model_a28f constant varchar2(100) := 'A28f -';
  g_model_a28g constant varchar2(100) := 'A28g -';

  g_test_prcs_name_a constant varchar2(100) := 'test 028 - task error boundary events a';
  g_test_prcs_name_b constant varchar2(100) := 'test 028 - task error boundary events b';
  g_test_prcs_name_c constant varchar2(100) := 'test 028 - task error boundary events c';
  g_test_prcs_name_d constant varchar2(100) := 'test 028 - task error boundary events d';
  g_test_prcs_name_e constant varchar2(100) := 'test 028 - task error boundary events e';
  g_test_prcs_name_f constant varchar2(100) := 'test 028 - task error boundary events f';
  g_test_prcs_name_g constant varchar2(100) := 'test 028 - task error boundary events g';

  g_prcs_id_a       flow_processes.prcs_id%type;
  g_prcs_id_b       flow_processes.prcs_id%type;
  g_prcs_id_c       flow_processes.prcs_id%type;
  g_prcs_id_d       flow_processes.prcs_id%type;
  g_prcs_id_e       flow_processes.prcs_id%type;
  g_prcs_id_f       flow_processes.prcs_id%type;
  g_prcs_id_g       flow_processes.prcs_id%type;

  g_dgrm_a28a_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a28b_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a28c_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a28d_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a28e_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a28f_id  flow_diagrams.dgrm_id%type;
  g_dgrm_a28g_id  flow_diagrams.dgrm_id%type;

  procedure set_up_tests
  is 
  begin
  
    -- get dgrm_ids to use for comparison
    g_dgrm_a28a_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a28a );
    g_dgrm_a28b_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a28b );
    --g_dgrm_a28c_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a28c );
    --g_dgrm_a28d_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a28d );
    --g_dgrm_a28e_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a28e );
    --g_dgrm_a28f_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a28f );
    --g_dgrm_a28g_id := test_helper.set_dgrm_id( pi_dgrm_name => g_model_a28g );

    flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a28a_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a28b_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a28c_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a28d_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a28e_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a28f_id);
    --flow_bpmn_parser_pkg.parse( pi_dgrm_id => g_dgrm_a28g_id);

  end set_up_tests;

 

  --beforeall
  procedure set_up_tests;

  --test(A - Parse and Access all objects - No Lanes)
  procedure custom_exts_no_lanes;

  --test(B - Parse and Access all objects - In Collaboration)
  procedure custom_ext_lanes;

  --afterall
  procedure tear_down_tests;

end test_028_task_error_boundary_events;
/
