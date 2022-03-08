create or replace package body test_gateway is

   model_a2 constant varchar2(100) := 'A2 - Exclusive Gateway No Route';
   model_a3 constant varchar2(100) := 'A3 - Exclusive Gateway Default Route';
   model_a4 constant varchar2(100) := 'A4 - Exclusive Gateway Routing';

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
           pi_dgrm_name => model_a2
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

   end exclusive_no_route;

   procedure exclusive_default
   is
   begin
     null;
   end;


   procedure exclusive_route_provided
   is
   begin
     null;
   end;

   procedure inclusive_no_route
   is
   begin
     null;
   end;

   procedure inclusive_default
   is
   begin
     null;
   end;

   procedure inclusive_route_a
   is
   begin
     null;
   end;

   procedure inclusive_route_b
   is
   begin
     null;
   end;

   procedure inclusive_route_c
   is
   begin
     null;
   end;

   procedure inclusive_route_ab
   is
   begin
     null;
   end;

   procedure inclusive_route_ac
   is
   begin
     null;
   end;

   procedure inclusive_route_bc
   is
   begin
     null;
   end;

   procedure parallel
   is
   begin
     null;
   end;

end test_gateway;