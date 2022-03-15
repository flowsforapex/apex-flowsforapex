create or replace package body test_variable_expressions is

   model_a10 constant varchar2(100) := 'A10 - Variable Expressions Types';

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
      l_dgrm_id := get_dgrm_id( model_a10 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => l_dgrm_id
         , pi_prcs_name => 'test - var_exp_all_types'
      );

      open l_actual for
        select * 
        from flow_process_variables 
        where prov_prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_have_count( 0 );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - var_exp_all_types' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Activity_StaticVC2' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Activity_ProcVarVC2' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Activity_SQLSingleVC2' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Activity_SQLMultiVC2' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Activity_ExpressionVC2' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Activity_FuncBodyVC2' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            'Author'   as prov_var_name, 
            'Richard'  as prov_var_vc2
         from dual
         union
         select 
            'StaticVC2' as prov_var_name, 
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select 
            'CopyStaticVC2' as prov_var_name, 
            'StaticVC2' as prov_var_vc2
         from dual
         union
         select 
            'SQLSingleVC2' as prov_var_name, 
            'SingleVC2' as prov_var_vc2
         from dual
         union
         select 
            'SQLMultiVC2' as prov_var_name, 
            'value1:value2:value3' as prov_var_vc2
         from dual
         union
         select 
            'ExpressionVC2' as prov_var_name, 
            'KING is UPPERCASE' as prov_var_vc2
         from dual
         union
         select 
            'ExpressionVC2' as prov_var_name, 
            'KING is UPPERCASE' as prov_var_vc2
         from dual
         union
         select 
            'FuncBodyVC2' as prov_var_name, 
            'January' as prov_var_vc2
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_vc2
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_type = 'VARCHAR2'
         and prov_var_num is null
         and prov_var_date is null
         and prov_var_clob is null;
   
      ut.expect( l_actual ).to_equal( l_expected );

   end var_exp_all_types;


end test_variable_expressions;