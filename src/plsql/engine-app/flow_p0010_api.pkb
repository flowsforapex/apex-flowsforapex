create or replace package body flow_p0010_api
as

  procedure process_action
  (
    pi_action  in varchar2
  , pi_prcs_ids in apex_application.g_f01%type
  , pi_sbfl_ids in apex_application.g_f02%type
  , pi_dgrm_ids in apex_application.g_f03%type
  , pi_prcs_names in apex_application.g_f04%type
  , pi_reservation in varchar2
  )
  as
    l_error_occured boolean := false;
    l_url           varchar2(4000);
  begin
    for i in pi_prcs_ids.first..pi_prcs_ids.last
    loop
      apex_debug.message( p_message => 'Action: %s, PRCS: %s, SBFL: %s', p0 => pi_action, p1 => pi_prcs_ids(i), p2 => pi_sbfl_ids(i) );
      case upper(pi_action)
        when 'RESET-FLOW-INSTANCE' then
          flow_api_pkg.flow_reset( p_process_id => pi_prcs_ids(i) );
        when 'BULK-RESET-FLOW-INSTANCE' then
          flow_api_pkg.flow_reset( p_process_id => pi_prcs_ids(i) );
        when 'START-FLOW-INSTANCE' then
          flow_api_pkg.flow_start( p_process_id => pi_prcs_ids(i) );
        when 'BULK-START-FLOW-INSTANCE' then
          flow_api_pkg.flow_start( p_process_id => pi_prcs_ids(i) );
        when 'DELETE-FLOW-INSTANCE' then
          flow_api_pkg.flow_delete( p_process_id => pi_prcs_ids(i) );
        when 'BULK-DELETE-FLOW-INSTANCE' then
          flow_api_pkg.flow_delete( p_process_id => pi_prcs_ids(i) );
        when 'RESERVE-STEP' then
          flow_api_pkg.flow_reserve_step
          (
            p_process_id => pi_prcs_ids(i)
          , p_subflow_id => pi_sbfl_ids(i)
          , p_reservation => coalesce(pi_reservation, V('APP_USER'))
          );
        when 'BULK-RESERVE-STEP' then
          flow_api_pkg.flow_reserve_step
          (
            p_process_id => pi_prcs_ids(i)
          , p_subflow_id => pi_sbfl_ids(i)
          , p_reservation => coalesce(pi_reservation, V('APP_USER'))
          );
        when 'TERMINATE-FLOW-INSTANCE' then 
          flow_api_pkg.flow_terminate ( p_process_id => pi_prcs_ids(i) );
        when 'BULK-TERMINATE-FLOW-INSTANCE' then 
          flow_api_pkg.flow_terminate ( p_process_id => pi_prcs_ids(i) );
        when 'RELEASE-STEP' then
          flow_api_pkg.flow_release_step
          (
            p_process_id => pi_prcs_ids(i)
          , p_subflow_id => pi_sbfl_ids(i)
          );   
        when 'BULK-RELEASE-STEP' then
          flow_api_pkg.flow_release_step
          (
            p_process_id => pi_prcs_ids(i)
          , p_subflow_id => pi_sbfl_ids(i)
          );        
        when 'COMPLETE-STEP' then
          flow_api_pkg.flow_complete_step
          (
            p_process_id    => pi_prcs_ids(i)
          , p_subflow_id    => pi_sbfl_ids(i)
          );
        when 'BULK-COMPLETE-STEP' then
          flow_api_pkg.flow_complete_step
          (
            p_process_id    => pi_prcs_ids(i)
          , p_subflow_id    => pi_sbfl_ids(i)
          );
        when 'RESTART-STEP' then 
          flow_api_pkg.flow_restart_step 
          (
            p_process_id    => pi_prcs_ids(i)
          , p_subflow_id    => pi_sbfl_ids(i)           
          );
        when 'BULK-RESTART-STEP' then 
          flow_api_pkg.flow_restart_step 
          (
            p_process_id    => pi_prcs_ids(i)
          , p_subflow_id    => pi_sbfl_ids(i)           
          );
        when 'VIEW-FLOW-INSTANCE' then
          l_url := apex_page.get_url(
              p_page => 12
            , p_items => 'P12_PRCS_ID'
            , p_values => pi_prcs_ids(i)
          );
        when 'FLOW-INSTANCE-AUDIT' then
          l_url := apex_page.get_url(
              p_page => 14
            , p_items => 'P14_PRCS_ID,P14_TITLE'
            , p_values => pi_prcs_ids(i)||','||pi_prcs_names(i)
          );
        when 'EDIT-FLOW-DIAGRAM' then
          l_url := apex_page.get_url(
              p_page => 7
            , p_items => 'P7_DGRM_ID'
            , p_values => pi_dgrm_ids(i)
          );
        else
          apex_error.add_error
          (
            p_message          => 'Unknow action requested.'
          , p_display_location => apex_error.c_on_error_page
          );
      end case;
    end loop;
    
  
    apex_json.open_object;
    apex_json.write( p_name => 'success', p_value => not apex_error.have_errors_occurred );
    if l_url is not null then
      apex_json.write( p_name => 'url', p_value => l_url );
    end if;
    apex_json.close_all;
    
  exception
      when others then
        l_error_occured := true;
    
  end process_action;


procedure process_variables_row
(
  pi_request         in varchar2
, pi_delete_prov_var in boolean default false
, pi_prov_prcs_id    in out nocopy flow_process_variables.prov_prcs_id%type
, pi_prov_var_name   in out nocopy flow_process_variables.prov_var_name%type
, pi_prov_var_type   in flow_process_variables.prov_var_type%type
, pi_prov_var_vc2    in flow_process_variables.prov_var_vc2%type
, pi_prov_var_num    in flow_process_variables.prov_var_num%type
, pi_prov_var_date   in flow_process_variables.prov_var_date%type
, pi_prov_var_clob   in flow_process_variables.prov_var_clob%type
)
as
begin
  if ( pi_delete_prov_var ) then
    flow_process_vars.delete_var(
        pi_prcs_id  => pi_prov_prcs_id
      , pi_var_name => pi_prov_var_name
    );
  end if;

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
