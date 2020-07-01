create or replace package body flow_p0010_api
as

  procedure process_action
  (
    pi_action  in varchar2
  , pi_prcs_id in flow_processes.prcs_id%type
  , pi_sbfl_id in flow_subflows.sbfl_id%type
  , pi_branch  in varchar2
  )
  as
  begin
    case upper(pi_action)
      when 'RESET' then
        flow_api_pkg.flow_reset( p_process_id => pi_prcs_id );
      when 'START' then
        flow_api_pkg.flow_start( p_process_id => pi_prcs_id );
      when 'DELETE' then
        flow_api_pkg.flow_delete( p_process_id => pi_prcs_id );
      when 'NEXT_STEP' then
        flow_api_pkg.flow_next_step
        (
          p_process_id    => pi_prcs_id
        , p_subflow_id    => pi_sbfl_id
        , p_forward_route => pi_branch
        );
      when 'CHOOSE_BRANCH' then
        flow_api_pkg.flow_next_branch
        (
          p_process_id  => pi_prcs_id
        , p_subflow_id  => pi_sbfl_id
        , p_branch_name => pi_branch
        );
      else
        apex_error.add_error
        (
          p_message          => 'Unknow action requested.'
        , p_display_location => apex_error.c_on_error_page
        );
    end case;

    apex_json.open_object;
    apex_json.write( p_name => 'success', p_value => true );
    apex_json.close_all;
  
  end process_action;

end flow_p0010_api;
/
