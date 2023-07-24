create or replace package body flow_rest_logging
as

  req_call_guid  raw(16);
  req_method     varchar2(10);
  req_endpoint   varchar2(2000);
  req_client_id  varchar2(200);
  req_token      varchar2(200);

  req_log_rest_incoming varchar2(1);

  -------------------------------------------------------------------------------------------------------------------

  procedure initialize
  as
  begin
    req_call_guid  := sys_guid();
    req_method     := owa_util.get_cgi_env('REQUEST_METHOD');
    req_endpoint   := owa_util.get_cgi_env('X-APEX-PATH');
    req_client_id  := owa_util.get_cgi_env('REMOTE_USER');
    req_token      := replace(owa_util.get_cgi_env('Authorization'),'Bearer ');
    
    req_log_rest_incoming := flow_engine_util.get_config_value( p_config_key     => flow_rest_logging.c_log_rest_incoming
                                                              , p_default_value  => flow_rest_logging.c_log_rest_incoming_default );

  end initialize;
  
  procedure cleanup
  as
  begin
    req_call_guid  := null;
    req_method     := null;
    req_endpoint   := null;
    req_client_id  := null;
    req_token      := null;
    req_log_rest_incoming := null;
  end cleanup;

  -------------------------------------------------------------------------------------------------------------------

  function is_event_log_enabled
    return boolean
  as
  begin

    if nvl(req_log_rest_incoming, 'Y') = 'Y' then
      return true;
    end if;

    return false;
    
  end is_event_log_enabled;

  -------------------------------------------------------------------------------------------------------------------

  procedure enter( pi_payload          json_element_t 
                 )
  as
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_payload_clob  clob;
  begin
    
    if is_event_log_enabled 
    then

      l_payload_clob := pi_payload.to_clob;

      INSERT INTO flows4apex.flow_rest_event_log (
          lgrt_call_guid
        , lgrt_client_id
        , lgrt_log_info
        , lgrt_token
        , lgrt_timestamp
        , lgrt_http_method
        , lgrt_endpoint
        , lgrt_payload
      ) VALUES (
          req_call_guid
        , req_client_id
        , flow_rest_logging.c_log_info_enter
        , req_token
        , systimestamp
        , req_method
        , req_endpoint
        , l_payload_clob
      );

      commit;

    end if;

    exception 
      when others then 
        rollback;
        raise;
  end enter;
    
  -------------------------------------------------------------------------------------------------------------------

  procedure finished( pi_payload          json_element_t 
                    )
  as
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_payload_clob  clob;
  begin

    if is_event_log_enabled 
    then
      l_payload_clob := pi_payload.to_clob;

      INSERT INTO flows4apex.flow_rest_event_log (
          lgrt_call_guid
        , lgrt_client_id
        , lgrt_log_info
        , lgrt_token
        , lgrt_timestamp
        , lgrt_http_method
        , lgrt_endpoint
        , lgrt_payload
      ) VALUES (
          req_call_guid
        , req_client_id
        , flow_rest_logging.c_log_info_finished
        , req_token
        , systimestamp
        , req_method
        , req_endpoint
        , l_payload_clob
      );

      commit;

    end if;

    exception 
      when others then 
        rollback;
        raise;
  end finished;

  -------------------------------------------------------------------------------------------------------------------

  procedure error( pi_payload            json_element_t
                 , pi_error_code         flow_rest_event_log.lgrt_error_code%type
                 , pi_error_msg          flow_rest_event_log.lgrt_error_msg%type
                 , pi_error_stacktrace   flow_rest_event_log.lgrt_error_stacktrace%type
                 )
  as
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_payload_clob  clob;
  begin

    if is_event_log_enabled 
    then
    
      if pi_payload is not null then 
        l_payload_clob := pi_payload.to_clob;
      end if;

      INSERT INTO flows4apex.flow_rest_event_log (
          lgrt_call_guid
        , lgrt_client_id
        , lgrt_log_info
        , lgrt_token
        , lgrt_timestamp
        , lgrt_http_method
        , lgrt_endpoint
        , lgrt_payload
        , lgrt_error_code
        , lgrt_error_msg
        , lgrt_error_stacktrace
      ) VALUES (
          req_call_guid
        , req_client_id
        , flow_rest_logging.c_log_info_error
        , req_token
        , systimestamp
        , req_method
        , req_endpoint
        , l_payload_clob
        , pi_error_code
        , pi_error_msg
        , pi_error_stacktrace
      );

      commit;
    
    end if;

    exception 
      when others then 
        rollback;
        raise;

  end error;

  -------------------------------------------------------------------------------------------------------------------

  procedure set_logging_config( pi_log_rest_incoming         varchar2
                              , pi_log_rest_incoming_retain  varchar2 )
  as
  begin

    flow_engine_util.set_config_value( p_config_key => flow_rest_logging.c_log_rest_incoming
                                     , p_value      => pi_log_rest_incoming );

    flow_engine_util.set_config_value( p_config_key => flow_rest_logging.c_log_rest_incoming_retain_days
                                     , p_value      => pi_log_rest_incoming_retain );

  end set_logging_config;

end flow_rest_logging;
/
