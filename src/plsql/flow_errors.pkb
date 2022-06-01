create or replace package body flow_errors
as 

  g_logging_language        flow_configuration.cfig_value%type; 

  procedure autonomous_write_to_instance_log
  ( pi_prcs_id        in flow_processes.prcs_id%type
  , pi_objt_bpmn_id   in flow_subflows.sbfl_current%type default null
  , pi_message        in flow_instance_event_log.lgpr_comment%type
  , pi_error_info     in flow_instance_event_log.lgpr_error_info%type
  )
  is
    pragma autonomous_transaction;
  begin
    -- add to instance_event_log
    flow_logging.log_instance_event
    ( p_process_id        => pi_prcs_id
    , p_objt_bpmn_id      => pi_objt_bpmn_id
    , p_event             => flow_constants_pkg.gc_prcs_event_error
    , p_comment           => pi_message
    , p_error_info        => pi_error_info
    );
    --  commit the autonomous transaction
    commit;
  end autonomous_write_to_instance_log;

  procedure set_error_status
  ( pi_prcs_id        in flow_processes.prcs_id%type
  , pi_sbfl_id        in flow_subflows.sbfl_id%type
  )
  is 
  begin  
      apex_debug.enter
      ( 'set_error_status'
      , 'pi_prcs_id', pi_prcs_id
      , 'pi_sbfl_id', pi_sbfl_id
      );
      -- set sbfl & prcs error status
      update flow_subflows sbfl
        set sbfl.sbfl_status = flow_constants_pkg.gc_sbfl_status_error
          , sbfl.sbfl_last_update = systimestamp
      where sbfl.sbfl_id = pi_sbfl_id
      ;
      update flow_processes prcs
        set prcs.prcs_status = flow_constants_pkg.gc_prcs_status_error
          , prcs.prcs_last_update = systimestamp
      where prcs.prcs_id = pi_prcs_id
      ;   
  end set_error_status;

  function make_error_message
  ( pi_message_key    in flow_messages.fmsg_message_key%type 
  , pi_lang           in flow_messages.fmsg_lang%type
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  ) return flow_messages.fmsg_message_content%type
  is
    l_message_content  flow_messages.fmsg_message_content%type;
    l_message          flow_instance_event_log.lgpr_comment%type;
  begin 
    -- get the message template in the correct language, or fall through to default language
    begin
      select fmsg.fmsg_message_content
        into l_message_content
        from flow_messages fmsg
       where fmsg.fmsg_message_key = pi_message_key
         and fmsg.fmsg_lang = pi_lang
      ;
    exception
      when no_data_found then
        begin
          select fmsg.fmsg_message_content
            into l_message_content
            from flow_messages fmsg
           where fmsg.fmsg_message_key = pi_message_key
             and fmsg.fmsg_lang = flow_constants_pkg.gc_config_default_logging_language
          ;
        exception
          when no_data_found then
            l_message_content := 'Missing Message Key '||pi_message_key||' language '
                                 ||flow_constants_pkg.gc_config_default_logging_language;
          when others then
            l_message_content := 'Problem getting error message - check flow_messages loaded';
        end;
      when others then
        l_message_content := 'Problem getting error message - check flow_messages loaded';
    end;
    -- now make the error message in local language for log & apex_error
    l_message :=  apex_string.format
                  ( p_message => l_message_content
                  , p0 => p0
                  , p1 => p1
                  , p2 => p2
                  , p3 => p3
                  , p4 => p4
                  , p5 => p5
                  , p6 => p6
                  , p7 => p7
                  , p8 => p8
                  , p9 => p9
                  );
    return l_message;
  end make_error_message;

  procedure handle_instance_error
  ( pi_prcs_id        in flow_processes.prcs_id%type
  , pi_sbfl_id        in flow_subflows.sbfl_id%type default null
  , pi_message_key    in varchar2
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  )
  is
    l_message_content  flow_messages.fmsg_message_content%type;
    l_message          flow_instance_event_log.lgpr_comment%type;
    l_error_info       flow_instance_event_log.lgpr_error_info%type;
    l_current          flow_subflows.sbfl_current%type;
  begin 
    apex_debug.enter
    ( 'handle_instance_error'
    , 'pi_sbfl_id', pi_sbfl_id
    , 'pi_message_key', pi_message_key
    , 'is_recursive' , case when flow_globals.get_is_recursive_step then 'true' else 'false' end
    );
    -- get the message template in the correct language, or fall through to default language
    -- for log & apex_error
    l_message :=  make_error_message
                  ( pi_message_key   => pi_message_key
                  , pi_lang          => g_logging_language
                  , p0               => p0
                  , p1               => p1
                  , p2               => p2
                  , p3               => p3
                  , p4               => p4
                  , p5               => p5
                  , p6               => p6
                  , p7               => p7
                  , p8               => p8
                  , p9               => p9
                  );
    -- get the error stack and step type
    l_error_info   := dbms_utility.format_error_stack;
    -- get the current step, if known & available
    begin
      if pi_sbfl_id is not null then
        select sbfl.sbfl_current
          into l_current
          from flow_subflows sbfl
        where sbfl.sbfl_id = pi_sbfl_id
        ;
      else
        l_current := null;
      end if;
    exception
      when others then
        l_current := null;
    end; 
    -- add to instance_event_log
    autonomous_write_to_instance_log
    ( pi_prcs_id        => pi_prcs_id
    , pi_objt_bpmn_id   => l_current
    , pi_message        => l_message
    , pi_error_info     => l_error_info
    );
    -- decide where to put error message
    if flow_globals.get_is_recursive_step then
      -- errors written to log, status already set to error in autonomous session
      flow_globals.set_step_error (p_has_error => true);
    else
      -- step belongs to current user's current session - use apex_error
      apex_error.add_error
      ( p_message => l_message
      , p_display_location => apex_error.c_on_error_page
      );
    end if;
  end handle_instance_error;

  procedure handle_general_error
  ( pi_message_key    in varchar2
  , p0                in varchar2 default null
  , p1                in varchar2 default null
  , p2                in varchar2 default null
  , p3                in varchar2 default null
  , p4                in varchar2 default null
  , p5                in varchar2 default null
  , p6                in varchar2 default null
  , p7                in varchar2 default null
  , p8                in varchar2 default null
  , p9                in varchar2 default null
  )
  is
    l_message_content  flow_messages.fmsg_message_content%type;
    l_message          flow_instance_event_log.lgpr_comment%type;
  begin 
    apex_debug.enter
    ( 'handle_instance_error'
    , 'pi_message_key', pi_message_key
    );
    -- get the message template in the correct language, or fall through to default language
    -- for log & apex_error
    l_message :=  make_error_message
                  ( pi_message_key   => pi_message_key
                  , pi_lang          => g_logging_language
                  , p0               => p0
                  , p1               => p1
                  , p2               => p2
                  , p3               => p3
                  , p4               => p4
                  , p5               => p5
                  , p6               => p6
                  , p7               => p7
                  , p8               => p8
                  , p9               => p9
                  );
    apex_error.add_error
      ( p_message => l_message
      , p_display_location => apex_error.c_on_error_page
      );
  end handle_general_error;

  -- initialize logging parameters

  begin 
    g_logging_language := flow_engine_util.get_config_value
                       ( p_config_key => flow_constants_pkg.gc_config_logging_language
                       , p_default_value => flow_constants_pkg.gc_config_default_logging_language
                       );

end flow_errors;
/
