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
            , p_step_key   => apex_application.g_f03(i)
            , p_reservation => coalesce(apex_application.g_x02, V('APP_USER'))
            );
          when 'BULK-RELEASE-STEP' then
            flow_api_pkg.flow_release_step
            (
              p_process_id => apex_application.g_f01(i)
            , p_subflow_id => apex_application.g_f02(i)
            , p_step_key   => apex_application.g_f03(i)
            );        
          when 'BULK-COMPLETE-STEP' then
            flow_api_pkg.flow_complete_step
            (
              p_process_id => apex_application.g_f01(i)
            , p_subflow_id => apex_application.g_f02(i)
            , p_step_key   => apex_application.g_f03(i)
            );
          when 'BULK-RESTART-STEP' then 
            flow_api_pkg.flow_restart_step 
            (
              p_process_id => apex_application.g_f01(i)
            , p_subflow_id => apex_application.g_f02(i)
            , p_step_key   => apex_application.g_f03(i)
            , p_comment       => apex_application.g_x02           
            );
          when 'BULK-DELETE-PROCESS-VARIABLE' then 
            flow_process_vars.delete_var(
              pi_prcs_id => apex_application.g_f01(i)
            , pi_var_name => apex_application.g_f02(i)
          );
          when 'BULK-RESCHEDULE-TIMER' then
          flow_api_pkg.flow_reschedule_timer(
              p_process_id    => apex_application.g_f01(i)
            , p_subflow_id    => apex_application.g_f02(i)
            , p_step_key      => apex_application.g_f03(i)
            , p_is_immediate  => case apex_application.g_x02 when 'Y' then true end
            , p_new_timestamp => case apex_application.g_x03 when 'N' then to_timestamp(apex_application.g_x06, v('APP_NLS_TIMESTAMP_FORMAT')) end
            , p_comment       => apex_application.g_x04
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
      apex_debug.message( p_message => 'Action: %0, PRCS: %1, SBFL: %2, STEP KEY: %3', p0 => apex_application.g_x01, 
      p1 => apex_application.g_x02, p2 => apex_application.g_x03 , p3 => apex_application.g_x04);

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
          , p_step_key   => apex_application.g_x04
          , p_reservation => coalesce(apex_application.g_x05, V('APP_USER'))
          );
        when 'TERMINATE-FLOW-INSTANCE' then 
          flow_api_pkg.flow_terminate ( p_process_id => apex_application.g_x02, p_comment => apex_application.g_x03 );
        when 'RELEASE-STEP' then
          flow_api_pkg.flow_release_step
          (
            p_process_id => apex_application.g_x02
          , p_subflow_id => apex_application.g_x03
          , p_step_key   => apex_application.g_x04
          );    
        when 'COMPLETE-STEP' then
          flow_api_pkg.flow_complete_step
          (
            p_process_id    => apex_application.g_x02
          , p_subflow_id    => apex_application.g_x03
          , p_step_key      => apex_application.g_x04
          );
        when 'RESTART-STEP' then 
          flow_api_pkg.flow_restart_step 
          (
            p_process_id    => apex_application.g_x02
          , p_subflow_id    => apex_application.g_x03
          , p_step_key      => apex_application.g_x04
          , p_comment       => apex_application.g_x05       
          );
        when 'FLOW-INSTANCE-AUDIT' then
          l_url := apex_page.get_url(
              p_page => 14
            , p_items => 'P14_PRCS_ID,P14_TITLE'
            , p_values => apex_application.g_x02||','||apex_application.g_x03
            , p_clear_cache => 'RP'
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
        when 'RESCHEDULE-TIMER' then
          flow_api_pkg.flow_reschedule_timer(
              p_process_id    => apex_application.g_x02
            , p_subflow_id    => apex_application.g_x03
            , p_step_key      => apex_application.g_x04
            , p_is_immediate  => case apex_application.g_x05 when 'Y' then true end
            , p_new_timestamp => case apex_application.g_x05 when 'N' then to_timestamp(apex_application.g_x06, v('APP_NLS_TIMESTAMP_FORMAT')) end
            , p_comment       => apex_application.g_x07
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
        apex_json.open_object;
        apex_json.write( p_name => 'success', p_value => false );
        apex_json.close_all;
        l_error_occured := true;
  end handle_ajax;


  function get_objt_list(
    p_prcs_id in flow_processes.prcs_id%type
  ) return varchar2
  as
    l_objt_list varchar2(32767);
  begin    
    select distinct listagg(OBJT_BPMN_ID, ':') within group (order by OBJT_BPMN_ID)
      into l_objt_list
      from flow_objects
     where objt_dgrm_id = (
           select prcs_dgrm_id 
             from flow_processes
            where prcs_id = p_prcs_id)
       and objt_tag_name not in ('bpmn:process', 'bpmn:textAnnotation', 'bpmn:participant', 'bpmn:laneSet', 'bpmn:lane');
    return l_objt_list;
  end get_objt_list;


  function get_objt_list(
    p_dgrm_id in flow_diagrams.dgrm_id%type
  ) return varchar2
  as
    l_objt_list varchar2(32767);
  begin    
    select distinct listagg(OBJT_BPMN_ID, ':') within group (order by OBJT_BPMN_ID)
      into l_objt_list
      from flow_objects
     where objt_dgrm_id = p_dgrm_id
       and objt_tag_name not in ('bpmn:process', 'bpmn:textAnnotation', 'bpmn:participant', 'bpmn:laneSet', 'bpmn:lane');
    return l_objt_list;
  end get_objt_list;
  
  
  function get_objt_name(
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_dgrm_id      in flow_diagrams.dgrm_id%type
  ) return flow_objects.objt_name%type
  as
    l_objt_name flow_objects.objt_name%type;
  begin
    select objt_name
      into l_objt_name
      from flow_objects
     where objt_bpmn_id = p_objt_bpmn_id
       and objt_dgrm_id = p_dgrm_id;
    return l_objt_name;
  end get_objt_name;


  function get_objt_name(
    p_objt_bpmn_id in flow_objects.objt_bpmn_id%type
  , p_prcs_id      in flow_processes.prcs_id%type
  ) return flow_objects.objt_name%type
  as
    l_objt_name flow_objects.objt_name%type;
  begin
    select objt_name
      into l_objt_name
      from flow_objects
     where objt_bpmn_id = p_objt_bpmn_id
       and objt_dgrm_id = (select prcs_dgrm_id
                             from flow_processes
                            where prcs_id = p_prcs_id);
    return l_objt_name;
  end get_objt_name;


  procedure set_viewport(
    p_display_setting in varchar2)
  as
  begin
    apex_util.set_preference('VIEWPORT', p_display_setting);
  end set_viewport;
    
    
  procedure add_viewport_script(
    p_item in varchar2
  )
  as
    l_script varchar2(4000 byte);
    l_display_setting varchar2(20 byte);
  begin
    -- Initialize
    l_display_setting := coalesce(apex_util.get_preference('VIEWPORT'),'row');
    apex_util.set_session_state(p_item, l_display_setting);
    
    -- Set IDs for the the row divs
    l_script := q'#apex.jQuery("#flow-instances").parent().attr("id","col1");
                 apex.jQuery("#flow-monitor").parent().attr("id","col2");#';
    
    apex_javascript.add_onload_code(
      p_code => l_script,
      p_key  => 'init_viewport');    
    
    l_script := null;
    -- Set view to side-by-side if preference = 'column'
    case l_display_setting 
      when 'column' then    
        l_script := q'#apex.jQuery( "#col1" ).addClass( "col-6" ).removeClass( [ "col-12", "col-end" ] );
                      apex.jQuery( "#col2" ).addClass( "col-6" ).removeClass( [ "col-12", "col-start" ] );
                      apex.jQuery("#col2").appendTo(apex.jQuery("#col1").parent());
                      apex.jQuery("#flow-monitor").show();
                      apex.region( "flow-monitor" ).refresh();#';
      when 'window' then
        l_script := q'#apex.jQuery("#flow-monitor").hide();
                       apex.jQuery( "#col1" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );
                       apex.jQuery( "#col2" ).addClass( [ "col-12", "col-start", "col-end" ] ).removeClass( "col-6" );#';
    else
      null;
    end case;
    
    if l_script is not null then
      apex_javascript.add_onload_code(
        p_code => l_script,
        p_key  => 'viewport');
    end if;
  end add_viewport_script;


  procedure get_url_p13(
    pi_dgrm_id flow_diagrams.dgrm_id%type
  , pi_objt_id varchar2
  , pi_title varchar2
  )
  as
    l_url varchar2(2000);
  begin
    l_url := apex_page.get_url(
      p_application => v('APP_ID'),
      p_page => '13',
      p_session => v('APP_SESSION'),
      p_clear_cache => 'RP',
      p_items => 'P13_DGRM_ID,P13_OBJT_ID,P13_TITLE',
      p_values => pi_dgrm_id || ',' || pi_objt_id || ',' || pi_title
    );
    htp.p(l_url);
  end get_url_p13;


  procedure get_url_p13(
    pi_prcs_id flow_processes.prcs_id%type
  , pi_objt_id varchar2
  , pi_title varchar2
  )
  as
    l_url varchar2(2000);
    l_dgrm_id flow_processes.prcs_dgrm_id%type;
  begin
    select prcs_dgrm_id 
      into l_dgrm_id 
      from flow_processes 
    where prcs_id = pi_prcs_id;
      
    l_url := apex_page.get_url(
      p_application => v('APP_ID'),
      p_page => '13',
      p_session => v('APP_SESSION'),
      p_clear_cache => 'RP',
      p_items => 'P13_DGRM_ID,P13_PRCS_ID,P13_OBJT_ID,P13_TITLE',
      p_values => l_dgrm_id || ',' || pi_prcs_id || ',' || pi_objt_id || ',' || pi_title
    );
    htp.p(l_url);
  end get_url_p13;


  /* page 2 */
  

  function check_flow_exists(
    p_dgrm_name    in flow_diagrams.dgrm_name%type,
    p_dgrm_version in flow_diagrams.dgrm_version%type)
  return boolean
  as
    l_exists binary_integer;
  begin
  
    select count(*)
      into l_exists
      from dual
     where exists(
           select null
             from flow_diagrams
            where dgrm_name = p_dgrm_name
              and dgrm_version = p_dgrm_version);
    return l_exists = 1;
  end check_flow_exists;
  

  function validate_flow_exists_bulk(
    pi_dgrm_id_list in varchar2
  , pi_new_version  in flow_diagrams.dgrm_version%type
  ) return varchar2 
  as
    l_err varchar2(4000 byte);
    l_flows apex_t_varchar2;
    l_dgrm_name flow_diagrams.dgrm_name%type;
  begin
    -- Initialize
    l_flows := apex_string.split(pi_dgrm_id_list, ':');
    
    for i in 1 .. l_flows.count loop
  
      select dgrm_name 
        into l_dgrm_name
        from flow_diagrams
       where dgrm_id = l_flows(i);

      if check_flow_exists(l_dgrm_name, pi_new_version) then
        l_err := apex_lang.message(
                   p_name => 'APP_ERR_MODEL_EXIST',
                   p0 => l_dgrm_name,
                   p1 => pi_new_version);
      end if;
      exit when l_err is not null;
    end loop;
    return l_err;
  end validate_flow_exists_bulk;


  function validate_flow_exists(
    pi_dgrm_id     in flow_diagrams.dgrm_id%type
  , pi_new_version in flow_diagrams.dgrm_version%type 
  ) return varchar2 
  as
    l_err varchar2(4000 byte);
    l_dgrm_name flow_diagrams.dgrm_name%type;
  begin
  
    select dgrm_name
      into l_dgrm_name
      from flow_diagrams
     where dgrm_id = pi_dgrm_id;
    
    if check_flow_exists(l_dgrm_name, pi_new_version) then
      l_err := apex_lang.message(
                 p_name => 'APP_ERR_MODEL_EXIST',
                 p0 => l_dgrm_name,
                 p1 => pi_new_version);
    end if;
    return l_err;
  end validate_flow_exists;
  
  
  function validate_flow_copy_bulk(
    pi_dgrm_id_list in varchar2
  , pi_new_name     in flow_diagrams.dgrm_name%type 
  ) return varchar2 
  as
    l_err varchar2(4000 byte);
    l_flows apex_t_varchar2;
    l_dgrm_name flow_diagrams.dgrm_name%type;
  begin
    -- Initialize
    l_flows := apex_string.split(pi_dgrm_id_list, ':');
    
    for i in 1 .. l_flows.count loop
  
      select dgrm_name|| ' - ' || pi_new_name
        into l_dgrm_name
        from flow_diagrams 
       where dgrm_id = l_flows(i);

      if check_flow_exists(l_dgrm_name, '0') then
        l_err := apex_lang.message(
                   p_name => 'APP_ERR_MODEL_EXIST',
                   p0 => pi_new_name,
                   p1 => '0');
      end if;
      exit when l_err is not null;
    end loop;
    return l_err;
  end validate_flow_copy_bulk;
  
  
  function validate_flow_copy(
    pi_new_name in flow_diagrams.dgrm_name%type 
  ) return varchar2 
  as
    l_err varchar2(4000);
  begin
    if check_flow_exists(pi_new_name, '0') then
      l_err := apex_lang.message(
                 p_name => 'APP_ERR_MODEL_EXIST',
                 p0 => pi_new_name,
                 p1 => '0');
    end if;
    return l_err;
  end validate_flow_copy;
  
  
  procedure copy_selection_to_collection
  as
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => 'C_SELECT' );
    for i in 1 .. apex_application.g_f01.count() loop
      apex_collection.add_member(
         p_collection_name => 'C_SELECT',
         p_n001 => apex_application.g_f01(i));
    end loop;
  end;

  
  procedure add_new_version(
    pi_dgrm_id_list in varchar2
  , pi_new_version  in flow_diagrams.dgrm_version%type 
  )
  as
    r_diagrams flow_diagrams%rowtype;
    l_flows apex_t_varchar2;
    l_dgrm_id flow_diagrams.dgrm_id%type;
  begin
    -- Initialize
    l_flows := apex_string.split(pi_dgrm_id_list, ':');
    
    for i in 1 .. l_flows.count loop
      select * 
        into r_diagrams
        from flow_diagrams
       where dgrm_id = l_flows(i);

      l_dgrm_id := flow_diagram.import_diagram(
        pi_dgrm_name => r_diagrams.dgrm_name,
        pi_dgrm_version => pi_new_version,
        pi_dgrm_category => r_diagrams.dgrm_category,
        pi_dgrm_content => r_diagrams.dgrm_content);
    end loop;
    
  end add_new_version;
  
  
  procedure copy_model(
    pi_dgrm_id_list in varchar2
  , pi_new_name     in flow_diagrams.dgrm_name%type 
  )
  as
    l_flows apex_t_varchar2;
    l_dgrm_id flow_diagrams.dgrm_id%type;
    r_diagrams flow_diagrams%rowtype;
  begin
    -- Initialize
    l_flows := apex_string.split(pi_dgrm_id_list, ':');
    
    for i in 1 .. l_flows.count loop
      select * 
        into r_diagrams
        from flow_diagrams
       where dgrm_id = l_flows(i);

      l_dgrm_id := flow_diagram.import_diagram(
        pi_dgrm_name => case when l_flows.count() > 1 then r_diagrams.dgrm_name || ' - ' end || pi_new_name,
        pi_dgrm_version => '0',
        pi_dgrm_category => r_diagrams.dgrm_category,
        pi_dgrm_content => r_diagrams.dgrm_content);

    end loop;
  end copy_model;


  /* page 4 */


  function get_region_title(
    pi_dgrm_id in flow_diagrams.dgrm_id%type
  )
  return varchar2 
  as
    l_region_title varchar2(128 byte);
  begin
  
    select dgrm_name || ' (Version: ' || dgrm_version || ', Status: ' || dgrm_status || ')' as d
      into l_region_title
      from flow_diagrams
     where dgrm_id = pi_dgrm_id;

    return l_region_title;
  end get_region_title;


  /* page 5 */


  function get_file_name
  (
    p_dgrm_id                  in number
  , p_include_version          in varchar2
  , p_include_status           in varchar2
  , p_include_category         in varchar2
  , p_include_last_change_date in varchar2
  , p_download_as              in varchar2
  ) 
  return varchar2
  is
    l_file_name        varchar2(300 char);
    l_dgrm_name        flow_diagrams.dgrm_name%type;
    l_dgrm_version     flow_diagrams.dgrm_version%type;
    l_dgrm_status      flow_diagrams.dgrm_status%type;
    l_dgrm_category    flow_diagrams.dgrm_category%type;
    l_dgrm_last_update flow_diagrams.dgrm_last_update%type;
  begin
    select dgrm_name
         , dgrm_version
         , dgrm_status
         , dgrm_category
         , dgrm_last_update
      into l_dgrm_name
         , l_dgrm_version
         , l_dgrm_status
         , l_dgrm_category
         , l_dgrm_last_update
      from flow_diagrams
     where dgrm_id = p_dgrm_id
    ;
    
    l_file_name := to_char(sysdate, 'YYYYMMDD-HH24MI') || '_' || l_dgrm_name;
    
    if (p_include_category = 'Y' and l_dgrm_category is not null) then
      l_file_name := l_file_name || '_' || l_dgrm_category;
    end if;
    if (p_include_status = 'Y') then
      l_file_name := l_file_name || '_' || l_dgrm_status;
    end if;
    if (p_include_version = 'Y') then
      l_file_name := l_file_name || '_' || l_dgrm_version;
    end if;
    if (p_include_last_change_date = 'Y') then
      l_file_name := l_file_name || '_' || to_char(l_dgrm_last_update, 'YYYYMMDD-HH24MI');
    end if;
    if (p_download_as = 'SQL') then
      l_file_name := l_file_name || '.sql';
    end if;
    if (p_download_as = 'BPMN') then
      l_file_name := l_file_name || '.bpmn';
    end if;
    return l_file_name;
  end get_file_name;


  function get_sql_script(
      p_dgrm_id in number
  ) 
  return clob
  is
    l_split_content apex_t_varchar2;
    l_sql clob;
    l_buffer varchar2(32767);  
    r_diagrams flow_diagrams%rowtype;
  begin 
    dbms_lob.createtemporary(l_sql,true, DBMS_LOB.CALL);
    select *
    into r_diagrams
    from flow_diagrams
    where dgrm_id = p_dgrm_id;
    l_buffer := 'declare'||utl_tcp.crlf;
    l_buffer := l_buffer||'  l_dgrm_content clob;'||utl_tcp.crlf;
    l_buffer := l_buffer||'begin'||utl_tcp.crlf;
    dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);
    l_split_content := apex_string.split(p_str => replace(r_diagrams.dgrm_content,  apex_application.CRLF,  apex_application.LF));
    l_buffer := '  l_dgrm_content := apex_string.join_clob('||utl_tcp.crlf;
    l_buffer := l_buffer||'    apex_t_varchar2('||utl_tcp.crlf;
    dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);
    for i in l_split_content.first..l_split_content.last
    loop
      if (i = l_split_content.first) then
        l_buffer := '      q''['||l_split_content(i)||']'''||utl_tcp.crlf;
      else
        l_buffer := '      ,q''['||l_split_content(i)||']'''||utl_tcp.crlf;
      end if;
      dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);
    end loop;
    l_buffer := '  ));';
    l_buffer := l_buffer||utl_tcp.crlf;
    l_buffer := l_buffer||'  flow_bpmn_parser_pkg.upload_and_parse('||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_name => '||dbms_assert.enquote_literal(r_diagrams.dgrm_name)||','||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_version => '||dbms_assert.enquote_literal(r_diagrams.dgrm_version)||','||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_category => '||dbms_assert.enquote_literal(r_diagrams.dgrm_category)||','||utl_tcp.crlf;
    l_buffer := l_buffer||'    pi_dgrm_content => l_dgrm_content'||utl_tcp.crlf||');'||utl_tcp.crlf;
    l_buffer := l_buffer||'end;'||utl_tcp.crlf||'/'||utl_tcp.crlf;
    dbms_lob.writeappend(l_sql, length(l_buffer), l_buffer);
    
    return l_sql;
  end get_sql_script;

  
  function get_bmpn_content(
      p_dgrm_id in number
  ) return clob
  is 
    l_dgrm_content flow_diagrams.dgrm_content%type;
  begin
    select dgrm_content
    into l_dgrm_content
    from flow_diagrams
    where dgrm_id = p_dgrm_id;
    return l_dgrm_content;
  end get_bmpn_content;


  function sanitize_file_name(
    p_file_name in varchar2
  )
  return varchar2
  is
    l_file_name varchar2(300 char);
  begin
    l_file_name := p_file_name;
    l_file_name := replace(l_file_name, '/', '_');
    l_file_name := replace(l_file_name, '\', '_');
    l_file_name := replace(l_file_name, '*', '_');
    l_file_name := replace(l_file_name, ':', '_');
    l_file_name := replace(l_file_name, '?', '_');
    l_file_name := replace(l_file_name, '|', '_');
    l_file_name := replace(l_file_name, '<', '_');
    l_file_name := replace(l_file_name, '>', '_');
    return l_file_name;
  end sanitize_file_name;


  function clob_to_blob(
    p_clob in clob
  )
  return blob
  is
    l_blob         BLOB;
    l_dest_offset  PLS_INTEGER := 1;
    l_src_offset   PLS_INTEGER := 1;
    l_lang_context PLS_INTEGER := DBMS_LOB.default_lang_ctx;
    l_warning      PLS_INTEGER := DBMS_LOB.warn_inconvertible_char;
  begin
    dbms_lob.createtemporary(
      lob_loc => l_blob,
      cache   => TRUE
    );
    dbms_lob.converttoblob(
      dest_lob      => l_blob,
      src_clob      => p_clob,
      amount        => DBMS_LOB.lobmaxsize,
      dest_offset   => l_dest_offset,
      src_offset    => l_src_offset, 
      blob_csid     => DBMS_LOB.default_csid,
      lang_context  => l_lang_context,
      warning       => l_warning
    );
  
    return l_blob;
  end clob_to_blob;


  procedure download_file(
      p_dgrm_id     in number,
      p_file_name   in varchar2,
      p_download_as in varchar2,
      p_multi_file  in boolean default false
  )
  is 
    l_clob        clob;
    l_blob        blob;
    l_zip_file    blob;
    l_buffer      varchar2(32767);  
    l_length      integer;
    l_desc_offset pls_integer := 1;
    l_src_offset  pls_integer := 1;
    l_lang        pls_integer := 0;
    l_warning     pls_integer := 0;
    l_mime_type   varchar2(100) := 'application/octet';
    type r_flow   is record (
      dgrm_id       flow_diagrams.dgrm_id%type, 
      dgrm_name     flow_diagrams.dgrm_name%type,
      dgrm_version  flow_diagrams.dgrm_version%type,
      dgrm_status   flow_diagrams.dgrm_status%type,
      dgrm_category flow_diagrams.dgrm_category%type,
      filename      varchar2(300)
    );
    type t_flows  is table of r_flow index by binary_integer;
    l_flows       t_flows;
    l_flow        r_flow;
    l_json_array  json_array_t;
    l_json_object json_object_t;
    l_json_clob   clob;
    l_sql_clob    clob;
    l_file_name   varchar2(300);
  begin
    l_file_name := p_file_name;
    if ( p_download_as = 'BPMN' ) then
      l_json_array := json_array_t('[]');
    end if;
    if ( p_multi_file ) then
      select 
        dgrm_id, 
        dgrm_name,
        dgrm_version,
        dgrm_status,
        dgrm_category,
        dgrm_name||'_'||dgrm_version as filename
      bulk collect into l_flows
      from flow_diagrams 
      where dgrm_id in (
        select n001
        from apex_collections
        where collection_name = 'C_SELECT'
      );
    else
      l_flow.dgrm_id := p_dgrm_id;
      l_flows(1)     := l_flow;
    end if;
    for i in 1..l_flows.count()
    loop
      if (p_download_as = 'BPMN') then
          l_clob := get_bmpn_content(p_dgrm_id => l_flows(i).dgrm_id);
          apex_debug.message(dbms_lob.getlength(l_clob));
      end if;
      if (p_download_as = 'SQL') then
        l_clob := get_sql_script(p_dgrm_id => l_flows(i).dgrm_id);
      end if;
      l_blob := clob_to_blob(l_clob);
      if ( p_multi_file ) then
        apex_zip.add_file (
          p_zipped_blob => l_zip_file,
          p_file_name   => sanitize_file_name(l_flows(i).filename) || '.' || lower(p_download_as),
          p_content     => l_blob
        );
        if ( p_download_as = 'BPMN' ) then
          l_json_object := json_object_t('{}');
          l_json_object.put('dgrm_name' ,  l_flows(i).dgrm_name);
          l_json_object.put('dgrm_version' ,  l_flows(i).dgrm_version);
          l_json_object.put('dgrm_status' ,  l_flows(i).dgrm_status);
          l_json_object.put('dgrm_category' ,  l_flows(i).dgrm_category);
          l_json_object.put('file' ,  sanitize_file_name(l_flows(i).filename) || '.bpmn');
          l_json_array.append(l_json_object);
        elsif ( p_download_as = 'SQL' ) then
          l_sql_clob := l_sql_clob||'@"'||sanitize_file_name(l_flows(i).filename) || '.' || lower(p_download_as)||'";'||utl_tcp.crlf;
        end if;
      end if;
    end loop;
    if ( p_multi_file ) then
      if ( p_download_as = 'BPMN' ) then
        l_json_clob := treat(l_json_array as json_element_t).to_clob(); 
        l_blob := clob_to_blob(l_json_clob);
        apex_zip.add_file (
          p_zipped_blob => l_zip_file,
          p_file_name   => 'import.json',
          p_content     => l_blob
        );
      elsif ( p_download_as = 'SQL' ) then
        l_sql_clob := 'set define off;' || utl_tcp.crlf || l_sql_clob || utl_tcp.crlf;
        l_blob := clob_to_blob(l_sql_clob);
        apex_zip.add_file (
          p_zipped_blob => l_zip_file,
          p_file_name   => 'import.sql',
          p_content     => l_blob
        );
      end if;
      apex_zip.finish (
        p_zipped_blob => l_zip_file 
      );
      l_blob := l_zip_file;
      l_mime_type := 'application/zip';
      l_file_name := 'F4A_'||to_char(systimestamp, 'YYYYMMDD_HH24MISS')||'.zip';
    end if;
    l_length := dbms_lob.getlength(l_blob);
    owa_util.mime_header(l_mime_type, false) ;
    htp.p('Content-length: ' || l_length);
    htp.p('Content-Disposition: attachment; filename="'||sanitize_file_name(l_file_name)||'"');
    owa_util.http_header_close;
    wpg_docload.download_file(l_blob);
    apex_application.stop_apex_engine;
  end download_file;


  /* page 6 */


  function is_file_uploaded(
        pi_file_name in varchar2
    )
    return boolean
    is
        l_dgrm_content flow_diagrams.dgrm_content%type;
        l_err boolean := true;
    begin
        begin
            select to_clob(blob_content)
            into l_dgrm_content
            from apex_application_temp_files
            where name = pi_file_name;
        exception when no_data_found then
            l_err := false;
        end;
 
        return l_err;
    end is_file_uploaded;
    
    
    function is_valid_xml(
        pi_import_from  in varchar2,
        pi_dgrm_content in flow_diagrams.dgrm_content%type,
        pi_file_name    in varchar2
    )
    return boolean
    is
        l_dgrm_content flow_diagrams.dgrm_content%type;
        l_xmltype xmltype;
        l_err boolean := true;
    begin
        if (pi_import_from = 'text') then
            l_dgrm_content := pi_dgrm_content;
        else
            select to_clob(blob_content)
            into l_dgrm_content
            from apex_application_temp_files
            where name = pi_file_name;
        end if;
        begin
            l_xmltype := xmltype.createXML(l_dgrm_content);
        exception when others then
            l_err := false;
        end;
        return l_err;
    end is_valid_xml;
    
    
    function is_valid_multi_file_archive(
        pi_file_name in varchar2
    )
    return varchar2
    is
        l_mime_type    apex_application_temp_files.mime_type%type;
        l_blob_content apex_application_temp_files.blob_content%type;
        l_error        varchar2(4000);
        l_files        apex_zip.t_files;
        l_found_json   boolean := false;
    begin
        select mime_type, blob_content
        into l_mime_type, l_blob_content
        from apex_application_temp_files
        where name = pi_file_name;
        if ( l_mime_type != 'application/zip') then
            l_error := 'You should provide a valid Flows for APEX zip export file.';
        else
            l_files := apex_zip.get_files(
                p_zipped_blob => l_blob_content
            );
            for i in 1..l_files.count loop
                apex_debug.message(l_files(i));
                if ( l_files(i) = 'import.json' ) then
                    l_found_json := true;
                end if;
                exit when l_found_json;
            end loop;
            if ( l_found_json = false ) then
                l_error := 'Missing import.json file in the zip export file.';
            end if;
        end if;
        return l_error;
    end is_valid_multi_file_archive;
    
    
    function upload_and_parse(
        pi_import_from     in varchar2,
        pi_dgrm_name       in flow_diagrams.dgrm_name%type,
        pi_dgrm_category   in flow_diagrams.dgrm_category%type,
        pi_dgrm_version    in flow_diagrams.dgrm_version%type,
        pi_dgrm_content    in flow_diagrams.dgrm_content%type,
        pi_file_name       in varchar2,
        pi_force_overwrite in varchar2
    ) return flow_diagrams.dgrm_id%type
    is
        l_dgrm_id flow_diagrams.dgrm_id%type;
        l_dgrm_content flow_diagrams.dgrm_content%type;
        l_dgrm_exists number;
    begin
        if (pi_import_from = 'text') then
            l_dgrm_content := pi_dgrm_content;
        else
            select to_clob(blob_content)
            into l_dgrm_content
            from apex_application_temp_files
            where name = pi_file_name;
        end if;
            
        l_dgrm_id := flow_diagram.import_diagram(
            pi_dgrm_name => pi_dgrm_name,
            pi_dgrm_version => pi_dgrm_version,
            pi_dgrm_category => pi_dgrm_category,
            pi_dgrm_content => l_dgrm_content,
            pi_force_overwrite => pi_force_overwrite);
        return l_dgrm_id;
    exception
      when flow_diagram.diagram_exists then
        apex_error.add_error(
            p_message => 'Model already exists.'
            , p_display_location => apex_error.c_on_error_page);
      when flow_diagram.diagram_not_draft then
        apex_error.add_error(
            p_message => 'Overwrite only possible for draft models.'
            , p_display_location => apex_error.c_on_error_page);
    end upload_and_parse;
    
    
    procedure multiple_flow_import(
        pi_file_name       in varchar2,
        pi_force_overwrite in varchar2
    )
    as
        l_dgrm_id       flow_diagrams.dgrm_id%type;
        l_dgrm_name     flow_diagrams.dgrm_name%type;
        l_dgrm_category flow_diagrams.dgrm_category%type;
        l_dgrm_version  flow_diagrams.dgrm_version%type;
        l_dgrm_content  flow_diagrams.dgrm_content%type;
        l_file          varchar2(300);
        l_json_array    json_array_t;
        l_json_object   json_object_t;
        l_blob_content  blob;
        l_json_file     blob;
        l_bpmn_file     blob;
        l_clob          clob;
    begin
        select blob_content
        into l_blob_content
        from apex_application_temp_files
        where name = pi_file_name;
        l_json_file := apex_zip.get_file_content(
            p_zipped_blob => l_blob_content,
            p_file_name   => 'import.json'
        );
        l_json_array := json_array_t.parse(l_json_file);
        for i in 0..l_json_array.get_size() - 1 loop
            l_json_object := treat(l_json_array.get(i) as json_object_t);
            l_dgrm_name     := l_json_object.get_String('dgrm_name');
            l_dgrm_version  := l_json_object.get_String('dgrm_version');
            l_dgrm_category := l_json_object.get_String('dgrm_category');
            l_dgrm_name     := l_json_object.get_String('dgrm_name');
            l_file          := l_json_object.get_String('file');   
            l_bpmn_file := apex_zip.get_file_content(
                p_zipped_blob => l_blob_content,
                p_file_name   => l_file
            );
            select to_clob(l_bpmn_file)
            into l_clob
            from dual;
            
            l_dgrm_id := upload_and_parse(
                  pi_import_from => 'text'
                , pi_dgrm_name => l_dgrm_name
                , pi_dgrm_category => l_dgrm_category
                , pi_dgrm_version => l_dgrm_version
                , pi_dgrm_content => l_clob
                , pi_file_name => null
                , pi_force_overwrite => pi_force_overwrite
            );
        end loop;
    end multiple_flow_import;


  /* page 7 */
  

  function validate_new_version(
    pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type
  ) return varchar2
  as
    l_err varchar2(4000);
  begin
    
    if (pi_dgrm_version is null) then
        l_err := apex_lang.message(p_name => 'APEX.PAGE_ITEM_IS_REQUIRED'); --'#LABEL# must have a value';
    elsif check_flow_exists(pi_dgrm_name, pi_dgrm_version) then
        l_err := apex_lang.message(p_name => 'APP_ERR_MODEL_VERSION_EXIST');
    end if;
    return l_err;
  end validate_new_version;
  

  procedure process_page_p7(
    pio_dgrm_id      in out nocopy flow_diagrams.dgrm_id%type,
    pi_dgrm_name     in flow_diagrams.dgrm_name%type,
    pi_dgrm_version  in flow_diagrams.dgrm_version%type,
    pi_dgrm_category in flow_diagrams.dgrm_category%type,
    pi_new_version   in flow_diagrams.dgrm_version%type,
    pi_cascade       in varchar2,
    pi_request       in varchar2)
  as
  begin
    case pi_request
      when 'CREATE' then
        pio_dgrm_id := flow_diagram.create_diagram(
                         pi_dgrm_name => pi_dgrm_name,
                         pi_dgrm_category => pi_dgrm_category,
                         pi_dgrm_version => pi_dgrm_version);
      when 'SAVE' then
        flow_diagram.edit_diagram(
          pi_dgrm_id => pio_dgrm_id,
          pi_dgrm_name => pi_dgrm_name,
          pi_dgrm_category => pi_dgrm_category,
          pi_dgrm_version => pi_dgrm_version);
      when 'DELETE' then
        flow_diagram.delete_diagram(
          pi_dgrm_id => pio_dgrm_id,
          pi_cascade => pi_cascade);
      when 'ADD_VERSION' then
        pio_dgrm_id := flow_diagram.add_diagram_version(
          pi_dgrm_id => pio_dgrm_id,
          pi_dgrm_version => pi_new_version);
      when 'RELEASE' then
        flow_diagram.release_diagram(
          pi_dgrm_id => pio_dgrm_id);
      when 'DEPRECATE' then
        flow_diagram.deprecate_diagram(
          pi_dgrm_id => pio_dgrm_id);
      when 'ARCHIVE' then
        flow_diagram.archive_diagram(
          pi_dgrm_id => pio_dgrm_id);
      else
        raise_application_error(-20002, 'Unknown operation requested.');
    end case;
  end process_page_p7;
  
  
  function get_page_title(
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_dgrm_name    in flow_diagrams.dgrm_name%type
  , pi_dgrm_version in flow_diagrams.dgrm_version%type
  ) return varchar2
  as
    l_page_title varchar2(128 byte);
  begin
    case 
    when pi_dgrm_id is null then 
      l_page_title := apex_lang.message(
                        p_name => 'APP_TITLE_NEW_MODEL'
                      );
    else 
      l_page_title := apex_lang.message(
                        p_name => 'APP_TITLE_MODEL',
                        p0 => pi_dgrm_name,
                        p1 => pi_dgrm_version
                      );
    end case;
    return l_page_title;
  end get_page_title;


  /* page 8 */


  function check_is_date(
    pi_value       in varchar2,
    pi_format_mask in varchar2)
  return varchar2 
  as
    l_dummy_date date;
  begin 
    l_dummy_date := to_date(pi_value, pi_format_mask);
    return flow_constants_pkg.gc_true;
  exception
    when others then  
      return flow_constants_pkg.gc_false;
  end check_is_date;


  function check_is_number(
    pi_value in varchar2)
  return varchar2 
  as
    l_dummy_number number;
  begin 
    l_dummy_number := to_number(pi_value);
    return flow_constants_pkg.gc_true;
  exception
    when others then  
      return flow_constants_pkg.gc_false;
  end check_is_number;
  
  
  procedure pass_variable
  as
    l_prov_prcs_id  flow_process_variables.prov_prcs_id%type;
    l_prov_var_name flow_process_variables.prov_var_name%type;
    l_prov_var_type flow_process_variables.prov_var_type%type;
    l_prov_var_vc2  flow_process_variables.prov_var_vc2%type;
    l_prov_var_num  flow_process_variables.prov_var_num%type;
    l_prov_var_date flow_process_variables.prov_var_date%type;
    l_prov_var_clob flow_process_variables.prov_var_clob%type;
  begin
    -- Initialize
    l_prov_prcs_id := apex_application.g_x01;
    l_prov_var_name := apex_application.g_x02;
    l_prov_var_type := apex_application.g_x03;
    
    case l_prov_var_type
      when 'VARCHAR2' then
        l_prov_var_vc2 := flow_process_vars.get_var_vc2(
                            pi_prcs_id => l_prov_prcs_id,
                            pi_var_name =>l_prov_var_name);
      when 'NUMBER' then
        l_prov_var_num := flow_process_vars.get_var_num(
                            pi_prcs_id => l_prov_prcs_id,
                            pi_var_name =>l_prov_var_name);
      when 'DATE' then
        l_prov_var_date := flow_process_vars.get_var_date(
                             pi_prcs_id => l_prov_prcs_id,
                             pi_var_name =>l_prov_var_name);
      when 'CLOB' then
          l_prov_var_clob := flow_process_vars.get_var_clob(
                               pi_prcs_id => l_prov_prcs_id,
                               pi_var_name =>l_prov_var_name);
    end case;
    
    apex_json.open_object;
    apex_json.write( p_name => 'success', p_value => not apex_error.have_errors_occurred );
    apex_json.write( p_name => 'vc2_value', p_value => l_prov_var_vc2);
    apex_json.write( p_name => 'num_value', p_value => to_char(l_prov_var_num));
    apex_json.write( p_name => 'date_value', p_value => to_char(l_prov_var_date, v('APP_DATE_TIME_FORMAT')));
    apex_json.write( p_name => 'clob_value', p_value => l_prov_var_clob);
    apex_json.close_all;
    
  end pass_variable;
    
  
  function get_connection_select_option(
    pi_gateway in flow_objects.objt_bpmn_id%type
  , pi_prcs_id in flow_processes.prcs_id%type
  ) return varchar2
  as
    l_select_option flow_instance_gateways_lov.select_option%type;
  begin
    select select_option
      into l_select_option
      from flow_instance_gateways_lov
     where objt_bpmn_id = pi_gateway
       and prcs_id = pi_prcs_id;
    return l_select_option;
  end get_connection_select_option;


  /* page 9 */
  

  procedure set_settings(
    pi_logging_language          in flow_configuration.cfig_value%type
  , pi_logging_level             in flow_configuration.cfig_value%type
  , pi_logging_hide_userid       in flow_configuration.cfig_value%type
  , pi_engine_app_mode           in flow_configuration.cfig_value%type
  , pi_duplicate_step_prevention in flow_configuration.cfig_value%type
  )
  as
  begin
      flow_engine_util.set_config_value( p_config_key => 'logging_language', p_value => pi_logging_language);
      flow_engine_util.set_config_value( p_config_key => 'logging_level', p_value => pi_logging_level);
      flow_engine_util.set_config_value( p_config_key => 'logging_hide_userid', p_value => pi_logging_hide_userid);
      flow_engine_util.set_config_value( p_config_key => 'engine_app_mode', p_value => pi_engine_app_mode);
      flow_engine_util.set_config_value( p_config_key => 'duplicate_step_prevention', p_value => pi_duplicate_step_prevention);
  end set_settings;


  /* page 11 */


  function create_instance(
    pi_dgrm_id      in flow_diagrams.dgrm_id%type
  , pi_prcs_name    in flow_processes.prcs_name%type
  , pi_business_ref in flow_process_variables.prov_var_vc2%type
  ) return flow_processes.prcs_id%type
  as
    l_prcs_id flow_processes.prcs_id%type;
  begin
    l_prcs_id := flow_api_pkg.flow_create( 
                   pi_dgrm_id   => pi_dgrm_id,
                   pi_prcs_name => pi_prcs_name);
    
    if pi_business_ref is not null then
      flow_process_vars.set_var( 
        pi_prcs_id   => l_prcs_id,
        pi_var_name  => 'BUSINESS_REF',
        pi_vc2_value => pi_business_ref,
        pi_scope => 0);
    end if;
    return l_prcs_id; 
  end create_instance;


  /* page 12 */
  
  
  function get_prcs_name(
    pi_prcs_id in flow_processes.prcs_id%type
  ) return flow_processes.prcs_name%type
  as
    l_prcs_name flow_processes.prcs_name%type;
  begin
    select prcs_name 
      into l_prcs_name
      from flow_instances_vw 
     where prcs_id = pi_prcs_id;
    return l_prcs_name;
  end get_prcs_name;
  

  /* page 13 */


  function has_error(
    pi_prcs_id in flow_processes.prcs_id%type,
    pi_objt_id in flow_subflows.sbfl_current%type)
  return boolean 
  as
    l_has_error binary_integer;
  begin
    select count(*)
      into l_has_error
      from flow_subflows_vw
     where sbfl_prcs_id = pi_prcs_id 
       and sbfl_current = pi_objt_id
       and sbfl_status = 'error'
       and exists (
           select null
             from FLOW_P0013_INSTANCE_LOG_VW
            where lgpr_prcs_id = pi_prcs_id 
              and lgpr_objt_id = pi_objt_id);
              
    return l_has_error = 1;
  end has_error;


end flow_engine_app_api;
/
