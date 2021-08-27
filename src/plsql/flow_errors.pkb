create or replace package body flow_errors
as

  g_logging_language        flow_configuration.cfig_value%type; 

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
  begin 
    -- get the message in the correct language, or default language
    begin
      select fmsg.fmsg_message_content
        into l_message_content
        from flow_messages fmsg
       where fmsg.fmsg_message_key = pi_message_key
         and fmsg.fmsg_lang = g_logging_language
      ;
    exception
      when others then
        begin
          select fmsg.fmsg_message_content
            into l_message_content
            from flow_messages fmsg
           where fmsg.fmsg_message_key = pi_message_key
             and fmsg.fmsg_lang = flow_constants_pkg.gc_config_default_logging_language
          ;
        exception
          when others then
            l_message_content := 'Missing Message Key '||pi_message_key;
        end;
    end;

    flow_logging.log_instance_event
    ( p_process_id        => pi_prcs_id
    , p_event             => flow_constants_pkg.gc_prcs_event_error
    , p_comment           => apex_string.format
                                  (p_message => l_message_content
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
                                  )
    , p_error_info        => dbms_utility.format_error_stack
    );
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
  end handle_instance_error;

  -- initialize logging parameters

  begin 
    g_logging_language := flow_engine_util.get_config_value
                       ( p_config_key => flow_constants_pkg.gc_config_logging_language
                       , p_default_value => flow_constants_pkg.gc_config_default_logging_language
                       );

end flow_errors;
/