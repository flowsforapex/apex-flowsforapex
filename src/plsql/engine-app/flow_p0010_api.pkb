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
        else
          apex_error.add_error
          (
            p_message          => 'Unknow action requested.'
          , p_display_location => apex_error.c_on_error_page
          );
      end case;
  
      apex_json.open_object;
      apex_json.write( p_name => 'success', p_value => not apex_error.have_errors_occurred );
      apex_json.close_all;
    exception
      when others then
        l_error_occured := true;
    end;
  end process_action;

end flow_p0010_api;
/
