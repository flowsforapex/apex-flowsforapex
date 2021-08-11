create or replace package body flow_p0010_api
as

  procedure process_action
  (
    pi_action  in varchar2
  , pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  )
  as
    l_error_occured boolean := false;
    l_url           varchar2(4000);
  begin
    apex_debug.message( p_message => 'Action: %s, PRCS: %s, SBFL: %s', p0 => pi_action, p1 => pi_prcs_id, p2 => pi_sbfl_id );
    begin
      case upper(pi_action)
        when 'RESET' then
          flow_api_pkg.flow_reset( p_process_id => pi_prcs_id );
        when 'START' then
          flow_api_pkg.flow_start( p_process_id => pi_prcs_id );
        when 'DELETE' then
          flow_api_pkg.flow_delete( p_process_id => pi_prcs_id );
        when 'RESERVE' then
          flow_api_pkg.flow_reserve_step
          (
            p_process_id => pi_prcs_id
          , p_subflow_id => pi_sbfl_id
          , p_reservation => V('APP_USER')
          );
        when 'TERMINATE' then 
          flow_api_pkg.flow_terminate ( p_process_id => pi_prcs_id );
        when 'RELEASE' then
          flow_api_pkg.flow_release_step
          (
            p_process_id => pi_prcs_id
          , p_subflow_id => pi_sbfl_id
          );         
        when 'NEXT_STEP' then
          flow_api_pkg.flow_complete_step
          (
            p_process_id    => pi_prcs_id
          , p_subflow_id    => pi_sbfl_id
          );
        when 'RESTART_STEP' then 
          flow_api_pkg.flow_restart_step 
          (
            p_process_id    => pi_prcs_id
          , p_subflow_id    => pi_sbfl_id           
          );
        when 'VIEW' then
          l_url := apex_page.get_url(
              p_page => 12
            , p_items => 'P12_PRCS_ID'
            , p_values => pi_prcs_id
          );
        else
          apex_error.add_error
          (
            p_message          => 'Unknow action requested.'
          , p_display_location => apex_error.c_on_error_page
          );
      end case;
  
      apex_json.open_object;
      apex_json.write( p_name => 'success', p_value => not apex_error.have_errors_occurred );
      if upper(pi_action) = 'VIEW' then
        apex_json.write( p_name => 'url', p_value => l_url );
      end if;
      apex_json.close_all;
    exception
      when others then
        l_error_occured := true;
    end;
  end process_action;


procedure process_variables_row
(
  pi_row_status    in varchar2
, pi_prov_prcs_id  in out nocopy flow_process_variables.prov_prcs_id%type
, pi_prov_var_name in out nocopy flow_process_variables.prov_var_name%type
, pi_prov_var_type in flow_process_variables.prov_var_type%type
, pi_prov_var_vc2  in flow_process_variables.prov_var_vc2%type
, pi_prov_var_num  in flow_process_variables.prov_var_num%type
, pi_prov_var_date in flow_process_variables.prov_var_date%type
, pi_prov_var_clob in flow_process_variables.prov_var_clob%type
)
as
begin
  case pi_prov_var_type
    when 'VARCHAR2' then
      flow_process_vars.set_var
      (
        pi_prcs_id   => pi_prov_prcs_id
      , pi_var_name  => pi_prov_var_name
      , pi_vc2_value => pi_prov_var_vc2
      );
    when 'NUMBER' then
      flow_process_vars.set_var
      (
        pi_prcs_id   => pi_prov_prcs_id
      , pi_var_name  => pi_prov_var_name
      , pi_num_value => pi_prov_var_num
      );
    when 'DATE' then
      flow_process_vars.set_var
      (
        pi_prcs_id    => pi_prov_prcs_id
      , pi_var_name   => pi_prov_var_name
      , pi_date_value => pi_prov_var_date
      );
    when 'CLOB' then
      flow_process_vars.set_var
      (
        pi_prcs_id    => pi_prov_prcs_id
      , pi_var_name   => pi_prov_var_name
      , pi_clob_value => pi_prov_var_clob
      );
    else
      null;
  end case;
end process_variables_row;

end flow_p0010_api;
/
