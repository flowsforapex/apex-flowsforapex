create or replace package flow_rest_errors
  authid definer
as

  procedure handle_error( pi_sqlcode            number 
                        , pi_message            varchar2 
                        , pi_stacktrace         varchar2 
                        , pi_payload            json_element_t default null
                        , pi_payload_attr_name  varchar2 default null
                        , po_status_code        out number );

end flow_rest_errors;
/
