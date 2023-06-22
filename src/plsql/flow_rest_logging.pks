create or replace package flow_rest_logging
  authid definer
as

  c_log_info_enter     constant varchar2(10) := 'ENTER';
  c_log_info_finished  constant varchar2(10) := 'FINISHED';
  c_log_info_error     constant varchar2(10) := 'ERROR';

  c_log_rest_incoming              constant varchar2(50) := 'logging_rest_incoming_calls';
  c_log_rest_incoming_retain_days  constant varchar2(50) := 'logging_rest_incoming_calls_retain_days';

  c_log_rest_incoming_default              constant varchar2(50) := 'Y';
  c_log_rest_incoming_retain_days_default  constant varchar2(50) := '60';

  procedure initialize;
  procedure cleanup;

  procedure enter( pi_payload            json_element_t
                 );

  procedure finished( pi_payload            json_element_t
                    );

  procedure error( pi_payload            json_element_t
                 , pi_error_code         flow_rest_event_log.lgrt_error_code%type
                 , pi_error_msg          flow_rest_event_log.lgrt_error_msg%type
                 , pi_error_stacktrace   flow_rest_event_log.lgrt_error_stacktrace%type
                 );

  procedure set_logging_config( pi_log_rest_incoming         varchar2
                              , pi_log_rest_incoming_retain  varchar2 );

end flow_rest_logging;
/
