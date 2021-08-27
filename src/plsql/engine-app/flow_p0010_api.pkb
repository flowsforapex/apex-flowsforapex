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
        when 'TERMINATE-FLOW-INSTANCE' then 
          flow_api_pkg.flow_terminate ( p_process_id => pi_prcs_ids(i) );
        when 'BULK-TERMINATE-FLOW-INSTANCE' then 
          flow_api_pkg.flow_terminate ( p_process_id => pi_prcs_ids(i) );
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
        when 'OPEN-FLOW-INSTANCE-DETAILS' then
          l_url := apex_page.get_url(
              p_page => 8
            , p_items => 'P8_PRCS_ID'
            , p_values => pi_prcs_ids(i)
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

end flow_p0010_api;
/
