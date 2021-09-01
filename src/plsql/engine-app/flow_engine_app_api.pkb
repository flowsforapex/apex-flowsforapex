create or replace package body flow_engine_app_api
as

  procedure handle_ajax
  as 
    l_error_occured boolean := false;
    l_url           varchar2(4000);
    l_clob          clob;
    l_before_prcs_status flow_instances_vw.prcs_status%type;
    l_after_prcs_status flow_instances_vw.prcs_status%type;
    l_reload boolean := false;
  begin
    apex_debug.message( p_message => 'Action: %s', p0 => apex_application.g_x01 );
    if instr(apex_application.g_x01, 'bulk-') > 0 then
      apex_debug.message( p_message => 'This is a bulk action');
      if ( upper(apex_application.g_x01) = 'BULK-COMPLETE-STEP' or upper(apex_application.g_x01) = 'BULK-RESTART-STEP' ) then
        select prcs_status
        into l_before_prcs_status
        from flow_instances_vw
        where prcs_id = apex_application.g_f01(1);
      end if;
      for i in apex_application.g_f01.first..apex_application.g_f01.last
      loop
        apex_debug.message( p_message => 'Action: %s, PRCS: %s', p0 => apex_application.g_x01, p1 => apex_application.g_f01(i) );
        case upper(apex_application.g_x01)
          when 'BULK-RESET-FLOW-INSTANCE' then
            flow_api_pkg.flow_reset( p_process_id => apex_application.g_f01(i), p_comment => apex_application.g_x02 );
          when 'BULK-START-FLOW-INSTANCE' then
            flow_api_pkg.flow_start( p_process_id => apex_application.g_f01(i) );
          when 'BULK-DELETE-FLOW-INSTANCE' then
            flow_api_pkg.flow_delete( p_process_id => apex_application.g_f01(i), p_comment => apex_application.g_x02 );
          when 'BULK-TERMINATE-FLOW-INSTANCE' then 
            flow_api_pkg.flow_terminate ( p_process_id => apex_application.g_f01(i), p_comment => apex_application.g_x02 );
          when 'BULK-RESERVE-STEP' then
            flow_api_pkg.flow_reserve_step
            (
              p_process_id => apex_application.g_f01(i)
            , p_subflow_id => apex_application.g_f02(i)
            , p_reservation => coalesce(apex_application.g_x02, V('APP_USER'))
            );
          when 'BULK-RELEASE-STEP' then
            flow_api_pkg.flow_release_step
            (
              p_process_id => apex_application.g_f01(i)
            , p_subflow_id => apex_application.g_f02(i)
            );        
          when 'BULK-COMPLETE-STEP' then
            flow_api_pkg.flow_complete_step
            (
              p_process_id => apex_application.g_f01(i)
            , p_subflow_id => apex_application.g_f02(i)
            );
          when 'BULK-RESTART-STEP' then 
            flow_api_pkg.flow_restart_step 
            (
              p_process_id => apex_application.g_f01(i)
            , p_subflow_id => apex_application.g_f02(i)
            , p_comment       => apex_application.g_x02           
            );
          when 'BULK-DELETE-PROCESS-VARIABLE' then 
            flow_process_vars.delete_var(
              pi_prcs_id => apex_application.g_f01(i)
            , pi_var_name => apex_application.g_f02(i)
          );
          else
            apex_error.add_error
            (
              p_message          => 'Unknow action requested.'
            , p_display_location => apex_error.c_on_error_page
            );
        end case;
      end loop;
      if ( upper(apex_application.g_x01) = 'BULK-COMPLETE-STEP' or upper(apex_application.g_x01) = 'BULK-RESTART-STEP' ) then
        select prcs_status
        into l_after_prcs_status
        from flow_instances_vw
        where prcs_id = apex_application.g_f01(1);

        if l_before_prcs_status != l_after_prcs_status then
          l_reload := true;
        end if;
      end if;
    else
      apex_debug.message( p_message => 'Action: %s, PRCS: %s, SBFL: %s', p0 => apex_application.g_x01, p1 => apex_application.g_x02, p2 => apex_application.g_x03 );

      if ( upper( apex_application.g_x01 ) = 'COMPLETE-STEP' or upper( apex_application.g_x01 ) = 'RESTART-STEP' ) then
        select prcs_status
        into l_before_prcs_status
        from flow_instances_vw
        where prcs_id = apex_application.g_x02;
      end if;


      case upper(apex_application.g_x01)
        when 'RESET-FLOW-INSTANCE' then
          flow_api_pkg.flow_reset( p_process_id => apex_application.g_x02, p_comment => apex_application.g_x03 );
        when 'START-FLOW-INSTANCE' then
          flow_api_pkg.flow_start( p_process_id => apex_application.g_x02 );
        when 'DELETE-FLOW-INSTANCE' then
          flow_api_pkg.flow_delete( p_process_id => apex_application.g_x02, p_comment => apex_application.g_x03 );
          l_url := apex_page.get_url(
                p_page => 10
              , p_clear_cache => 10
          );
        when 'RESERVE-STEP' then
          flow_api_pkg.flow_reserve_step
          (
            p_process_id => apex_application.g_x02
          , p_subflow_id => apex_application.g_x03
          , p_reservation => coalesce(apex_application.g_x04, V('APP_USER'))
          );
        when 'TERMINATE-FLOW-INSTANCE' then 
          flow_api_pkg.flow_terminate ( p_process_id => apex_application.g_x02, p_comment => apex_application.g_x03 );
        when 'RELEASE-STEP' then
          flow_api_pkg.flow_release_step
          (
            p_process_id => apex_application.g_x02
          , p_subflow_id => apex_application.g_x03
          );    
        when 'COMPLETE-STEP' then
          flow_api_pkg.flow_complete_step
          (
            p_process_id    => apex_application.g_x02
          , p_subflow_id    => apex_application.g_x03
          );
        when 'RESTART-STEP' then 
          flow_api_pkg.flow_restart_step 
          (
            p_process_id    => apex_application.g_x02
          , p_subflow_id    => apex_application.g_x03
          , p_comment       => apex_application.g_x04       
          );
        when 'FLOW-INSTANCE-AUDIT' then
          l_url := apex_page.get_url(
              p_page => 14
            , p_items => 'P14_PRCS_ID,P14_TITLE'
            , p_values => apex_application.g_x02||','||apex_application.g_x03
          );
        when 'EDIT-FLOW-DIAGRAM' then
          l_url := apex_page.get_url(
              p_page => 7
            , p_items => 'P7_DGRM_ID'
            , p_values => apex_application.g_x02
          );
        when 'OPEN-FLOW-INSTANCE-DETAILS' then
          l_url := apex_page.get_url(
              p_page => 8
            , p_items => 'P8_PRCS_ID'
            , p_values => apex_application.g_x02
            , p_clear_cache => 8
          );
        when 'VIEW-FLOW-INSTANCE' then
          l_url := apex_page.get_url(
              p_page => 12
            , p_items => 'P12_PRCS_ID'
            , p_values => apex_application.g_x02
            , p_clear_cache => 12
          );
        when 'PROCESS-VARIABLE' then
          case apex_application.g_x04
            when 'VARCHAR2' then
              flow_process_vars.set_var
              (
                pi_prcs_id   => apex_application.g_x02
              , pi_var_name  => apex_application.g_x03
              , pi_vc2_value => apex_application.g_x05
              );
            when 'NUMBER' then
              flow_process_vars.set_var
              (
                pi_prcs_id   => apex_application.g_x02
              , pi_var_name  => apex_application.g_x03
              , pi_num_value => to_number(apex_application.g_x05)
              );
            when 'DATE' then
              flow_process_vars.set_var
              (
                pi_prcs_id    => apex_application.g_x02
              , pi_var_name   => apex_application.g_x03
              , pi_date_value => to_date(apex_application.g_x05, v('APP_DATE_TIME_FORMAT'))
              );
            when 'CLOB' then
              for i in apex_application.g_f01.first..apex_application.g_f01.last
              loop
                l_clob := l_clob || apex_application.g_f01(i);
              end loop;
              flow_process_vars.set_var
              (
                pi_prcs_id    => apex_application.g_x02
              , pi_var_name   => apex_application.g_x03
              , pi_clob_value => l_clob
              );
            else
              null;
          end case;
        when 'DELETE-PROCESS-VARIABLE' then
          flow_process_vars.delete_var(
            pi_prcs_id => apex_application.g_x02
            , pi_var_name => apex_application.g_x03
          );
        else
          apex_error.add_error
          (
            p_message          => 'Unknow action requested.'
          , p_display_location => apex_error.c_on_error_page
          );
      end case;

      if ( upper( apex_application.g_x01 ) = 'COMPLETE-STEP' or upper( apex_application.g_x01 ) = 'RESTART-STEP' ) then
        select prcs_status
        into l_after_prcs_status
        from flow_instances_vw
        where prcs_id = apex_application.g_x02;

        if l_before_prcs_status != l_after_prcs_status then
          l_reload := true;
        end if;
      end if;

    end if;

    apex_json.open_object;
    apex_json.write( p_name => 'success', p_value => not apex_error.have_errors_occurred );
    if l_url is not null then
      apex_json.write( p_name => 'url', p_value => l_url );
    end if;
    if l_reload then 
      apex_json.write( p_name => 'reloadPage', p_value => true );
    end if;
    apex_json.close_all;
    
  exception
      when others then
        l_error_occured := true;
  end handle_ajax;

end flow_engine_app_api;
/
