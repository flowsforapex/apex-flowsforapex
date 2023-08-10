create or replace package flow_rest_api_v1
  authid definer
as

  procedure dispatch( pi_method           varchar2 
                    , pi_endpoint         varchar2
                    , pi_dgrm_id          flow_diagrams.dgrm_id%type default null
                    , pi_prcs_id          flow_processes.prcs_id%type default null
                    , pi_sbfl_id          flow_subflows.sbfl_id%type default null
                    , pi_message_name     flow_message_subscriptions.msub_message_name%type default null
                    , pi_payload          blob 
                    , pi_current_user     varchar2
                    , po_status_code      out number 
                    , po_forward_location out varchar2
                    );



  function get_links_string_http_GET ( pi_object_type  varchar2
                                     , pi_object_id    varchar2)
    return clob;    

  function get_path( pi_path_endpoint  varchar2, pi_object_id  varchar2)
    return varchar2;

end flow_rest_api_v1;
/
