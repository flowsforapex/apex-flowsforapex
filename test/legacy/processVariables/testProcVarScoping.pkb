create or replace package body testProcVarScoping
as


  procedure basic_vc2_in_scope_0
  as
    l_value varchar2 (20);
    l_type   varchar2 (20);
  begin
    flow_process_vars.set_var
      ( pi_prcs_id => 25
      , pi_scope => 0
      , pi_var_name => 'MyFirstVC2'
      , pi_vc2_value => 'MyFirstVC2value'
      );
    select prov_var_type
         , prov_var_vc2
      into l_type
         , l_value
      from flow_process_variables
     where prov_prcs_id = 25
       and prov_scope   = 0
       and prov_var_name = 'MyFirstVC2'
       ;

    ut.expect(l_value).to_equal('MyFirstVC2value');
    
  end basic_vc2_in_scope_0;

end testProcVarScoping;
  /