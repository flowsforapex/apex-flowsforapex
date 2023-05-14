create or replace package body flow_rest_response
as

  procedure send_error( pi_sqlerrm            varchar2 
                      , pi_stacktrace         varchar2 default null
                      , pi_payload            json_element_t default null
                      , pi_payload_attr_name  varchar2 default null
                      , po_status_code        out number )
  as
    l_error_jo  json_object_t;
  begin
    l_error_jo := new json_object_t();
    l_error_jo.put( key => 'success', val => false);
    l_error_jo.put( key => 'message', val => pi_sqlerrm);
    if pi_stacktrace is not null then 
      l_error_jo.put( key => 'stacktrace', val => pi_stacktrace);
    end if;
    if pi_payload is not null then 
      l_error_jo.put( key => pi_payload_attr_name, val => pi_payload );   
    end if;
    
    --apex_util.prn(p_clob => l_error_jo.stringify, p_escape => false);
    sys.htp.p(l_error_jo.stringify);
    po_status_code := flow_rest_constants.c_http_code_ERROR;

  end send_error;

  -------------------------------------------------------------------------------------------------------------------

  procedure send_success( pi_success_message   varchar2
                        , pi_payload           json_element_t default null
                        , pi_payload_attr_name varchar2 default null
                        , po_status_code       out number )
  as
    l_success_jo  json_object_t;
  begin
    l_success_jo := new json_object_t();
    l_success_jo.put( key => 'success', val => true);
    l_success_jo.put( key => 'message', val => pi_success_message);
    if pi_payload is not null then 
      l_success_jo.put( key => pi_payload_attr_name, val => pi_payload );   
    end if;

    --apex_util.prn(p_clob => l_success_jo.stringify, p_escape => false);
    sys.htp.p(l_success_jo.stringify);
    po_status_code := flow_rest_constants.c_http_code_OK;

  end send_success;

end flow_rest_response;
/
