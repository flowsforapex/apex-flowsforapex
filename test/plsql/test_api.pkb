create or replace package body test_api is

   model_a1 constant varchar2(100) := 'A1 - Basic Model';

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

   procedure flow_create
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_create'
      );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_create' as prcs_name, flow_constants_pkg.gc_prcs_status_created as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

   end flow_create;


   procedure flow_start
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_start'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_start' as prcs_name, flow_constants_pkg.gc_prcs_status_running as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      open l_expected for
         select l_prcs_id as sbfl_prcs_id, l_dgrm_id as sbfl_dgrm_id, 'A' as sbfl_current, flow_constants_pkg.gc_sbfl_status_running sbfl_status from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

   end flow_start;

   procedure flow_reset
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_reset'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      flow_api_pkg.flow_reset( p_process_id => l_prcs_id );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_reset' as prcs_name, flow_constants_pkg.gc_prcs_status_created as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

   end flow_reset; 

   procedure flow_terminate
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_terminate'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      flow_api_pkg.flow_terminate( p_process_id => l_prcs_id );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_terminate' as prcs_name, flow_constants_pkg.gc_prcs_status_terminated as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );
     
   end flow_terminate;

   procedure flow_delete
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_delete'
      );

      flow_api_pkg.flow_delete( p_process_id => l_prcs_id );

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_have_count( 0 );
     
   end flow_delete;

   procedure flow_complete_step
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_complete_step'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

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
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_complete_step' as prcs_name, flow_constants_pkg.gc_prcs_status_running as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      open l_expected for
         select l_prcs_id as sbfl_prcs_id, l_dgrm_id as sbfl_dgrm_id, 'B' as sbfl_current, flow_constants_pkg.gc_sbfl_status_running sbfl_status from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status from flow_subflows where sbfl_prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

   end flow_complete_step;

   procedure flow_reserve_step
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_reserve_step'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;

      flow_api_pkg.flow_reserve_step(
           p_process_id  => l_prcs_id
         , p_subflow_id  => l_sbfl_id
         , p_step_key    => l_step_key
         , p_reservation => 'TEST'
      );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_reserve_step' as prcs_name, flow_constants_pkg.gc_prcs_status_running as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status,
            'TEST' as sbfl_reservation
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status, sbfl_reservation from flow_subflows where sbfl_prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

   end flow_reserve_step;

   procedure flow_release_step
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_release_step'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      select sbfl_id, sbfl_step_key
      into l_sbfl_id, l_step_key
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;

      flow_api_pkg.flow_reserve_step(
           p_process_id  => l_prcs_id
         , p_subflow_id  => l_sbfl_id
         , p_step_key    => l_step_key
         , p_reservation => 'TEST'
      );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_release_step' as prcs_name, flow_constants_pkg.gc_prcs_status_running as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status,
            'TEST' as sbfl_reservation
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status, sbfl_reservation from flow_subflows where sbfl_prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );

      flow_api_pkg.flow_release_step(
           p_process_id  => l_prcs_id
         , p_subflow_id  => l_sbfl_id
         , p_step_key    => l_step_key
      );

      open l_expected for
         select 
            l_prcs_id as sbfl_prcs_id, 
            l_dgrm_id as sbfl_dgrm_id, 
            'A' as sbfl_current, 
            flow_constants_pkg.gc_sbfl_status_running as sbfl_status,
            null as sbfl_reservation
         from dual;

      open l_actual for
         select sbfl_prcs_id, sbfl_dgrm_id, sbfl_current, sbfl_status, sbfl_reservation from flow_subflows where sbfl_prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );
   end flow_release_step;

   procedure flow_start_step
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_sbfl_id  flow_subflows.sbfl_id%type;
      l_step_key flow_subflows.sbfl_step_key%type;
      l_sbfl_work_started flow_subflows.sbfl_work_started%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_start_step'
      );

      flow_api_pkg.flow_start( p_process_id => l_prcs_id );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_start_step' as prcs_name, flow_constants_pkg.gc_prcs_status_running as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected ); 
 
      select sbfl_id, sbfl_step_key, sbfl_work_started
      into l_sbfl_id, l_step_key, l_sbfl_work_started
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_sbfl_work_started ).to_be_null();

      flow_api_pkg.flow_start_step(
           p_process_id  => l_prcs_id
         , p_subflow_id  => l_sbfl_id
         , p_step_key    => l_step_key
      );

      select sbfl_work_started
      into l_sbfl_work_started
      from flow_subflows
      where sbfl_prcs_id = l_prcs_id;
      
      ut.expect( l_sbfl_work_started ).to_be_not_null();

   end flow_start_step;
   
   procedure flow_variables
   is
      l_prcs_id  flow_processes.prcs_id%type;
      l_dgrm_id  flow_diagrams.dgrm_id%type;
      l_actual   sys_refcursor;
      l_expected sys_refcursor;
      l_vc2_var_name varchar2(10) := 'vc2_var';
      l_num_var_name varchar2(10) := 'num_var';
      l_date_var_name varchar2(10) := 'date_var';
      l_clob_var_name varchar2(10) := 'clob_var';
      l_expected_vc2 varchar2(4000) := 'TEST';
      l_expected_num number := 1000;
      l_expected_date date := to_date('01/01/2022', 'DD/MM/YYYY');
      l_expected_clob clob := to_clob('TEST');
      l_actual_vc2 varchar2(4000);
      l_actual_num number;
      l_actual_date date;
      l_actual_clob clob;
   
      l_rec flow_process_variables%rowtype;
   begin
      -- get dgrm_id to use for comparaison
      l_dgrm_id := get_dgrm_id( model_a1 );

      -- create a new instance
      l_prcs_id := flow_api_pkg.flow_create(
           pi_dgrm_name => model_a1
         , pi_prcs_name => 'test - flow_variables'
      );

      open l_expected for
         select l_dgrm_id as prcs_dgrm_id, 'test - flow_variables' as prcs_name, flow_constants_pkg.gc_prcs_status_created as prcs_status from dual;

      open l_actual for
         select prcs_dgrm_id, prcs_name, prcs_status from flow_processes where prcs_id = l_prcs_id;

      ut.expect( l_actual ).to_equal( l_expected );  

      -- Set variables
      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_vc2_var_name
         , pi_vc2_value => l_expected_vc2
      );

      open l_expected for
         select 
            l_vc2_var_name as prov_var_name, 
            'VARCHAR2' as prov_var_type, 
            l_expected_vc2 prov_var_vc2
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_vc2
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_vc2_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected );

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_vc2_var_name;

      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_num ).to_be_null();
      ut.expect( l_rec.prov_var_date ).to_be_null();
      ut.expect( l_rec.prov_var_clob ).to_be_null(); 

      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_num_var_name
         , pi_num_value => l_expected_num 
      );

      open l_expected for
         select 
            l_num_var_name as prov_var_name, 
            'NUMBER' as prov_var_type, 
            l_expected_num as prov_var_num
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_num
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_num_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected ); 

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_num_var_name;
      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_vc2 ).to_be_null();
      ut.expect( l_rec.prov_var_date ).to_be_null();
      ut.expect( l_rec.prov_var_clob ).to_be_null(); 

      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_date_var_name
         , pi_date_value => l_expected_date 
      );

      open l_expected for
         select 
            l_date_var_name as prov_var_name, 
            'DATE' as prov_var_type, 
            l_expected_date as prov_var_date
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_date 
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_date_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected ); 

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_date_var_name;
      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_vc2 ).to_be_null();
      ut.expect( l_rec.prov_var_num ).to_be_null();
      ut.expect( l_rec.prov_var_clob ).to_be_null(); 

      flow_process_vars.set_var(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_clob_var_name
         , pi_clob_value => l_expected_clob 
      );

      open l_expected for
         select 
            l_clob_var_name as prov_var_name, 
            'CLOB' as prov_var_type, 
            l_expected_clob as prov_var_clob
         from dual;

      open l_actual for 
         select prov_var_name, prov_var_type, prov_var_clob 
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_clob_var_name;
   
      ut.expect( l_actual ).to_equal( l_expected ); 

      open l_actual for 
         select *
         from flow_process_variables
         where prov_prcs_id = l_prcs_id
         and prov_var_name = l_clob_var_name;
      fetch l_actual into l_rec;

      ut.expect( l_rec.prov_var_vc2 ).to_be_null();
      ut.expect( l_rec.prov_var_num ).to_be_null();
      ut.expect( l_rec.prov_var_date ).to_be_null(); 

      -- Get variables
      l_actual_vc2 := flow_process_vars.get_var_vc2(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_vc2_var_name
      );

      ut.expect( l_actual_vc2 ).to_equal( l_expected_vc2 );

      l_actual_num := flow_process_vars.get_var_num(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_num_var_name
      );

      ut.expect( l_actual_num ).to_equal( l_expected_num );

      l_actual_date := flow_process_vars.get_var_date(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_date_var_name
      );

      ut.expect( l_actual_date ).to_equal( l_expected_date );

      l_actual_clob := flow_process_vars.get_var_clob(
           pi_prcs_id => l_prcs_id
         , pi_var_name => l_clob_var_name
      );

      ut.expect( l_actual_clob ).to_equal( l_expected_clob );

   end flow_variables;


end test_api;