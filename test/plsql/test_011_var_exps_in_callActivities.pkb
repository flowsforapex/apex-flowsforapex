create or replace package body test_011_var_exps_in_callActivities is
/* 
-- Flows for APEX - test_011_var_exps_in_callActivities.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created 2022   Richard Allen, Oracle   
-- 
*/

   model_a11a constant varchar2(100) := 'A11a - Variable Exp Types with CallActivity';
   model_a11b constant varchar2(100) := 'A11b - Variable Exp Types with CallActivity';
   l_scope_a11b             flow_subflows.sbfl_scope%type;
   l_main_subflow_calling   flow_subflows.sbfl_id%type;
   l_called_subflow         flow_subflows.sbfl_id%type;
   l_step_key               flow_subflows.sbfl_step_key%type;
   l_dgrm_a_id              flow_diagrams.dgrm_id%type;
   l_dgrm_b_id              flow_diagrams.dgrm_id%type;

   g_prcs_id_1 number;

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

   procedure var_exp_all_types
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_a_id := get_dgrm_id( model_a11a );
      l_dgrm_b_id := get_dgrm_id( model_a11b );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => l_dgrm_a_id
         , pi_prcs_name => 'test - var_exp_in_callActivities'
      );
      g_prcs_id_1 := l_prcs_id;

      open l_actual for
        select *
        from flow_process_variables
        where prov_prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_have_count( 0 );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      -- get the initial subflow id & step key
      select sbfl_id
           , sbfl_step_key
        into l_main_subflow_calling
           , l_step_key
        from flow_subflows
       where sbfl_prcs_id = l_prcs_id;

      open l_expected for
         select
            l_dgrm_a_id as prcs_dgrm_id,
            'test - var_exp_in_callActivities' as prcs_name,
            flow_constants_pkg.gc_prcs_status_running as prcs_status
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      -- check the  local Variables got created in the calling scope
      open l_expected for
         select
            'StaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2, 
            0 as prov_scope
         from dual
         union
         select
            'CopyStaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2, 
            0 as prov_scope
         from dual
         union
         select
            'SQLSingleVC2' as prov_var_name,
            'SingleVC2' as prov_var_vc2, 
            0 as prov_scope
         from dual
         union
         select
            'SQLMultiVC2' as prov_var_name,
            'value1:value2:value3' as prov_var_vc2, 
            0 as prov_scope
         from dual
         union
         select
            'ExpressionVC2' as prov_var_name,
            'KING is UPPERCASE' as prov_var_vc2,
            0 as prov_scope
         from dual
         union
         select
            'FuncBodyVC2' as prov_var_name,
            'January' as prov_var_vc2, 
            0 as prov_scope
         from dual;

      open l_actual for
         select prov_var_name, prov_var_vc2, prov_scope
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_type = 'VARCHAR2'
         and prov_var_name != 'BUSINESS_REF'
         and prov_scope = 0
         and prov_var_num is null
         and prov_var_date is null
         and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- step the process forward into the callActivity.  This will call diagram A11b
      flow_api_pkg.flow_complete_step 
      ( p_process_id => l_prcs_id
      , p_subflow_id => l_main_subflow_calling
      , p_step_key   => l_step_key
      );


      -- get the new subflow id (in called diagram, scope, and step_key so we can step it forward again
      select sbfl_id
           , sbfl_step_key
           , sbfl_scope
        into l_called_subflow
           , l_step_key
           , l_scope_a11b
        from flow_subflows
       where sbfl_prcs_id = l_prcs_id
         and sbfl_id != l_main_subflow_calling;

      -- 
      -- get the scope variable to show flow_globals.scope works
/*
      open l_expected for 
        select
            'Model11b_scope'      as prov_var_name,
            to_char(l_scope_a11b) as prov_var_vc2,
            l_scope_a11b          as prov_scope
         from dual
         ;

      open l_actual for
         select prov_var_name, prov_var_vc2, prov_scope
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_type = 'VARCHAR2'
         and prov_var_name = 'Model11b_scope'
         and prov_var_num is null
         and prov_var_date is null
         and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected );

*/



      -- check the inVariables got created in the called scope
      open l_expected for
         select
            'Called_Invar_StaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select
            'Called_Invar_CopyStaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select
            'Called_Invar_SQLSingleVC2' as prov_var_name,
            'SingleVC2' as prov_var_vc2
         from dual
         union
         select
            'Called_Invar_SQLMultiVC2' as prov_var_name,
            'value1:value2:value3' as prov_var_vc2
         from dual
         union
         select
            'Called_Invar_ExpressionVC2' as prov_var_name,
            'KING is UPPERCASE' as prov_var_vc2
         from dual
         union
         select
            'Called_Invar_FuncBodyVC2' as prov_var_name,
            'January' as prov_var_vc2
         from dual;

      open l_actual for
         select prov_var_name, prov_var_vc2
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_type = 'VARCHAR2'
         and prov_scope = l_scope_a11b
         and prov_var_name like 'Called_Invar_%'
         and prov_var_num is null
         and prov_var_date is null
         and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- check the local Variables got created in the called scope
      open l_expected for
         select
            'VarExp_InCalled_StaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select
            'VarExp_InCalled_CopyStaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select
            'VarExp_InCalled_SQLSingleVC2' as prov_var_name,
            'SingleVC2' as prov_var_vc2
         from dual
         union
         select
            'VarExp_InCalled_SQLMultiVC2' as prov_var_name,
            'value1:value2:value3' as prov_var_vc2
         from dual
         union
         select
            'VarExp_InCalled_ExpressionVC2' as prov_var_name,
            'KING is UPPERCASE' as prov_var_vc2
         from dual
         union
         select
            'VarExp_InCalled_FuncBodyVC2' as prov_var_name,
            'January' as prov_var_vc2
         from dual;

      open l_actual for
         select prov_var_name, prov_var_vc2
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_type = 'VARCHAR2'
         and prov_scope = l_scope_a11b
         and prov_var_name like 'VarExp_InCalled_%'
         and prov_var_num is null
         and prov_var_date is null
         and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

   -- step the process forward back into the callActivity.  This will return to diagram A11a
      flow_api_pkg.flow_complete_step 
      ( p_process_id => l_prcs_id
      , p_subflow_id => l_called_subflow
      , p_step_key   => l_step_key
      );

      -- check the outVariables got created in the calling scope
      open l_expected for
         select
            'Called_Outvar_StaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select
            'Called_Outvar_CopyStaticVC2' as prov_var_name,
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select
            'Called_Outvar_SQLSingleVC2' as prov_var_name,
            'SingleVC2' as prov_var_vc2
         from dual
         union
         select
            'Called_Outvar_SQLMultiVC2' as prov_var_name,
            'value1:value2:value3' as prov_var_vc2
         from dual
         union
         select
            'Called_Outvar_ExpressionVC2' as prov_var_name,
            'KING is UPPERCASE' as prov_var_vc2
         from dual
         union
         select
            'Called_Outvar_FuncBodyVC2' as prov_var_name,
            'January' as prov_var_vc2
         from dual;

      open l_actual for
         select prov_var_name, prov_var_vc2
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_type = 'VARCHAR2'
         and prov_scope = 0
         and prov_var_name like 'Called_Outvar_%'
         and prov_var_num is null
         and prov_var_date is null
         and prov_var_clob is null;

      ut.expect( l_actual ).to_equal( l_expected ).unordered;

   end var_exp_all_types;


   procedure tear_down_tests
   is
   begin
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_1);

   end;


end test_011_var_exps_in_callActivities;