create or replace package flow_rest_logging
  authid definer
as

  c_log_info_enter     constant varchar2(10) := 'ENTER';
  c_log_info_finished  constant varchar2(10) := 'FINISHED';
  c_log_info_error     constant varchar2(10) := 'ERROR';

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

end flow_rest_logging;
/
