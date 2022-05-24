create or replace package body test_gateway is

   model_a2 constant varchar2(100) := 'A2 - Exclusive Gateway No Route';
   model_a3 constant varchar2(100) := 'A3 - Exclusive Gateway Default Route';
   model_a4 constant varchar2(100) := 'A4 - Exclusive Gateway Routing';
   model_a5 constant varchar2(100) := 'A5 - Inclusive Gateway No Route';
   model_a6 constant varchar2(100) := 'A6 - Inclusive Gateway Default Route';
   model_a7 constant varchar2(100) := 'A7 - Inclusive Gateway Routing';
   model_a8 constant varchar2(100) := 'A8 - Parallel Gateway';
   model_a9 constant varchar2(100) := 'A9 - Event Based Gateway';

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
            'No gateway routing instruction provided in variable Exclusive:route and model contains no default route.' as lgpr_comment, 
            'ORA-01403: no data found
' lgpr_error_info 
         from dual;

      open l_actual for
         select lgpr_objt_id, lgpr_prcs_event, lgpr_comment, lgpr_error_info
         from flow_instance_event_log 
         where lgpr_prcs_id = l_prcs_id
         order by lgpr_timestamp desc 
         fetch first 1 rows only;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_delete(p_process_id => l_prcs_id);
   end exclusive_no_route;

   procedure exclusive_default
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a3 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_id   => l_dgrm_id
         , pi_prcs_name => 'test - exclusive_default'
      );

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


   procedure exclusive_route_provided
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
         , pi_prcs_name => 'test - exclusive_route_provided'
      );

      --Set RouteA
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Exclusive:route'
         , pi_vc2_value => 'RouteA'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - exclusive_route_provided' as prcs_name, 
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
            'test - exclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteB
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Exclusive:route'
         , pi_vc2_value => 'RouteB'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - exclusive_route_provided' as prcs_name, 
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
            'test - exclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Exclusive:route'
         , pi_vc2_value => 'RouteC'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - exclusive_route_provided' as prcs_name, 
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
            'test - exclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

   end;

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
            'No gateway routing instruction provided in variable Inclusive:route and model contains no default route.' as lgpr_comment, 
            'ORA-01403: no data found
' lgpr_error_info 
         from dual;

      open l_actual for
         select lgpr_objt_id, lgpr_prcs_event, lgpr_comment, lgpr_error_info
         from flow_instance_event_log 
         where lgpr_prcs_id = l_prcs_id
         order by lgpr_timestamp desc 
         fetch first 1 rows only;

      ut.expect( l_actual ).to_equal( l_expected );
   end;

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

   procedure inclusive_route_provided
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
         , pi_prcs_name => 'test - inclusive_route_provided'
      );

      --Set RouteA
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Inclusive:route'
         , pi_vc2_value => 'RouteA'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_route_provided' as prcs_name, 
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
            'test - inclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteB
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Inclusive:route'
         , pi_vc2_value => 'RouteB'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_route_provided' as prcs_name, 
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
            'test - inclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Inclusive:route'
         , pi_vc2_value => 'RouteC'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_route_provided' as prcs_name, 
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
            'test - inclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteA:RouteB
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Inclusive:route'
         , pi_vc2_value => 'RouteA:RouteB'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_route_provided' as prcs_name, 
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
            'test - inclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      --Set RouteA:RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Inclusive:route'
         , pi_vc2_value => 'RouteA:RouteC'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_route_provided' as prcs_name, 
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
            'test - inclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );
      
      --Set RouteB:RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Inclusive:route'
         , pi_vc2_value => 'RouteB:RouteC'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_route_provided' as prcs_name, 
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
            'test - inclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );
      
      --Set RouteA:RouteB:RouteC
      flow_process_vars.set_var(
           pi_prcs_id   => l_prcs_id
         , pi_var_name  => 'Inclusive:route'
         , pi_vc2_value => 'RouteA:RouteB:RouteC'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );
      
      open l_expected for
         select 
            l_dgrm_id as prcs_dgrm_id, 
            'test - inclusive_route_provided' as prcs_name, 
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
            'test - inclusive_route_provided' as prcs_name, 
            flow_constants_pkg.gc_prcs_status_completed as prcs_status 
         from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );
   end;

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

end test_gateway;