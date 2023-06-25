create or replace package flow_rest_response
  authid definer
as
/* 
-- Flows for APEX - flow_rest_response.pks
-- 
-- (c) Copyright Oracle Corporation and / or its affiliates, 2023.
--
-- Created  14-MAY-2023  Jörg Doppelreiter (solicon IT GmbH)
--
*/

  procedure send_error( pi_sqlerrm            varchar2 
                      , pi_stacktrace         varchar2 default null
                      , pi_payload            json_element_t default null
                      , pi_payload_attr_name  varchar2 default null
                      , po_status_code        out number );

  procedure send_success( pi_success_message   varchar2
                        , pi_payload           json_element_t default null
                        , pi_payload_attr_name varchar2 default null
                        , po_status_code       out number );                       


end flow_rest_response;
/
