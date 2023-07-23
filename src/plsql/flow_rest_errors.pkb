create or replace package body flow_rest_errors
as

  procedure handle_error( pi_sqlcode            number 
                        , pi_message            varchar2 
                        , pi_stacktrace         varchar2 
                        , pi_payload            json_element_t default null
                        , pi_payload_attr_name  varchar2 default null
                        , po_status_code        out number )
  as

    l_message  varchar2(2000);
    
    function remove_ora_numer( pi_msg  varchar2 )
      return varchar2
    is
    begin
      return regexp_replace( pi_msg, 'ORA-[0-9]+: +','');
    end;

  begin                                

    rollback;

    case pi_sqlcode

      when -20101 then -- e_payload_not_acceptable
        l_message :=  'Payload not accepted';
      when -20102 then -- e_multiple_object_error
        l_message :=  'Multiple objects found';
      when -20103 then -- e_attribute_not_found
        l_message :=  'Attribute not found';
      when -20104 then -- e_item_not_found
        l_message :=  'Item not found';
      when -20105 then -- e_processing_error
        l_message :=  'Processing Error';
      when -20106 then -- e_process_unknown_status
        l_message :=  'Status unknown';
      when -20107 then -- e_step_unknown_operation
        l_message :=  'Unkown operation for step';
      when -20108 then -- e_privilege_not_granted
        flow_rest_response.send_error( pi_sqlerrm     => 'Necessary privilege not granted'
                                     , po_status_code => po_status_code );
        po_status_code := 401;
      when -20109 then --e_payload_processing
        l_message :=  'JSON Payload can not be processed';
      when -20200 then -- e_not_implemented
        l_message :=  'Not implemented';
      else

        l_message := pi_message;

    end case;

    flow_rest_logging.error( pi_payload            => pi_payload
                           , pi_error_code         => pi_sqlcode
                           , pi_error_msg          => l_message
                           , pi_error_stacktrace   => pi_stacktrace
                           );
 

    if nvl(po_status_code, -1) != 401 then 
      flow_rest_response.send_error(  pi_sqlerrm            => remove_ora_numer(l_message)
                                    , pi_stacktrace         => pi_stacktrace
                                    , pi_payload            => pi_payload
                                    , pi_payload_attr_name  => pi_payload_attr_name
                                    , po_status_code        => po_status_code
                                    );
    end if;
    
    po_status_code := nvl(po_status_code, flow_rest_constants.c_http_code_ERROR) ;

    flow_rest.cleanup;

  end handle_error;

end flow_rest_errors;
/
