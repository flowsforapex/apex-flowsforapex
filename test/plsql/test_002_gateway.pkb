create or replace package body test_002_gateway is
/* 
-- Flows for APEX - test_002_gateway.pkb
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2022.
--
-- Created  08-Mar-2022   Louis Moreaux, Insum
-- Modified 28-Jun-2022   Richard Allen, Oracle   
-- 
*/

   model_a2  constant varchar2(100) := 'A02a - Exclusive Gateway No Route';
   model_a3  constant varchar2(100) := 'A02b - Exclusive Gateway Default Route';
   model_a4  constant varchar2(100) := 'A02c - Exclusive Gateway Routing';
   model_a5  constant varchar2(100) := 'A02d - Inclusive Gateway No Route';
   model_a6  constant varchar2(100) := 'A02e - Inclusive Gateway Default Route';
   model_a7  constant varchar2(100) := 'A02f - Inclusive Gateway Routing';
   model_a8  constant varchar2(100) := 'A02g - Parallel Gateway';
   model_a9  constant varchar2(100) := 'A02h - Event Based Gateway';
   model_a10 constant varchar2(100) := 'A02i - Inc GW Merge and Resplit';
   model_a11 constant varchar2(100) := 'A02j - Par GW Merge and Resplit';
   model_a12 constant varchar2(100) := 'A02k - Inc GW Merge and Resplit - GRExps';


   g_prcs_id_1    number;
   g_prcs_id_2    number;
   g_prcs_id_3    number;
   g_prcs_id_4    number;
   g_prcs_id_5    number;
   g_prcs_id_6    number;
   g_prcs_id_7    number;
   g_prcs_id_8    number;
   g_prcs_id_9    number;
   g_prcs_id_10   number;

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

   --test(a. exclusive gateway - no route provided)

   procedure exclusive_no_route
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_sqlerrm varchar2(4000);
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a2 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => l_dgrm_id
         , pi_prcs_name => 'test - exclusive_no_route'
      );
      g_prcs_id_1 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - exclusive_no_route' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_error as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Exclusive' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_error sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            'Exclusive' as lgpr_objt_id, 
            flow_constants_pkg.gc_prcs_event_error as lgpr_prcs_event, 
            'No gateway routing instruction provided in variable Exclusive:route and model contains no default route.' as lgpr_comment
           /* , 
            'ORA-01403: no data found
' lgpr_error_info */
         from dual;

      open l_actual for
         select lgpr_objt_id, lgpr_prcs_event, lgpr_comment/*, lgpr_error_info*/
         from flow_instance_event_log 
         where lgpr_prcs_id = l_prcs_id
         order by lgpr_timestamp desc 
         fetch first 1 rows only;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_delete(p_process_id => l_prcs_id);
   end exclusive_no_route;

   --test(b. exclusive gateway - default routing)

   procedure exclusive_default
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparison
      l_dgrm_id := get_dgrm_id( model_a3 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => l_dgrm_id
         , pi_prcs_name => 'test - exclusive_default'
      );
      g_prcs_id_2 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - exclusive_default' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;

      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - exclusive_default' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );
   end;

   -- tests C1-3

   procedure exclusive_route_provided_runner
   ( pi_prcs_name    in flow_processes.prcs_name%type
   , pi_routing_var_name_A   in varchar2
   , pi_routing_value_A      in varchar2
   , pi_routing_var_name_B   in varchar2
   , pi_routing_value_B      in varchar2
   , pi_routing_var_name_C   in varchar2
   , pi_routing_value_C      in varchar2
   )
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a4 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => l_dgrm_id
         , pi_prcs_name => pi_prcs_name 
      );
      g_prcs_id_3 := l_prcs_id;

      --Set RouteA
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  =>  pi_routing_var_name_A
         , pi_vc2_value =>  pi_routing_value_A
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name  as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;

      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name  as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteB
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_B
         , pi_vc2_value => pi_routing_value_B
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name  as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;

      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name  as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_C
         , pi_vc2_value =>  pi_routing_value_C
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name  as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name  as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      -- tear down test
      flow_api_pkg.flow_delete ( p_process_id => l_prcs_id);


   end exclusive_route_provided_runner;

   -- test c1 - exclusive gateway - GR var provided - matching case)
   procedure exclusive_route_provided_correct_case
   is
   begin
      exclusive_route_provided_runner 
      ( pi_prcs_name             => 'test - exclusive_route_provided - matching case'
      , pi_routing_var_name_A    => 'Exclusive:route'
      , pi_routing_value_A       => 'RouteA'
      , pi_routing_var_name_B    => 'Exclusive:route'
      , pi_routing_value_B       => 'RouteB'
      , pi_routing_var_name_C    => 'Exclusive:route'
      , pi_routing_value_C       => 'RouteC'
      );
   end exclusive_route_provided_correct_case;

   -- test(c2. exclusive gateway - GR var provided - UPPER CASE)

   procedure exclusive_route_provided_upper_case
   is
   begin
      exclusive_route_provided_runner 
      ( pi_prcs_name             => 'test - exclusive_route_provided - upper case'
      , pi_routing_var_name_A    => 'EXCLUSIVE:ROUTE'
      , pi_routing_value_A       => 'RouteA'
      , pi_routing_var_name_B    => 'EXCLUSIVE:ROUTE'
      , pi_routing_value_B       => 'RouteB'
      , pi_routing_var_name_C    => 'EXCLUSIVE:ROUTE'
      , pi_routing_value_C       => 'RouteC'
      );
   end exclusive_route_provided_upper_case;

   -- test(c3. exclusive gateway - GR var provided - lower CASE)

   procedure exclusive_route_provided_lower_case
   is
   begin
      exclusive_route_provided_runner 
      ( pi_prcs_name             => 'test - exclusive_route_provided - lower case'
      , pi_routing_var_name_A    => 'exclusive:route'
      , pi_routing_value_A       => 'RouteA'
      , pi_routing_var_name_B    => 'exclusive:route'
      , pi_routing_value_B       => 'RouteB'
      , pi_routing_var_name_C    => 'exclusive:route'
      , pi_routing_value_C       => 'RouteC'
      );
   end exclusive_route_provided_lower_case;

   -- test(d. inclusive gateway - no routing)

   procedure inclusive_no_route
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_sqlerrm varchar2(4000);
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a5 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => l_dgrm_id
         , pi_prcs_name => 'test - inclusive_no_route'
      );
      g_prcs_id_4 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_no_route' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_error as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'Inclusive' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_error sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            'Inclusive' as lgpr_objt_id, 
            flow_constants_pkg.gc_prcs_event_error as lgpr_prcs_event, 
            'No gateway routing instruction provided in variable Inclusive:route and model contains no default route.' as lgpr_comment/*, 
            'ORA-01403: no data found
' lgpr_error_info */
         from dual;

      open l_actual for
         select lgpr_objt_id, lgpr_prcs_event, lgpr_comment/*, lgpr_error_info */
         from flow_instance_event_log 
         where lgpr_prcs_id = l_prcs_id
         order by lgpr_timestamp desc 
         fetch first 1 rows only;

      ut.expect( l_actual ).to_equal( l_expected );
   end;

   -- test(e. inclusive gateway - default routing)

   procedure inclusive_default
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a6 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id => l_dgrm_id
         , pi_prcs_name => 'test - inclusive_default'
      );
      g_prcs_id_5 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_default' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'A';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_default' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );
   end;

   -- runner for tests f1-4

   procedure inclusive_route_provided_runner
   ( pi_prcs_name            in flow_processes.prcs_name%type
   , pi_routing_var_name_A   in varchar2
   , pi_routing_value_A      in varchar2
   , pi_routing_var_name_B   in varchar2
   , pi_routing_value_B      in varchar2
   , pi_routing_var_name_C   in varchar2
   , pi_routing_value_C      in varchar2
   , pi_routing_var_name_AB  in varchar2
   , pi_routing_value_AB     in varchar2
   , pi_routing_var_name_BC  in varchar2
   , pi_routing_value_BC     in varchar2
   , pi_routing_var_name_AC  in varchar2
   , pi_routing_value_AC     in varchar2
   , pi_routing_var_name_ABC in varchar2
   , pi_routing_value_ABC    in varchar2   
   )  
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a7 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id => l_dgrm_id
         , pi_prcs_name => pi_prcs_name
      );
      g_prcs_id_6 := l_prcs_id;

      --Set RouteA
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_A
         , pi_vc2_value => pi_routing_value_A
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'A';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteB
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_B
         , pi_vc2_value => pi_routing_value_B 
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'B';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_C
         , pi_vc2_value => pi_routing_value_C
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'C';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteA:RouteB
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_AB
         , pi_vc2_value => pi_routing_value_AB
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'A';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'InclusiveClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'B';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteA:RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_AC
         , pi_vc2_value => pi_routing_value_AC 
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'A';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'InclusiveClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'C';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );
      
      --Set RouteB:RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_BC
         , pi_vc2_value => pi_routing_value_BC
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'B';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'InclusiveClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'C';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );
      
      --Set RouteA:RouteB:RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => pi_routing_var_name_ABC
         , pi_vc2_value => pi_routing_value_ABC
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'A';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'InclusiveClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'B';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union all
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'InclusiveClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union all
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'InclusiveClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union all
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'C';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            pi_prcs_name as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      -- tear down test
      flow_api_pkg.flow_delete ( p_process_id => l_prcs_id);

   end inclusive_route_provided_runner;

   -- test f1 - inclusive gateway - GR provided - matching case)

   procedure inclusive_route_provided_correct_case
   is
   begin
      inclusive_route_provided_runner 
      ( pi_prcs_name             => 'test - inclusive_route_provided - matching case'
      , pi_routing_var_name_A    => 'Inclusive:route'
      , pi_routing_value_A       => 'RouteA'
      , pi_routing_var_name_B    => 'Inclusive:route'
      , pi_routing_value_B       => 'RouteB'
      , pi_routing_var_name_C    => 'Inclusive:route'
      , pi_routing_value_C       => 'RouteC'
      , pi_routing_var_name_AB   => 'Inclusive:route'
      , pi_routing_value_AB      => 'RouteA:RouteB'
      , pi_routing_var_name_BC   => 'Inclusive:route'
      , pi_routing_value_BC      => 'RouteB:RouteC'
      , pi_routing_var_name_AC   => 'Inclusive:route'
      , pi_routing_value_AC      => 'RouteA:RouteC'
      , pi_routing_var_name_ABC  => 'Inclusive:route'
      , pi_routing_value_ABC     => 'RouteA:RouteB:RouteC'
      );
   end inclusive_route_provided_correct_case;

   -- test f2 - inclusive gateway - GR provided - UPPER CASE)
   
   procedure inclusive_route_provided_upper_case
   is
   begin
      inclusive_route_provided_runner 
      ( pi_prcs_name             => 'test - inclusive_route_provided - upper case'
      , pi_routing_var_name_A    => 'INCLUSIVE:ROUTE'
      , pi_routing_value_A       => 'RouteA'
      , pi_routing_var_name_B    => 'INCLUSIVE:ROUTE'
      , pi_routing_value_B       => 'RouteB'
      , pi_routing_var_name_C    => 'INCLUSIVE:ROUTE'
      , pi_routing_value_C       => 'RouteC'
      , pi_routing_var_name_AB   => 'INCLUSIVE:ROUTE'
      , pi_routing_value_AB      => 'RouteA:RouteB'
      , pi_routing_var_name_BC   => 'INCLUSIVE:ROUTE'
      , pi_routing_value_BC      => 'RouteB:RouteC'
      , pi_routing_var_name_AC   => 'INCLUSIVE:ROUTE'
      , pi_routing_value_AC      => 'RouteA:RouteC'
      , pi_routing_var_name_ABC  => 'INCLUSIVE:ROUTE'
      , pi_routing_value_ABC     => 'RouteA:RouteB:RouteC'
      );
   end inclusive_route_provided_upper_case;

   -- test f3 - inclusive gateway - GR provided - lower case)
   
   procedure inclusive_route_provided_lower_case
   is
   begin
      inclusive_route_provided_runner 
      ( pi_prcs_name             => 'test - inclusive_route_provided - lower case'
      , pi_routing_var_name_A    => 'inclusive:route'
      , pi_routing_value_A       => 'RouteA'
      , pi_routing_var_name_B    => 'inclusive:route'
      , pi_routing_value_B       => 'RouteB'
      , pi_routing_var_name_C    => 'inclusive:route'
      , pi_routing_value_C       => 'RouteC'
      , pi_routing_var_name_AB   => 'inclusive:route'
      , pi_routing_value_AB      => 'RouteA:RouteB'
      , pi_routing_var_name_BC   => 'inclusive:route'
      , pi_routing_value_BC      => 'RouteB:RouteC'
      , pi_routing_var_name_AC   => 'inclusive:route'
      , pi_routing_value_AC      => 'RouteA:RouteC'
      , pi_routing_var_name_ABC  => 'inclusive:route'
      , pi_routing_value_ABC     => 'RouteA:RouteB:RouteC'
      );
   end inclusive_route_provided_lower_case;

   -- test f4 - inclusive gateway - GR provided - JuMbLeD case)
   
   procedure inclusive_route_provided_jumbled_case
   is
   begin
      inclusive_route_provided_runner 
      ( pi_prcs_name             => 'test - inclusive_route_provided - jumbled case'
      , pi_routing_var_name_A    => 'iNcLuSive:RouTe'
      , pi_routing_value_A       => 'RouteA'
      , pi_routing_var_name_B    => 'iNcLuSive:RouTe'
      , pi_routing_value_B       => 'RouteB'
      , pi_routing_var_name_C    => 'iNcLuSive:RouTe'
      , pi_routing_value_C       => 'RouteC'
      , pi_routing_var_name_AB   => 'iNcLuSive:RouTe'
      , pi_routing_value_AB      => 'RouteA:RouteB'
      , pi_routing_var_name_BC   => 'iNcLuSive:RouTe'
      , pi_routing_value_BC      => 'RouteB:RouteC'
      , pi_routing_var_name_AC   => 'iNcLuSive:RouTe'
      , pi_routing_value_AC      => 'RouteA:RouteC'
      , pi_routing_var_name_ABC  => 'iNcLuSive:RouTe'
      , pi_routing_value_ABC     => 'RouteA:RouteB:RouteC'
      );
   end inclusive_route_provided_jumbled_case;

   -- test f5 - inclusve gateway - merge and resplit



   procedure IncGWResplitTestRunner
   ( p_prcs_name           in flow_processes.prcs_name%type
   , p_dgrm_name           in flow_diagrams.dgrm_name%type
   , p_gw_split_GRV        in varchar2 default null
   , p_gw_mergeSplit_GRV   in varchar2 default null
   , p_gw_split_GRE        in varchar2 default null
   , p_gw_mergeSplit_GRE   in varchar2 default null
   , p_expected_paths_XY   in varchar2
   , p_expected_paths_ABC  in varchar2
   )
   is
      l_actual            sys_refcursor;
      l_expected          sys_refcursor;
      l_actual_vc2        varchar2(200);
      l_actual_number     number;
      l_result_set_xy    apex_t_varchar2;
      l_result_set_abc   apex_t_varchar2;
      l_result            flow_process_variables.prov_var_vc2%type;
      test_dgrm_id        flow_diagrams.dgrm_id%type;
      test_prcs_id        flow_processes.prcs_id%type;
      test_sbfl_id_main   flow_subflows.sbfl_id%type;
      test_prcs_name      flow_processes.prcs_name%type := p_prcs_name;  
   begin
      test_dgrm_id := test_helper.set_dgrm_id( pi_dgrm_name => p_dgrm_name);
      -- create new process
      test_prcs_id := flow_api_pkg.flow_create 
                       ( pi_dgrm_id   => test_dgrm_id
                       , pi_prcs_name => test_prcs_name
                       );

      -- set gatewy variables
      if p_gw_split_GRV is not null then
         flow_process_vars.set_var
         ( pi_prcs_id => test_prcs_id
         , pi_var_name => 'Gateway_Split:route'
         , pi_scope => 0
         , pi_vc2_value => p_gw_split_GRV
         );
      end if;

      if p_gw_mergeSplit_GRV is not null then
         flow_process_vars.set_var
         ( pi_prcs_id => test_prcs_id
         , pi_var_name => 'Gateway_MergeSplit:route'
         , pi_scope => 0
         , pi_vc2_value => p_gw_mergeSplit_GRV
         );
      end if;

      if p_gw_split_GRE is not null then
         flow_process_vars.set_var
         ( pi_prcs_id => test_prcs_id
         , pi_var_name => 'GW_Split_Var'
         , pi_scope => 0
         , pi_vc2_value => p_gw_split_GRE
         );
      end if;

      if p_gw_mergeSplit_GRE is not null then
         flow_process_vars.set_var
         ( pi_prcs_id => test_prcs_id
         , pi_var_name => 'GW_ReSplit_Var'
         , pi_scope => 0
         , pi_vc2_value => p_gw_mergeSplit_GRE
         );
      end if;

      -- start process

      flow_api_pkg.flow_start( p_process_id => test_prcs_id );

      -- check process and subflow are running
      open l_expected for
          select
          test_dgrm_id                               as prcs_dgrm_id,
          test_prcs_name                             as prcs_name,
          flow_constants_pkg.gc_prcs_status_running   as prcs_status
          from dual;
      open l_actual for
          select prcs_dgrm_id, prcs_name, prcs_status 
            from flow_processes p
           where p.prcs_id = test_prcs_id;
      ut.expect( l_actual ).to_equal( l_expected );  

      -- check 1st subflow running

      open l_expected for
         select
            test_prcs_id           as sbfl_prcs_id,
            test_dgrm_id           as sbfl_dgrm_id,
            'Activity_Pre'        as sbfl_current,
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status
         from dual    
         ; 
      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status 
         from flow_subflows 
         where sbfl_prcs_id = test_prcs_id
         and sbfl_status not like 'split'; 
      ut.expect( l_actual ).to_equal( l_expected ).unordered;

      -- step forward into Inc GW Split

      test_helper.step_forward(pi_prcs_id => test_prcs_id, pi_current => 'Activity_Pre');    


      -- check which paths were chosen
      select sbfl_current
      bulk collect into  l_result_set_xy
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
         and sbfl_status  = flow_constants_pkg.gc_sbfl_status_running
       order by sbfl_current
      ;   
      -- create delimited string output
      l_result := apex_string.join
        ( p_table => l_result_set_xy
        , p_sep => ':'
        );
      ut.expect (l_result).to_equal(p_expected_paths_xy);

      -- step forward on X and/or Y

      for path in 1..l_result_set_xy.count
      loop
         test_helper.step_forward ( pi_prcs_id => test_prcs_id, pi_current => l_result_set_xy(path) );   
      end loop;

    -- this sould step us into gateway_mergeResplit

     -- check which paths were chosen

      select sbfl_current
      bulk collect into  l_result_set_abc
        from flow_subflows
       where sbfl_prcs_id = test_prcs_id
         and sbfl_status  = flow_constants_pkg.gc_sbfl_status_running
       order by sbfl_current
      ;   
      -- create delimited string output
      l_result := apex_string.join
        ( p_table => l_result_set_abc
        , p_sep => ':'
        );
      ut.expect (l_result).to_equal(p_expected_paths_abc);

      -- step forward on X and/or Y

      for path in 1..l_result_set_abc.count
      loop
         test_helper.step_forward ( pi_prcs_id => test_prcs_id, pi_current => l_result_set_abc(path) );   
      end loop;


      -- delete process

      flow_api_pkg.flow_delete ( p_process_id => test_prcs_id);

      ut.expect (v('APP_SESSION')).to_be_null;

   end IncGWResplitTestRunner; 

   -- test f5 - inc gateway merge resplit - all paths taken

   procedure inclusive_merge_resplit_f5
   is
   begin
      IncGWResplitTestRunner 
      ( p_prcs_name           => 'Suite 02 Test f7 Inc Resplits'
      , p_dgrm_name           => model_a10
      , p_gw_split_GRV        => 'Flow_X:Flow_Y'
      , p_gw_mergeSplit_GRV   => 'Flow_A:Flow_B:Flow_C'
      , p_expected_paths_XY   => 'Activity_X:Activity_Y'
      , p_expected_paths_ABC  => 'Activity_A:Activity_B:Activity_C'
      );
   end inclusive_merge_resplit_f5;

   -- test f6 - inc gateway merge resplit - all paths taken

   procedure inclusive_merge_resplit_f6
   is
   begin
      IncGWResplitTestRunner 
      ( p_prcs_name           => 'Suite 02 Test f6 Inc Resplits'
      , p_dgrm_name           => model_a10
      , p_gw_split_GRV        => 'Flow_X:Flow_Y'
      , p_gw_mergeSplit_GRV   => 'Flow_A:Flow_C'
      , p_expected_paths_XY   => 'Activity_X:Activity_Y'
      , p_expected_paths_ABC  => 'Activity_A:Activity_C'
      );
   end inclusive_merge_resplit_f6;

      -- test f7 - inc gateway merge resplit - all paths taken

   procedure inclusive_merge_resplit_f7
   is
   begin
      IncGWResplitTestRunner 
      ( p_prcs_name           => 'Suite 02 Test f7 Inc Resplits'
      , p_dgrm_name           => model_a10
      , p_gw_split_GRV        => 'Flow_Y'
      , p_gw_mergeSplit_GRV   => 'Flow_A:Flow_B'
      , p_expected_paths_XY   => 'Activity_Y'
      , p_expected_paths_ABC  => 'Activity_A:Activity_B'
      );
   end inclusive_merge_resplit_f7;

   -- test f8 - inc gateway merge resplit - all paths taken

   procedure inclusive_merge_resplit_f8
   is
   begin
      IncGWResplitTestRunner 
      ( p_prcs_name           => 'Suite 02 Test f8 Inc Resplits Exprs'
      , p_dgrm_name           => model_a12
      , p_gw_split_GRE        => 'X:Y'
      , p_gw_mergeSplit_GRE   => 'A:B:C'
      , p_expected_paths_XY   => 'Activity_X:Activity_Y'
      , p_expected_paths_ABC  => 'Activity_A:Activity_B:Activity_C'
      );
   end inclusive_merge_resplit_f8;

   -- test f9 - inc gateway merge resplit - all paths taken

   procedure inclusive_merge_resplit_f9
   is
   begin
      IncGWResplitTestRunner 
      ( p_prcs_name           => 'Suite 02 Test f9 Inc Resplits Exprs'
      , p_dgrm_name           => model_a12
      , p_gw_split_GRE        => 'X:Y'
      , p_gw_mergeSplit_GRE   => 'A:C'
      , p_expected_paths_XY   => 'Activity_X:Activity_Y'
      , p_expected_paths_ABC  => 'Activity_A:Activity_C'
      );
   end inclusive_merge_resplit_f9;

      -- test f10 - inc gateway merge resplit - all paths taken

   procedure inclusive_merge_resplit_f10
   is
   begin
      IncGWResplitTestRunner 
      ( p_prcs_name           => 'Suite 02 Test f10 Inc Resplits Exprs'
      , p_dgrm_name           => model_a12
      , p_gw_split_GRE        => 'Y'
      , p_gw_mergeSplit_GRE   => 'A:B'
      , p_expected_paths_XY   => 'Activity_Y'
      , p_expected_paths_ABC  => 'Activity_A:Activity_B'
      );
   end inclusive_merge_resplit_f10;


   -- test(g. parallel gateway)

   procedure parallel
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a8 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id => l_dgrm_id
         , pi_prcs_name => 'test - parallel'
      );
      g_prcs_id_7 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - parallel' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'A';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'ParallelClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'B' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'B';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            null as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union all
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'ParallelClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union all
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'ParallelClose' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_gateway sbfl_status
         from dual
         union all
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'C' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual
         ;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'C';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - parallel' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );
   end;

   -- test g2 : parallel merge- resplit gateway

   procedure parallel_merge_resplit
   is
   begin
      IncGWResplitTestRunner 
      ( p_prcs_name           => 'Suite 02 Test g2 Par Resplits'
      , p_dgrm_name           => model_a11
      , p_gw_split_GRV        => null
      , p_gw_mergeSplit_GRV   => null
      , p_expected_paths_XY   => 'Activity_X:Activity_Y'
      , p_expected_paths_ABC  => 'Activity_A:Activity_B:Activity_C'
      );
   end parallel_merge_resplit;

   -- test h. event based gateway - uses timer)

   procedure event_based 
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_count_sbfl number;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_need_wait boolean := true;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a9 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id => l_dgrm_id
         , pi_prcs_name => 'test - event_based'
      );
      g_prcs_id_8 := l_prcs_id;

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - event_based' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_running as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'EventGateway' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_split sbfl_status
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'TimerA' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status 
         from dual
         union
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'TimerB' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_waiting_timer sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected ).unordered();

      -- wait for timerA 
      while l_need_wait loop
         select count(*)
         into l_count_sbfl
         from flow_subflows 
         where sbfl_prcs_id = l_prcs_id;
         if (l_count_sbfl = 1) then
            l_need_wait := false;
         else
            dbms_session.sleep(1);
         end if;
      end loop;
      

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running sbfl_status 
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_actual ).to_equal( l_expected );

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id
      and sbfl_current = 'A';
      
      flow_api_pkg.flow_complete_step(
           p_process_id => l_prcs_id
         , p_subflow_id => l_sbfl_id
         , p_step_key   => l_step_key 
      );

      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - event_based' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );
     
   end event_based;


   procedure tear_down_tests
   is
   begin
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_1);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_2);
      -- test 3 is torn down in the test runner
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_4);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_5);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_6);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_7);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_8);
      flow_api_pkg.flow_delete ( p_process_id => g_prcs_id_9);
   end;

end test_002_gateway;